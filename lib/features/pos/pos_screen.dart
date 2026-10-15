import 'dart:convert';
import 'package:flutter/material.dart' hide Route;
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart' as drift;
import 'package:intl/intl.dart';
import '../../core/db/app_database.dart';
import 'invoice_printer.dart';
import '../inventory/parts_master_screen.dart'; // for dbProvider

class PosScreen extends ConsumerStatefulWidget {
  const PosScreen({super.key});

  @override
  ConsumerState<PosScreen> createState() => _PosScreenState();
}

class _PosScreenState extends ConsumerState<PosScreen> {
  final FocusNode _keyboardFocusNode = FocusNode();
  final FocusNode _barcodeFocusNode = FocusNode();
  final _barcodeController = TextEditingController();
  final List<_PosItem> _items = [];
  
  Customer? _selectedCustomer;
  Route? _selectedRoute;
  Employee? _selectedSalesman;

  double _discount = 0;
  double _paidAmount = 0;
  bool _isWholesale = false;
  String _selectedPrintFormat = 'A5_2UP';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadPrintFormat();
      _barcodeFocusNode.requestFocus();
    });
  }

  Future<void> _loadPrintFormat() async {
    final db = ref.read(dbProvider);
    final fmt = await db.getConfig('DEFAULT_PRINT_FORMAT') ?? await db.getConfig('PRINT_MODE');
    if (fmt != null && mounted) {
      setState(() {
        _selectedPrintFormat = (fmt == 'LASER_A5' ? 'A5_2UP' : fmt);
      });
    }
  }

  @override
  void dispose() {
    _keyboardFocusNode.dispose();
    _barcodeFocusNode.dispose();
    _barcodeController.dispose();
    super.dispose();
  }

  void _onKey(KeyEvent event) {
    if (event is KeyDownEvent) {
      if (event.logicalKey == LogicalKeyboardKey.f1) {
        _finalizeSale();
      } else if (event.logicalKey == LogicalKeyboardKey.f2) {
        _clearSale();
      } else if (event.logicalKey == LogicalKeyboardKey.f6) {
        _holdCart();
      } else if (event.logicalKey == LogicalKeyboardKey.f7) {
        _showRecallModal();
      }
    }
  }

  void _clearSale() {
    setState(() {
      _items.clear();
      _selectedCustomer = null;
      _selectedRoute = null;
      _selectedSalesman = null;
      _discount = 0;
      _paidAmount = 0;
      _isWholesale = false;
    });
    _barcodeFocusNode.requestFocus();
  }

  void _scanBarcode(String code) async {
    if (code.isEmpty) return;
    final db = ref.read(dbProvider);
    final part = await (db.select(db.parts)..where((t) => t.code.equals(code) | t.barcode.equals(code))).getSingleOrNull();
    if (part != null) {
      setState(() {
        final existing = _items.indexWhere((e) => e.part.id == part.id);
        if (existing >= 0) {
          _items[existing].qty++;
        } else {
          _items.add(_PosItem(
            part: part,
            qty: 1,
            unitRatePaisa: _isWholesale ? part.wholesalePricePaisa : part.retailPricePaisa,
          ));
        }
      });
      _barcodeController.clear();
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Part not found')));
        _barcodeController.clear();
      }
    }
    _barcodeFocusNode.requestFocus();
  }

  void _updatePricing() {
    bool isWholesaleCustomer = _selectedCustomer?.customerType == 'WHOLESALE';
    bool isRouteSelected = _selectedRoute != null;
    _isWholesale = isWholesaleCustomer || isRouteSelected;
    
    for (var item in _items) {
      item.unitRatePaisa = _isWholesale ? item.part.wholesalePricePaisa : item.part.retailPricePaisa;
    }
  }

  Future<void> _finalizeSale() async {
    if (_items.isEmpty) return;

    final db = ref.read(dbProvider);
    int grossAmount = _items.fold(0, (sum, item) => sum + (item.qty * item.unitRatePaisa));
    int discountPaisa = (_discount * 100).toInt();
    int netAmount = grossAmount - discountPaisa;
    int paidPaisa = (_paidAmount * 100).toInt();
    
    // Credit Limit Guard Step-Up
    if (_selectedCustomer != null && paidPaisa < netAmount) {
      int newBalance = _selectedCustomer!.currentBalancePaisa + (netAmount - paidPaisa);
      if (_selectedCustomer!.creditLimitPaisa != null && newBalance > _selectedCustomer!.creditLimitPaisa!) {
        bool? authorized = await _showManagerPinDialog();
        if (authorized != true) {
          if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Credit Limit Exceeded. Manager approval required.')));
          _barcodeFocusNode.requestFocus();
          return;
        }
      }
    }

    String paymentStatus = paidPaisa >= netAmount ? 'PAID' : (paidPaisa > 0 ? 'PARTIAL' : 'CREDIT');

    // Immutability: Bills cannot be edited or deleted once finalized. DB constraints and UI prevent this.
    await db.transaction(() async {
      final billNum = DateTime.now().millisecondsSinceEpoch ~/ 1000;
      
      final saleId = await db.into(db.sales).insert(
        SalesCompanion(
          billNumber: drift.Value(billNum),
          customerId: _selectedCustomer == null ? const drift.Value.absent() : drift.Value(_selectedCustomer!.id),
          salesmanId: _selectedSalesman == null ? const drift.Value.absent() : drift.Value(_selectedSalesman!.id),
          routeId: _selectedRoute == null ? const drift.Value.absent() : drift.Value(_selectedRoute!.id),
          saleType: drift.Value(_isWholesale ? 'WHOLESALE' : 'RETAIL'),
          grossAmountPaisa: drift.Value(grossAmount),
          discountAmountPaisa: drift.Value(discountPaisa),
          netAmountPaisa: drift.Value(netAmount),
          paidAmountPaisa: drift.Value(paidPaisa),
          previousBalancePaisa: drift.Value(_selectedCustomer?.currentBalancePaisa ?? 0),
          paymentStatus: drift.Value(paymentStatus),
          createdBy: const drift.Value(1), // dummy user
        )
      );

      for (var item in _items) {
        await db.into(db.saleItems).insert(
          SaleItemsCompanion(
            saleId: drift.Value(saleId),
            partId: drift.Value(item.part.id),
            qty: drift.Value(item.qty),
            unitRatePaisa: drift.Value(item.unitRatePaisa),
            lineTotalPaisa: drift.Value(item.qty * item.unitRatePaisa),
          )
        );

        // Deduct Stock
        await (db.update(db.parts)..where((t) => t.id.equals(item.part.id))).write(
          PartsCompanion(
            currentStock: drift.Value(item.part.currentStock - item.qty),
          )
        );
      }

      if (_selectedCustomer != null) {
        int balanceIncrease = netAmount - paidPaisa;
        int newBal = _selectedCustomer!.currentBalancePaisa + balanceIncrease;
        
        await (db.update(db.customers)..where((t) => t.id.equals(_selectedCustomer!.id))).write(
          CustomersCompanion(currentBalancePaisa: drift.Value(newBal))
        );

        await db.into(db.customerLedgerEntries).insert(
          CustomerLedgerEntriesCompanion(
            customerId: drift.Value(_selectedCustomer!.id),
            invoiceId: drift.Value(saleId),
            entryType: const drift.Value('INVOICE_DEBIT'),
            debitAmountPaisa: drift.Value(balanceIncrease),
            runningBalancePaisa: drift.Value(newBal),
          )
        );
      }

      // Print
      final savedSale = await (db.select(db.sales)..where((t) => t.id.equals(saleId))).getSingle();
      final savedItems = await (db.select(db.saleItems)..where((t) => t.saleId.equals(saleId))).get();
      final parts = await db.select(db.parts).get();
      await InvoicePrinter.printInvoice(
        savedSale, 
        savedItems, 
        parts, 
        _selectedCustomer,
        route: _selectedRoute,
        salesman: _selectedSalesman,
        printMode: _selectedPrintFormat,
      );
    });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Sale Completed')));
      setState(() {
        _items.clear();
        _selectedCustomer = null;
        _selectedRoute = null;
        _selectedSalesman = null;
        _discount = 0;
        _paidAmount = 0;
        _isWholesale = false;
      });
      _barcodeFocusNode.requestFocus();
    }
  }

  Future<bool?> _showManagerPinDialog() {
    final pinController = TextEditingController();
    final dFocus = FocusNode();
    dFocus.requestFocus();
    
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Manager Approval Required'),
        content: TextField(
          controller: pinController,
          focusNode: dFocus,
          obscureText: true,
          decoration: const InputDecoration(labelText: 'Enter Manager PIN'),
          onSubmitted: (v) {
            if (v == '1234') {
              Navigator.pop(context, true);
            } else {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Invalid PIN')));
            }
          },
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              if (pinController.text == '1234') {
                Navigator.pop(context, true);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Invalid PIN')));
              }
            }, 
            child: const Text('Approve')
          ),
        ],
      )
    );
  }

  Future<void> _holdCart() async {
    if (_items.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Cart is empty. Add items before holding.'))
      );
      _barcodeFocusNode.requestFocus();
      return;
    }

    final defaultRef = _selectedCustomer != null 
        ? '${_selectedCustomer!.name} (${_selectedCustomer!.shopName ?? "Customer"})' 
        : 'Walk-in #${DateTime.now().millisecondsSinceEpoch % 10000}';
    final noteController = TextEditingController(text: defaultRef);

    final shouldHold = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.pause_circle_filled, color: Color(0xFFD97706)),
            SizedBox(width: 8),
            Text('Hold Current Cart (F6)'),
          ],
        ),
        content: SizedBox(
          width: 380,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Suspending ${_items.length} items with total of Rs ${(_items.fold<int>(0, (s, i) => s + (i.qty * i.unitRatePaisa)) / 100).toStringAsFixed(2)}.'),
              const SizedBox(height: 12),
              TextField(
                controller: noteController,
                autofocus: true,
                decoration: const InputDecoration(
                  labelText: 'Reference Note / Customer Tag',
                  border: OutlineInputBorder(),
                  hintText: 'e.g. Mechanic Aslam, CD70 Customer',
                ),
                onSubmitted: (_) => Navigator.pop(context, true),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF0F172A), foregroundColor: Colors.white),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Hold & Clear Grid'),
          ),
        ],
      ),
    );

    if (shouldHold != true) {
      _barcodeFocusNode.requestFocus();
      return;
    }

    final db = ref.read(dbProvider);
    final cartData = _items.map((i) => {
      'partId': i.part.id,
      'qty': i.qty,
      'unitRatePaisa': i.unitRatePaisa,
    }).toList();

    await db.into(db.parkedCarts).insert(
      ParkedCartsCompanion(
        referenceNote: drift.Value(noteController.text.trim()),
        customerId: _selectedCustomer != null ? drift.Value(_selectedCustomer!.id) : const drift.Value.absent(),
        routeId: _selectedRoute != null ? drift.Value(_selectedRoute!.id) : const drift.Value.absent(),
        salesmanId: _selectedSalesman != null ? drift.Value(_selectedSalesman!.id) : const drift.Value.absent(),
        saleType: drift.Value(_isWholesale ? 'WHOLESALE' : 'RETAIL'),
        cartJson: drift.Value(jsonEncode(cartData)),
        discountPaisa: drift.Value((_discount * 100).toInt()),
        parkedBy: const drift.Value(1),
      ),
    );

    setState(() {
      _items.clear();
      _selectedCustomer = null;
      _selectedRoute = null;
      _selectedSalesman = null;
      _discount = 0;
      _paidAmount = 0;
      _isWholesale = false;
    });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Cart parked as "${noteController.text.trim()}". Press F7 to recall.'),
          backgroundColor: Colors.amber.shade900,
        ),
      );
    }
    _barcodeFocusNode.requestFocus();
  }

  Future<void> _showRecallModal() async {
    final db = ref.read(dbProvider);
    final parkedList = await (db.select(db.parkedCarts)..orderBy([(t) => drift.OrderingTerm.desc(t.createdAt)])).get();

    if (!mounted) return;

    if (parkedList.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No parked carts currently on hold.'))
      );
      _barcodeFocusNode.requestFocus();
      return;
    }

    final customers = await db.select(db.customers).get();
    final custMap = {for (var c in customers) c.id: c};
    final routes = await db.select(db.routes).get();
    final routeMap = {for (var r in routes) r.id: r};
    final salesmen = await db.select(db.employees).get();
    final salesMap = {for (var s in salesmen) s.id: s};
    final parts = await db.select(db.parts).get();
    final partMap = {for (var p in parts) p.id: p};

    if (!mounted) return;

    await showDialog<void>(
      context: context,
      builder: (modalContext) {
        return StatefulBuilder(
          builder: (ctx, setModalState) {
            return AlertDialog(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.restore_page_outlined, color: Color(0xFF0F172A)),
                      const SizedBox(width: 8),
                      Text('Recall Parked Cart (F7) — ${parkedList.length} on hold'),
                    ],
                  ),
                  IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.pop(modalContext)),
                ],
              ),
              content: SizedBox(
                width: 650,
                height: 400,
                child: parkedList.isEmpty
                    ? const Center(child: Text('No more parked carts.', style: TextStyle(color: Colors.grey)))
                    : ListView.separated(
                        itemCount: parkedList.length,
                        separatorBuilder: (_, __) => const Divider(height: 1),
                        itemBuilder: (context, idx) {
                          final pc = parkedList[idx];
                          final List<dynamic> decoded = jsonDecode(pc.cartJson);
                          int totalPaisa = 0;
                          int totalQty = 0;
                          for (final item in decoded) {
                            final m = item as Map<String, dynamic>;
                            final qty = m['qty'] as int;
                            final rate = m['unitRatePaisa'] as int;
                            totalQty += qty;
                            totalPaisa += (qty * rate);
                          }
                          totalPaisa -= pc.discountPaisa;
                          final cust = pc.customerId != null ? custMap[pc.customerId] : null;
                          final timeStr = DateFormat('hh:mm a • dd MMM').format(pc.createdAt);

                          return ListTile(
                            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            leading: CircleAvatar(
                              backgroundColor: const Color(0xFFF1F5F9),
                              child: Text('${idx + 1}', style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF0F172A))),
                            ),
                            title: Row(
                              children: [
                                Text(
                                  pc.referenceNote ?? (cust?.name ?? 'Walk-in Customer'),
                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                                ),
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: pc.saleType == 'WHOLESALE' ? Colors.blue.shade50 : Colors.grey.shade200,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(pc.saleType, style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: pc.saleType == 'WHOLESALE' ? Colors.blue.shade800 : Colors.grey.shade800)),
                                ),
                              ],
                            ),
                            subtitle: Text(
                              '$totalQty items • Parked at $timeStr ${cust != null ? "• ${cust.shopName ?? cust.name}" : ""}',
                              style: const TextStyle(fontSize: 11, color: Color(0xFF64748B)),
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  'Rs ${(totalPaisa / 100).toStringAsFixed(2)}',
                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFF0F172A)),
                                ),
                                const SizedBox(width: 14),
                                ElevatedButton.icon(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF0F172A),
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                  ),
                                  icon: const Icon(Icons.restore, size: 16),
                                  label: const Text('Restore'),
                                  onPressed: () async {
                                    if (_items.isNotEmpty) {
                                      final confirm = await showDialog<bool>(
                                        context: modalContext,
                                        builder: (c) => AlertDialog(
                                          title: const Text('Overwrite Active Cart?'),
                                          content: const Text('Your current checkout grid has items. Restoring will replace the active cart.'),
                                          actions: [
                                            TextButton(onPressed: () => Navigator.pop(c, false), child: const Text('Cancel')),
                                            ElevatedButton(onPressed: () => Navigator.pop(c, true), child: const Text('Overwrite')),
                                          ],
                                        ),
                                      );
                                      if (confirm != true) return;
                                    }

                                    final restored = <_PosItem>[];
                                    for (final item in decoded) {
                                      final m = item as Map<String, dynamic>;
                                      final p = partMap[m['partId'] as int];
                                      if (p != null) {
                                        restored.add(_PosItem(
                                          part: p,
                                          qty: m['qty'] as int,
                                          unitRatePaisa: m['unitRatePaisa'] as int,
                                        ));
                                      }
                                    }

                                    await (db.delete(db.parkedCarts)..where((t) => t.id.equals(pc.id))).go();

                                    setState(() {
                                      _items.clear();
                                      _items.addAll(restored);
                                      _selectedCustomer = cust;
                                      _selectedRoute = pc.routeId != null ? routeMap[pc.routeId] : null;
                                      _selectedSalesman = pc.salesmanId != null ? salesMap[pc.salesmanId] : null;
                                      _discount = pc.discountPaisa / 100.0;
                                      _isWholesale = pc.saleType == 'WHOLESALE';
                                      _updatePricing();
                                    });

                                    if (modalContext.mounted) {
                                      Navigator.pop(modalContext);
                                    }
                                    _barcodeFocusNode.requestFocus();
                                    if (context.mounted) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: Text('Cart "${pc.referenceNote ?? "Restored"}" loaded successfully!'),
                                          backgroundColor: Colors.green.shade800,
                                        ),
                                      );
                                    }
                                  },
                                ),
                                const SizedBox(width: 8),
                                OutlinedButton.icon(
                                  style: OutlinedButton.styleFrom(
                                    foregroundColor: Colors.red.shade700,
                                    side: BorderSide(color: Colors.red.shade300),
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                                  ),
                                  icon: const Icon(Icons.delete_outline, size: 16),
                                  label: const Text('Discard'),
                                  onPressed: () async {
                                    final confirm = await showDialog<bool>(
                                      context: modalContext,
                                      builder: (c) => AlertDialog(
                                        title: const Text('Discard Parked Cart?'),
                                        content: Text('Are you sure you want to discard "${pc.referenceNote ?? "this parked cart"}"? This cannot be undone.'),
                                        actions: [
                                          TextButton(onPressed: () => Navigator.pop(c, false), child: const Text('Cancel')),
                                          ElevatedButton(
                                            style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
                                            onPressed: () => Navigator.pop(c, true),
                                            child: const Text('Discard'),
                                          ),
                                        ],
                                      ),
                                    );
                                    if (confirm == true) {
                                      await (db.delete(db.parkedCarts)..where((t) => t.id.equals(pc.id))).go();
                                      setModalState(() {
                                        parkedList.removeAt(idx);
                                      });
                                    }
                                  },
                                ),
                              ],
                            ),
                          );
                        },
                      ),
              ),
            );
          },
        );
      },
    );
    _barcodeFocusNode.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    final db = ref.watch(dbProvider);

    return KeyboardListener(
      focusNode: _keyboardFocusNode,
      onKeyEvent: _onKey,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('POS Terminal [F1: Finalize | F2: Clear | F6: Hold | F7: Recall]'),
          actions: [
            StreamBuilder<List<ParkedCart>>(
              stream: db.select(db.parkedCarts).watch(),
              builder: (context, snapshot) {
                final parkedCount = snapshot.data?.length ?? 0;
                return Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: const Color(0xFFD97706),
                        side: const BorderSide(color: Color(0xFFF59E0B)),
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      ),
                      icon: const Icon(Icons.pause_circle_outline, size: 18),
                      label: const Text('Hold Bill (F6)', style: TextStyle(fontWeight: FontWeight.bold)),
                      onPressed: _holdCart,
                    ),
                    const SizedBox(width: 8),
                    Badge(
                      isLabelVisible: parkedCount > 0,
                      label: Text('$parkedCount', style: const TextStyle(fontWeight: FontWeight.bold)),
                      backgroundColor: Colors.amber.shade800,
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: parkedCount > 0 ? const Color(0xFF0F172A) : const Color(0xFFF1F5F9),
                          foregroundColor: parkedCount > 0 ? Colors.white : const Color(0xFF64748B),
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        ),
                        icon: const Icon(Icons.restore_page_outlined, size: 18),
                        label: Text(parkedCount > 0 ? 'Parked Carts ($parkedCount) [F7]' : 'Recall Bill (F7)', style: const TextStyle(fontWeight: FontWeight.bold)),
                        onPressed: _showRecallModal,
                      ),
                    ),
                    const SizedBox(width: 16),
                  ],
                );
              },
            ),
          ],
        ),
        body: Row(
          children: [
            // Left Panel: Items & Scanners
            Expanded(
              flex: 3,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  children: [
                    TextField(
                      controller: _barcodeController,
                      focusNode: _barcodeFocusNode,
                      decoration: const InputDecoration(
                        labelText: 'Search / Scan Barcode (Auto-Focused)',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.qr_code_scanner),
                      ),
                      onSubmitted: _scanBarcode,
                    ),
                    const SizedBox(height: 10),
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: ListView.separated(
                          itemCount: _items.length,
                          separatorBuilder: (context, index) => const Divider(height: 1),
                          itemBuilder: (context, index) {
                            final item = _items[index];
                            return ListTile(
                              title: Text(item.part.nameEn, style: const TextStyle(fontWeight: FontWeight.w600)),
                              subtitle: Text('Rate: Rs ${item.unitRatePaisa / 100}'),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(icon: const Icon(Icons.remove_circle_outline), onPressed: () {
                                    setState(() {
                                      if (item.qty > 1) {
                                        item.qty--;
                                      } else {
                                        _items.removeAt(index);
                                      }
                                    });
                                    _barcodeFocusNode.requestFocus();
                                  }),
                                  SizedBox(width: 30, child: Center(child: Text('${item.qty}', style: const TextStyle(fontSize: 16)))),
                                  IconButton(icon: const Icon(Icons.add_circle_outline), onPressed: () {
                                    setState(() { item.qty++; });
                                    _barcodeFocusNode.requestFocus();
                                  }),
                                  const SizedBox(width: 20),
                                  SizedBox(
                                    width: 80, 
                                    child: Align(
                                      alignment: Alignment.centerRight, 
                                      child: Text('Rs ${(item.qty * item.unitRatePaisa) / 100}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16))
                                    )
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const VerticalDivider(width: 1),
            // Right Panel: Customer & Totals
            Expanded(
              flex: 1,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    FutureBuilder<List<Route>>(
                      future: db.select(db.routes).get(),
                      builder: (context, snapshot) {
                        return DropdownButtonFormField<Route>(
                          decoration: const InputDecoration(labelText: 'Route'),
                          value: _selectedRoute,
                          items: (snapshot.data ?? []).map((r) => DropdownMenuItem(value: r, child: Text(r.name))).toList(),
                          onChanged: (r) {
                            setState(() {
                              _selectedRoute = r;
                              _updatePricing();
                            });
                            _barcodeFocusNode.requestFocus();
                          },
                        );
                      }
                    ),
                    const SizedBox(height: 10),
                    FutureBuilder<List<Employee>>(
                      future: (db.select(db.employees)..where((t) => t.role.equals('SALESMAN'))).get(),
                      builder: (context, snapshot) {
                        return DropdownButtonFormField<Employee>(
                          decoration: const InputDecoration(labelText: 'Booker / DSO'),
                          value: _selectedSalesman,
                          items: (snapshot.data ?? []).map((e) => DropdownMenuItem(value: e, child: Text(e.name))).toList(),
                          onChanged: (e) {
                            setState(() { _selectedSalesman = e; });
                            _barcodeFocusNode.requestFocus();
                          },
                        );
                      }
                    ),
                    const SizedBox(height: 10),
                    FutureBuilder<List<Customer>>(
                      future: db.select(db.customers).get(),
                      builder: (context, snapshot) {
                        return DropdownButtonFormField<Customer>(
                          decoration: const InputDecoration(labelText: 'Customer (Credit/Walk-in)'),
                          value: _selectedCustomer,
                          items: (snapshot.data ?? []).map((c) => DropdownMenuItem(value: c, child: Text(c.name))).toList(),
                          onChanged: (c) {
                            setState(() {
                              _selectedCustomer = c;
                              _updatePricing();
                            });
                            _barcodeFocusNode.requestFocus();
                          },
                        );
                      },
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      decoration: const InputDecoration(labelText: 'Discount (Rs)'),
                      keyboardType: TextInputType.number,
                      onChanged: (v) => setState(() => _discount = double.tryParse(v) ?? 0),
                      onFieldSubmitted: (_) => _barcodeFocusNode.requestFocus(),
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      decoration: const InputDecoration(labelText: 'Paid Amount (Rs)'),
                      keyboardType: TextInputType.number,
                      onChanged: (v) => setState(() => _paidAmount = double.tryParse(v) ?? 0),
                      onFieldSubmitted: (_) => _barcodeFocusNode.requestFocus(),
                    ),
                    const SizedBox(height: 12),
                    // Quick Format Selector Chip / Profile
                    Card(
                      elevation: 0,
                      color: const Color(0xFFF8FAFC),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                        side: const BorderSide(color: Color(0xFFE2E8F0)),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Row(
                              children: [
                                Icon(Icons.print_outlined, size: 14, color: Color(0xFF64748B)),
                                SizedBox(width: 4),
                                Text(
                                  'Print Format',
                                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF475569)),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Wrap(
                              spacing: 6,
                              runSpacing: 4,
                              children: [
                                ChoiceChip(
                                  visualDensity: VisualDensity.compact,
                                  label: const Text('A5 2-Up Laser', style: TextStyle(fontSize: 11)),
                                  selected: _selectedPrintFormat == 'A5_2UP' || _selectedPrintFormat == 'LASER_A5',
                                  onSelected: (sel) {
                                    if (sel) setState(() => _selectedPrintFormat = 'A5_2UP');
                                    _barcodeFocusNode.requestFocus();
                                  },
                                ),
                                ChoiceChip(
                                  visualDensity: VisualDensity.compact,
                                  label: const Text('80mm Thermal', style: TextStyle(fontSize: 11)),
                                  selected: _selectedPrintFormat == 'THERMAL_80MM',
                                  onSelected: (sel) {
                                    if (sel) setState(() => _selectedPrintFormat = 'THERMAL_80MM');
                                    _barcodeFocusNode.requestFocus();
                                  },
                                ),
                                ChoiceChip(
                                  visualDensity: VisualDensity.compact,
                                  label: const Text('58mm Thermal', style: TextStyle(fontSize: 11)),
                                  selected: _selectedPrintFormat == 'THERMAL_58MM',
                                  onSelected: (sel) {
                                    if (sel) setState(() => _selectedPrintFormat = 'THERMAL_58MM');
                                    _barcodeFocusNode.requestFocus();
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.blueGrey.shade50,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Pricing Mode:', style: TextStyle(color: Colors.black54)),
                              Text(_isWholesale ? 'WHOLESALE' : 'RETAIL', style: TextStyle(fontWeight: FontWeight.bold, color: _isWholesale ? Colors.orange.shade800 : Colors.blue.shade800)),
                            ],
                          ),
                          const Divider(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Gross Amount:'),
                              Text('Rs ${(_items.fold<int>(0, (s, i) => s + (i.qty * i.unitRatePaisa)) / 100).toStringAsFixed(2)}'),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Net Payable:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                              Text('Rs ${((_items.fold<int>(0, (s, i) => s + (i.qty * i.unitRatePaisa)) / 100) - _discount).toStringAsFixed(2)}', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.green)),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      icon: const Icon(Icons.check_circle),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.all(20),
                        backgroundColor: Colors.blueGrey.shade900,
                        foregroundColor: Colors.white,
                      ),
                      onPressed: _finalizeSale,
                      label: const Text('FINALIZE (F1)', style: TextStyle(fontSize: 18)),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PosItem {
  final Part part;
  int qty;
  int unitRatePaisa;
  _PosItem({required this.part, required this.qty, required this.unitRatePaisa});
}
