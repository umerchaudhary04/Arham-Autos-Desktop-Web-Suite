import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart' as drift;
import 'package:intl/intl.dart';

import '../../core/db/app_database.dart';
import '../inventory/parts_master_screen.dart'; // contains dbProvider

class ExpensesScreen extends ConsumerStatefulWidget {
  const ExpensesScreen({super.key});

  @override
  ConsumerState<ExpensesScreen> createState() => _ExpensesScreenState();
}

class _ExpensesScreenState extends ConsumerState<ExpensesScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final _amountController = TextEditingController();
  final _descController = TextEditingController();
  String _category = 'TEA_MEALS';
  String _paymentMode = 'CASH';
  DateTime _expenseDate = DateTime.now();

  final DateFormat _dateFormat = DateFormat('yyyy-MM-dd');
  final DateFormat _dateTimeFormat = DateFormat('yyyy-MM-dd HH:mm');

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _amountController.dispose();
    _descController.dispose();
    super.dispose();
  }

  Future<void> _recordExpense() async {
    final amountVal = double.tryParse(_amountController.text.trim()) ?? 0.0;
    if (amountVal <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Expense amount must be greater than Rs 0.')),
      );
      return;
    }

    final db = ref.read(dbProvider);
    final amountPaisa = (amountVal * 100).toInt();
    final desc = _descController.text.trim();

    await db.into(db.expenses).insert(
      ExpensesCompanion(
        category: drift.Value(_category),
        amountPaisa: drift.Value(amountPaisa),
        paymentMode: drift.Value(_paymentMode),
        description: drift.Value(desc.isEmpty ? null : desc),
        recordedBy: const drift.Value(1),
        expenseDate: drift.Value(_expenseDate),
      ),
    );

    await db.into(db.auditLogs).insert(
      AuditLogsCompanion.insert(
        actionType: 'EXPENSE_RECORDED',
        details: 'Expense of Rs ${amountVal.toStringAsFixed(2)} logged under category $_category ($_paymentMode)',
      ),
    );

    _amountController.clear();
    _descController.clear();
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Expense of Rs ${amountVal.toStringAsFixed(2)} recorded!'),
          backgroundColor: Colors.green.shade800,
        ),
      );
      setState(() {});
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
                  child: const Icon(Icons.account_balance_wallet_rounded, color: Colors.white, size: 24),
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Expense Journal & General Ledger (GL)',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                    ),
                    Text(
                      'Operational disbursements, petty cash vouchers & double-entry chart of accounts',
                      style: TextStyle(fontSize: 12, color: Color(0xFF64748B)),
                    ),
                  ],
                ),
                const Spacer(),
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
                      Tab(text: 'Operational Expense Journal'),
                      Tab(text: 'General Ledger & Chart of Accounts'),
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
                _buildExpenseJournalTab(),
                _buildGeneralLedgerTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================
  // TAB 1: OPERATIONAL EXPENSE JOURNAL
  // ==========================================
  Widget _buildExpenseJournalTab() {
    final db = ref.watch(dbProvider);

    return StreamBuilder<List<Expense>>(
      stream: (db.select(db.expenses)..orderBy([(t) => drift.OrderingTerm.desc(t.expenseDate)])).watch(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
        final expenses = snapshot.data!;

        final now = DateTime.now();
        final startOfMonth = DateTime(now.year, now.month, 1);
        final startOfDay = DateTime(now.year, now.month, now.day);

        final totalAllPaisa = expenses.fold<int>(0, (s, e) => s + e.amountPaisa);
        final totalMonthPaisa = expenses.where((e) => e.expenseDate.isAfter(startOfMonth)).fold<int>(0, (s, e) => s + e.amountPaisa);
        final totalTodayPaisa = expenses.where((e) => e.expenseDate.isAfter(startOfDay)).fold<int>(0, (s, e) => s + e.amountPaisa);

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Left Entry Form Card
            SizedBox(
              width: 420,
              child: Container(
                margin: const EdgeInsets.all(20),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.add_card_outlined, color: Color(0xFF0F172A)),
                        SizedBox(width: 8),
                        Text('Post New Expense Voucher', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF0F172A))),
                      ],
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      decoration: const InputDecoration(labelText: 'Expense Category *', border: OutlineInputBorder()),
                      value: _category,
                      items: const [
                        DropdownMenuItem(value: 'TEA_MEALS', child: Text('Tea / Refreshments / Meals')),
                        DropdownMenuItem(value: 'RENT', child: Text('Shop / Warehouse Rent')),
                        DropdownMenuItem(value: 'ELECTRICITY', child: Text('Electricity / Utility Bills')),
                        DropdownMenuItem(value: 'FUEL', child: Text('Delivery Fuel / Conveyance')),
                        DropdownMenuItem(value: 'MAINTENANCE', child: Text('Shop Maintenance / Repairs')),
                        DropdownMenuItem(value: 'PAYROLL', child: Text('Staff Payroll & Salary')),
                        DropdownMenuItem(value: 'SALARY', child: Text('Staff Salary / Wage Advance')),
                        DropdownMenuItem(value: 'MISC', child: Text('Miscellaneous Expenses')),
                      ],
                      onChanged: (v) => setState(() => _category = v ?? 'TEA_MEALS'),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _amountController,
                            decoration: const InputDecoration(
                              labelText: 'Amount (Rs.) *',
                              prefixIcon: Icon(Icons.attach_money),
                              border: OutlineInputBorder(),
                            ),
                            keyboardType: TextInputType.number,
                          ),
                        ),
                        const SizedBox(width: 10),
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
                      ],
                    ),
                    const SizedBox(height: 12),
                    OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Color(0xFFCBD5E1)),
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      icon: const Icon(Icons.calendar_today, size: 16),
                      label: Text('Expense Date: ${_dateFormat.format(_expenseDate)}', style: const TextStyle(fontSize: 12, color: Color(0xFF0F172A))),
                      onPressed: () async {
                        final picked = await showDatePicker(
                          context: context,
                          initialDate: _expenseDate,
                          firstDate: DateTime(2020),
                          lastDate: DateTime(2050),
                        );
                        if (picked != null) setState(() => _expenseDate = picked);
                      },
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _descController,
                      decoration: const InputDecoration(
                        labelText: 'Description / Payee Details',
                        hintText: 'e.g. Daily tea for mechanics, Generator fuel',
                        border: OutlineInputBorder(),
                      ),
                      maxLines: 2,
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF0F172A),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                        icon: const Icon(Icons.check_circle_outline, size: 18),
                        label: const Text('Post Expense Voucher', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                        onPressed: _recordExpense,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Right Journal Table & KPIs
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 20, right: 20, bottom: 20),
                child: Column(
                  children: [
                    // KPI Row
                    Row(
                      children: [
                        _buildKpiCard('Today Expenses', 'Rs ${(totalTodayPaisa / 100).toStringAsFixed(0)}', '${expenses.where((e) => e.expenseDate.isAfter(startOfDay)).length} Vouchers', const Color(0xFFDC2626), Icons.today),
                        const SizedBox(width: 12),
                        _buildKpiCard('This Month Expenses', 'Rs ${(totalMonthPaisa / 100).toStringAsFixed(0)}', 'Current Month Total', const Color(0xFFD97706), Icons.calendar_month),
                        const SizedBox(width: 12),
                        _buildKpiCard('All-Time Recorded', 'Rs ${(totalAllPaisa / 100).toStringAsFixed(0)}', '${expenses.length} Total Vouchers', const Color(0xFF0F172A), Icons.receipt_long),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Table Container
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: const Color(0xFFE2E8F0)),
                        ),
                        child: Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                              color: const Color(0xFFF1F5F9),
                              child: const Row(
                                children: [
                                  SizedBox(width: 130, child: Text('Date & Time', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: Color(0xFF475569)))),
                                  SizedBox(width: 130, child: Text('Category', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: Color(0xFF475569)))),
                                  SizedBox(width: 100, child: Text('Mode', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: Color(0xFF475569)))),
                                  Expanded(child: Text('Description / Notes', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: Color(0xFF475569)))),
                                  SizedBox(width: 120, child: Text('Amount (Rs)', textAlign: TextAlign.right, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: Color(0xFF475569)))),
                                ],
                              ),
                            ),
                            Expanded(
                              child: expenses.isEmpty
                                  ? const Center(child: Text('No expenses recorded yet', style: TextStyle(color: Color(0xFF94A3B8))))
                                  : ListView.separated(
                                      itemCount: expenses.length,
                                      separatorBuilder: (_, __) => const Divider(height: 1),
                                      itemBuilder: (context, i) {
                                        final exp = expenses[i];
                                        return Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                                          color: i % 2 == 0 ? Colors.white : const Color(0xFFFAFAFA),
                                          child: Row(
                                            children: [
                                              SizedBox(
                                                width: 130,
                                                child: Text(_dateTimeFormat.format(exp.createdAt), style: const TextStyle(fontSize: 12, color: Color(0xFF334155))),
                                              ),
                                              SizedBox(
                                                width: 130,
                                                child: _buildCategoryBadge(exp.category),
                                              ),
                                              SizedBox(
                                                width: 100,
                                                child: Text(exp.paymentMode, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Color(0xFF475569))),
                                              ),
                                              Expanded(
                                                child: Text(
                                                  exp.description ?? '-',
                                                  style: const TextStyle(fontSize: 12, color: Color(0xFF0F172A)),
                                                  maxLines: 1,
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                              ),
                                              SizedBox(
                                                width: 120,
                                                child: Text(
                                                  'Rs ${(exp.amountPaisa / 100).toStringAsFixed(2)}',
                                                  textAlign: TextAlign.right,
                                                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFFDC2626)),
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
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  // ==========================================
  // TAB 2: GENERAL LEDGER CHART OF ACCOUNTS
  // ==========================================
  Widget _buildGeneralLedgerTab() {
    final db = ref.watch(dbProvider);

    return FutureBuilder<Map<String, dynamic>>(
      future: () async {
        // 1. Sales & Revenue
        final sales = await db.select(db.sales).get();
        final grossSalesPaisa = sales.fold<int>(0, (sum, s) => sum + s.grossAmountPaisa);
        final netSalesPaisa = sales.fold<int>(0, (sum, s) => sum + s.netAmountPaisa);
        final netCashSalesPaisa = sales.fold<int>(0, (sum, s) => sum + s.paidAmountPaisa);

        // 2. Customer Recoveries (Khata settlements)
        final custEntries = await db.select(db.customerLedgerEntries).get();
        final customerRecoveriesPaisa = custEntries
            .where((e) => e.entryType == 'PAYMENT_CREDIT')
            .fold<int>(0, (sum, e) => sum + e.creditAmountPaisa);

        // 3. Operating Expenses & Payroll
        final allExpenses = await db.select(db.expenses).get();
        final cashExpensesPaisa = allExpenses
            .where((e) => e.paymentMode == 'CASH')
            .fold<int>(0, (sum, e) => sum + e.amountPaisa);

        final payrollDisbursedPaisa = allExpenses
            .where((e) => e.category == 'PAYROLL' || e.category == 'SALARY')
            .fold<int>(0, (sum, e) => sum + e.amountPaisa);

        final operatingExpensesPaisa = allExpenses
            .where((e) => e.category != 'PAYROLL' && e.category != 'SALARY')
            .fold<int>(0, (sum, e) => sum + e.amountPaisa);

        final totalExpensesPaisa = allExpenses.fold<int>(0, (sum, e) => sum + e.amountPaisa);

        // 4. Supplier Payments
        final suppEntries = await db.select(db.supplierLedgerEntries).get();
        final supplierPaymentsPaisa = suppEntries
            .where((e) => e.entryType == 'PAYMENT_PAID')
            .fold<int>(0, (sum, e) => sum + e.debitAmountPaisa);

        // 5. Cash Refunds (Approved Return Claims)
        final approvedClaims = await (db.select(db.returnClaims)
            ..where((t) => t.claimStatus.equals('APPROVED'))).get();
        final cashRefundsPaisa = approvedClaims.fold<int>(0, (sum, r) => sum + r.totalRefundAmountPaisa);

        // 6. Cash-in-Hand: (Net Cash Sales + Customer Recoveries - Cash Expenses - Supplier Payments - Cash Refunds)
        final cashInHandPaisa = netCashSalesPaisa + customerRecoveriesPaisa - cashExpensesPaisa - supplierPaymentsPaisa - cashRefundsPaisa;

        // 7. Inventory Valuation: Sum of Current Stock * Avg Cost
        final parts = await db.select(db.parts).get();
        final inventoryValuePaisa = parts.fold<int>(0, (sum, p) => sum + (p.currentStock * p.avgCostPaisa));

        // 8. Accounts Receivable: Sum of Customer Balances
        final customers = await db.select(db.customers).get();
        final receivablesPaisa = customers.fold<int>(0, (sum, c) => sum + (c.currentBalancePaisa > 0 ? c.currentBalancePaisa : 0));

        // 9. Accounts Payable: Sum of Supplier Balances
        final suppliers = await db.select(db.suppliers).get();
        final payablesPaisa = suppliers.fold<int>(0, (sum, s) => sum + (s.currentBalancePaisa > 0 ? s.currentBalancePaisa : 0));

        // 10. Cost of Goods Sold (COGS)
        final saleItems = await db.select(db.saleItems).get();
        final partMap = {for (var p in parts) p.id: p};
        final cogsPaisa = saleItems.fold<int>(0, (sum, item) {
          final p = partMap[item.partId];
          return sum + (item.qty * (p?.avgCostPaisa ?? 0));
        });

        // 11. Net Operating Profit: Net Sales Revenue - COGS - Operating Expenses - Payroll Disbursed
        final netOperatingProfitPaisa = netSalesPaisa - cogsPaisa - operatingExpensesPaisa - payrollDisbursedPaisa;

        final totalAssetsPaisa = cashInHandPaisa + receivablesPaisa + inventoryValuePaisa;

        return {
          'cashInHandPaisa': cashInHandPaisa,
          'inventoryValuePaisa': inventoryValuePaisa,
          'receivablesPaisa': receivablesPaisa,
          'totalAssetsPaisa': totalAssetsPaisa,
          'payablesPaisa': payablesPaisa,
          'grossSalesPaisa': grossSalesPaisa,
          'netSalesPaisa': netSalesPaisa,
          'cogsPaisa': cogsPaisa,
          'operatingExpensesPaisa': operatingExpensesPaisa,
          'payrollDisbursedPaisa': payrollDisbursedPaisa,
          'totalExpensesPaisa': totalExpensesPaisa,
          'netOperatingProfitPaisa': netOperatingProfitPaisa,
          'netCashSalesPaisa': netCashSalesPaisa,
          'customerRecoveriesPaisa': customerRecoveriesPaisa,
          'cashExpensesPaisa': cashExpensesPaisa,
          'supplierPaymentsPaisa': supplierPaymentsPaisa,
          'cashRefundsPaisa': cashRefundsPaisa,
        };
      }(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
        final gl = snapshot.data!;

        final totalAssets = (gl['totalAssetsPaisa'] as int) / 100.0;
        final cashInHand = (gl['cashInHandPaisa'] as int) / 100.0;
        final invVal = (gl['inventoryValuePaisa'] as int) / 100.0;
        final recVal = (gl['receivablesPaisa'] as int) / 100.0;
        final payVal = (gl['payablesPaisa'] as int) / 100.0;
        final grossSales = (gl['grossSalesPaisa'] as int) / 100.0;
        final netSales = (gl['netSalesPaisa'] as int) / 100.0;
        final cogs = (gl['cogsPaisa'] as int) / 100.0;
        final opExpenses = (gl['operatingExpensesPaisa'] as int) / 100.0;
        final payroll = (gl['payrollDisbursedPaisa'] as int) / 100.0;
        final netProfit = (gl['netOperatingProfitPaisa'] as int) / 100.0;

        // Trial Balance Items (Double-Entry Debit & Credit)
        final trialBalanceItems = [
          {'code': '1010', 'name': 'Cash-in-Hand (Liquid Till)', 'type': 'Asset', 'debit': cashInHand > 0 ? cashInHand : 0.0, 'credit': cashInHand < 0 ? -cashInHand : 0.0},
          {'code': '1020', 'name': 'Accounts Receivable (Customer Khata)', 'type': 'Asset', 'debit': recVal, 'credit': 0.0},
          {'code': '1030', 'name': 'Merchandise Inventory Asset', 'type': 'Asset', 'debit': invVal, 'credit': 0.0},
          {'code': '2010', 'name': 'Accounts Payable (Supplier Khata)', 'type': 'Liability', 'debit': 0.0, 'credit': payVal},
          {'code': '4010', 'name': 'Gross Sales Revenue', 'type': 'Revenue', 'debit': 0.0, 'credit': grossSales},
          {'code': '5010', 'name': 'Cost of Goods Sold (COGS)', 'type': 'Expense', 'debit': cogs, 'credit': 0.0},
          {'code': '5020', 'name': 'Operating Expenses (Rent, Utilities, Fuel)', 'type': 'Expense', 'debit': opExpenses, 'credit': 0.0},
          {'code': '5030', 'name': 'Staff Payroll & Salaries Disbursed', 'type': 'Expense', 'debit': payroll, 'credit': 0.0},
        ];

        final totalDebits = trialBalanceItems.fold<double>(0.0, (sum, i) => sum + (i['debit'] as double));
        final totalCredits = trialBalanceItems.fold<double>(0.0, (sum, i) => sum + (i['credit'] as double));

        return SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Center(
            child: Container(
              constraints: const BoxConstraints(maxWidth: 1000),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title Header
                  Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text('General Ledger & Live Chart of Accounts', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF0F172A))),
                          SizedBox(height: 4),
                          Text('Real-time double-entry trial balance, balance sheet classifications & operational profit', style: TextStyle(fontSize: 13, color: Color(0xFF64748B))),
                        ],
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: const Color(0xFFECFDF5),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: const Color(0xFFA7F3D0)),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.check_circle_outline, color: Color(0xFF059669), size: 16),
                            SizedBox(width: 6),
                            Text('Live Drift Synchronization', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF065F46))),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Top 4 High-Level KPI Summary Cards
                  Row(
                    children: [
                      _buildKpiCard('TOTAL CURRENT ASSETS', 'Rs. ${totalAssets.toStringAsFixed(2)}', 'Cash + Stock + Receivables', const Color(0xFF16A34A), Icons.account_balance),
                      const SizedBox(width: 14),
                      _buildKpiCard('ACCOUNTS PAYABLE', 'Rs. ${payVal.toStringAsFixed(2)}', 'Supplier Khata Debt', const Color(0xFFDC2626), Icons.assignment_late_outlined),
                      const SizedBox(width: 14),
                      _buildKpiCard('GROSS SALES REVENUE', 'Rs. ${grossSales.toStringAsFixed(2)}', 'Net: Rs. ${netSales.toStringAsFixed(2)}', const Color(0xFF2563EB), Icons.trending_up),
                      const SizedBox(width: 14),
                      _buildKpiCard('NET OPERATING PROFIT', 'Rs. ${netProfit.toStringAsFixed(2)}', 'Revenue - COGS - OpEx - Payroll', netProfit >= 0 ? const Color(0xFF059669) : const Color(0xFFDC2626), Icons.savings_outlined),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // 1. Account Classification Cards
                  _buildGlCategoryCard(
                    title: '1000 — Current Assets',
                    color: const Color(0xFF16A34A),
                    icon: Icons.account_balance,
                    totalLabel: 'Total Assets: Rs. ${totalAssets.toStringAsFixed(2)}',
                    subAccounts: [
                      {
                        'code': '1010',
                        'name': 'Cash-in-Hand (Liquid Till)',
                        'amount': cashInHand,
                        'formula': 'Net Cash Sales + Recoveries - Cash OpEx - Supplier Pymts - Refunds',
                      },
                      {
                        'code': '1020',
                        'name': 'Accounts Receivable (Customer Khata)',
                        'amount': recVal,
                        'formula': 'Sum of outstanding customer credit balances',
                      },
                      {
                        'code': '1030',
                        'name': 'Merchandise Inventory Asset',
                        'amount': invVal,
                        'formula': 'Sum of Current Stock × Weighted Average Cost',
                      },
                    ],
                  ),
                  const SizedBox(height: 16),

                  _buildGlCategoryCard(
                    title: '2000 — Current Liabilities',
                    color: const Color(0xFFDC2626),
                    icon: Icons.assignment_late_outlined,
                    totalLabel: 'Total Liabilities: Rs. ${payVal.toStringAsFixed(2)}',
                    subAccounts: [
                      {
                        'code': '2010',
                        'name': 'Accounts Payable (Supplier Khata)',
                        'amount': payVal,
                        'formula': 'Sum of outstanding supplier invoice balances',
                      },
                    ],
                  ),
                  const SizedBox(height: 16),

                  _buildGlCategoryCard(
                    title: '4000 & 5000 — Revenue & Expense Summary',
                    color: const Color(0xFF2563EB),
                    icon: Icons.receipt_long_outlined,
                    totalLabel: 'Net Operating Profit: Rs. ${netProfit.toStringAsFixed(2)}',
                    subAccounts: [
                      {
                        'code': '4010',
                        'name': 'Gross Sales Revenue',
                        'amount': grossSales,
                        'formula': 'Total retail & wholesale billings before discount',
                      },
                      {
                        'code': '5010',
                        'name': 'Cost of Goods Sold (COGS)',
                        'amount': cogs,
                        'formula': 'Historical acquisition cost of all sold inventory items',
                      },
                      {
                        'code': '5020',
                        'name': 'Operating Expenses (Rent, Utilities, Fuel)',
                        'amount': opExpenses,
                        'formula': 'Daily shop vouchers logged under non-payroll categories',
                      },
                      {
                        'code': '5030',
                        'name': 'Staff Payroll & Salaries Disbursed',
                        'amount': payroll,
                        'formula': 'Total salary disbursements logged under PAYROLL / SALARY',
                      },
                      {
                        'code': '5090',
                        'name': 'Net Operating Profit',
                        'amount': netProfit,
                        'formula': 'Net Sales Revenue − COGS − Operating Expenses − Staff Payroll',
                      },
                    ],
                  ),
                  const SizedBox(height: 24),

                  // 2. Double-Entry Live Trial Balance Table
                  Card(
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: const BorderSide(color: Color(0xFFE2E8F0)),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: const [
                              Icon(Icons.table_chart_outlined, color: Color(0xFF0F172A), size: 20),
                              SizedBox(width: 10),
                              Text(
                                'Double-Entry Trial Balance Table',
                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                              ),
                              Spacer(),
                              Text('All Amounts in PKR (Rs.)', style: TextStyle(fontSize: 12, color: Color(0xFF64748B))),
                            ],
                          ),
                          const Divider(height: 24),

                          // Table Headers
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF8FAFC),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: const Row(
                              children: [
                                SizedBox(width: 70, child: Text('Code', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Color(0xFF475569)))),
                                Expanded(child: Text('Account Title', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Color(0xFF475569)))),
                                SizedBox(width: 110, child: Text('Classification', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Color(0xFF475569)))),
                                SizedBox(width: 130, child: Text('Debit (Rs.)', textAlign: TextAlign.right, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Color(0xFF475569)))),
                                SizedBox(width: 130, child: Text('Credit (Rs.)', textAlign: TextAlign.right, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Color(0xFF475569)))),
                              ],
                            ),
                          ),
                          const SizedBox(height: 6),

                          // Rows
                          ...trialBalanceItems.map((item) {
                            final debit = item['debit'] as double;
                            final credit = item['credit'] as double;

                            return Container(
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                              decoration: const BoxDecoration(
                                border: Border(bottom: BorderSide(color: Color(0xFFF1F5F9))),
                              ),
                              child: Row(
                                children: [
                                  SizedBox(
                                    width: 70,
                                    child: Text(
                                      item['code'] as String,
                                      style: const TextStyle(fontFamily: 'monospace', fontWeight: FontWeight.bold, fontSize: 12, color: Color(0xFF64748B)),
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      item['name'] as String,
                                      style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF0F172A)),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 110,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: _getGlTypeColor(item['type'] as String).withValues(alpha: 0.1),
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: Text(
                                        item['type'] as String,
                                        style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: _getGlTypeColor(item['type'] as String)),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 130,
                                    child: Text(
                                      debit > 0 ? debit.toStringAsFixed(2) : '—',
                                      textAlign: TextAlign.right,
                                      style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF0F172A)),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 130,
                                    child: Text(
                                      credit > 0 ? credit.toStringAsFixed(2) : '—',
                                      textAlign: TextAlign.right,
                                      style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF0F172A)),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }),

                          // Total Line
                          Container(
                            margin: const EdgeInsets.only(top: 8),
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                            decoration: BoxDecoration(
                              color: const Color(0xFF0F172A),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Row(
                              children: [
                                const SizedBox(width: 70),
                                const Expanded(
                                  child: Text(
                                    'TOTAL POSTED TRIAL BALANCE',
                                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.white),
                                  ),
                                ),
                                const SizedBox(width: 110),
                                SizedBox(
                                  width: 130,
                                  child: Text(
                                    'Rs. ${totalDebits.toStringAsFixed(2)}',
                                    textAlign: TextAlign.right,
                                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.white),
                                  ),
                                ),
                                SizedBox(
                                  width: 130,
                                  child: Text(
                                    'Rs. ${totalCredits.toStringAsFixed(2)}',
                                    textAlign: TextAlign.right,
                                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.white),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Color _getGlTypeColor(String type) {
    switch (type) {
      case 'Asset':
        return const Color(0xFF16A34A);
      case 'Liability':
        return const Color(0xFFDC2626);
      case 'Revenue':
        return const Color(0xFF2563EB);
      case 'Expense':
        return const Color(0xFFD97706);
      default:
        return const Color(0xFF475569);
    }
  }

  Widget _buildGlCategoryCard({
    required String title,
    required Color color,
    required IconData icon,
    required String totalLabel,
    required List<Map<String, dynamic>> subAccounts,
  }) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: Color(0xFFE2E8F0)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: color.withValues(alpha: 0.1),
                  child: Icon(icon, color: color, size: 20),
                ),
                const SizedBox(width: 14),
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF0F172A))),
                const Spacer(),
                Text(totalLabel, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: color)),
              ],
            ),
            const Divider(height: 24),
            ...subAccounts.map((acc) {
              final amt = acc['amount'] as double;
              final formula = acc['formula'] as String?;
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(acc['code'] as String, style: const TextStyle(fontFamily: 'monospace', fontWeight: FontWeight.bold, fontSize: 12, color: Color(0xFF64748B))),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(acc['name'] as String, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF334155))),
                          if (formula != null)
                            Text(formula, style: const TextStyle(fontSize: 11, color: Color(0xFF94A3B8))),
                        ],
                      ),
                    ),
                    Text('Rs. ${amt.toStringAsFixed(2)}', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: amt < 0 ? Colors.red : const Color(0xFF0F172A))),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryBadge(String category) {
    Color bg;
    Color fg;
    String label;

    switch (category) {
      case 'RENT':
        bg = const Color(0xFFEFF6FF);
        fg = const Color(0xFF1D4ED8);
        label = 'RENT';
        break;
      case 'ELECTRICITY':
        bg = const Color(0xFFFFFBEB);
        fg = const Color(0xFFD97706);
        label = 'UTILITIES';
        break;
      case 'TEA_MEALS':
        bg = const Color(0xFFF0FDF4);
        fg = const Color(0xFF15803D);
        label = 'TEA / MEALS';
        break;
      case 'FUEL':
        bg = const Color(0xFFFAF5FF);
        fg = const Color(0xFF7E22CE);
        label = 'FUEL';
        break;
      case 'SALARY':
      case 'PAYROLL':
        bg = const Color(0xFFFEF2F2);
        fg = const Color(0xFFDC2626);
        label = 'PAYROLL / SALARY';
        break;
      default:
        bg = const Color(0xFFF1F5F9);
        fg = const Color(0xFF475569);
        label = category;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(4)),
      child: Text(label, style: TextStyle(color: fg, fontSize: 9.5, fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildKpiCard(String title, String value, String subtitle, Color color, IconData icon) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: const Color(0xFFE2E8F0)),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
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
}

/// Standalone alias / entrypoint for General Ledger & Chart of Accounts screen
class GlScreen extends StatelessWidget {
  const GlScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const ExpensesScreen();
  }
}
