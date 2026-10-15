import 'dart:io';
import 'package:flutter/material.dart' hide Route;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:drift/drift.dart' as drift;
import 'package:csv/csv.dart';
import 'package:file_selector/file_selector.dart';

import '../../core/db/app_database.dart';
import '../inventory/parts_master_screen.dart'; // contains dbProvider
import 'customer_dialog.dart';
import 'khata_statement_printer.dart';
import '../suppliers/supplier_dialog.dart';

class KhataScreen extends ConsumerStatefulWidget {
  const KhataScreen({super.key});

  @override
  ConsumerState<KhataScreen> createState() => _KhataScreenState();
}

class _KhataScreenState extends ConsumerState<KhataScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // Customer Khata State
  Customer? _selectedCustomer;
  final TextEditingController _customerSearchController = TextEditingController();
  int? _customerRouteFilter;

  // Supplier Khata State
  Supplier? _selectedSupplier;
  final TextEditingController _supplierSearchController = TextEditingController();

  // Aging Summary State
  final TextEditingController _agingSearchController = TextEditingController();
  int? _agingRouteFilter;
  int? _agingSalesmanFilter;
  bool _isLoadingAging = false;
  List<Map<String, dynamic>> _agingData = [];

  final DateFormat _dateFormat = DateFormat('yyyy-MM-dd HH:mm');

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      if (_tabController.index == 2) {
        _refreshAging();
      }
      setState(() {});
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _customerSearchController.dispose();
    _supplierSearchController.dispose();
    _agingSearchController.dispose();
    super.dispose();
  }

  // ==========================================
  // AGING CALCULATION LOGIC (FIFO BUCKETING)
  // ==========================================
  Future<void> _refreshAging() async {
    setState(() => _isLoadingAging = true);
    final db = ref.read(dbProvider);

    try {
      final customers = await (db.select(db.customers)
            ..where((t) => t.currentBalancePaisa.isBiggerThanValue(0)))
          .get();

      final routes = await db.select(db.routes).get();
      final routeMap = {for (var r in routes) r.id: r};

      final employees = await db.select(db.employees).get();

      final now = DateTime.now();
      final List<Map<String, dynamic>> calculatedRows = [];

      for (final cust in customers) {
        final balancePaisa = cust.currentBalancePaisa;
        if (balancePaisa <= 0) continue;

        // Fetch customer ledger debits to calculate aging using FIFO
        final entries = await (db.select(db.customerLedgerEntries)
              ..where((t) => t.customerId.equals(cust.id) & t.debitAmountPaisa.isBiggerThanValue(0))
              ..orderBy([(t) => drift.OrderingTerm.desc(t.createdAt)]))
            .get();

        int remainingPaisa = balancePaisa;
        int bucket0to30Paisa = 0;
        int bucket31to60Paisa = 0;
        int bucket60PlusPaisa = 0;

        for (final entry in entries) {
          if (remainingPaisa <= 0) break;
          final debit = entry.debitAmountPaisa;
          final allocated = debit < remainingPaisa ? debit : remainingPaisa;
          final days = now.difference(entry.createdAt).inDays;

          if (days <= 30) {
            bucket0to30Paisa += allocated;
          } else if (days <= 60) {
            bucket31to60Paisa += allocated;
          } else {
            bucket60PlusPaisa += allocated;
          }

          remainingPaisa -= allocated;
        }

        // Any balance remaining without invoice reference (e.g. old opening balance) goes to 60+ days
        if (remainingPaisa > 0) {
          bucket60PlusPaisa += remainingPaisa;
        }

        final route = cust.routeId != null ? routeMap[cust.routeId] : null;
        // Find salesman assigned to this route if any
        Employee? salesman;
        if (cust.routeId != null) {
          salesman = employees.where((e) => e.assignedRouteId == cust.routeId).firstOrNull;
        }

        calculatedRows.add({
          'customer': cust,
          'route': route,
          'salesman': salesman,
          'totalBalance': balancePaisa / 100.0,
          'current30': bucket0to30Paisa / 100.0,
          'overdue60': bucket31to60Paisa / 100.0,
          'overdue90plus': bucket60PlusPaisa / 100.0,
        });
      }

      setState(() {
        _agingData = calculatedRows;
        _isLoadingAging = false;
      });
    } catch (e) {
      if (mounted) {
        setState(() => _isLoadingAging = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error computing aging: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  // ==========================================
  // CSV EXPORT METHODS
  // ==========================================
  Future<void> _exportCustomerCsv(Customer customer, List<CustomerLedgerEntry> entries) async {
    try {
      final List<List<dynamic>> rows = [
        ['Account ID', customer.id.toString(), 'Customer Name', customer.name, 'Shop', customer.shopName ?? ''],
        ['Phone', customer.phone ?? '', 'Tier', customer.customerType, 'Current Balance (Rs)', (customer.currentBalancePaisa / 100).toStringAsFixed(2)],
        [],
        ['Date & Time', 'Entry Type', 'Reference / Notes', 'Debit / Billed (Rs)', 'Credit / Paid (Rs)', 'Running Balance (Rs)'],
        ...entries.map((e) => [
          _dateFormat.format(e.createdAt),
          e.entryType,
          e.notes ?? '',
          (e.debitAmountPaisa / 100).toStringAsFixed(2),
          (e.creditAmountPaisa / 100).toStringAsFixed(2),
          (e.runningBalancePaisa / 100).toStringAsFixed(2),
        ]),
      ];

      final csvContent = csv.encode(rows);
      final safeName = customer.name.replaceAll(RegExp(r'[^\w\s]+'), '_').trim();
      final FileSaveLocation? location = await getSaveLocation(
        suggestedName: 'CustomerKhata_${safeName}_${DateFormat('yyyyMMdd').format(DateTime.now())}.csv',
      );

      if (location != null) {
        final file = File(location.path);
        await file.writeAsString(csvContent);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Customer statement exported: ${location.path}'),
              backgroundColor: Colors.green.shade800,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Export error: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  Future<void> _exportSupplierCsv(Supplier supplier, List<SupplierLedgerEntry> entries) async {
    try {
      final List<List<dynamic>> rows = [
        ['Vendor ID', supplier.id.toString(), 'Supplier Name', supplier.name, 'Company', supplier.company ?? ''],
        ['Phone', supplier.phone ?? '', 'Current Payable (Rs)', (supplier.currentBalancePaisa / 100).toStringAsFixed(2)],
        [],
        ['Date & Time', 'Entry Type', 'Reference / Notes', 'Debit / Paid (Rs)', 'Credit / Purchase (Rs)', 'Running Balance (Rs)'],
        ...entries.map((e) => [
          _dateFormat.format(e.createdAt),
          e.entryType,
          e.notes ?? '',
          (e.debitAmountPaisa / 100).toStringAsFixed(2),
          (e.creditAmountPaisa / 100).toStringAsFixed(2),
          (e.runningBalancePaisa / 100).toStringAsFixed(2),
        ]),
      ];

      final csvContent = csv.encode(rows);
      final safeName = supplier.name.replaceAll(RegExp(r'[^\w\s]+'), '_').trim();
      final FileSaveLocation? location = await getSaveLocation(
        suggestedName: 'SupplierKhata_${safeName}_${DateFormat('yyyyMMdd').format(DateTime.now())}.csv',
      );

      if (location != null) {
        final file = File(location.path);
        await file.writeAsString(csvContent);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Supplier statement exported: ${location.path}'),
              backgroundColor: Colors.green.shade800,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Export error: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: Column(
        children: [
          // Header Bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(bottom: BorderSide(color: Color(0xFFE2E8F0))),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0F172A),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.menu_book_rounded, color: Colors.white, size: 24),
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Khata & Ledger Accounts',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                    ),
                    Text(
                      'Double-entry customer receivables, supplier payables & FIFO aging',
                      style: TextStyle(fontSize: 12, color: Color(0xFF64748B)),
                    ),
                  ],
                ),
                const Spacer(),
                // Tab Selector
                Container(
                  height: 42,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF1F5F9),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: const Color(0xFFCBD5E1)),
                  ),
                  child: TabBar(
                    controller: _tabController,
                    isScrollable: true,
                    indicator: BoxDecoration(
                      color: const Color(0xFF0F172A),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    labelColor: Colors.white,
                    unselectedLabelColor: const Color(0xFF475569),
                    labelStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                    indicatorSize: TabBarIndicatorSize.tab,
                    tabs: const [
                      Tab(text: 'Customer Khata (Receivables)'),
                      Tab(text: 'Supplier Khata (Payables)'),
                      Tab(text: 'Aging Receivables (0-30 / 31-60 / 60+ Days)'),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Main Tab Views
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildCustomerKhataTab(),
                _buildSupplierKhataTab(),
                _buildAgingSummaryTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================
  // TAB 1: CUSTOMER KHATA (RECEIVABLES)
  // ==========================================
  Widget _buildCustomerKhataTab() {
    final db = ref.watch(dbProvider);

    return StreamBuilder<List<Customer>>(
      stream: db.select(db.customers).watch(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final allCustomers = snapshot.data!;
        final search = _customerSearchController.text.toLowerCase().trim();

        final filteredCustomers = allCustomers.where((c) {
          final matchesSearch = search.isEmpty ||
              c.name.toLowerCase().contains(search) ||
              (c.shopName?.toLowerCase().contains(search) ?? false) ||
              (c.phone?.contains(search) ?? false);
          final matchesRoute = _customerRouteFilter == null || c.routeId == _customerRouteFilter;
          return matchesSearch && matchesRoute;
        }).toList();

        // Keep selection synced
        if (_selectedCustomer != null) {
          _selectedCustomer = allCustomers.where((c) => c.id == _selectedCustomer!.id).firstOrNull;
        }

        return Row(
          children: [
            // Left List: Customers
            SizedBox(
              width: 380,
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  border: Border(right: BorderSide(color: Color(0xFFE2E8F0))),
                ),
                child: Column(
                  children: [
                    // Top Search & Route Filter
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: const BoxDecoration(
                        border: Border(bottom: BorderSide(color: Color(0xFFE2E8F0))),
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  controller: _customerSearchController,
                                  decoration: InputDecoration(
                                    hintText: 'Search by Name, Shop, Phone...',
                                    hintStyle: const TextStyle(fontSize: 12),
                                    prefixIcon: const Icon(Icons.search, size: 20),
                                    suffixIcon: _customerSearchController.text.isNotEmpty
                                        ? IconButton(
                                            icon: const Icon(Icons.clear, size: 16),
                                            onPressed: () {
                                              setState(() {
                                                _customerSearchController.clear();
                                              });
                                            },
                                          )
                                        : null,
                                    isDense: true,
                                    filled: true,
                                    fillColor: const Color(0xFFF8FAFC),
                                    contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      borderSide: const BorderSide(color: Color(0xFFCBD5E1)),
                                    ),
                                  ),
                                  onChanged: (_) => setState(() {}),
                                ),
                              ),
                              const SizedBox(width: 8),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF0F172A),
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                ),
                                onPressed: () async {
                                  final newCustomer = await showDialog<Customer>(
                                    context: context,
                                    builder: (_) => const CustomerFormDialog(),
                                  );
                                  if (newCustomer != null && mounted) {
                                    setState(() => _selectedCustomer = newCustomer);
                                  }
                                },
                                child: const Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.add, size: 16),
                                    SizedBox(width: 4),
                                    Text('New', style: TextStyle(fontSize: 12)),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          // Route Filter Dropdown
                          FutureBuilder<List<Route>>(
                            future: db.select(db.routes).get(),
                            builder: (context, routeSnap) {
                              final routes = routeSnap.data ?? [];
                              return DropdownButtonFormField<int?>(
                                decoration: InputDecoration(
                                  isDense: true,
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                                  filled: true,
                                  fillColor: const Color(0xFFF8FAFC),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: const BorderSide(color: Color(0xFFCBD5E1)),
                                  ),
                                ),
                                value: _customerRouteFilter,
                                hint: const Text('All Routes / Territories', style: TextStyle(fontSize: 12)),
                                items: [
                                  const DropdownMenuItem<int?>(value: null, child: Text('All Routes / Territories', style: TextStyle(fontSize: 12))),
                                  ...routes.map((r) => DropdownMenuItem<int?>(value: r.id, child: Text('${r.name} (${r.city})', style: const TextStyle(fontSize: 12)))),
                                ],
                                onChanged: (v) => setState(() => _customerRouteFilter = v),
                              );
                            },
                          ),
                        ],
                      ),
                    ),

                    // Customer List Counter
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      color: const Color(0xFFF1F5F9),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('${filteredCustomers.length} Customers Found', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF475569))),
                          Text('Balance (Rs)', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF475569))),
                        ],
                      ),
                    ),

                    // List of Customers
                    Expanded(
                      child: filteredCustomers.isEmpty
                          ? const Center(
                              child: Text('No customers found', style: TextStyle(color: Color(0xFF94A3B8), fontSize: 13)),
                            )
                          : ListView.separated(
                              itemCount: filteredCustomers.length,
                              separatorBuilder: (_, __) => const Divider(height: 1, color: Color(0xFFF1F5F9)),
                              itemBuilder: (context, index) {
                                final c = filteredCustomers[index];
                                final isSelected = _selectedCustomer?.id == c.id;
                                final bal = c.currentBalancePaisa / 100.0;
                                final limit = (c.creditLimitPaisa ?? 0) / 100.0;
                                final isOverLimit = limit > 0 && bal > limit;
                                final ratio = limit > 0 ? (bal / limit).clamp(0.0, 1.0) : 0.0;

                                return ListTile(
                                  selected: isSelected,
                                  selectedTileColor: const Color(0xFFE2E8F0).withOpacity(0.5),
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                                  leading: CircleAvatar(
                                    radius: 18,
                                    backgroundColor: isSelected ? const Color(0xFF0F172A) : const Color(0xFFF1F5F9),
                                    child: Text(
                                      c.name.isNotEmpty ? c.name[0].toUpperCase() : '?',
                                      style: TextStyle(
                                        color: isSelected ? Colors.white : const Color(0xFF334155),
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                  title: Text(
                                    c.shopName != null && c.shopName!.isNotEmpty ? c.shopName! : c.name,
                                    style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: Color(0xFF0F172A)),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  subtitle: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '${c.name} ${c.phone != null ? "• ${c.phone}" : ""}',
                                        style: const TextStyle(fontSize: 11, color: Color(0xFF64748B)),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      if (limit > 0) ...[
                                        const SizedBox(height: 4),
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(3),
                                          child: LinearProgressIndicator(
                                            value: ratio,
                                            minHeight: 4,
                                            backgroundColor: const Color(0xFFE2E8F0),
                                            color: isOverLimit
                                                ? Colors.red
                                                : ratio > 0.8
                                                    ? Colors.amber.shade700
                                                    : Colors.blue.shade700,
                                          ),
                                        ),
                                      ],
                                    ],
                                  ),
                                  trailing: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        'Rs ${bal.toStringAsFixed(0)}',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 13,
                                          color: bal > 0 ? Colors.red.shade800 : Colors.green.shade800,
                                        ),
                                      ),
                                      if (isOverLimit)
                                        Container(
                                          margin: const EdgeInsets.only(top: 2),
                                          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                                          decoration: BoxDecoration(
                                            color: Colors.red.shade50,
                                            borderRadius: BorderRadius.circular(4),
                                            border: Border.all(color: Colors.red.shade200),
                                          ),
                                          child: const Text('OVER LIMIT', style: TextStyle(color: Colors.red, fontSize: 8, fontWeight: FontWeight.bold)),
                                        ),
                                    ],
                                  ),
                                  onTap: () {
                                    setState(() => _selectedCustomer = c);
                                  },
                                );
                              },
                            ),
                    ),
                  ],
                ),
              ),
            ),

            // Right Panel: Customer Details & Ledger Table
            Expanded(
              child: _selectedCustomer == null
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(Icons.person_search_outlined, size: 64, color: Color(0xFFCBD5E1)),
                          SizedBox(height: 12),
                          Text('Select a Customer to View Ledger', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Color(0xFF64748B))),
                          SizedBox(height: 4),
                          Text('Search from the list on the left or create a new account', style: TextStyle(fontSize: 12, color: Color(0xFF94A3B8))),
                        ],
                      ),
                    )
                  : _buildCustomerLedgerDetail(_selectedCustomer!),
            ),
          ],
        );
      },
    );
  }

  Widget _buildCustomerLedgerDetail(Customer customer) {
    final db = ref.watch(dbProvider);
    final curBal = customer.currentBalancePaisa / 100.0;
    final limit = (customer.creditLimitPaisa ?? 0) / 100.0;
    final isOverLimit = limit > 0 && curBal > limit;

    return Column(
      children: [
        // Top Header of Selected Customer
        Container(
          padding: const EdgeInsets.all(20),
          decoration: const BoxDecoration(
            color: Colors.white,
            border: Border(bottom: BorderSide(color: Color(0xFFE2E8F0))),
          ),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              customer.shopName != null && customer.shopName!.isNotEmpty ? customer.shopName! : customer.name,
                              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: customer.customerType == 'WHOLESALE' ? const Color(0xFFEFF6FF) : const Color(0xFFF1F5F9),
                                borderRadius: BorderRadius.circular(4),
                                border: Border.all(
                                  color: customer.customerType == 'WHOLESALE' ? const Color(0xFF93C5FD) : const Color(0xFFCBD5E1),
                                ),
                              ),
                              child: Text(
                                customer.customerType,
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: customer.customerType == 'WHOLESALE' ? const Color(0xFF1D4ED8) : const Color(0xFF475569),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(Icons.person, size: 14, color: Color(0xFF64748B)),
                            const SizedBox(width: 4),
                            Text(customer.name, style: const TextStyle(fontSize: 12, color: Color(0xFF475569))),
                            const SizedBox(width: 16),
                            const Icon(Icons.phone, size: 14, color: Color(0xFF64748B)),
                            const SizedBox(width: 4),
                            Text(customer.phone ?? 'No Phone', style: const TextStyle(fontSize: 12, color: Color(0xFF475569))),
                            if (customer.address != null) ...[
                              const SizedBox(width: 16),
                              const Icon(Icons.location_on, size: 14, color: Color(0xFF64748B)),
                              const SizedBox(width: 4),
                              Text(customer.address!, style: const TextStyle(fontSize: 12, color: Color(0xFF475569))),
                            ],
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Financial Balance Indicators
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    decoration: BoxDecoration(
                      color: isOverLimit ? const Color(0xFFFEF2F2) : const Color(0xFFF8FAFC),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: isOverLimit ? const Color(0xFFFCA5A5) : const Color(0xFFE2E8F0),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        const Text('Outstanding Balance', style: TextStyle(fontSize: 11, color: Color(0xFF64748B), fontWeight: FontWeight.w500)),
                        Text(
                          'Rs ${curBal.toStringAsFixed(2)}',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: curBal > 0 ? const Color(0xFFDC2626) : const Color(0xFF16A34A),
                          ),
                        ),
                        if (limit > 0)
                          Text('Credit Limit: Rs ${limit.toStringAsFixed(0)}', style: const TextStyle(fontSize: 10, color: Color(0xFF64748B))),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Action Buttons Row
              Row(
                children: [
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF16A34A),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    icon: const Icon(Icons.payments_outlined, size: 16),
                    label: const Text('Record Recovery / Payment', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                    onPressed: () async {
                      final updated = await showDialog<bool>(
                        context: context,
                        builder: (_) => CustomerPaymentDialog(customer: customer),
                      );
                      if (updated == true) {
                        setState(() {});
                      }
                    },
                  ),
                  const SizedBox(width: 10),
                  OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFF0F172A),
                      side: const BorderSide(color: Color(0xFFCBD5E1)),
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    icon: const Icon(Icons.edit_outlined, size: 16),
                    label: const Text('Edit Customer', style: TextStyle(fontSize: 12)),
                    onPressed: () async {
                      final updated = await showDialog<Customer>(
                        context: context,
                        builder: (_) => CustomerFormDialog(customer: customer),
                      );
                      if (updated != null && mounted) {
                        setState(() => _selectedCustomer = updated);
                      }
                    },
                  ),
                  const Spacer(),
                  // FutureBuilder to load entries for CSV and PDF printing
                  StreamBuilder<List<CustomerLedgerEntry>>(
                    stream: (db.select(db.customerLedgerEntries)
                          ..where((t) => t.customerId.equals(customer.id))
                          ..orderBy([(t) => drift.OrderingTerm.desc(t.createdAt)]))
                        .watch(),
                    builder: (context, ledgerSnap) {
                      final entries = ledgerSnap.data ?? [];
                      return Row(
                        children: [
                          OutlinedButton.icon(
                            style: OutlinedButton.styleFrom(
                              foregroundColor: const Color(0xFF0F172A),
                              side: const BorderSide(color: Color(0xFFCBD5E1)),
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            ),
                            icon: const Icon(Icons.file_download_outlined, size: 16),
                            label: const Text('Export CSV', style: TextStyle(fontSize: 12)),
                            onPressed: entries.isEmpty ? null : () => _exportCustomerCsv(customer, entries),
                          ),
                          const SizedBox(width: 10),
                          ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF0F172A),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            ),
                            icon: const Icon(Icons.print_outlined, size: 16),
                            label: const Text('Print Statement (PDF)', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                            onPressed: entries.isEmpty
                                ? null
                                : () async {
                                    String? routeName;
                                    if (customer.routeId != null) {
                                      final r = await (db.select(db.routes)..where((t) => t.id.equals(customer.routeId!))).getSingleOrNull();
                                      routeName = r?.name;
                                    }
                                    await KhataStatementPrinter.printCustomerStatement(
                                      customer: customer,
                                      entries: entries,
                                      routeName: routeName,
                                    );
                                  },
                          ),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ),

        // Ledger Entries Table
        Expanded(
          child: StreamBuilder<List<CustomerLedgerEntry>>(
            stream: (db.select(db.customerLedgerEntries)
                  ..where((t) => t.customerId.equals(customer.id))
                  ..orderBy([(t) => drift.OrderingTerm.desc(t.createdAt)]))
                .watch(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }

              final entries = snapshot.data!;
              if (entries.isEmpty) {
                return const Center(
                  child: Text('No ledger entries recorded yet for this customer', style: TextStyle(color: Color(0xFF94A3B8))),
                );
              }

              return Column(
                children: [
                  // Table Header
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    color: const Color(0xFFF1F5F9),
                    child: const Row(
                      children: [
                        SizedBox(width: 140, child: Text('Date & Time', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: Color(0xFF475569)))),
                        SizedBox(width: 120, child: Text('Entry Type', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: Color(0xFF475569)))),
                        Expanded(child: Text('Notes / Reference', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: Color(0xFF475569)))),
                        SizedBox(width: 110, child: Text('Debit (+) Rs', textAlign: TextAlign.right, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: Color(0xFF475569)))),
                        SizedBox(width: 110, child: Text('Credit (-) Rs', textAlign: TextAlign.right, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: Color(0xFF475569)))),
                        SizedBox(width: 130, child: Text('Balance Rs', textAlign: TextAlign.right, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: Color(0xFF475569)))),
                      ],
                    ),
                  ),

                  // Table Body
                  Expanded(
                    child: ListView.separated(
                      padding: EdgeInsets.zero,
                      itemCount: entries.length,
                      separatorBuilder: (_, __) => const Divider(height: 1, color: Color(0xFFF1F5F9)),
                      itemBuilder: (context, i) {
                        final entry = entries[i];
                        final isDebit = entry.debitAmountPaisa > 0;
                        final isCredit = entry.creditAmountPaisa > 0;

                        return Container(
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                          color: i % 2 == 0 ? Colors.white : const Color(0xFFFAFAFA),
                          child: Row(
                            children: [
                              SizedBox(
                                width: 140,
                                child: Text(_dateFormat.format(entry.createdAt), style: const TextStyle(fontSize: 11, color: Color(0xFF334155))),
                              ),
                              SizedBox(
                                width: 120,
                                child: _buildEntryTypeBadge(entry.entryType),
                              ),
                              Expanded(
                                child: Text(
                                  entry.notes ?? (entry.invoiceId != null ? 'Invoice #${entry.invoiceId}' : '-'),
                                  style: const TextStyle(fontSize: 12, color: Color(0xFF475569)),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              SizedBox(
                                width: 110,
                                child: Text(
                                  isDebit ? (entry.debitAmountPaisa / 100).toStringAsFixed(2) : '-',
                                  textAlign: TextAlign.right,
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: isDebit ? FontWeight.w600 : FontWeight.normal,
                                    color: isDebit ? const Color(0xFF0F172A) : const Color(0xFF94A3B8),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 110,
                                child: Text(
                                  isCredit ? (entry.creditAmountPaisa / 100).toStringAsFixed(2) : '-',
                                  textAlign: TextAlign.right,
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: isCredit ? FontWeight.w600 : FontWeight.normal,
                                    color: isCredit ? const Color(0xFF16A34A) : const Color(0xFF94A3B8),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 130,
                                child: Text(
                                  'Rs ${(entry.runningBalancePaisa / 100).toStringAsFixed(2)}',
                                  textAlign: TextAlign.right,
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: entry.runningBalancePaisa > 0 ? const Color(0xFFDC2626) : const Color(0xFF16A34A),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }

  // ==========================================
  // TAB 2: SUPPLIER KHATA (PAYABLES)
  // ==========================================
  Widget _buildSupplierKhataTab() {
    final db = ref.watch(dbProvider);

    return StreamBuilder<List<Supplier>>(
      stream: db.select(db.suppliers).watch(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final allSuppliers = snapshot.data!;
        final search = _supplierSearchController.text.toLowerCase().trim();

        final filteredSuppliers = allSuppliers.where((s) {
          return search.isEmpty ||
              s.name.toLowerCase().contains(search) ||
              (s.company?.toLowerCase().contains(search) ?? false) ||
              (s.phone?.contains(search) ?? false);
        }).toList();

        // Keep selection in sync
        if (_selectedSupplier != null) {
          _selectedSupplier = allSuppliers.where((s) => s.id == _selectedSupplier!.id).firstOrNull;
        }

        return Row(
          children: [
            // Left List: Suppliers
            SizedBox(
              width: 380,
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  border: Border(right: BorderSide(color: Color(0xFFE2E8F0))),
                ),
                child: Column(
                  children: [
                    // Search Bar & New Button
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: const BoxDecoration(
                        border: Border(bottom: BorderSide(color: Color(0xFFE2E8F0))),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _supplierSearchController,
                              decoration: InputDecoration(
                                hintText: 'Search by Name, Company, Phone...',
                                hintStyle: const TextStyle(fontSize: 12),
                                prefixIcon: const Icon(Icons.search, size: 20),
                                suffixIcon: _supplierSearchController.text.isNotEmpty
                                    ? IconButton(
                                        icon: const Icon(Icons.clear, size: 16),
                                        onPressed: () => setState(() => _supplierSearchController.clear()),
                                      )
                                    : null,
                                isDense: true,
                                filled: true,
                                fillColor: const Color(0xFFF8FAFC),
                                contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: const BorderSide(color: Color(0xFFCBD5E1)),
                                ),
                              ),
                              onChanged: (_) => setState(() {}),
                            ),
                          ),
                          const SizedBox(width: 8),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF0F172A),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            ),
                            onPressed: () async {
                              final newSupplier = await showDialog<Supplier>(
                                context: context,
                                builder: (_) => const SupplierFormDialog(),
                              );
                              if (newSupplier != null && mounted) {
                                setState(() => _selectedSupplier = newSupplier);
                              }
                            },
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.add, size: 16),
                                SizedBox(width: 4),
                                Text('New', style: TextStyle(fontSize: 12)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Counter
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      color: const Color(0xFFF1F5F9),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('${filteredSuppliers.length} Suppliers Found', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF475569))),
                          const Text('Payable Balance (Rs)', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF475569))),
                        ],
                      ),
                    ),

                    // List
                    Expanded(
                      child: filteredSuppliers.isEmpty
                          ? const Center(child: Text('No suppliers found', style: TextStyle(color: Color(0xFF94A3B8), fontSize: 13)))
                          : ListView.separated(
                              itemCount: filteredSuppliers.length,
                              separatorBuilder: (_, __) => const Divider(height: 1, color: Color(0xFFF1F5F9)),
                              itemBuilder: (context, index) {
                                final s = filteredSuppliers[index];
                                final isSelected = _selectedSupplier?.id == s.id;
                                final bal = s.currentBalancePaisa / 100.0;

                                return ListTile(
                                  selected: isSelected,
                                  selectedTileColor: const Color(0xFFE2E8F0).withOpacity(0.5),
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                                  leading: CircleAvatar(
                                    radius: 18,
                                    backgroundColor: isSelected ? const Color(0xFF0F172A) : const Color(0xFFF1F5F9),
                                    child: Text(
                                      s.name.isNotEmpty ? s.name[0].toUpperCase() : '?',
                                      style: TextStyle(
                                        color: isSelected ? Colors.white : const Color(0xFF334155),
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                  title: Text(
                                    s.company != null && s.company!.isNotEmpty ? s.company! : s.name,
                                    style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: Color(0xFF0F172A)),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  subtitle: Text(
                                    '${s.name} ${s.phone != null ? "• ${s.phone}" : ""}',
                                    style: const TextStyle(fontSize: 11, color: Color(0xFF64748B)),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  trailing: Text(
                                    'Rs ${bal.toStringAsFixed(0)}',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13,
                                      color: bal > 0 ? Colors.red.shade800 : Colors.green.shade800,
                                    ),
                                  ),
                                  onTap: () => setState(() => _selectedSupplier = s),
                                );
                              },
                            ),
                    ),
                  ],
                ),
              ),
            ),

            // Right Panel: Supplier Ledger Detail
            Expanded(
              child: _selectedSupplier == null
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(Icons.local_shipping_outlined, size: 64, color: Color(0xFFCBD5E1)),
                          SizedBox(height: 12),
                          Text('Select a Supplier to View Payables Ledger', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Color(0xFF64748B))),
                          SizedBox(height: 4),
                          Text('Manage purchases, disbursements, and account balance', style: TextStyle(fontSize: 12, color: Color(0xFF94A3B8))),
                        ],
                      ),
                    )
                  : _buildSupplierLedgerDetail(_selectedSupplier!),
            ),
          ],
        );
      },
    );
  }

  Widget _buildSupplierLedgerDetail(Supplier supplier) {
    final db = ref.watch(dbProvider);
    final curBal = supplier.currentBalancePaisa / 100.0;

    return Column(
      children: [
        // Header
        Container(
          padding: const EdgeInsets.all(20),
          decoration: const BoxDecoration(
            color: Colors.white,
            border: Border(bottom: BorderSide(color: Color(0xFFE2E8F0))),
          ),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          supplier.company != null && supplier.company!.isNotEmpty ? supplier.company! : supplier.name,
                          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(Icons.person, size: 14, color: Color(0xFF64748B)),
                            const SizedBox(width: 4),
                            Text(supplier.name, style: const TextStyle(fontSize: 12, color: Color(0xFF475569))),
                            const SizedBox(width: 16),
                            const Icon(Icons.phone, size: 14, color: Color(0xFF64748B)),
                            const SizedBox(width: 4),
                            Text(supplier.phone ?? 'No Phone', style: const TextStyle(fontSize: 12, color: Color(0xFF475569))),
                            if (supplier.address != null) ...[
                              const SizedBox(width: 16),
                              const Icon(Icons.location_on, size: 14, color: Color(0xFF64748B)),
                              const SizedBox(width: 4),
                              Text(supplier.address!, style: const TextStyle(fontSize: 12, color: Color(0xFF475569))),
                            ],
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8FAFC),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        const Text('Current Payable Balance', style: TextStyle(fontSize: 11, color: Color(0xFF64748B), fontWeight: FontWeight.w500)),
                        Text(
                          'Rs ${curBal.toStringAsFixed(2)}',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: curBal > 0 ? const Color(0xFFDC2626) : const Color(0xFF16A34A),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Action Buttons
              Row(
                children: [
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0F172A),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    icon: const Icon(Icons.payments_outlined, size: 16),
                    label: const Text('Record Payment / Paid', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                    onPressed: () async {
                      final updated = await showDialog<bool>(
                        context: context,
                        builder: (_) => SupplierPaymentDialog(supplier: supplier),
                      );
                      if (updated == true) setState(() {});
                    },
                  ),
                  const SizedBox(width: 10),
                  OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFF0F172A),
                      side: const BorderSide(color: Color(0xFFCBD5E1)),
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    icon: const Icon(Icons.edit_outlined, size: 16),
                    label: const Text('Edit Supplier', style: TextStyle(fontSize: 12)),
                    onPressed: () async {
                      final updated = await showDialog<Supplier>(
                        context: context,
                        builder: (_) => SupplierFormDialog(supplier: supplier),
                      );
                      if (updated != null && mounted) {
                        setState(() => _selectedSupplier = updated);
                      }
                    },
                  ),
                  const Spacer(),
                  StreamBuilder<List<SupplierLedgerEntry>>(
                    stream: (db.select(db.supplierLedgerEntries)
                          ..where((t) => t.supplierId.equals(supplier.id))
                          ..orderBy([(t) => drift.OrderingTerm.desc(t.createdAt)]))
                        .watch(),
                    builder: (context, ledgerSnap) {
                      final entries = ledgerSnap.data ?? [];
                      return Row(
                        children: [
                          OutlinedButton.icon(
                            style: OutlinedButton.styleFrom(
                              foregroundColor: const Color(0xFF0F172A),
                              side: const BorderSide(color: Color(0xFFCBD5E1)),
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            ),
                            icon: const Icon(Icons.file_download_outlined, size: 16),
                            label: const Text('Export CSV', style: TextStyle(fontSize: 12)),
                            onPressed: entries.isEmpty ? null : () => _exportSupplierCsv(supplier, entries),
                          ),
                          const SizedBox(width: 10),
                          ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF0F172A),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            ),
                            icon: const Icon(Icons.print_outlined, size: 16),
                            label: const Text('Print Statement (PDF)', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                            onPressed: entries.isEmpty
                                ? null
                                : () async {
                                    await KhataStatementPrinter.printSupplierStatement(
                                      supplier: supplier,
                                      entries: entries,
                                    );
                                  },
                          ),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ),

        // Supplier Table
        Expanded(
          child: StreamBuilder<List<SupplierLedgerEntry>>(
            stream: (db.select(db.supplierLedgerEntries)
                  ..where((t) => t.supplierId.equals(supplier.id))
                  ..orderBy([(t) => drift.OrderingTerm.desc(t.createdAt)]))
                .watch(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }

              final entries = snapshot.data!;
              if (entries.isEmpty) {
                return const Center(
                  child: Text('No ledger entries recorded yet for this supplier', style: TextStyle(color: Color(0xFF94A3B8))),
                );
              }

              return Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    color: const Color(0xFFF1F5F9),
                    child: const Row(
                      children: [
                        SizedBox(width: 140, child: Text('Date & Time', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: Color(0xFF475569)))),
                        SizedBox(width: 130, child: Text('Entry Type', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: Color(0xFF475569)))),
                        Expanded(child: Text('Notes / Reference', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: Color(0xFF475569)))),
                        SizedBox(width: 110, child: Text('Paid (-) Rs', textAlign: TextAlign.right, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: Color(0xFF475569)))),
                        SizedBox(width: 110, child: Text('Purchase (+) Rs', textAlign: TextAlign.right, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: Color(0xFF475569)))),
                        SizedBox(width: 130, child: Text('Payable Balance Rs', textAlign: TextAlign.right, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: Color(0xFF475569)))),
                      ],
                    ),
                  ),
                  Expanded(
                    child: ListView.separated(
                      padding: EdgeInsets.zero,
                      itemCount: entries.length,
                      separatorBuilder: (_, __) => const Divider(height: 1, color: Color(0xFFF1F5F9)),
                      itemBuilder: (context, i) {
                        final entry = entries[i];
                        final isDebit = entry.debitAmountPaisa > 0;
                        final isCredit = entry.creditAmountPaisa > 0;

                        return Container(
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                          color: i % 2 == 0 ? Colors.white : const Color(0xFFFAFAFA),
                          child: Row(
                            children: [
                              SizedBox(
                                width: 140,
                                child: Text(_dateFormat.format(entry.createdAt), style: const TextStyle(fontSize: 11, color: Color(0xFF334155))),
                              ),
                              SizedBox(
                                width: 130,
                                child: _buildSupplierEntryBadge(entry.entryType),
                              ),
                              Expanded(
                                child: Text(
                                  entry.notes ?? (entry.grnId != null ? 'GRN #${entry.grnId}' : '-'),
                                  style: const TextStyle(fontSize: 12, color: Color(0xFF475569)),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              SizedBox(
                                width: 110,
                                child: Text(
                                  isDebit ? (entry.debitAmountPaisa / 100).toStringAsFixed(2) : '-',
                                  textAlign: TextAlign.right,
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: isDebit ? FontWeight.w600 : FontWeight.normal,
                                    color: isDebit ? const Color(0xFF16A34A) : const Color(0xFF94A3B8),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 110,
                                child: Text(
                                  isCredit ? (entry.creditAmountPaisa / 100).toStringAsFixed(2) : '-',
                                  textAlign: TextAlign.right,
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: isCredit ? FontWeight.w600 : FontWeight.normal,
                                    color: isCredit ? const Color(0xFF0F172A) : const Color(0xFF94A3B8),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 130,
                                child: Text(
                                  'Rs ${(entry.runningBalancePaisa / 100).toStringAsFixed(2)}',
                                  textAlign: TextAlign.right,
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: entry.runningBalancePaisa > 0 ? const Color(0xFFDC2626) : const Color(0xFF16A34A),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }

  // ==========================================
  // TAB 3: [PRIORITY 0] AGING ACCOUNTS RECEIVABLE
  // ==========================================
  Widget _buildAgingSummaryTab() {
    final db = ref.watch(dbProvider);

    final search = _agingSearchController.text.toLowerCase().trim();
    final filtered = _agingData.where((row) {
      final cust = row['customer'] as Customer;
      final salesman = row['salesman'] as Employee?;

      final matchesSearch = search.isEmpty ||
          cust.name.toLowerCase().contains(search) ||
          (cust.shopName?.toLowerCase().contains(search) ?? false) ||
          (cust.phone?.contains(search) ?? false);

      final matchesRoute = _agingRouteFilter == null || cust.routeId == _agingRouteFilter;
      final matchesSalesman = _agingSalesmanFilter == null || (salesman != null && salesman.id == _agingSalesmanFilter);

      return matchesSearch && matchesRoute && matchesSalesman;
    }).toList();

    double totalReceivables = 0;
    double total0to30 = 0;
    double total31to60 = 0;
    double total60plus = 0;

    for (final r in filtered) {
      totalReceivables += (r['totalBalance'] as double);
      total0to30 += (r['current30'] as double);
      total31to60 += (r['overdue60'] as double);
      total60plus += (r['overdue90plus'] as double);
    }

    return Column(
      children: [
        // Top 4 KPI Summary Cards
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          color: Colors.white,
          child: Row(
            children: [
              _buildAgingKpiCard('Total Receivables', 'Rs ${totalReceivables.toStringAsFixed(0)}', '${filtered.length} Accounts', const Color(0xFF0F172A), Icons.account_balance_wallet_outlined),
              const SizedBox(width: 14),
              _buildAgingKpiCard('0–30 Days (Current)', 'Rs ${total0to30.toStringAsFixed(0)}', '${((totalReceivables > 0 ? total0to30 / totalReceivables : 0) * 100).toStringAsFixed(0)}% of Total', const Color(0xFF16A34A), Icons.check_circle_outline),
              const SizedBox(width: 14),
              _buildAgingKpiCard('31–60 Days (Warning)', 'Rs ${total31to60.toStringAsFixed(0)}', '${((totalReceivables > 0 ? total31to60 / totalReceivables : 0) * 100).toStringAsFixed(0)}% of Total', const Color(0xFFD97706), Icons.warning_amber_rounded),
              const SizedBox(width: 14),
              _buildAgingKpiCard('60+ Days (Critical)', 'Rs ${total60plus.toStringAsFixed(0)}', '${((totalReceivables > 0 ? total60plus / totalReceivables : 0) * 100).toStringAsFixed(0)}% of Total', const Color(0xFFDC2626), Icons.error_outline),
            ],
          ),
        ),

        const Divider(height: 1, color: Color(0xFFE2E8F0)),

        // Filter and Action Bar
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          color: Colors.white,
          child: Row(
            children: [
              // Search input
              Expanded(
                flex: 3,
                child: TextField(
                  controller: _agingSearchController,
                  decoration: InputDecoration(
                    hintText: 'Search customer name or shop...',
                    hintStyle: const TextStyle(fontSize: 12),
                    prefixIcon: const Icon(Icons.search, size: 20),
                    isDense: true,
                    filled: true,
                    fillColor: const Color(0xFFF8FAFC),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Color(0xFFCBD5E1))),
                  ),
                  onChanged: (_) => setState(() {}),
                ),
              ),
              const SizedBox(width: 12),
              // Route filter
              Expanded(
                flex: 2,
                child: FutureBuilder<List<Route>>(
                  future: db.select(db.routes).get(),
                  builder: (context, snap) {
                    final routes = snap.data ?? [];
                    return DropdownButtonFormField<int?>(
                      isDense: true,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                        filled: true,
                        fillColor: const Color(0xFFF8FAFC),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Color(0xFFCBD5E1))),
                      ),
                      value: _agingRouteFilter,
                      hint: const Text('All Routes / Areas', style: TextStyle(fontSize: 12)),
                      items: [
                        const DropdownMenuItem(value: null, child: Text('All Routes / Areas', style: TextStyle(fontSize: 12))),
                        ...routes.map((r) => DropdownMenuItem(value: r.id, child: Text('${r.name} (${r.city})', style: const TextStyle(fontSize: 12)))),
                      ],
                      onChanged: (v) => setState(() => _agingRouteFilter = v),
                    );
                  },
                ),
              ),
              const SizedBox(width: 12),
              // Salesman / Booker filter
              Expanded(
                flex: 2,
                child: FutureBuilder<List<Employee>>(
                  future: db.select(db.employees).get(),
                  builder: (context, snap) {
                    final employees = (snap.data ?? []).where((e) => e.role == 'SALESMAN').toList();
                    return DropdownButtonFormField<int?>(
                      isDense: true,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                        filled: true,
                        fillColor: const Color(0xFFF8FAFC),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Color(0xFFCBD5E1))),
                      ),
                      value: _agingSalesmanFilter,
                      hint: const Text('All Salesmen / DSOs', style: TextStyle(fontSize: 12)),
                      items: [
                        const DropdownMenuItem(value: null, child: Text('All Salesmen / DSOs', style: TextStyle(fontSize: 12))),
                        ...employees.map((e) => DropdownMenuItem(value: e.id, child: Text(e.name, style: const TextStyle(fontSize: 12)))),
                      ],
                      onChanged: (v) => setState(() => _agingSalesmanFilter = v),
                    );
                  },
                ),
              ),
              const SizedBox(width: 14),
              // Refresh button
              IconButton(
                tooltip: 'Recompute Aging',
                icon: _isLoadingAging
                    ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2))
                    : const Icon(Icons.refresh),
                onPressed: _isLoadingAging ? null : _refreshAging,
              ),
              const SizedBox(width: 8),
              // Print Recovery Sheet Button
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0F172A),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                icon: const Icon(Icons.print_outlined, size: 16),
                label: const Text('Print Salesman Recovery Sheet (PDF)', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                onPressed: filtered.isEmpty
                    ? null
                    : () async {
                        String routeLabel = 'All Routes';
                        if (_agingRouteFilter != null) {
                          final r = await (db.select(db.routes)..where((t) => t.id.equals(_agingRouteFilter!))).getSingleOrNull();
                          if (r != null) routeLabel = r.name;
                        }
                        String salesmanLabel = 'All Salesmen';
                        if (_agingSalesmanFilter != null) {
                          final e = await (db.select(db.employees)..where((t) => t.id.equals(_agingSalesmanFilter!))).getSingleOrNull();
                          if (e != null) salesmanLabel = e.name;
                        }

                        await KhataStatementPrinter.printAgingRecoverySheet(
                          routeName: routeLabel,
                          salesmanName: salesmanLabel,
                          agingRows: filtered,
                        );
                      },
              ),
            ],
          ),
        ),

        const Divider(height: 1, color: Color(0xFFE2E8F0)),

        // Aging Table
        Expanded(
          child: _isLoadingAging
              ? const Center(child: CircularProgressIndicator())
              : filtered.isEmpty
                  ? const Center(
                      child: Text('No overdue customer accounts found', style: TextStyle(color: Color(0xFF94A3B8))),
                    )
                  : Column(
                      children: [
                        // Table Header
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                          color: const Color(0xFFF1F5F9),
                          child: const Row(
                            children: [
                              SizedBox(width: 40, child: Text('#', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: Color(0xFF475569)))),
                              Expanded(flex: 3, child: Text('Customer & Shop Name', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: Color(0xFF475569)))),
                              Expanded(flex: 2, child: Text('Route / Area', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: Color(0xFF475569)))),
                              Expanded(flex: 2, child: Text('Booker / DSO', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: Color(0xFF475569)))),
                              SizedBox(width: 110, child: Text('Total Due (Rs)', textAlign: TextAlign.right, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: Color(0xFF475569)))),
                              SizedBox(width: 100, child: Text('0–30 Days', textAlign: TextAlign.right, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: Color(0xFF16A34A)))),
                              SizedBox(width: 100, child: Text('31–60 Days', textAlign: TextAlign.right, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: Color(0xFFD97706)))),
                              SizedBox(width: 100, child: Text('60+ Days', textAlign: TextAlign.right, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: Color(0xFFDC2626)))),
                              SizedBox(width: 110, child: Center(child: Text('Status', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: Color(0xFF475569))))),
                              SizedBox(width: 90, child: Center(child: Text('Action', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: Color(0xFF475569))))),
                            ],
                          ),
                        ),

                        // Table Rows
                        Expanded(
                          child: ListView.separated(
                            itemCount: filtered.length,
                            separatorBuilder: (_, __) => const Divider(height: 1, color: Color(0xFFF1F5F9)),
                            itemBuilder: (context, i) {
                              final row = filtered[i];
                              final cust = row['customer'] as Customer;
                              final route = row['route'] as Route?;
                              final salesman = row['salesman'] as Employee?;
                              final total = row['totalBalance'] as double;
                              final c30 = row['current30'] as double;
                              final c60 = row['overdue60'] as double;
                              final c90 = row['overdue90plus'] as double;

                              return Container(
                                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                                color: i % 2 == 0 ? Colors.white : const Color(0xFFFAFAFA),
                                child: Row(
                                  children: [
                                    SizedBox(width: 40, child: Text('${i + 1}', style: const TextStyle(fontSize: 11, color: Color(0xFF64748B)))),
                                    Expanded(
                                      flex: 3,
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            cust.shopName != null && cust.shopName!.isNotEmpty ? cust.shopName! : cust.name,
                                            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          Text('${cust.name} ${cust.phone != null ? "• ${cust.phone}" : ""}', style: const TextStyle(fontSize: 10, color: Color(0xFF64748B))),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: Text(route != null ? '${route.name} (${route.city})' : 'Counter / None', style: const TextStyle(fontSize: 11, color: Color(0xFF475569))),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: Text(salesman != null ? salesman.name : '-', style: const TextStyle(fontSize: 11, color: Color(0xFF475569))),
                                    ),
                                    SizedBox(
                                      width: 110,
                                      child: Text('Rs ${total.toStringAsFixed(0)}', textAlign: TextAlign.right, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF0F172A))),
                                    ),
                                    SizedBox(
                                      width: 100,
                                      child: Text(c30 > 0 ? (c30).toStringAsFixed(0) : '-', textAlign: TextAlign.right, style: TextStyle(fontSize: 12, color: c30 > 0 ? const Color(0xFF16A34A) : const Color(0xFF94A3B8))),
                                    ),
                                    SizedBox(
                                      width: 100,
                                      child: Text(c60 > 0 ? (c60).toStringAsFixed(0) : '-', textAlign: TextAlign.right, style: TextStyle(fontSize: 12, fontWeight: c60 > 0 ? FontWeight.bold : FontWeight.normal, color: c60 > 0 ? const Color(0xFFD97706) : const Color(0xFF94A3B8))),
                                    ),
                                    SizedBox(
                                      width: 100,
                                      child: Text(c90 > 0 ? (c90).toStringAsFixed(0) : '-', textAlign: TextAlign.right, style: TextStyle(fontSize: 12, fontWeight: c90 > 0 ? FontWeight.bold : FontWeight.normal, color: c90 > 0 ? const Color(0xFFDC2626) : const Color(0xFF94A3B8))),
                                    ),
                                    SizedBox(
                                      width: 110,
                                      child: Center(
                                        child: _buildRiskBadge(c90, c60, c30),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 90,
                                      child: Center(
                                        child: IconButton(
                                          icon: const Icon(Icons.payment, size: 18, color: Color(0xFF16A34A)),
                                          tooltip: 'Record Payment',
                                          onPressed: () async {
                                            final updated = await showDialog<bool>(
                                              context: context,
                                              builder: (_) => CustomerPaymentDialog(customer: cust),
                                            );
                                            if (updated == true) {
                                              _refreshAging();
                                            }
                                          },
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
        ),
      ],
    );
  }

  // ==========================================
  // HELPER WIDGETS
  // ==========================================
  Widget _buildAgingKpiCard(String title, String value, String subtitle, Color color, IconData icon) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFF8FAFC),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: const Color(0xFFE2E8F0)),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: color, size: 22),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontSize: 11, color: Color(0xFF64748B), fontWeight: FontWeight.w500)),
                  const SizedBox(height: 2),
                  Text(value, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: color)),
                  const SizedBox(height: 2),
                  Text(subtitle, style: const TextStyle(fontSize: 10, color: Color(0xFF94A3B8))),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRiskBadge(double overdue90, double overdue60, double current30) {
    if (overdue90 > 0) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
        decoration: BoxDecoration(
          color: const Color(0xFFFEF2F2),
          borderRadius: BorderRadius.circular(4),
          border: Border.all(color: const Color(0xFFFCA5A5)),
        ),
        child: const Text('60+ DAYS DUE', style: TextStyle(color: Color(0xFFDC2626), fontSize: 9, fontWeight: FontWeight.bold)),
      );
    } else if (overdue60 > 0) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
        decoration: BoxDecoration(
          color: const Color(0xFFFFFBEB),
          borderRadius: BorderRadius.circular(4),
          border: Border.all(color: const Color(0xFFFCD34D)),
        ),
        child: const Text('31-60 DAYS DUE', style: TextStyle(color: Color(0xFFD97706), fontSize: 9, fontWeight: FontWeight.bold)),
      );
    } else {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
        decoration: BoxDecoration(
          color: const Color(0xFFF0FDF4),
          borderRadius: BorderRadius.circular(4),
          border: Border.all(color: const Color(0xFF86EFAC)),
        ),
        child: const Text('CURRENT', style: TextStyle(color: Color(0xFF16A34A), fontSize: 9, fontWeight: FontWeight.bold)),
      );
    }
  }

  Widget _buildEntryTypeBadge(String type) {
    Color bg;
    Color fg;
    String label;

    switch (type) {
      case 'INVOICE_DEBIT':
        bg = const Color(0xFFEFF6FF);
        fg = const Color(0xFF1D4ED8);
        label = 'INVOICE';
        break;
      case 'PAYMENT_CREDIT':
        bg = const Color(0xFFF0FDF4);
        fg = const Color(0xFF15803D);
        label = 'PAYMENT';
        break;
      case 'RETURN_CREDIT':
        bg = const Color(0xFFFAF5FF);
        fg = const Color(0xFF7E22CE);
        label = 'RETURN';
        break;
      case 'ADJUSTMENT':
        bg = const Color(0xFFFFF7ED);
        fg = const Color(0xFFC2410C);
        label = 'ADJUSTMENT';
        break;
      default:
        bg = const Color(0xFFF1F5F9);
        fg = const Color(0xFF475569);
        label = type;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(label, style: TextStyle(color: fg, fontSize: 10, fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildSupplierEntryBadge(String type) {
    Color bg;
    Color fg;
    String label;

    switch (type) {
      case 'PURCHASE_PAYABLE':
        bg = const Color(0xFFEFF6FF);
        fg = const Color(0xFF1D4ED8);
        label = 'PURCHASE GRN';
        break;
      case 'PAYMENT_PAID':
        bg = const Color(0xFFF0FDF4);
        fg = const Color(0xFF15803D);
        label = 'PAYMENT PAID';
        break;
      case 'RETURN_DEBIT':
        bg = const Color(0xFFFAF5FF);
        fg = const Color(0xFF7E22CE);
        label = 'PURCHASE RETURN';
        break;
      default:
        bg = const Color(0xFFF1F5F9);
        fg = const Color(0xFF475569);
        label = type;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(label, style: TextStyle(color: fg, fontSize: 10, fontWeight: FontWeight.bold)),
    );
  }
}
