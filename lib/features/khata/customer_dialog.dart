import 'package:flutter/material.dart' hide Route;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart' as drift;
import '../../core/db/app_database.dart';
import '../inventory/parts_master_screen.dart'; // contains dbProvider

class CustomerFormDialog extends ConsumerStatefulWidget {
  final Customer? customer;
  const CustomerFormDialog({super.key, this.customer});

  @override
  ConsumerState<CustomerFormDialog> createState() => _CustomerFormDialogState();
}

class _CustomerFormDialogState extends ConsumerState<CustomerFormDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _shopNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _creditLimitController = TextEditingController(text: '50000');
  final _openingBalanceController = TextEditingController(text: '0');

  Route? _selectedRoute;
  String _customerType = 'RETAIL'; // RETAIL, WHOLESALE
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    if (widget.customer != null) {
      final c = widget.customer!;
      _nameController.text = c.name;
      _shopNameController.text = c.shopName ?? '';
      _phoneController.text = c.phone ?? '';
      _addressController.text = c.address ?? '';
      _customerType = c.customerType;
      _creditLimitController.text = c.creditLimitPaisa != null
          ? (c.creditLimitPaisa! / 100).toStringAsFixed(0)
          : '';
      _openingBalanceController.text = (c.currentBalancePaisa / 100).toStringAsFixed(0);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _shopNameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _creditLimitController.dispose();
    _openingBalanceController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);
    final db = ref.read(dbProvider);

    final name = _nameController.text.trim();
    final shopName = _shopNameController.text.trim();
    final phone = _phoneController.text.trim();
    final address = _addressController.text.trim();
    final creditLimitVal = double.tryParse(_creditLimitController.text.trim());
    final creditLimitPaisa = creditLimitVal != null ? (creditLimitVal * 100).toInt() : null;
    final openingBalanceVal = double.tryParse(_openingBalanceController.text.trim()) ?? 0.0;
    final openingBalancePaisa = (openingBalanceVal * 100).toInt();

    Customer? resultCustomer;

    try {
      await db.transaction(() async {
        if (widget.customer == null) {
          // Create new customer
          final newId = await db.into(db.customers).insert(
            CustomersCompanion(
              name: drift.Value(name),
              shopName: drift.Value(shopName.isEmpty ? null : shopName),
              phone: drift.Value(phone.isEmpty ? null : phone),
              address: drift.Value(address.isEmpty ? null : address),
              routeId: _selectedRoute != null ? drift.Value(_selectedRoute!.id) : const drift.Value.absent(),
              customerType: drift.Value(_customerType),
              creditLimitPaisa: drift.Value(creditLimitPaisa),
              currentBalancePaisa: drift.Value(openingBalancePaisa),
            ),
          );

          if (openingBalancePaisa != 0) {
            await db.into(db.customerLedgerEntries).insert(
              CustomerLedgerEntriesCompanion(
                customerId: drift.Value(newId),
                entryType: const drift.Value('ADJUSTMENT'),
                debitAmountPaisa: drift.Value(openingBalancePaisa > 0 ? openingBalancePaisa : 0),
                creditAmountPaisa: drift.Value(openingBalancePaisa < 0 ? -openingBalancePaisa : 0),
                runningBalancePaisa: drift.Value(openingBalancePaisa),
                notes: const drift.Value('Opening balance on account creation'),
              ),
            );
          }

          resultCustomer = await (db.select(db.customers)..where((t) => t.id.equals(newId))).getSingle();
        } else {
          // Update customer
          await (db.update(db.customers)..where((t) => t.id.equals(widget.customer!.id))).write(
            CustomersCompanion(
              name: drift.Value(name),
              shopName: drift.Value(shopName.isEmpty ? null : shopName),
              phone: drift.Value(phone.isEmpty ? null : phone),
              address: drift.Value(address.isEmpty ? null : address),
              routeId: _selectedRoute != null ? drift.Value(_selectedRoute!.id) : const drift.Value.absent(),
              customerType: drift.Value(_customerType),
              creditLimitPaisa: drift.Value(creditLimitPaisa),
            ),
          );

          resultCustomer = await (db.select(db.customers)..where((t) => t.id.equals(widget.customer!.id))).getSingle();
        }
      });

      if (mounted) {
        Navigator.of(context).pop(resultCustomer);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error saving customer: $e'), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final db = ref.watch(dbProvider);
    final isEdit = widget.customer != null;

    return AlertDialog(
      title: Text(isEdit ? 'Edit Customer Khata Profile' : 'Add New Customer Account'),
      content: SizedBox(
        width: 520,
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _nameController,
                        decoration: const InputDecoration(
                          labelText: 'Customer / Owner Name *',
                          prefixIcon: Icon(Icons.person_outline),
                          border: OutlineInputBorder(),
                        ),
                        validator: (v) => v == null || v.trim().isEmpty ? 'Customer name required' : null,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextFormField(
                        controller: _shopNameController,
                        decoration: const InputDecoration(
                          labelText: 'Shop / Business Name',
                          prefixIcon: Icon(Icons.storefront_outlined),
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _phoneController,
                        decoration: const InputDecoration(
                          labelText: 'Phone Number',
                          prefixIcon: Icon(Icons.phone_outlined),
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.phone,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        decoration: const InputDecoration(
                          labelText: 'Customer Tier / Pricing',
                          border: OutlineInputBorder(),
                        ),
                        value: _customerType,
                        items: const [
                          DropdownMenuItem(value: 'RETAIL', child: Text('Retail (B2C)')),
                          DropdownMenuItem(value: 'WHOLESALE', child: Text('Wholesale (B2B)')),
                        ],
                        onChanged: (v) => setState(() => _customerType = v ?? 'RETAIL'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                FutureBuilder<List<Route>>(
                  future: db.select(db.routes).get(),
                  builder: (context, snapshot) {
                    final routes = snapshot.data ?? [];
                    if (widget.customer?.routeId != null && _selectedRoute == null && routes.isNotEmpty) {
                      _selectedRoute = routes.firstWhere(
                        (r) => r.id == widget.customer!.routeId,
                        orElse: () => routes.first,
                      );
                    }
                    return DropdownButtonFormField<Route>(
                      decoration: const InputDecoration(
                        labelText: 'Assigned Route / Territory',
                        prefixIcon: Icon(Icons.route_outlined),
                        border: OutlineInputBorder(),
                      ),
                      value: _selectedRoute != null && routes.any((r) => r.id == _selectedRoute!.id)
                          ? routes.firstWhere((r) => r.id == _selectedRoute!.id)
                          : null,
                      items: routes.map((r) => DropdownMenuItem(value: r, child: Text('${r.name} (${r.city})'))).toList(),
                      onChanged: (r) => setState(() => _selectedRoute = r),
                    );
                  },
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _addressController,
                  decoration: const InputDecoration(
                    labelText: 'Market Address / Landmark',
                    prefixIcon: Icon(Icons.location_on_outlined),
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _creditLimitController,
                        decoration: const InputDecoration(
                          labelText: 'Credit Limit (Rs.)',
                          prefixIcon: Icon(Icons.credit_card_outlined),
                          border: OutlineInputBorder(),
                          helperText: 'Manager PIN required if breached',
                        ),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    if (!isEdit) ...[
                      const SizedBox(width: 12),
                      Expanded(
                        child: TextFormField(
                          controller: _openingBalanceController,
                          decoration: const InputDecoration(
                            labelText: 'Opening Balance (Rs.)',
                            prefixIcon: Icon(Icons.account_balance_wallet_outlined),
                            border: OutlineInputBorder(),
                            helperText: 'Positive = customer owes store',
                          ),
                          keyboardType: TextInputType.number,
                        ),
                      ),
                    ],
                  ],
                ),
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
          onPressed: _isSaving ? null : _save,
          child: _isSaving
              ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
              : Text(isEdit ? 'Update Customer' : 'Save Customer'),
        ),
      ],
    );
  }
}

class CustomerPaymentDialog extends ConsumerStatefulWidget {
  final Customer customer;
  const CustomerPaymentDialog({super.key, required this.customer});

  @override
  ConsumerState<CustomerPaymentDialog> createState() => _CustomerPaymentDialogState();
}

class _CustomerPaymentDialogState extends ConsumerState<CustomerPaymentDialog> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _refController = TextEditingController();
  final _notesController = TextEditingController();
  String _paymentMode = 'CASH'; // CASH, BANK_TRANSFER, CHEQUE
  bool _isPosting = false;

  @override
  void dispose() {
    _amountController.dispose();
    _refController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _recordPayment() async {
    if (!_formKey.currentState!.validate()) return;

    final amountVal = double.tryParse(_amountController.text.trim()) ?? 0.0;
    if (amountVal <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Payment amount must be greater than Rs 0.')),
      );
      return;
    }

    setState(() => _isPosting = true);
    final db = ref.read(dbProvider);
    final amountPaisa = (amountVal * 100).toInt();
    final refStr = _refController.text.trim();
    final notesStr = _notesController.text.trim();

    try {
      await db.transaction(() async {
        final freshCustomer = await (db.select(db.customers)..where((t) => t.id.equals(widget.customer.id))).getSingle();
        final newBalance = freshCustomer.currentBalancePaisa - amountPaisa;

        // 1. Update customer balance
        await (db.update(db.customers)..where((t) => t.id.equals(freshCustomer.id))).write(
          CustomersCompanion(
            currentBalancePaisa: drift.Value(newBalance),
          ),
        );

        // 2. Insert customer ledger entry
        await db.into(db.customerLedgerEntries).insert(
          CustomerLedgerEntriesCompanion(
            customerId: drift.Value(freshCustomer.id),
            entryType: const drift.Value('PAYMENT_CREDIT'),
            debitAmountPaisa: const drift.Value(0),
            creditAmountPaisa: drift.Value(amountPaisa),
            runningBalancePaisa: drift.Value(newBalance),
            notes: drift.Value('Recovery Mode: $_paymentMode${refStr.isNotEmpty ? " | Ref: $refStr" : ""}${notesStr.isNotEmpty ? " | $notesStr" : ""}'),
          ),
        );

        // 3. Log audit trail
        await db.into(db.auditLogs).insert(
          AuditLogsCompanion.insert(
            actionType: 'PAYMENT_RECOVERY',
            details: 'Recovery of Rs ${amountVal.toStringAsFixed(2)} ($_paymentMode) received from ${freshCustomer.name}',
          ),
        );
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Payment of Rs ${amountVal.toStringAsFixed(2)} successfully credited!'),
            backgroundColor: Colors.green.shade800,
          ),
        );
        Navigator.of(context).pop(true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error recording payment: $e'), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) setState(() => _isPosting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final curBal = widget.customer.currentBalancePaisa / 100;

    return AlertDialog(
      title: Text('Record Recovery: ${widget.customer.name}'),
      content: SizedBox(
        width: 440,
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Total Current Outstanding:', style: TextStyle(fontWeight: FontWeight.w600)),
                    Text(
                      'Rs ${curBal.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: curBal > 0 ? Colors.red.shade800 : Colors.green.shade800,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      decoration: const InputDecoration(labelText: 'Payment Mode', border: OutlineInputBorder()),
                      value: _paymentMode,
                      items: const [
                        DropdownMenuItem(value: 'CASH', child: Text('Cash')),
                        DropdownMenuItem(value: 'BANK_TRANSFER', child: Text('Bank Transfer')),
                        DropdownMenuItem(value: 'CHEQUE', child: Text('Cheque / Slip')),
                      ],
                      onChanged: (v) => setState(() => _paymentMode = v ?? 'CASH'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextFormField(
                      controller: _amountController,
                      decoration: const InputDecoration(
                        labelText: 'Received Amount (Rs.) *',
                        prefixIcon: Icon(Icons.attach_money),
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      validator: (v) => v == null || v.trim().isEmpty ? 'Amount required' : null,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _refController,
                decoration: const InputDecoration(
                  labelText: 'Receipt No / Cheque / Txn Ref',
                  prefixIcon: Icon(Icons.tag),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _notesController,
                decoration: const InputDecoration(
                  labelText: 'Notes / Remarks',
                  prefixIcon: Icon(Icons.notes),
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text('Cancel'),
        ),
        ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF0F172A),
            foregroundColor: Colors.white,
          ),
          onPressed: _isPosting ? null : _recordPayment,
          icon: const Icon(Icons.check_circle_outline, size: 18),
          label: _isPosting
              ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
              : const Text('Post Recovery'),
        ),
      ],
    );
  }
}

class SupplierPaymentDialog extends ConsumerStatefulWidget {
  final Supplier supplier;
  const SupplierPaymentDialog({super.key, required this.supplier});

  @override
  ConsumerState<SupplierPaymentDialog> createState() => _SupplierPaymentDialogState();
}

class _SupplierPaymentDialogState extends ConsumerState<SupplierPaymentDialog> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _refController = TextEditingController();
  final _notesController = TextEditingController();
  String _paymentMode = 'CASH';
  bool _isPosting = false;

  @override
  void dispose() {
    _amountController.dispose();
    _refController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _recordPayment() async {
    if (!_formKey.currentState!.validate()) return;

    final amountVal = double.tryParse(_amountController.text.trim()) ?? 0.0;
    if (amountVal <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Payment amount must be greater than Rs 0.')),
      );
      return;
    }

    setState(() => _isPosting = true);
    final db = ref.read(dbProvider);
    final amountPaisa = (amountVal * 100).toInt();
    final refStr = _refController.text.trim();
    final notesStr = _notesController.text.trim();

    try {
      await db.transaction(() async {
        final freshSupplier = await (db.select(db.suppliers)..where((t) => t.id.equals(widget.supplier.id))).getSingle();
        final newBalance = freshSupplier.currentBalancePaisa - amountPaisa;

        // 1. Update supplier balance
        await (db.update(db.suppliers)..where((t) => t.id.equals(freshSupplier.id))).write(
          SuppliersCompanion(
            currentBalancePaisa: drift.Value(newBalance),
          ),
        );

        // 2. Insert supplier ledger entry
        await db.into(db.supplierLedgerEntries).insert(
          SupplierLedgerEntriesCompanion(
            supplierId: drift.Value(freshSupplier.id),
            entryType: const drift.Value('PAYMENT_PAID'),
            debitAmountPaisa: drift.Value(amountPaisa),
            creditAmountPaisa: const drift.Value(0),
            runningBalancePaisa: drift.Value(newBalance),
            notes: drift.Value('Disbursement: $_paymentMode${refStr.isNotEmpty ? " | Ref: $refStr" : ""}${notesStr.isNotEmpty ? " | $notesStr" : ""}'),
          ),
        );

        // 3. Log audit trail
        await db.into(db.auditLogs).insert(
          AuditLogsCompanion.insert(
            actionType: 'SUPPLIER_PAYMENT',
            details: 'Disbursement of Rs ${amountVal.toStringAsFixed(2)} ($_paymentMode) paid to ${freshSupplier.name}',
          ),
        );
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Payment of Rs ${amountVal.toStringAsFixed(2)} successfully recorded!'),
            backgroundColor: Colors.green.shade800,
          ),
        );
        Navigator.of(context).pop(true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error recording payment: $e'), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) setState(() => _isPosting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final curBal = widget.supplier.currentBalancePaisa / 100;

    return AlertDialog(
      title: Text('Supplier Payment: ${widget.supplier.name}'),
      content: SizedBox(
        width: 440,
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Current Payable Balance:', style: TextStyle(fontWeight: FontWeight.w600)),
                    Text(
                      'Rs ${curBal.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: curBal > 0 ? Colors.red.shade800 : Colors.green.shade800,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      decoration: const InputDecoration(labelText: 'Payment Mode', border: OutlineInputBorder()),
                      value: _paymentMode,
                      items: const [
                        DropdownMenuItem(value: 'CASH', child: Text('Cash')),
                        DropdownMenuItem(value: 'BANK_TRANSFER', child: Text('Bank Transfer')),
                        DropdownMenuItem(value: 'CHEQUE', child: Text('Cheque / Pay Order')),
                      ],
                      onChanged: (v) => setState(() => _paymentMode = v ?? 'CASH'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextFormField(
                      controller: _amountController,
                      decoration: const InputDecoration(
                        labelText: 'Paid Amount (Rs.) *',
                        prefixIcon: Icon(Icons.attach_money),
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      validator: (v) => v == null || v.trim().isEmpty ? 'Amount required' : null,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _refController,
                decoration: const InputDecoration(
                  labelText: 'Payment Voucher / Cheque / Txn Ref',
                  prefixIcon: Icon(Icons.tag),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _notesController,
                decoration: const InputDecoration(
                  labelText: 'Notes / Remarks',
                  prefixIcon: Icon(Icons.notes),
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text('Cancel'),
        ),
        ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF0F172A),
            foregroundColor: Colors.white,
          ),
          onPressed: _isPosting ? null : _recordPayment,
          icon: const Icon(Icons.check_circle_outline, size: 18),
          label: _isPosting
              ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
              : const Text('Post Payment'),
        ),
      ],
    );
  }
}
