import 'package:flutter/material.dart' hide Route;
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart' as drift;
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

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _barcodeFocusNode.requestFocus();
    });
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
        setState(() {
          _items.clear();
          _selectedCustomer = null;
          _selectedRoute = null;
          _selectedSalesman = null;
          _isWholesale = false;
        });
        _barcodeFocusNode.requestFocus();
      }
    }
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

  @override
  Widget build(BuildContext context) {
    final db = ref.watch(dbProvider);

    return KeyboardListener(
      focusNode: _keyboardFocusNode,
      onKeyEvent: _onKey,
      child: Scaffold(
        appBar: AppBar(title: const Text('POS Terminal [F1: Finalize | F2: Clear]')),
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
              child: Padding(
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
                    const Spacer(),
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
