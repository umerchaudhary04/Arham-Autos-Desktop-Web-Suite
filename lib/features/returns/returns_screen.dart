import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart' as drift;
import '../../core/db/app_database.dart';
import '../inventory/parts_master_screen.dart'; // dbProvider

class ReturnsScreen extends ConsumerStatefulWidget {
  const ReturnsScreen({super.key});

  @override
  ConsumerState<ReturnsScreen> createState() => _ReturnsScreenState();
}

class _ReturnsScreenState extends ConsumerState<ReturnsScreen> {
  final _invoiceController = TextEditingController();
  Sale? _sale;
  List<SaleItem> _saleItems = [];
  Map<int, Part> _partsMap = {};

  final Map<int, int> _returnQuantities = {};
  String _triage = 'SELLABLE';

  void _searchInvoice() async {
    final invoiceId = int.tryParse(_invoiceController.text);
    if (invoiceId == null) return;

    final db = ref.read(dbProvider);
    final sale = await (db.select(db.sales)..where((t) => t.id.equals(invoiceId))).getSingleOrNull();
    
    if (sale != null) {
      final items = await (db.select(db.saleItems)..where((t) => t.saleId.equals(invoiceId))).get();
      final pMap = <int, Part>{};
      for (var i in items) {
        final p = await (db.select(db.parts)..where((t) => t.id.equals(i.partId))).getSingle();
        pMap[i.partId] = p;
      }
      setState(() {
        _sale = sale;
        _saleItems = items;
        _partsMap = pMap;
        _returnQuantities.clear();
      });
    } else {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Invoice not found')));
    }
  }

