import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart' as drift;
import '../../core/db/app_database.dart';
import '../inventory/parts_master_screen.dart'; // To get dbProvider
import '../suppliers/supplier_dialog.dart';

class GrnScreen extends ConsumerStatefulWidget {
  const GrnScreen({super.key});

  @override
  ConsumerState<GrnScreen> createState() => _GrnScreenState();
}

class _GrnScreenState extends ConsumerState<GrnScreen> {
  final _formKey = GlobalKey<FormState>();
  final _vendorBillController = TextEditingController();
  final _notesController = TextEditingController();
  final List<_GrnItem> _items = [];

  Supplier? _selectedSupplier;
  Part? _selectedPart;
  final _qtyController = TextEditingController(text: '1');
  final _costController = TextEditingController();
  bool _isPosting = false;

  @override
  void dispose() {
    _vendorBillController.dispose();
    _notesController.dispose();
    _qtyController.dispose();
    _costController.dispose();
    super.dispose();
  }

  void _addItem() {
    if (_selectedPart == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a spare part first.')),
      );
      return;
    }
    final qty = int.tryParse(_qtyController.text.trim()) ?? 0;
    final cost = double.tryParse(_costController.text.trim()) ?? 0.0;

    if (qty <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Quantity must be greater than 0.')),
      );
      return;
    }
    if (cost < 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Unit cost cannot be negative.')),
      );
      return;
    }

    setState(() {
      final existingIndex = _items.indexWhere((i) => i.part.id == _selectedPart!.id);
      if (existingIndex >= 0) {
        _items[existingIndex].qty += qty;
        _items[existingIndex].unitCostPaisa = (cost * 100).toInt();
      } else {
        _items.add(_GrnItem(
          part: _selectedPart!,
          qty: qty,
          unitCostPaisa: (cost * 100).toInt(),
        ));
      }
      _selectedPart = null;
      _qtyController.text = '1';
      _costController.clear();
    });
  }

  void _removeItem(int index) {
    setState(() {
      _items.removeAt(index);
    });
  }

  Future<void> _postGrn() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedSupplier == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Mandatory: Please select a Supplier before posting GRN.')),
      );
      return;
    }
    if (_items.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please add at least one line item to the Goods Receipt Note.')),
      );
      return;
    }

    setState(() => _isPosting = true);
    final db = ref.read(dbProvider);
    final invoiceNo = _vendorBillController.text.trim();
    final totalAmount = _items.fold<int>(0, (sum, item) => sum + (item.qty * item.unitCostPaisa));

    try {
      await db.transaction(() async {
        // 1. Create PurchasesGrn record
        final grnId = await db.into(db.purchasesGrn).insert(
          PurchasesGrnCompanion(
            supplierId: drift.Value(_selectedSupplier!.id),
            supplierInvoiceNo: drift.Value(invoiceNo),
            purchaseDate: drift.Value(DateTime.now()),
            totalAmountPaisa: drift.Value(totalAmount),
            notes: drift.Value(_notesController.text.trim().isEmpty ? null : _notesController.text.trim()),
            createdBy: const drift.Value(1), // Manager/Active session ID
          ),
        );

        // 2. Add line items, increment stock & recalculate weighted moving average cost
        for (final item in _items) {
          final lineTotal = item.qty * item.unitCostPaisa;

          await db.into(db.purchaseItemsGrn).insert(
            PurchaseItemsGrnCompanion(
              grnId: drift.Value(grnId),
              partId: drift.Value(item.part.id),
              quantityReceived: drift.Value(item.qty),
              unitPurchasePricePaisa: drift.Value(item.unitCostPaisa),
              lineTotalPaisa: drift.Value(lineTotal),
            ),
          );

          // Fetch fresh part data inside transaction
          final freshPart = await (db.select(db.parts)..where((t) => t.id.equals(item.part.id))).getSingle();
          final newStock = freshPart.currentStock + item.qty;

          // Weighted Moving Average Cost calculation:
          // newAvgCost = (currentStock * avgCost + receivedQty * unitPurchasePrice) / newStock
          final currentVal = freshPart.currentStock * freshPart.avgCostPaisa;
          final incomingVal = item.qty * item.unitCostPaisa;
          final newAvgCost = newStock > 0 ? ((currentVal + incomingVal) ~/ newStock) : item.unitCostPaisa;

          await (db.update(db.parts)..where((t) => t.id.equals(freshPart.id))).write(
            PartsCompanion(
              currentStock: drift.Value(newStock),
              avgCostPaisa: drift.Value(newAvgCost),
            ),
          );
        }

        // 3. Update Supplier Payable Balance & Insert Supplier Ledger Entry
        final freshSupplier = await (db.select(db.suppliers)..where((t) => t.id.equals(_selectedSupplier!.id))).getSingle();
        final newSupplierBalance = freshSupplier.currentBalancePaisa + totalAmount;

        await (db.update(db.suppliers)..where((t) => t.id.equals(freshSupplier.id))).write(
          SuppliersCompanion(
            currentBalancePaisa: drift.Value(newSupplierBalance),
          ),
        );

        await db.into(db.supplierLedgerEntries).insert(
          SupplierLedgerEntriesCompanion(
            supplierId: drift.Value(freshSupplier.id),
            grnId: drift.Value(grnId),
            entryType: const drift.Value('PURCHASE_PAYABLE'),
            creditAmountPaisa: drift.Value(totalAmount),
            debitAmountPaisa: const drift.Value(0),
            runningBalancePaisa: drift.Value(newSupplierBalance),
            notes: drift.Value('GRN #$grnId / Inv: $invoiceNo'),
          ),
        );

        // 4. Log Audit Trail
        await db.into(db.auditLogs).insert(
          AuditLogsCompanion.insert(
            actionType: 'GRN_POSTED',
            details: 'GRN #$grnId posted for ${freshSupplier.name} (Inv: $invoiceNo). Total: Rs ${(totalAmount / 100).toStringAsFixed(2)}',
          ),
        );
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('GRN Posted Successfully! Supplier payable balance & inventory updated.'),
            backgroundColor: Colors.green.shade800,
          ),
        );
        setState(() {
          _items.clear();
          _vendorBillController.clear();
          _notesController.clear();
          _selectedPart = null;
          _selectedSupplier = null;
          _costController.clear();
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to post GRN: $e'), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) setState(() => _isPosting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final db = ref.watch(dbProvider);
    final totalAmount = _items.fold<int>(0, (sum, item) => sum + (item.qty * item.unitCostPaisa));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Purchases / Goods Receipt Note (GRN)'),
        actions: [
          TextButton.icon(
            style: TextButton.styleFrom(foregroundColor: const Color(0xFF0F172A)),
            icon: const Icon(Icons.people_alt_outlined),
            label: const Text('Supplier Directory'),
            onPressed: () {
              showDialog(
                context: context,
                builder: (_) => const SupplierManagementDialog(),
              );
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Card: Supplier selection & Invoice Number
              Card(
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: const BorderSide(color: Color(0xFFE2E8F0)),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Supplier Selector
                      Expanded(
                        flex: 3,
                        child: StreamBuilder<List<Supplier>>(
                          stream: db.select(db.suppliers).watch(),
                          builder: (context, snapshot) {
                            final suppliers = snapshot.data ?? [];
                            return Row(
                              children: [
                                Expanded(
                                  child: DropdownButtonFormField<Supplier>(
                                    decoration: const InputDecoration(
                                      labelText: 'Select Supplier *',
                                      prefixIcon: Icon(Icons.business),
                                      border: OutlineInputBorder(),
                                    ),
                                    value: _selectedSupplier != null && suppliers.any((s) => s.id == _selectedSupplier!.id)
                                        ? suppliers.firstWhere((s) => s.id == _selectedSupplier!.id)
                                        : null,
                                    items: suppliers.map((s) {
                                      final bal = s.currentBalancePaisa / 100;
                                      return DropdownMenuItem(
                                        value: s,
                                        child: Text('${s.name} ${s.company != null ? "(${s.company})" : ""} — Bal: Rs ${bal.toStringAsFixed(0)}'),
                                      );
                                    }).toList(),
                                    onChanged: (v) => setState(() => _selectedSupplier = v),
                                    validator: (v) => v == null ? 'Supplier is required' : null,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                IconButton(
                                  icon: const Icon(Icons.add_business_outlined),
                                  tooltip: 'Quick Add Supplier',
                                  onPressed: () async {
                                    final newSup = await showDialog<Supplier>(
                                      context: context,
                                      builder: (_) => const SupplierFormDialog(),
                                    );
                                    if (newSup != null && mounted) {
                                      setState(() => _selectedSupplier = newSup);
                                    }
                                  },
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                      const SizedBox(width: 16),
                      // Vendor Invoice No
                      Expanded(
                        flex: 2,
                        child: TextFormField(
                          controller: _vendorBillController,
                          decoration: const InputDecoration(
                            labelText: 'Supplier Invoice / Bill No *',
                            prefixIcon: Icon(Icons.receipt_outlined),
                            border: OutlineInputBorder(),
                          ),
                          validator: (v) => v == null || v.trim().isEmpty ? 'Invoice number is required' : null,
                        ),
                      ),
                      const SizedBox(width: 16),
                      // Notes
                      Expanded(
                        flex: 2,
                        child: TextFormField(
                          controller: _notesController,
                          decoration: const InputDecoration(
                            labelText: 'Notes / Shipment Ref (Optional)',
                            prefixIcon: Icon(Icons.note_alt_outlined),
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Item Entry Bar
              Card(
                elevation: 0,
                color: const Color(0xFFF8FAFC),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: const BorderSide(color: Color(0xFFE2E8F0)),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      // Part Selection
                      Expanded(
                        flex: 4,
                        child: StreamBuilder<List<Part>>(
                          stream: db.select(db.parts).watch(),
                          builder: (context, snapshot) {
                            final parts = snapshot.data ?? [];
                            return DropdownButtonFormField<Part>(
                              decoration: const InputDecoration(
                                labelText: 'Select Spare Part',
                                prefixIcon: Icon(Icons.inventory_2_outlined),
                                filled: true,
                                fillColor: Colors.white,
                                border: OutlineInputBorder(),
                              ),
                              value: _selectedPart != null && parts.any((p) => p.id == _selectedPart!.id)
                                  ? parts.firstWhere((p) => p.id == _selectedPart!.id)
                                  : null,
                              items: parts.map((p) {
                                return DropdownMenuItem(
                                  value: p,
                                  child: Text('${p.nameEn} [${p.code}] — In Stock: ${p.currentStock}'),
                                );
                              }).toList(),
                              onChanged: (p) {
                                setState(() {
                                  _selectedPart = p;
                                  if (p != null) {
                                    _costController.text = (p.avgCostPaisa / 100).toStringAsFixed(2);
                                  }
                                });
                              },
                            );
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      // Qty
                      Expanded(
                        flex: 2,
                        child: TextFormField(
                          controller: _qtyController,
                          decoration: const InputDecoration(
                            labelText: 'Qty Received',
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.number,
                        ),
                      ),
                      const SizedBox(width: 12),
                      // Unit Cost
                      Expanded(
                        flex: 2,
                        child: TextFormField(
                          controller: _costController,
                          decoration: const InputDecoration(
                            labelText: 'Unit Cost (Rs)',
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.number,
                        ),
                      ),
                      const SizedBox(width: 12),
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF0F172A),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                        onPressed: _addItem,
                        icon: const Icon(Icons.add),
                        label: const Text('Add Item'),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Items Table
              Expanded(
                child: Card(
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: const BorderSide(color: Color(0xFFE2E8F0)),
                  ),
                  child: _items.isEmpty
                      ? const Center(
                          child: Text(
                            'No items added to this Goods Receipt Note yet.',
                            style: TextStyle(color: Color(0xFF64748B), fontSize: 15),
                          ),
                        )
                      : ListView.separated(
                          itemCount: _items.length,
                          separatorBuilder: (_, __) => const Divider(height: 1),
                          itemBuilder: (context, index) {
                            final item = _items[index];
                            final lineTotal = (item.qty * item.unitCostPaisa) / 100;

                            return ListTile(
                              leading: CircleAvatar(
                                backgroundColor: const Color(0xFFF1F5F9),
                                foregroundColor: const Color(0xFF0F172A),
                                child: Text('${index + 1}'),
                              ),
                              title: Text(
                                item.part.nameEn,
                                style: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                              subtitle: Text(
                                'Code: ${item.part.code} | Qty: ${item.qty} ${item.part.unit} @ Rs ${(item.unitCostPaisa / 100).toStringAsFixed(2)}',
                              ),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    'Rs ${lineTotal.toStringAsFixed(2)}',
                                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                  ),
                                  const SizedBox(width: 12),
                                  IconButton(
                                    icon: const Icon(Icons.delete_outline, color: Colors.red),
                                    onPressed: () => _removeItem(index),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                ),
              ),
              const SizedBox(height: 16),

              // Bottom Summary & Post GRN Action
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF0F172A),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Total Line Items: ${_items.length}',
                          style: const TextStyle(color: Colors.white70, fontSize: 13),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Total Net Payable: Rs ${(totalAmount / 100).toStringAsFixed(2)}',
                          style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFD4AF37),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      onPressed: _isPosting || _items.isEmpty ? null : _postGrn,
                      icon: _isPosting
                          ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                          : const Icon(Icons.check_circle_outline),
                      label: Text(
                        _isPosting ? 'Posting GRN...' : 'POST GRN & UPDATE STOCK',
                        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _GrnItem {
  final Part part;
  int qty;
  int unitCostPaisa;
  _GrnItem({required this.part, required this.qty, required this.unitCostPaisa});
}
