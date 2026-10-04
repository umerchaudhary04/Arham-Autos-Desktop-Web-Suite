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
  final _notesController = TextEditingController();
  String _adjustmentType = 'ADJ_IN'; // or ADJ_OUT
  String _reason = 'PHYSICAL_AUDIT'; // Default valid reason

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
        await db.into(db.stockAdjustments).insert(
          StockAdjustmentsCompanion(
            partId: drift.Value(widget.part.id),
            quantityChange: drift.Value(finalQtyChange),
            reason: drift.Value(_reason),
            notes: drift.Value(_notesController.text),
            adjustedBy: const drift.Value(1), // Dummy user ID for now
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
            DropdownButtonFormField<String>(
              value: _reason,
              items: const [
                DropdownMenuItem(value: 'DAMAGE', child: Text('Damage')),
                DropdownMenuItem(value: 'PHYSICAL_AUDIT', child: Text('Physical Audit')),
                DropdownMenuItem(value: 'DEFECTIVE_BATCH', child: Text('Defective Batch')),
                DropdownMenuItem(value: 'INTERNAL_USE', child: Text('Internal Use')),
              ],
              onChanged: (v) => setState(() => _reason = v!),
              decoration: const InputDecoration(labelText: 'Reason for Adjustment *'),
            ),
            TextFormField(
              controller: _notesController,
              decoration: const InputDecoration(labelText: 'Notes (Optional)'),
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
