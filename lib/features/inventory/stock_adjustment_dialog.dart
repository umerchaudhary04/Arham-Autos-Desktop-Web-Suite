import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart' as drift;
import '../../core/db/app_database.dart';
import 'parts_master_screen.dart';

class StockAdjustmentDialog extends ConsumerStatefulWidget {
  final Part part;
  const StockAdjustmentDialog({super.key, required this.part});

  @override
  ConsumerState<StockAdjustmentDialog> createState() => _StockAdjustmentDialogState();
}

class _StockAdjustmentDialogState extends ConsumerState<StockAdjustmentDialog> {
  final _formKey = GlobalKey<FormState>();
  final _qtyController = TextEditingController();
  final _reasonController = TextEditingController();
  String _adjustmentType = 'ADJ_IN'; // or ADJ_OUT

  void _save() async {
    if (_formKey.currentState!.validate()) {
      final db = ref.read(dbProvider);
      
      final qtyChange = int.parse(_qtyController.text);
      final finalQtyChange = _adjustmentType == 'ADJ_OUT' ? -qtyChange : qtyChange;
      
      final newStock = widget.part.currentStock + finalQtyChange;
      if (newStock < 0) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Stock cannot go below 0')));
        return;
      }

      await db.transaction(() async {
        // Update part stock
        await (db.update(db.parts)..where((t) => t.id.equals(widget.part.id))).write(
          PartsCompanion(currentStock: drift.Value(newStock)),
        );
        
        // Record movement
        await db.into(db.stockMovements).insert(
          StockMovementsCompanion(
            partId: drift.Value(widget.part.id),
            movementType: drift.Value(_adjustmentType),
            qtyChange: drift.Value(finalQtyChange),
            unitCostPaisa: drift.Value(widget.part.avgCostPaisa),
            notes: drift.Value(_reasonController.text),
            userId: const drift.Value(1), // Dummy user ID for now
          )
        );
      });

      if (mounted) Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Adjust Stock: ${widget.part.nameEn}'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Current Stock: ${widget.part.currentStock}'),
            const SizedBox(height: 10),
            DropdownButtonFormField<String>(
              value: _adjustmentType,
              items: const [
                DropdownMenuItem(value: 'ADJ_IN', child: Text('Add to Stock (+)')),
                DropdownMenuItem(value: 'ADJ_OUT', child: Text('Remove from Stock (-)')),
              ],
              onChanged: (v) => setState(() => _adjustmentType = v!),
              decoration: const InputDecoration(labelText: 'Adjustment Type'),
            ),
            TextFormField(
              controller: _qtyController,
              decoration: const InputDecoration(labelText: 'Quantity'),
              keyboardType: TextInputType.number,
              validator: (v) {
                if (v == null || v.isEmpty) return 'Required';
                if (int.tryParse(v) == null || int.parse(v) <= 0) return 'Enter valid quantity > 0';
                return null;
              },
            ),
            TextFormField(
              controller: _reasonController,
              decoration: const InputDecoration(labelText: 'Reason for Adjustment *'),
              validator: (v) => v == null || v.trim().isEmpty ? 'Reason is compulsory' : null,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
        ElevatedButton(onPressed: _save, child: const Text('Confirm')),
      ],
    );
  }
}
