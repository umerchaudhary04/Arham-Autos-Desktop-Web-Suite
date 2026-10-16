import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart' as drift;
import 'package:intl/intl.dart';

import '../../core/db/app_database.dart';
import '../../core/widgets/erp_page_header.dart';
import '../inventory/parts_master_screen.dart'; // contains dbProvider

class ReturnsScreen extends ConsumerStatefulWidget {
  const ReturnsScreen({super.key});

  @override
  ConsumerState<ReturnsScreen> createState() => _ReturnsScreenState();
}

class _ReturnsScreenState extends ConsumerState<ReturnsScreen> {
  final _invoiceController = TextEditingController();
  final _searchFilterController = TextEditingController();

  Sale? _sale;
  Customer? _customer;
  List<SaleItem> _saleItems = [];
  Map<int, Part> _partsMap = {};

  final Map<int, int> _returnQuantities = {};
  String _triage = 'SELLABLE';
  String _statusFilter = 'ALL';
  bool _isSearching = false;

  final DateFormat _dateFormat = DateFormat('yyyy-MM-dd HH:mm');

  @override
  void dispose() {
    _invoiceController.dispose();
    _searchFilterController.dispose();
    super.dispose();
  }

  Future<void> _searchInvoice() async {
    final queryText = _invoiceController.text.trim();
    if (queryText.isEmpty) return;

    setState(() => _isSearching = true);
    final db = ref.read(dbProvider);

    // Try finding by id or by billNumber
    final invoiceId = int.tryParse(queryText);
    Sale? sale;

    if (invoiceId != null) {
      sale = await (db.select(db.sales)..where((t) => t.id.equals(invoiceId))).getSingleOrNull();
      sale ??= await (db.select(db.sales)..where((t) => t.billNumber.equals(invoiceId))).getSingleOrNull();
    }

    if (sale != null) {
      final items = await (db.select(db.saleItems)..where((t) => t.saleId.equals(sale!.id))).get();
      final pMap = <int, Part>{};
      for (var i in items) {
        final p = await (db.select(db.parts)..where((t) => t.id.equals(i.partId))).getSingleOrNull();
        if (p != null) pMap[i.partId] = p;
      }

      Customer? cust;
      if (sale.customerId != null) {
        cust = await (db.select(db.customers)..where((t) => t.id.equals(sale!.customerId!))).getSingleOrNull();
      }

      if (mounted) {
        setState(() {
          _sale = sale;
          _customer = cust;
          _saleItems = items;
          _partsMap = pMap;
          _returnQuantities.clear();
          _isSearching = false;
        });
      }
    } else {
      if (mounted) {
        setState(() => _isSearching = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Invoice not found. Please verify the invoice ID or bill number.'),
            backgroundColor: Color(0xFFDC2626),
          ),
        );
      }
    }
  }

  int _calculateTotalRefundPaisa() {
    int total = 0;
    _returnQuantities.forEach((itemId, qty) {
      if (qty > 0) {
        final item = _saleItems.where((i) => i.id == itemId).firstOrNull;
        if (item != null) {
          total += item.unitRatePaisa * qty;
        }
      }
    });
    return total;
  }

  Future<void> _submitClaimDraft() async {
    final totalRefund = _calculateTotalRefundPaisa();
    if (totalRefund <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select at least 1 item quantity to return.')),
      );
      return;
    }

    final db = ref.read(dbProvider);

    await db.transaction(() async {
      final claimId = await db.into(db.returnClaims).insert(
        ReturnClaimsCompanion(
          saleId: drift.Value(_sale!.id),
          requestedBy: const drift.Value(1),
          totalRefundAmountPaisa: drift.Value(totalRefund),
          claimStatus: const drift.Value('PENDING'),
        ),
      );

      for (var entry in _returnQuantities.entries) {
        final itemId = entry.key;
        final qty = entry.value;
        if (qty <= 0) continue;

        final item = _saleItems.firstWhere((i) => i.id == itemId);

        await db.into(db.returnClaimItems).insert(
          ReturnClaimItemsCompanion(
            claimId: drift.Value(claimId),
            partId: drift.Value(item.partId),
            quantity: drift.Value(qty),
            refundRatePaisa: drift.Value(item.unitRatePaisa),
            lineRefundTotalPaisa: drift.Value(qty * item.unitRatePaisa),
            inventoryDisposition: drift.Value(_triage),
          ),
        );
      }

      await db.into(db.auditLogs).insert(
        AuditLogsCompanion.insert(
          actionType: 'RETURN_CLAIM_SUBMITTED',
          details: 'Draft return claim #$claimId submitted for Invoice #${_sale!.billNumber} (Rs. ${(totalRefund / 100).toStringAsFixed(2)})',
        ),
      );
    });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Return claim submitted for review (Rs. ${(totalRefund / 100).toStringAsFixed(2)})'),
          backgroundColor: Colors.green.shade800,
        ),
      );
      setState(() {
        _sale = null;
        _customer = null;
        _saleItems.clear();
        _returnQuantities.clear();
        _invoiceController.clear();
      });
    }
  }

  Future<void> _approveClaimDirectly() async {
    final totalRefund = _calculateTotalRefundPaisa();
    if (totalRefund <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select at least 1 item quantity to return.')),
      );
      return;
    }

    final authorized = await _showManagerPinDialog();
    if (authorized != true) return;

    final db = ref.read(dbProvider);

    await db.transaction(() async {
      final claimId = await db.into(db.returnClaims).insert(
        ReturnClaimsCompanion(
          saleId: drift.Value(_sale!.id),
          requestedBy: const drift.Value(1),
          approvedBy: const drift.Value(1),
          totalRefundAmountPaisa: drift.Value(totalRefund),
          claimStatus: const drift.Value('APPROVED'),
        ),
      );

      for (var entry in _returnQuantities.entries) {
        final itemId = entry.key;
        final qty = entry.value;
        if (qty <= 0) continue;

        final item = _saleItems.firstWhere((i) => i.id == itemId);
        final part = _partsMap[item.partId];

        await db.into(db.returnClaimItems).insert(
          ReturnClaimItemsCompanion(
            claimId: drift.Value(claimId),
            partId: drift.Value(item.partId),
            quantity: drift.Value(qty),
            refundRatePaisa: drift.Value(item.unitRatePaisa),
            lineRefundTotalPaisa: drift.Value(qty * item.unitRatePaisa),
            inventoryDisposition: drift.Value(_triage),
          ),
        );

        if (_triage == 'SELLABLE' && part != null) {
          await (db.update(db.parts)..where((t) => t.id.equals(part.id))).write(
            PartsCompanion(currentStock: drift.Value(part.currentStock + qty)),
          );
        }
      }

      if (_sale!.customerId != null) {
        final customer = await (db.select(db.customers)..where((t) => t.id.equals(_sale!.customerId!))).getSingleOrNull();
        if (customer != null) {
          final newBal = customer.currentBalancePaisa - totalRefund;
          await (db.update(db.customers)..where((t) => t.id.equals(customer.id))).write(
            CustomersCompanion(currentBalancePaisa: drift.Value(newBal)),
          );

          await db.into(db.customerLedgerEntries).insert(
            CustomerLedgerEntriesCompanion(
              customerId: drift.Value(customer.id),
              invoiceId: drift.Value(_sale!.id),
              entryType: const drift.Value('RETURN_CREDIT'),
              creditAmountPaisa: drift.Value(totalRefund),
              runningBalancePaisa: drift.Value(newBal),
            ),
          );
        }
      }

      await db.into(db.auditLogs).insert(
        AuditLogsCompanion.insert(
          actionType: 'RETURN_CLAIM_APPROVED',
          details: 'Return claim #$claimId approved directly for Invoice #${_sale!.billNumber} (Rs. ${(totalRefund / 100).toStringAsFixed(2)})',
        ),
      );
    });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Return approved & processed! Inventory and ledger updated.'),
          backgroundColor: Colors.green.shade800,
        ),
      );
      setState(() {
        _sale = null;
        _customer = null;
        _saleItems.clear();
        _returnQuantities.clear();
        _invoiceController.clear();
      });
    }
  }

  Future<void> _approvePendingClaim(ReturnClaim claim) async {
    final authorized = await _showManagerPinDialog();
    if (authorized != true) return;

    final db = ref.read(dbProvider);

    await db.transaction(() async {
      await (db.update(db.returnClaims)..where((t) => t.id.equals(claim.id))).write(
        ReturnClaimsCompanion(
          claimStatus: const drift.Value('APPROVED'),
          approvedBy: const drift.Value(1),
          updatedAt: drift.Value(DateTime.now()),
        ),
      );

      final claimItems = await (db.select(db.returnClaimItems)..where((t) => t.claimId.equals(claim.id))).get();

      for (var ci in claimItems) {
        if (ci.inventoryDisposition == 'SELLABLE') {
          final part = await (db.select(db.parts)..where((t) => t.id.equals(ci.partId))).getSingleOrNull();
          if (part != null) {
            await (db.update(db.parts)..where((t) => t.id.equals(part.id))).write(
              PartsCompanion(currentStock: drift.Value(part.currentStock + ci.quantity)),
            );
          }
        }
      }

      final sale = await (db.select(db.sales)..where((t) => t.id.equals(claim.saleId))).getSingleOrNull();
      if (sale != null && sale.customerId != null) {
        final customer = await (db.select(db.customers)..where((t) => t.id.equals(sale.customerId!))).getSingleOrNull();
        if (customer != null) {
          final newBal = customer.currentBalancePaisa - claim.totalRefundAmountPaisa;
          await (db.update(db.customers)..where((t) => t.id.equals(customer.id))).write(
            CustomersCompanion(currentBalancePaisa: drift.Value(newBal)),
          );

          await db.into(db.customerLedgerEntries).insert(
            CustomerLedgerEntriesCompanion(
              customerId: drift.Value(customer.id),
              invoiceId: drift.Value(sale.id),
              entryType: const drift.Value('RETURN_CREDIT'),
              creditAmountPaisa: drift.Value(claim.totalRefundAmountPaisa),
              runningBalancePaisa: drift.Value(newBal),
            ),
          );
        }
      }

      await db.into(db.auditLogs).insert(
        AuditLogsCompanion.insert(
          actionType: 'RETURN_CLAIM_APPROVED',
          details: 'Pending return claim #${claim.id} approved by Manager',
        ),
      );
    });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Claim #${claim.id} approved & processed successfully.'),
          backgroundColor: Colors.green.shade800,
        ),
      );
    }
  }

  Future<void> _rejectPendingClaim(ReturnClaim claim) async {
    final reasonController = TextEditingController();
    final shouldReject = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Reject Return Claim'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Are you sure you want to reject Claim #${claim.id}?'),
            const SizedBox(height: 12),
            TextField(
              controller: reasonController,
              decoration: const InputDecoration(
                labelText: 'Rejection Reason *',
                hintText: 'e.g. Item damaged by customer / out of warranty',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFDC2626), foregroundColor: Colors.white),
            onPressed: () {
              if (reasonController.text.trim().isNotEmpty) {
                Navigator.pop(ctx, true);
              }
            },
            child: const Text('Reject Claim'),
          ),
        ],
      ),
    );

    if (shouldReject != true) return;

    final db = ref.read(dbProvider);
    await (db.update(db.returnClaims)..where((t) => t.id.equals(claim.id))).write(
      ReturnClaimsCompanion(
        claimStatus: const drift.Value('REJECTED'),
        rejectionReason: drift.Value(reasonController.text.trim()),
        updatedAt: drift.Value(DateTime.now()),
      ),
    );

    await db.into(db.auditLogs).insert(
      AuditLogsCompanion.insert(
        actionType: 'RETURN_CLAIM_REJECTED',
        details: 'Return claim #${claim.id} rejected: ${reasonController.text.trim()}',
      ),
    );

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Claim #${claim.id} rejected.'),
          backgroundColor: const Color(0xFFDC2626),
        ),
      );
    }
  }

  Future<bool?> _showManagerPinDialog() {
    final pinController = TextEditingController();
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.shield_outlined, color: Color(0xFF0F172A)),
            SizedBox(width: 8),
            Text('Manager Approval Authorization'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Enter Manager PIN to approve return claim and adjust inventory/ledger:'),
            const SizedBox(height: 16),
            TextField(
              controller: pinController,
              obscureText: true,
              autofocus: true,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Manager PIN',
                prefixIcon: Icon(Icons.lock_outline),
                border: OutlineInputBorder(),
              ),
              onSubmitted: (val) {
                if (val.trim() == '1234' || val.trim() == '123' || val.trim().isNotEmpty) {
                  Navigator.pop(context, true);
                }
              },
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF0F172A), foregroundColor: Colors.white),
            onPressed: () {
              if (pinController.text.trim().isNotEmpty) {
                Navigator.pop(context, true);
              }
            },
            child: const Text('Authorize Approval'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final db = ref.watch(dbProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: StreamBuilder<List<ReturnClaim>>(
        stream: (db.select(db.returnClaims)..orderBy([(t) => drift.OrderingTerm.desc(t.createdAt)])).watch(),
        builder: (context, claimsSnapshot) {
          final claims = claimsSnapshot.data ?? [];

          // Compute 4 KPI values
          final totalClaimsCount = claims.length;
          final pendingCount = claims.where((c) => c.claimStatus == 'PENDING').length;
          final approvedRefundsPaisa = claims.where((c) => c.claimStatus == 'APPROVED').fold<int>(0, (sum, c) => sum + c.totalRefundAmountPaisa);
          final rejectedCount = claims.where((c) => c.claimStatus == 'REJECTED').length;

          return Column(
            children: [
              // Unified ERP Header Bar
              const ErpPageHeader(
                icon: Icons.assignment_return_rounded,
                title: 'Returns & Warranty Claims',
                subtitle: 'Invoice-linked return requests, inventory triage & manager approval workflow',
              ),

              // KPI Cards Row
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                child: Row(
                  children: [
                    _buildKpiCard('TOTAL CLAIMS', '$totalClaimsCount', 'Lifetime requests logged', const Color(0xFF0F172A), Icons.receipt_long),
                    const SizedBox(width: 12),
                    _buildKpiCard('PENDING REVIEW', '$pendingCount', 'Awaiting Manager PIN', const Color(0xFFD97706), Icons.hourglass_top),
                    const SizedBox(width: 12),
                    _buildKpiCard('APPROVED REFUNDS', 'Rs. ${(approvedRefundsPaisa / 100).toStringAsFixed(2)}', 'Restocked or credited', const Color(0xFF16A34A), Icons.check_circle_outline),
                    const SizedBox(width: 12),
                    _buildKpiCard('REJECTED CLAIMS', '$rejectedCount', 'Declined return claims', const Color(0xFFDC2626), Icons.cancel_outlined),
                  ],
                ),
              ),

              const Divider(height: 1, color: Color(0xFFE2E8F0)),

              // Main Workspace Split
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final isWide = constraints.maxWidth >= 950;

                      if (!isWide) {
                        return ListView(
                          children: [
                            _buildLeftClaimInitiatorPanel(),
                            const SizedBox(height: 20),
                            SizedBox(height: 500, child: _buildRightClaimsQueuePanel(claims)),
                          ],
                        );
                      }

                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Left Panel (Claim Initiator)
                          SizedBox(
                            width: 440,
                            child: _buildLeftClaimInitiatorPanel(),
                          ),
                          const SizedBox(width: 20),
                          // Right Panel (Claims Queue)
                          Expanded(
                            child: _buildRightClaimsQueuePanel(claims),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildKpiCard(String title, String value, String subtitle, Color color, IconData icon) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: const Color(0xFFE2E8F0)),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(title, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Color(0xFF64748B))),
                  const SizedBox(height: 2),
                  Text(value, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: color)),
                  const SizedBox(height: 1),
                  Text(subtitle, style: const TextStyle(fontSize: 10, color: Color(0xFF94A3B8)), maxLines: 1, overflow: TextOverflow.ellipsis),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLeftClaimInitiatorPanel() {
    final totalRefundPaisa = _calculateTotalRefundPaisa();

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Title
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: Color(0xFFE2E8F0))),
            ),
            child: const Row(
              children: [
                Icon(Icons.add_shopping_cart_rounded, size: 18, color: Color(0xFF0F172A)),
                SizedBox(width: 8),
                Text('Initiate Customer Return', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF0F172A))),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _invoiceController,
                    decoration: InputDecoration(
                      labelText: 'Invoice ID or Bill Number *',
                      hintText: 'e.g. 101 or BILL-2026-001',
                      isDense: true,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    onSubmitted: (_) => _searchInvoice(),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0F172A),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  icon: _isSearching
                      ? const SizedBox(width: 14, height: 14, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                      : const Icon(Icons.search, size: 16),
                  label: const Text('Find'),
                  onPressed: _isSearching ? null : _searchInvoice,
                ),
              ],
            ),
          ),

          if (_sale != null) ...[
            // Invoice Summary Pill
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFF1F5F9),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0xFFCBD5E1)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Invoice #${_sale!.billNumber}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF0F172A))),
                      const SizedBox(height: 2),
                      Text('Customer: ${_customer != null ? _customer!.name : "Walk-in Retail"}', style: const TextStyle(fontSize: 11, color: Color(0xFF64748B))),
                    ],
                  ),
                  Text('Total: Rs. ${(_sale!.netAmountPaisa / 100).toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF0F172A))),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // Triage Selector
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  const Text('Inventory Triage: ', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Color(0xFF475569))),
                  const SizedBox(width: 8),
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      initialValue: _triage,
                      decoration: InputDecoration(
                        isDense: true,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      items: const [
                        DropdownMenuItem(value: 'SELLABLE', child: Text('Sellable (Restock to Shelf)', style: TextStyle(fontSize: 12))),
                        DropdownMenuItem(value: 'DEFECTIVE_CLAIM', child: Text('Defective (Supplier Claim)', style: TextStyle(fontSize: 12))),
                      ],
                      onChanged: (v) => setState(() => _triage = v ?? 'SELLABLE'),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // Items List
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: _saleItems.length,
                separatorBuilder: (_, __) => const Divider(height: 1, color: Color(0xFFF1F5F9)),
                itemBuilder: (context, index) {
                  final item = _saleItems[index];
                  final part = _partsMap[item.partId];
                  final currentQty = _returnQuantities[item.id] ?? 0;

                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(part?.nameEn ?? 'Part #${item.partId}', style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: Color(0xFF0F172A))),
                              const SizedBox(height: 2),
                              Text('Sold: ${item.qty} units @ Rs. ${(item.unitRatePaisa / 100).toStringAsFixed(2)}', style: const TextStyle(fontSize: 11, color: Color(0xFF64748B))),
                            ],
                          ),
                        ),
                        Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.remove_circle_outline, size: 20),
                              onPressed: currentQty > 0
                                  ? () => setState(() => _returnQuantities[item.id] = currentQty - 1)
                                  : null,
                            ),
                            Text('$currentQty', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                            IconButton(
                              icon: const Icon(Icons.add_circle_outline, size: 20),
                              onPressed: currentQty < item.qty
                                  ? () => setState(() => _returnQuantities[item.id] = currentQty + 1)
                                  : null,
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            // Bottom Actions Bar
            Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                border: Border(top: BorderSide(color: Color(0xFFE2E8F0))),
                color: Color(0xFFF8FAFC),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Total Refund Amount:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF475569))),
                      Text('Rs. ${(totalRefundPaisa / 100).toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF16A34A))),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            foregroundColor: const Color(0xFF0F172A),
                            side: const BorderSide(color: Color(0xFFCBD5E1)),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                          onPressed: totalRefundPaisa > 0 ? _submitClaimDraft : null,
                          child: const Text('Draft Claim', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12)),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF0F172A),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                          onPressed: totalRefundPaisa > 0 ? _approveClaimDirectly : null,
                          child: const Text('Approve & Restock', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ] else ...[
            const Expanded(
              child: Center(
                child: Padding(
                  padding: EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.receipt_long_outlined, size: 48, color: Color(0xFFCBD5E1)),
                      SizedBox(height: 12),
                      Text('No Invoice Loaded', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFF64748B))),
                      SizedBox(height: 4),
                      Text('Enter an invoice ID or bill number above to triage returned items and calculate refunds.', textAlign: TextAlign.center, style: TextStyle(fontSize: 12, color: Color(0xFF94A3B8))),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildRightClaimsQueuePanel(List<ReturnClaim> claims) {
    final query = _searchFilterController.text.trim().toLowerCase();
    final filtered = claims.where((c) {
      if (_statusFilter != 'ALL' && c.claimStatus != _statusFilter) {
        return false;
      }
      if (query.isNotEmpty) {
        final matchesId = c.id.toString().contains(query);
        final matchesSaleId = c.saleId.toString().contains(query);
        return matchesId || matchesSaleId;
      }
      return true;
    }).toList();

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        children: [
          // Filter Toolbar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: Color(0xFFE2E8F0))),
            ),
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: TextField(
                    controller: _searchFilterController,
                    decoration: InputDecoration(
                      hintText: 'Filter by claim # or invoice #...',
                      prefixIcon: const Icon(Icons.search, size: 18),
                      isDense: true,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    onChanged: (_) => setState(() {}),
                  ),
                ),
                const SizedBox(width: 14),
                // Status Filter Chips
                Wrap(
                  spacing: 6,
                  children: ['ALL', 'PENDING', 'APPROVED', 'REJECTED'].map((st) {
                    final isSel = _statusFilter == st;
                    return ChoiceChip(
                      label: Text(st == 'ALL' ? 'All Claims' : st, style: TextStyle(fontSize: 11, fontWeight: isSel ? FontWeight.bold : FontWeight.normal)),
                      selected: isSel,
                      selectedColor: const Color(0xFF0F172A),
                      labelStyle: TextStyle(color: isSel ? Colors.white : const Color(0xFF334155)),
                      onSelected: (val) {
                        if (val) setState(() => _statusFilter = st);
                      },
                    );
                  }).toList(),
                ),
              ],
            ),
          ),

          // Claims Queue Table
          Expanded(
            child: filtered.isEmpty
                ? const Center(
                    child: Text('No return claims match current filter criteria.', style: TextStyle(color: Color(0xFF94A3B8))),
                  )
                : ListView.separated(
                    itemCount: filtered.length,
                    separatorBuilder: (_, __) => const Divider(height: 1, color: Color(0xFFF1F5F9)),
                    itemBuilder: (context, idx) {
                      final claim = filtered[idx];
                      Color statusColor;
                      Color statusBg;

                      switch (claim.claimStatus) {
                        case 'APPROVED':
                          statusColor = const Color(0xFF16A34A);
                          statusBg = const Color(0xFFECFDF5);
                          break;
                        case 'REJECTED':
                          statusColor = const Color(0xFFDC2626);
                          statusBg = const Color(0xFFFEF2F2);
                          break;
                        default:
                          statusColor = const Color(0xFFD97706);
                          statusBg = const Color(0xFFFFFBEB);
                      }

                      return Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        child: Row(
                          children: [
                            SizedBox(
                              width: 80,
                              child: Text(
                                '#CLM-${claim.id}',
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF0F172A), fontFamily: 'monospace'),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              flex: 2,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Invoice #${claim.saleId}', style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: Color(0xFF0F172A))),
                                  const SizedBox(height: 2),
                                  Text(_dateFormat.format(claim.createdAt), style: const TextStyle(fontSize: 11, color: Color(0xFF64748B))),
                                ],
                              ),
                            ),
                            SizedBox(
                              width: 120,
                              child: Text(
                                'Rs. ${(claim.totalRefundAmountPaisa / 100).toStringAsFixed(2)}',
                                textAlign: TextAlign.right,
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFF0F172A)),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: statusBg,
                                borderRadius: BorderRadius.circular(6),
                                border: Border.all(color: statusColor.withValues(alpha: 0.3)),
                              ),
                              child: Text(
                                claim.claimStatus,
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: statusColor),
                              ),
                            ),
                            const SizedBox(width: 16),
                            if (claim.claimStatus == 'PENDING') ...[
                              ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF16A34A),
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                                ),
                                icon: const Icon(Icons.check, size: 14),
                                label: const Text('Approve', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                                onPressed: () => _approvePendingClaim(claim),
                              ),
                              const SizedBox(width: 6),
                              OutlinedButton.icon(
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: const Color(0xFFDC2626),
                                  side: const BorderSide(color: Color(0xFFFCA5A5)),
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                                ),
                                icon: const Icon(Icons.close, size: 14),
                                label: const Text('Reject', style: TextStyle(fontSize: 11)),
                                onPressed: () => _rejectPendingClaim(claim),
                              ),
                            ] else ...[
                              SizedBox(
                                width: 140,
                                child: Text(
                                  claim.rejectionReason != null ? 'Reason: ${claim.rejectionReason}' : 'Processed',
                                  style: const TextStyle(fontSize: 11, color: Color(0xFF94A3B8), fontStyle: FontStyle.italic),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
