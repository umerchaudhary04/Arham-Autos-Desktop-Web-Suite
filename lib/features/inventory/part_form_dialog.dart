import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart' as drift;
import '../../core/db/app_database.dart';
import 'parts_master_screen.dart';

class PartFormDialog extends ConsumerStatefulWidget {
  final Part? part;
  const PartFormDialog({super.key, this.part});

  @override
  ConsumerState<PartFormDialog> createState() => _PartFormDialogState();
}

class _PartFormDialogState extends ConsumerState<PartFormDialog> {
  final _formKey = GlobalKey<FormState>();
  final _codeController = TextEditingController();
  final _nameEnController = TextEditingController();
  final _nameUrController = TextEditingController();
  final _retailPriceController = TextEditingController();
  final _wholesalePriceController = TextEditingController();
  final _shelfLocationController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.part != null) {
      _codeController.text = widget.part!.code;
      _nameEnController.text = widget.part!.nameEn;
      _nameUrController.text = widget.part!.nameUr ?? '';
      _retailPriceController.text = (widget.part!.retailPricePaisa / 100).toString();
      _wholesalePriceController.text = (widget.part!.wholesalePricePaisa / 100).toString();
      _shelfLocationController.text = widget.part!.shelfLocation ?? '';
    }
  }

  void _save() async {
    if (_formKey.currentState!.validate()) {
      final db = ref.read(dbProvider);
      final companion = PartsCompanion(
        code: drift.Value(_codeController.text),
        nameEn: drift.Value(_nameEnController.text),
        nameUr: drift.Value(_nameUrController.text.isEmpty ? null : _nameUrController.text),
        retailPricePaisa: drift.Value((double.parse(_retailPriceController.text) * 100).toInt()),
        wholesalePricePaisa: drift.Value((double.parse(_wholesalePriceController.text) * 100).toInt()),
        shelfLocation: drift.Value(_shelfLocationController.text.isEmpty ? null : _shelfLocationController.text),
        categoryId: const drift.Value(1), // Dummy category for now
      );

      if (widget.part == null) {
        // First ensure dummy category exists
        final cat = await (db.select(db.partCategories)..limit(1)).getSingleOrNull();
        if (cat == null) {
          await db.into(db.partCategories).insert(
            PartCategoriesCompanion(nameEn: const drift.Value('General'))
          );
        }
        await db.into(db.parts).insert(companion);
      } else {
        await (db.update(db.parts)..where((t) => t.id.equals(widget.part!.id))).write(companion);
      }
      if (mounted) Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.part == null ? 'Add Part' : 'Edit Part'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _codeController,
                decoration: const InputDecoration(labelText: 'Part Code'),
                validator: (v) => v!.isEmpty ? 'Required' : null,
              ),
              TextFormField(
                controller: _nameEnController,
                decoration: const InputDecoration(labelText: 'Name (English)'),
                validator: (v) => v!.isEmpty ? 'Required' : null,
              ),
              TextFormField(
                controller: _nameUrController,
                decoration: const InputDecoration(labelText: 'Name (Urdu - Optional)'),
                textDirection: TextDirection.rtl,
              ),
              TextFormField(
                controller: _retailPriceController,
                decoration: const InputDecoration(labelText: 'Retail Price (Rs)'),
                keyboardType: TextInputType.number,
                validator: (v) => v!.isEmpty ? 'Required' : null,
              ),
              TextFormField(
                controller: _wholesalePriceController,
                decoration: const InputDecoration(labelText: 'Wholesale Price (Rs)'),
                keyboardType: TextInputType.number,
                validator: (v) => v!.isEmpty ? 'Required' : null,
              ),
              TextFormField(
                controller: _shelfLocationController,
                decoration: const InputDecoration(labelText: 'Shelf Location (Optional)'),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
        ElevatedButton(onPressed: _save, child: const Text('Save')),
      ],
    );
  }
}