  void _submitClaim() async {
    if (_returnQuantities.isEmpty) return;
    
    final db = ref.read(dbProvider);
    int totalRefund = 0;
    _returnQuantities.forEach((itemId, qty) {
      final item = _saleItems.firstWhere((i) => i.id == itemId);
      totalRefund += item.unitRatePaisa * qty;
    });

    await db.transaction(() async {
      final claimId = await db.into(db.returnClaims).insert(
        ReturnClaimsCompanion(
          saleId: drift.Value(_sale!.id),
          requestedBy: const drift.Value(1), // dummy user
          totalRefundAmountPaisa: drift.Value(totalRefund),
          claimStatus: const drift.Value('PENDING'),
        )
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
          )
        );
      }
    });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Return Claim Submitted as PENDING')));
      setState(() {
        _sale = null;
        _saleItems.clear();
        _returnQuantities.clear();
      });
    }
  }

  void _approveClaimDirectly() async {
    if (_returnQuantities.isEmpty) return;

    bool? authorized = await _showManagerPinDialog();
    if (authorized != true) return;

    final db = ref.read(dbProvider);
    int totalRefund = 0;
    _returnQuantities.forEach((itemId, qty) {
      final item = _saleItems.firstWhere((i) => i.id == itemId);
      totalRefund += item.unitRatePaisa * qty;
    });

    await db.transaction(() async {
      // Create approved claim
      final claimId = await db.into(db.returnClaims).insert(
        ReturnClaimsCompanion(
          saleId: drift.Value(_sale!.id),
          requestedBy: const drift.Value(1),
          approvedBy: const drift.Value(1), // manager dummy
          totalRefundAmountPaisa: drift.Value(totalRefund),
          claimStatus: const drift.Value('APPROVED'),
        )
      );

      for (var entry in _returnQuantities.entries) {
        final itemId = entry.key;
        final qty = entry.value;
        if (qty <= 0) continue;
        
        final item = _saleItems.firstWhere((i) => i.id == itemId);
        final part = _partsMap[item.partId]!;

        await db.into(db.returnClaimItems).insert(
          ReturnClaimItemsCompanion(
            claimId: drift.Value(claimId),
            partId: drift.Value(item.partId),
            quantity: drift.Value(qty),
            refundRatePaisa: drift.Value(item.unitRatePaisa),
            lineRefundTotalPaisa: drift.Value(qty * item.unitRatePaisa),
            inventoryDisposition: drift.Value(_triage),
          )
        );

        if (_triage == 'SELLABLE') {
          await (db.update(db.parts)..where((t) => t.id.equals(part.id))).write(
            PartsCompanion(currentStock: drift.Value(part.currentStock + qty))
          );
        } else {
          // DEFECTIVE_CLAIM pool (could track defective stock in a separate column)
          // we assume Parts has defectiveStock, let's update it
          // Note: our Parts table does not have defectiveStock in the TRD, but we'll just ignore for now or add to notes
        }
      }

      // Update customer balance if it was a credit sale or attached to customer
      if (_sale!.customerId != null) {
        final customer = await (db.select(db.customers)..where((t) => t.id.equals(_sale!.customerId!))).getSingle();
        final newBal = customer.currentBalancePaisa - totalRefund;
        
        await (db.update(db.customers)..where((t) => t.id.equals(customer.id))).write(
          CustomersCompanion(currentBalancePaisa: drift.Value(newBal))
        );

        await db.into(db.customerLedgerEntries).insert(
          CustomerLedgerEntriesCompanion(
            customerId: drift.Value(customer.id),
            invoiceId: drift.Value(_sale!.id),
            entryType: const drift.Value('RETURN_CREDIT'),
            creditAmountPaisa: drift.Value(totalRefund),
            runningBalancePaisa: drift.Value(newBal),
          )
        );
      }
    });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Return APPROVED & Stock Adjusted')));
      setState(() {
        _sale = null;
        _saleItems.clear();
        _returnQuantities.clear();
      });
    }
  }

  Future<bool?> _showManagerPinDialog() {
    final pinController = TextEditingController();
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Manager Approval'),
        content: TextField(
          controller: pinController,
          obscureText: true,
          decoration: const InputDecoration(labelText: 'Manager PIN'),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              if (pinController.text == '1234') Navigator.pop(context, true);
            }, 
            child: const Text('Approve')
          ),
        ],
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Returns & Claims Workflow')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _invoiceController,
                    decoration: const InputDecoration(labelText: 'Enter Invoice ID to Search'),
                    keyboardType: TextInputType.number,
                  ),
                ),
                IconButton(icon: const Icon(Icons.search), onPressed: _searchInvoice)
              ],
            ),
            const Divider(),
            if (_sale != null) ...[
              Text('Invoice #${_sale!.id} | Customer ID: ${_sale!.customerId ?? 'Walk-in'}', style: const TextStyle(fontWeight: FontWeight.bold)),
              Expanded(
                child: ListView.builder(
                  itemCount: _saleItems.length,
                  itemBuilder: (context, index) {
                    final item = _saleItems[index];
                    final part = _partsMap[item.partId]!;
                    return ListTile(
                      title: Text(part.nameEn),
                      subtitle: Text('Sold Qty: ${item.qty} @ Rs${item.unitRatePaisa / 100}'),
                      trailing: SizedBox(
                        width: 150,
                        child: TextField(
                          decoration: const InputDecoration(labelText: 'Return Qty'),
                          keyboardType: TextInputType.number,
                          onChanged: (v) {
                            int rQty = int.tryParse(v) ?? 0;
                            if (rQty > item.qty) rQty = item.qty;
                            _returnQuantities[item.id] = rQty;
                          },
                        ),
                      ),
                    );
                  },
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Triage: '),
                  DropdownButton<String>(
                    value: _triage,
                    items: const [
                      DropdownMenuItem(value: 'SELLABLE', child: Text('Sellable Stock')),
                      DropdownMenuItem(value: 'DEFECTIVE_CLAIM', child: Text('Defective Pool')),
                    ],
                    onChanged: (v) => setState(() => _triage = v!),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(onPressed: _submitClaim, child: const Text('Draft Claim (Operator)')),
                  ElevatedButton(
                    onPressed: _approveClaimDirectly, 
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.red[100]),
                    child: const Text('Approve & Process (Manager)')
                  ),
                ],
              )
            ]
          ],
        ),
      ),
    );
  }
}
