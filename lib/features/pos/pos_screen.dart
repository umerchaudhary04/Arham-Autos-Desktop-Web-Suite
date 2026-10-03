import 'package:flutter/material.dart';
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
  final FocusNode _focusNode = FocusNode();
  final _barcodeController = TextEditingController();
  final List<_PosItem> _items = [];
  
  Customer? _selectedCustomer;
  double _discount = 0;
  double _paidAmount = 0;
  bool _isWholesale = false;

  @override
  void initState() {
    super.initState();
    _focusNode.requestFocus();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  void _onKey(KeyEvent event) {
    if (event is KeyDownEvent) {
      if (event.logicalKey == LogicalKeyboardKey.f1) {
        // Example hotkey for finalize
        _finalizeSale();
      } else if (event.logicalKey == LogicalKeyboardKey.f2) {
        // Clear screen
        setState(() {
          _items.clear();
          _selectedCustomer = null;
          _isWholesale = false;
        });
      }
    }
  }

  void _scanBarcode(String code) async {
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
  }

  Future<void> _finalizeSale() async {
    if (_items.isEmpty) return;

    final db = ref.read(dbProvider);
    int grossAmount = _items.fold(0, (sum, item) => sum + (item.qty * item.unitRatePaisa));
    int discountPaisa = (_discount * 100).toInt();
    int netAmount = grossAmount - discountPaisa;
    int paidPaisa = (_paidAmount * 100).toInt();
    
    // Credit Limit Check
    if (_selectedCustomer != null && paidPaisa < netAmount) {
      int newBalance = _selectedCustomer!.currentBalancePaisa + (netAmount - paidPaisa);
      if (_selectedCustomer!.creditLimitPaisa != null && newBalance > _selectedCustomer!.creditLimitPaisa!) {
        // Requires manager PIN override
        bool? authorized = await _showManagerPinDialog();
        if (authorized != true) {
          if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Credit Limit Exceeded. Manager approval required.')));
          return;
        }
      }
    }

    String paymentStatus = paidPaisa >= netAmount ? 'PAID' : (paidPaisa > 0 ? 'PARTIAL' : 'CREDIT');

    // Proceed to save
    await db.transaction(() async {
      final billNum = DateTime.now().millisecondsSinceEpoch ~/ 1000; // temporary bill number gen
      
      final saleId = await db.into(db.sales).insert(
        SalesCompanion(
          billNumber: drift.Value(billNum),
          customerId: _selectedCustomer == null ? const drift.Value.absent() : drift.Value(_selectedCustomer!.id),
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
      await InvoicePrinter.printInvoice(savedSale, savedItems, parts, _selectedCustomer);
    });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Sale Completed')));
      setState(() {
        _items.clear();
        _selectedCustomer = null;
        _discount = 0;
        _paidAmount = 0;
        _isWholesale = false;
      });
      _focusNode.requestFocus();
    }
  }

  Future<bool?> _showManagerPinDialog() {
    final pinController = TextEditingController();
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Manager Approval Required'),
        content: TextField(
          controller: pinController,
          obscureText: true,
          decoration: const InputDecoration(labelText: 'Enter Manager PIN'),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              // Dummy check for manager pin
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
      focusNode: _focusNode,
      onKeyEvent: _onKey,
      child: Scaffold(
        appBar: AppBar(title: const Text('POS Terminal [F1: Finalize | F2: Clear]')),
        body: Row(
          children: [
            // Left Panel: Items & Scanners
            Expanded(
              flex: 3,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    TextField(
                      controller: _barcodeController,
                      decoration: const InputDecoration(
                        labelText: 'Scan Barcode or Enter Part Code',
                        border: OutlineInputBorder(),
                      ),
                      onSubmitted: _scanBarcode,
                    ),
                    const SizedBox(height: 10),
                    Expanded(
                      child: ListView.builder(
                        itemCount: _items.length,
                        itemBuilder: (context, index) {
                          final item = _items[index];
                          return ListTile(
                            title: Text(item.part.nameEn),
                            subtitle: Text('Rate: Rs ${item.unitRatePaisa / 100}'),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(icon: const Icon(Icons.remove), onPressed: () {
                                  setState(() {
                                    if (item.qty > 1) item.qty--;
                                    else _items.removeAt(index);
                                  });
                                }),
                                Text('${item.qty}'),
                                IconButton(icon: const Icon(Icons.add), onPressed: () {
                                  setState(() { item.qty++; });
                                }),
                                const SizedBox(width: 20),
                                Text('Rs ${(item.qty * item.unitRatePaisa) / 100}', style: const TextStyle(fontWeight: FontWeight.bold)),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const VerticalDivider(),
            // Right Panel: Customer & Totals
            Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    FutureBuilder<List<Customer>>(
                      future: db.select(db.customers).get(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) return const SizedBox.shrink();
                        return DropdownButtonFormField<Customer>(
                          decoration: const InputDecoration(labelText: 'Customer'),
                          value: _selectedCustomer,
                          items: snapshot.data!.map((c) => DropdownMenuItem(value: c, child: Text(c.name))).toList(),
                          onChanged: (c) {
                            setState(() {
                              _selectedCustomer = c;
                              _isWholesale = c?.customerType == 'WHOLESALE';
                              // Update prices of existing items
                              for (var item in _items) {
                                item.unitRatePaisa = _isWholesale ? item.part.wholesalePricePaisa : item.part.retailPricePaisa;
                              }
                            });
                          },
                        );
                      },
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      decoration: const InputDecoration(labelText: 'Discount (Rs)'),
                      keyboardType: TextInputType.number,
                      onChanged: (v) => setState(() => _discount = double.tryParse(v) ?? 0),
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      decoration: const InputDecoration(labelText: 'Paid Amount (Rs)'),
                      keyboardType: TextInputType.number,
                      onChanged: (v) => setState(() => _paidAmount = double.tryParse(v) ?? 0),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.all(16),
                      color: Colors.grey[200],
                      child: Column(
                        children: [
                          Text('Gross: Rs ${(_items.fold<int>(0, (s, i) => s + (i.qty * i.unitRatePaisa)) / 100).toStringAsFixed(2)}'),
                          Text('Net: Rs ${((_items.fold<int>(0, (s, i) => s + (i.qty * i.unitRatePaisa)) / 100) - _discount).toStringAsFixed(2)}', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(padding: const EdgeInsets.all(20)),
                      onPressed: _finalizeSale,
                      child: const Text('FINALIZE (F1)', style: TextStyle(fontSize: 18)),
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
