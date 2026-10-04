import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart' as drift;
import '../../core/db/app_database.dart';
import '../inventory/parts_master_screen.dart'; // To get dbProvider

class GrnScreen extends ConsumerStatefulWidget {
  const GrnScreen({super.key});

  @override
  ConsumerState<GrnScreen> createState() => _GrnScreenState();
}

class _GrnScreenState extends ConsumerState<GrnScreen> {
  final _vendorBillController = TextEditingController();
  final _notesController = TextEditingController();
  final List<_GrnItem> _items = [];
  
  Part? _selectedPart;
  final _qtyController = TextEditingController();
  final _costController = TextEditingController();

  void _addItem() {
    if (_selectedPart == null) return;
    final qty = int.tryParse(_qtyController.text) ?? 0;
    final cost = double.tryParse(_costController.text) ?? 0.0;
    
    if (qty > 0 && cost > 0) {
      setState(() {
        _items.add(_GrnItem(part: _selectedPart!, qty: qty, unitCostPaisa: (cost * 100).toInt()));
        _selectedPart = null;
        _qtyController.clear();
        _costController.clear();
      });
    }
  }

  void _postGrn() async {
    if (_items.isEmpty) return;
    
    final db = ref.read(dbProvider);
    final totalAmount = _items.fold<int>(0, (sum, item) => sum + (item.qty * item.unitCostPaisa));

    await db.transaction(() async {
      // 1. Create Purchase record
      final grnId = await db.into(db.purchasesGrn).insert(
        PurchasesGrnCompanion(
          supplierInvoiceNo: drift.Value(_vendorBillController.text),
          purchaseDate: drift.Value(DateTime.now()),
          totalAmountPaisa: drift.Value(totalAmount),
          notes: drift.Value(_notesController.text),
          createdBy: const drift.Value(1), // Dummy user ID
        )
      );

      // 2. Add items, update stock & moving average cost
      for (final item in _items) {
        final lineTotal = item.qty * item.unitCostPaisa;
        await db.into(db.purchaseItemsGrn).insert(
          PurchaseItemsGrnCompanion(
            grnId: drift.Value(grnId),
            partId: drift.Value(item.part.id),
            quantityReceived: drift.Value(item.qty),
            unitPurchasePricePaisa: drift.Value(item.unitCostPaisa),
            lineTotalPaisa: drift.Value(lineTotal),
          )
        );

        // Update Part stock and avg cost
        final newStock = item.part.currentStock + item.qty;
        // Simplified moving average cost for this example
        final totalOldValue = item.part.currentStock * item.part.avgCostPaisa;
        final totalNewValue = item.qty * item.unitCostPaisa;
        final newAvgCost = newStock > 0 ? (totalOldValue + totalNewValue) ~/ newStock : 0;

        await (db.update(db.parts)..where((t) => t.id.equals(item.part.id))).write(
          PartsCompanion(
            currentStock: drift.Value(newStock),
            avgCostPaisa: drift.Value(newAvgCost),
          )
        );

        // Record stock movement (We don't strictly have a GRN_IN in StockAdjustments constraints according to TRD, but TRD specifies reason must be DAMAGE, PHYSICAL_AUDIT, DEFECTIVE_BATCH, INTERNAL_USE for StockAdjustments. Wait! GRN and Sales affect stock directly but maybe shouldn't go into stock_adjustments table, or if they do, TRD says stock_adjustments reason MUST be IN... wait. TRD says: reason TEXT NOT NULL CHECK(reason IN ('DAMAGE', 'PHYSICAL_AUDIT', 'DEFECTIVE_BATCH', 'INTERNAL_USE')). So we shouldn't insert GRN movements into stock_adjustments. Let's just omit writing to stock_adjustments for GRN!)
      }
    });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('GRN Posted Successfully!')));
      setState(() {
        _items.clear();
        _vendorBillController.clear();
        _notesController.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final db = ref.watch(dbProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Purchases / GRN')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _vendorBillController,
              decoration: const InputDecoration(labelText: 'Vendor Bill No (Optional)'),
            ),
            TextField(
              controller: _notesController,
              decoration: const InputDecoration(labelText: 'Notes (Optional)'),
            ),
            const Divider(),
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: FutureBuilder<List<Part>>(
                    future: db.select(db.parts).get(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) return const CircularProgressIndicator();
                      final parts = snapshot.data!;
                      return DropdownButtonFormField<Part>(
                        decoration: const InputDecoration(labelText: 'Select Part'),
                        value: _selectedPart,
                        items: parts.map((p) => DropdownMenuItem(value: p, child: Text(p.nameEn))).toList(),
                        onChanged: (v) => setState(() => _selectedPart = v),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: _qtyController,
                    decoration: const InputDecoration(labelText: 'Qty'),
                    keyboardType: TextInputType.number,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: _costController,
                    decoration: const InputDecoration(labelText: 'Unit Cost (Rs)'),
                    keyboardType: TextInputType.number,
                  ),
                ),
                IconButton(icon: const Icon(Icons.add), onPressed: _addItem),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: _items.length,
                itemBuilder: (context, index) {
                  final item = _items[index];
                  return ListTile(
                    title: Text(item.part.nameEn),
                    subtitle: Text('Qty: ${item.qty} @ Rs${item.unitCostPaisa / 100}'),
                    trailing: Text('Total: Rs${(item.qty * item.unitCostPaisa) / 100}'),
                  );
                },
              ),
            ),
            ElevatedButton(
              onPressed: _items.isNotEmpty ? _postGrn : null,
              style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 50)),
              child: const Text('POST GRN & UPDATE STOCK'),
            )
          ],
        ),
      ),
    );
  }
}

class _GrnItem {
  final Part part;
  final int qty;
  final int unitCostPaisa;
  _GrnItem({required this.part, required this.qty, required this.unitCostPaisa});
}
