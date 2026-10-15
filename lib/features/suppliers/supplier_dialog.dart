import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart' as drift;
import '../../core/db/app_database.dart';
import '../inventory/parts_master_screen.dart'; // contains dbProvider

class SupplierFormDialog extends ConsumerStatefulWidget {
  final Supplier? supplier;
  const SupplierFormDialog({super.key, this.supplier});

  @override
  ConsumerState<SupplierFormDialog> createState() => _SupplierFormDialogState();
}

class _SupplierFormDialogState extends ConsumerState<SupplierFormDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _companyController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _openingBalanceController = TextEditingController(text: '0');

  @override
  void initState() {
    super.initState();
    if (widget.supplier != null) {
      _nameController.text = widget.supplier!.name;
      _companyController.text = widget.supplier!.company ?? '';
      _phoneController.text = widget.supplier!.phone ?? '';
      _addressController.text = widget.supplier!.address ?? '';
      _openingBalanceController.text = (widget.supplier!.currentBalancePaisa / 100).toStringAsFixed(2);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _companyController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _openingBalanceController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    final db = ref.read(dbProvider);
    final name = _nameController.text.trim();
    final company = _companyController.text.trim();
    final phone = _phoneController.text.trim();
    final address = _addressController.text.trim();
    final openingBalance = (double.tryParse(_openingBalanceController.text.trim()) ?? 0.0) * 100;

    Supplier? savedSupplier;

    if (widget.supplier == null) {
      final id = await db.into(db.suppliers).insert(
        SuppliersCompanion(
          name: drift.Value(name),
          company: drift.Value(company.isEmpty ? null : company),
          phone: drift.Value(phone.isEmpty ? null : phone),
          address: drift.Value(address.isEmpty ? null : address),
          currentBalancePaisa: drift.Value(openingBalance.toInt()),
        ),
      );

      savedSupplier = await (db.select(db.suppliers)..where((t) => t.id.equals(id))).getSingle();
    } else {
      await (db.update(db.suppliers)..where((t) => t.id.equals(widget.supplier!.id))).write(
        SuppliersCompanion(
          name: drift.Value(name),
          company: drift.Value(company.isEmpty ? null : company),
          phone: drift.Value(phone.isEmpty ? null : phone),
          address: drift.Value(address.isEmpty ? null : address),
        ),
      );

      savedSupplier = await (db.select(db.suppliers)..where((t) => t.id.equals(widget.supplier!.id))).getSingle();
    }

    if (mounted) {
      Navigator.of(context).pop(savedSupplier);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.supplier != null;

    return AlertDialog(
      title: Text(isEdit ? 'Edit Supplier' : 'Add New Supplier'),
      content: SingleChildScrollView(
        child: SizedBox(
          width: 440,
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Contact Person / Supplier Name *',
                    prefixIcon: Icon(Icons.person_outline),
                    border: OutlineInputBorder(),
                  ),
                  validator: (v) => v == null || v.trim().isEmpty ? 'Supplier name is required' : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _companyController,
                  decoration: const InputDecoration(
                    labelText: 'Company / Business Name',
                    prefixIcon: Icon(Icons.business_outlined),
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _phoneController,
                  decoration: const InputDecoration(
                    labelText: 'Phone Number',
                    prefixIcon: Icon(Icons.phone_outlined),
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.phone,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _addressController,
                  decoration: const InputDecoration(
                    labelText: 'Address / Market Location',
                    prefixIcon: Icon(Icons.location_on_outlined),
                    border: OutlineInputBorder(),
                  ),
                ),
                if (!isEdit) ...[
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _openingBalanceController,
                    decoration: const InputDecoration(
                      labelText: 'Opening Payable Balance (Rs)',
                      prefixIcon: Icon(Icons.account_balance_wallet_outlined),
                      border: OutlineInputBorder(),
                      helperText: 'Positive = store owes supplier (payable)',
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF0F172A),
            foregroundColor: Colors.white,
          ),
          onPressed: _save,
          child: Text(isEdit ? 'Update Supplier' : 'Save Supplier'),
        ),
      ],
    );
  }
}

class SupplierManagementDialog extends ConsumerStatefulWidget {
  const SupplierManagementDialog({super.key});

  @override
  ConsumerState<SupplierManagementDialog> createState() => _SupplierManagementDialogState();
}

class _SupplierManagementDialogState extends ConsumerState<SupplierManagementDialog> {
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final db = ref.watch(dbProvider);

    return AlertDialog(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text('Supplier Directory & Directory Master'),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF0F172A),
              foregroundColor: Colors.white,
            ),
            icon: const Icon(Icons.add, size: 18),
            label: const Text('Add Supplier'),
            onPressed: () async {
              final newSupplier = await showDialog<Supplier>(
                context: context,
                builder: (_) => const SupplierFormDialog(),
              );
              if (newSupplier != null && mounted) {
                setState(() {});
              }
            },
          ),
        ],
      ),
      content: SizedBox(
        width: 720,
        height: 480,
        child: Column(
          children: [
            TextField(
              decoration: const InputDecoration(
                hintText: 'Search suppliers by name, company, or phone...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (val) => setState(() => _searchQuery = val.trim().toLowerCase()),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: StreamBuilder<List<Supplier>>(
                stream: db.select(db.suppliers).watch(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
                  final suppliers = snapshot.data!.where((s) {
                    if (_searchQuery.isEmpty) return true;
                    final nameMatch = s.name.toLowerCase().contains(_searchQuery);
                    final companyMatch = (s.company ?? '').toLowerCase().contains(_searchQuery);
                    final phoneMatch = (s.phone ?? '').toLowerCase().contains(_searchQuery);
                    return nameMatch || companyMatch || phoneMatch;
                  }).toList();

                  if (suppliers.isEmpty) {
                    return const Center(child: Text('No suppliers found. Click "+ Add Supplier" to create one.'));
                  }

                  return ListView.separated(
                    itemCount: suppliers.length,
                    separatorBuilder: (_, __) => const Divider(height: 1),
                    itemBuilder: (context, index) {
                      final s = suppliers[index];
                      final balance = s.currentBalancePaisa / 100;

                      return ListTile(
                        leading: CircleAvatar(
                          backgroundColor: const Color(0xFFF1F5F9),
                          foregroundColor: const Color(0xFF0F172A),
                          child: Text(s.name.isNotEmpty ? s.name[0].toUpperCase() : 'S'),
                        ),
                        title: Text(
                          s.name,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          '${s.company != null && s.company!.isNotEmpty ? "${s.company} • " : ""}'
                          '${s.phone ?? "No phone"} • ${s.address ?? "No address"}',
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                const Text('Payable Balance:', style: TextStyle(fontSize: 11, color: Colors.grey)),
                                Text(
                                  'Rs. ${balance.toStringAsFixed(2)}',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: balance > 0 ? Colors.red.shade700 : Colors.green.shade700,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(width: 8),
                            IconButton(
                              icon: const Icon(Icons.edit, size: 20),
                              tooltip: 'Edit Supplier',
                              onPressed: () async {
                                await showDialog<Supplier>(
                                  context: context,
                                  builder: (_) => SupplierFormDialog(supplier: s),
                                );
                                if (mounted) setState(() {});
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Close'),
        ),
      ],
    );
  }
}
