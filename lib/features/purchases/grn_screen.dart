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
      final purchaseId = await db.into(db.purchases).insert(
        PurchasesCompanion(
          vendorBillNo: drift.Value(_vendorBillController.text),
          totalAmountPaisa: drift.Value(totalAmount),
          recordedBy: const drift.Value(1), // Dummy user ID
        )
      );

      // 2. Add items, update stock & moving average cost
      for (final item in _items) {
        await db.into(db.purchaseItems).insert(
          PurchaseItemsCompanion(
            purchaseId: drift.Value(purchaseId),
            partId: drift.Value(item.part.id),
            qty: drift.Value(item.qty),
            unitCostPaisa: drift.Value(item.unitCostPaisa),
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

        // Record stock movement
        await db.into(db.stockMovements).insert(
          StockMovementsCompanion(
            partId: drift.Value(item.part.id),
            movementType: const drift.Value('GRN_IN'),
            qtyChange: drift.Value(item.qty),
            unitCostPaisa: drift.Value(item.unitCostPaisa),
            refTable: const drift.Value('purchases'),
            refId: drift.Value(purchaseId),
            userId: const drift.Value(1),
          )
        );
      }
    });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('GRN Posted Successfully!')));
      setState(() {
        _items.clear();
        _vendorBillController.clear();
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
