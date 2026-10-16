import 'package:flutter/material.dart' hide Route;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart' as drift;
import 'package:intl/intl.dart';

import '../../core/db/app_database.dart';
import '../../core/widgets/erp_page_header.dart';
import '../inventory/parts_master_screen.dart'; // contains dbProvider

class EmployeesScreen extends ConsumerStatefulWidget {
  const EmployeesScreen({super.key});

  @override
  ConsumerState<EmployeesScreen> createState() => _EmployeesScreenState();
}

class _EmployeesScreenState extends ConsumerState<EmployeesScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // Search & Filter state for Employee Directory
  final _searchController = TextEditingController();
  String _roleFilter = 'ALL';
  String _statusFilter = 'ACTIVE';

  // State for Salary Disbursement Form
  Employee? _selectedEmployeeForPayroll;
  final _bonusController = TextEditingController(text: '0');
  final _deductionController = TextEditingController(text: '0');
  final _notesController = TextEditingController();
  String _payrollPaymentMode = 'CASH';
  DateTime _salaryMonth = DateTime.now();

  final NumberFormat _currencyFormat = NumberFormat('#,##0.00', 'en_US');
  final DateFormat _monthFormat = DateFormat('MMMM yyyy');
  final DateFormat _dateTimeFormat = DateFormat('yyyy-MM-dd HH:mm');
  int _payrollRightViewIndex = 0; // 0: Staff Balances, 1: History Journal

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    _bonusController.dispose();
    _deductionController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _openAddEditEmployeeDialog({Employee? employee, List<Route>? routes}) {
    final nameCtrl = TextEditingController(text: employee?.name ?? '');
    final phoneCtrl = TextEditingController(text: employee?.phone ?? '');
    final salaryCtrl = TextEditingController(
      text: employee != null
          ? (employee.monthlySalaryPaisa / 100).toStringAsFixed(0)
          : '25000',
    );
    String selectedRole = employee?.role ?? 'SALESMAN';
    int? selectedRouteId = employee?.assignedRouteId;
    bool isActive = employee?.isActive ?? true;
    final messenger = ScaffoldMessenger.of(context);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogCtx) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return Dialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
              child: Container(
                width: 500,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: const Color(0xFF0F172A),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            employee == null
                                ? Icons.person_add_rounded
                                : Icons.edit_note_rounded,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          employee == null
                              ? 'Add New Employee'
                              : 'Edit Employee: ${employee.name}',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF0F172A),
                          ),
                        ),
                        const Spacer(),
                        IconButton(
                          icon: const Icon(Icons.close, color: Color(0xFF64748B)),
                          onPressed: () => Navigator.pop(dialogCtx),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: nameCtrl,
                      decoration: const InputDecoration(
                        labelText: 'Full Name *',
                        hintText: 'e.g. Muhammad Usman',
                        prefixIcon: Icon(Icons.badge_outlined),
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 14),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: phoneCtrl,
                            decoration: const InputDecoration(
                              labelText: 'Phone / Mobile',
                              hintText: '0300-1234567',
                              prefixIcon: Icon(Icons.phone_outlined),
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            initialValue: selectedRole,
                            decoration: const InputDecoration(
                              labelText: 'Staff Role *',
                              prefixIcon: Icon(Icons.work_outline),
                              border: OutlineInputBorder(),
                            ),
                            items: const [
                              DropdownMenuItem(
                                  value: 'SALESMAN',
                                  child: Text('Salesman (DSO)')),
                              DropdownMenuItem(
                                  value: 'CASHIER', child: Text('POS Cashier')),
                              DropdownMenuItem(
                                  value: 'SHOP_BOY', child: Text('Shop Boy / Helper')),
                              DropdownMenuItem(
                                  value: 'MANAGER', child: Text('Manager')),
                            ],
                            onChanged: (val) {
                              if (val != null) {
                                setDialogState(() => selectedRole = val);
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: salaryCtrl,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              labelText: 'Monthly Base Salary (Rs) *',
                              prefixIcon: Icon(Icons.payments_outlined),
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: DropdownButtonFormField<int?>(
                            initialValue: selectedRouteId,
                            decoration: const InputDecoration(
                              labelText: 'Assigned Route',
                              prefixIcon: Icon(Icons.alt_route_rounded),
                              border: OutlineInputBorder(),
                            ),
                            items: [
                              const DropdownMenuItem<int?>(
                                value: null,
                                child: Text('Shop Based / None'),
                              ),
                              if (routes != null)
                                ...routes.map(
                                  (r) => DropdownMenuItem<int?>(
                                    value: r.id,
                                    child: Text('${r.name} (${r.city})'),
                                  ),
                                ),
                            ],
                            onChanged: (val) {
                              setDialogState(() => selectedRouteId = val);
                            },
                          ),
                        ),
                      ],
                    ),
                    if (employee != null) ...[
                      const SizedBox(height: 14),
                      Row(
                        children: [
                          const Text('Employment Status: ',
                              style: TextStyle(fontWeight: FontWeight.w600)),
                          Switch(
                            value: isActive,
                            activeThumbColor: const Color(0xFF10B981),
                            onChanged: (val) {
                              setDialogState(() => isActive = val);
                            },
                          ),
                          Text(
                            isActive ? 'Active Staff' : 'Inactive / Resigned',
                            style: TextStyle(
                              color: isActive
                                  ? const Color(0xFF10B981)
                                  : const Color(0xFFEF4444),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        OutlinedButton(
                          onPressed: () => Navigator.pop(dialogCtx),
                          child: const Text('Cancel'),
                        ),
                        const SizedBox(width: 12),
                        ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF0F172A),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 12),
                          ),
                          icon: const Icon(Icons.check, size: 18),
                          label: Text(employee == null ? 'Save Employee' : 'Update'),
                          onPressed: () async {
                            final name = nameCtrl.text.trim();
                            if (name.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text('Employee Name is required')),
                              );
                              return;
                            }
                            final salaryRs =
                                double.tryParse(salaryCtrl.text.trim()) ?? 0.0;
                            final salaryPaisa = (salaryRs * 100).toInt();

                            final db = ref.read(dbProvider);

                            if (employee == null) {
                              await db.into(db.employees).insert(
                                    EmployeesCompanion(
                                      name: drift.Value(name),
                                      phone: drift.Value(phoneCtrl.text.trim().isEmpty
                                          ? null
                                          : phoneCtrl.text.trim()),
                                      role: drift.Value(selectedRole),
                                      assignedRouteId:
                                          drift.Value(selectedRouteId),
                                      monthlySalaryPaisa:
                                          drift.Value(salaryPaisa),
                                      isActive: const drift.Value(true),
                                    ),
                                  );

                              await db.into(db.auditLogs).insert(
                                    AuditLogsCompanion.insert(
                                      actionType: 'EMPLOYEE_CREATED',
                                      details:
                                          'Added staff member $name ($selectedRole) with base salary Rs ${salaryRs.toStringAsFixed(2)}',
                                    ),
                                  );
                            } else {
                              await (db.update(db.employees)
                                    ..where((e) => e.id.equals(employee.id)))
                                  .write(
                                EmployeesCompanion(
                                  name: drift.Value(name),
                                  phone: drift.Value(phoneCtrl.text.trim().isEmpty
                                      ? null
                                      : phoneCtrl.text.trim()),
                                  role: drift.Value(selectedRole),
                                  assignedRouteId: drift.Value(selectedRouteId),
                                  monthlySalaryPaisa: drift.Value(salaryPaisa),
                                  isActive: drift.Value(isActive),
                                ),
                              );

                              await db.into(db.auditLogs).insert(
                                    AuditLogsCompanion.insert(
                                      actionType: 'EMPLOYEE_UPDATED',
                                      details:
                                          'Updated staff member $name (ID #${employee.id}) status: ${isActive ? "Active" : "Inactive"}',
                                    ),
                                  );
                            }

                            if (mounted && dialogCtx.mounted) {
                              Navigator.pop(dialogCtx);
                              messenger.showSnackBar(
                                SnackBar(
                                  content: Text(employee == null
                                      ? 'Staff member $name added successfully!'
                                      : 'Employee $name updated!'),
                                  backgroundColor: const Color(0xFF0F172A),
                                ),
                              );
                            }
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _confirmToggleEmployeeStatus(Employee employee) {
    final nextStatus = !employee.isActive;
    final messenger = ScaffoldMessenger.of(context);
    showDialog(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        title: Text(nextStatus ? 'Reactivate Staff Member?' : 'Deactivate Staff Member?'),
        content: Text(
          nextStatus
              ? 'Are you sure you want to reactivate ${employee.name}? They will reappear in active staff lists and payroll.'
              : 'Are you sure you want to deactivate ${employee.name}? They will be marked inactive and hidden from active billing routes.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogCtx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: nextStatus
                  ? const Color(0xFF10B981)
                  : const Color(0xFFEF4444),
              foregroundColor: Colors.white,
            ),
            onPressed: () async {
              final db = ref.read(dbProvider);
              await (db.update(db.employees)
                    ..where((e) => e.id.equals(employee.id)))
                  .write(
                EmployeesCompanion(isActive: drift.Value(nextStatus)),
              );

              await db.into(db.auditLogs).insert(
                    AuditLogsCompanion.insert(
                      actionType: 'EMPLOYEE_STATUS_CHANGED',
                      details:
                          'Staff member ${employee.name} (ID #${employee.id}) was ${nextStatus ? "Reactivated" : "Deactivated"}',
                    ),
                  );

              if (mounted && dialogCtx.mounted) {
                Navigator.pop(dialogCtx);
                messenger.showSnackBar(
                  SnackBar(
                    content: Text(
                      '${employee.name} is now ${nextStatus ? "Active" : "Inactive"}.',
                    ),
                    backgroundColor: nextStatus
                        ? const Color(0xFF10B981)
                        : const Color(0xFFEF4444),
                  ),
                );
              }
            },
            child: Text(nextStatus ? 'Reactivate' : 'Deactivate'),
          ),
        ],
      ),
    );
  }

  Future<void> _disburseSalaryVoucher() async {
    if (_selectedEmployeeForPayroll == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select an employee for payroll disbursement.')),
      );
      return;
    }

    final emp = _selectedEmployeeForPayroll!;
    final baseSalaryRs = emp.monthlySalaryPaisa / 100.0;
    final bonusRs = double.tryParse(_bonusController.text.trim()) ?? 0.0;
    final deductionRs = double.tryParse(_deductionController.text.trim()) ?? 0.0;

    final netPayableRs = baseSalaryRs + bonusRs - deductionRs;
    if (netPayableRs <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Net salary payable must be greater than Rs 0.')),
      );
      return;
    }

    final monthStr = _monthFormat.format(_salaryMonth);
    final notes = _notesController.text.trim();
    final description =
        'Monthly Salary: ${emp.name} (${emp.role}) - $monthStr. Base: Rs ${_currencyFormat.format(baseSalaryRs)}${bonusRs > 0 ? ", Bonus: Rs ${_currencyFormat.format(bonusRs)}" : ""}${deductionRs > 0 ? ", Deduct: Rs ${_currencyFormat.format(deductionRs)}" : ""}${notes.isNotEmpty ? " | Notes: $notes" : ""}';

    final db = ref.read(dbProvider);
    final amountPaisa = (netPayableRs * 100).toInt();

    // Atomic Drift Transaction: insert expense and audit log
    await db.transaction(() async {
      await db.into(db.expenses).insert(
            ExpensesCompanion(
              category: const drift.Value('PAYROLL'),
              amountPaisa: drift.Value(amountPaisa),
              paymentMode: drift.Value(_payrollPaymentMode),
              description: drift.Value(description),
              recordedBy: const drift.Value(1),
              expenseDate: drift.Value(DateTime.now()),
            ),
          );

      await db.into(db.auditLogs).insert(
            AuditLogsCompanion.insert(
              actionType: 'SALARY_DISBURSED',
              details:
                  'Disbursed Rs ${_currencyFormat.format(netPayableRs)} to ${emp.name} (${emp.role}) for $monthStr via $_payrollPaymentMode',
            ),
          );
    });

    _bonusController.text = '0';
    _deductionController.text = '0';
    _notesController.clear();

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Salary of Rs ${_currencyFormat.format(netPayableRs)} disbursed to ${emp.name}!',
          ),
          backgroundColor: const Color(0xFF10B981),
        ),
      );
      setState(() {});
    }
  }

  void _showSalarySlipDialog(Expense expense) {
    showDialog(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            const Icon(Icons.receipt_long, color: Color(0xFF0F172A)),
            const SizedBox(width: 8),
            const Text('Salary Voucher Receipt'),
            const Spacer(),
            IconButton(
              icon: const Icon(Icons.close),
              onPressed: () => Navigator.pop(dialogCtx),
            ),
          ],
        ),
        content: Container(
          width: 450,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFFF8FAFC),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFCBD5E1)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Center(
                child: Text(
                  'ARHAM AUTOS',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0F172A),
                    letterSpacing: 1.2,
                  ),
                ),
              ),
              const Center(
                child: Text(
                  'Bagobhar Road, Kotsmaba | Ph: 0300-6748837',
                  style: TextStyle(fontSize: 11, color: Color(0xFF64748B)),
                ),
              ),
              const Divider(height: 24, thickness: 1),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Voucher ID:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                  Text('#EXP-${expense.id}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                ],
              ),
              const SizedBox(height: 6),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Disbursement Date:', style: TextStyle(fontSize: 12, color: Color(0xFF64748B))),
                  Text(_dateTimeFormat.format(expense.createdAt), style: const TextStyle(fontSize: 12)),
                ],
              ),
              const SizedBox(height: 6),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Payment Mode:', style: TextStyle(fontSize: 12, color: Color(0xFF64748B))),
                  Text(expense.paymentMode, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                ],
              ),
              const SizedBox(height: 12),
              const Text('Details & Breakdown:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
              const SizedBox(height: 4),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                child: Text(
                  expense.description ?? 'Staff Salary Disbursement',
                  style: const TextStyle(fontSize: 12, color: Color(0xFF1E293B)),
                ),
              ),
              const Divider(height: 24, thickness: 1),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Net Disbursed Amount:', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                  Text(
                    'Rs. ${_currencyFormat.format(expense.amountPaisa / 100)}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF10B981),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              const Center(
                child: Text(
                  'For Account Solution Contact AlphaSync Systems: 03140486627',
                  style: TextStyle(
                    fontSize: 10,
                    fontStyle: FontStyle.italic,
                    color: Color(0xFF64748B),
                  ),
                ),
              ),
            ],
          ),
        ),
        actions: [
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF0F172A),
              foregroundColor: Colors.white,
            ),
            icon: const Icon(Icons.check, size: 16),
            label: const Text('Close'),
            onPressed: () => Navigator.pop(dialogCtx),
          ),
        ],
      ),
    );
  }

  Widget _buildRoleBadge(String role) {
    Color bg;
    Color fg;
    String displayRole;

    switch (role.toUpperCase()) {
      case 'SALESMAN':
        bg = const Color(0xFFEFF6FF);
        fg = const Color(0xFF2563EB);
        displayRole = 'Salesman (DSO)';
        break;
      case 'CASHIER':
        bg = const Color(0xFFECFDF5);
        fg = const Color(0xFF059669);
        displayRole = 'POS Cashier';
        break;
      case 'SHOP_BOY':
        bg = const Color(0xFFF5F3FF);
        fg = const Color(0xFF7C3AED);
        displayRole = 'Shop Boy';
        break;
      case 'MANAGER':
        bg = const Color(0xFF0F172A);
        fg = Colors.white;
        displayRole = 'Manager';
        break;
      default:
        bg = const Color(0xFFF1F5F9);
        fg = const Color(0xFF475569);
        displayRole = role;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        displayRole,
        style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: fg),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final db = ref.watch(dbProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: StreamBuilder<List<Route>>(
        stream: db.select(db.routes).watch(),
        builder: (context, routesSnapshot) {
          final routes = routesSnapshot.data ?? [];
          final routeMap = {for (var r in routes) r.id: r};

          return StreamBuilder<List<Employee>>(
            stream: db.select(db.employees).watch(),
            builder: (context, employeesSnapshot) {
              final allEmployees = employeesSnapshot.data ?? [];

              return Column(
                children: [
                  // Unified ERP Header Bar
                  ErpPageHeader(
                    icon: Icons.badge_rounded,
                    title: 'Employee Directory & HR Payroll',
                    subtitle: 'Staff management, role assignments, route mapping & salary disbursement journal',
                    trailing: Wrap(
                      spacing: 12,
                      runSpacing: 8,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Container(
                          height: 40,
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
                            labelStyle: const TextStyle(
                                fontWeight: FontWeight.w600, fontSize: 13),
                            tabs: const [
                              Tab(
                                iconMargin: EdgeInsets.zero,
                                child: Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 14),
                                  child: Row(
                                    children: [
                                      Icon(Icons.people_outline, size: 16),
                                      SizedBox(width: 8),
                                      Text('Employee Directory'),
                                    ],
                                  ),
                                ),
                              ),
                              Tab(
                                iconMargin: EdgeInsets.zero,
                                child: Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 14),
                                  child: Row(
                                    children: [
                                      Icon(Icons.payments_outlined, size: 16),
                                      SizedBox(width: 8),
                                      Text('Salary & Payroll Tracker'),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF0F172A),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 11),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8)),
                          ),
                          icon: const Icon(Icons.person_add_rounded, size: 18),
                          label: const Text('Add Employee',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 13)),
                          onPressed: () => _openAddEditEmployeeDialog(
                              routes: routes),
                        ),
                      ],
                    ),
                  ),

                  // Body Content with TabView
                  Expanded(
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        // Tab 1: Employee Directory
                        _buildDirectoryTab(allEmployees, routeMap, routes),

                        // Tab 2: Salary & Payroll Tracker
                        _buildPayrollTab(allEmployees, db),
                      ],
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildDirectoryTab(
    List<Employee> allEmployees,
    Map<int, Route> routeMap,
    List<Route> routes,
  ) {
    // Compute KPIs
    final totalStaff = allEmployees.length;
    final activeStaff = allEmployees.where((e) => e.isActive).length;
    final salesmanCount =
        allEmployees.where((e) => e.role.toUpperCase() == 'SALESMAN').length;
    final totalMonthlyPayrollPaisa = allEmployees
        .where((e) => e.isActive)
        .fold<int>(0, (acc, e) => acc + e.monthlySalaryPaisa);

    // Filter list
    final query = _searchController.text.toLowerCase().trim();
    final filtered = allEmployees.where((emp) {
      final matchesQuery = query.isEmpty ||
          emp.name.toLowerCase().contains(query) ||
          (emp.phone?.toLowerCase().contains(query) ?? false);

      final matchesRole =
          _roleFilter == 'ALL' || emp.role.toUpperCase() == _roleFilter;

      final matchesStatus = _statusFilter == 'ALL' ||
          (_statusFilter == 'ACTIVE' && emp.isActive) ||
          (_statusFilter == 'INACTIVE' && !emp.isActive);

      return matchesQuery && matchesRole && matchesStatus;
    }).toList();

    return Column(
      children: [
        // KPI Cards Row
        Container(
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
          child: Row(
            children: [
              _buildKpiCard(
                title: 'TOTAL STAFF MEMBERS',
                value: '$totalStaff Staff',
                icon: Icons.groups_rounded,
                color: const Color(0xFF0F172A),
              ),
              const SizedBox(width: 14),
              _buildKpiCard(
                title: 'ACTIVE ON DUTY',
                value: '$activeStaff Active',
                icon: Icons.check_circle_outline,
                color: const Color(0xFF10B981),
              ),
              const SizedBox(width: 14),
              _buildKpiCard(
                title: 'FIELD SALESMEN (DSO)',
                value: '$salesmanCount DSOs',
                icon: Icons.alt_route_rounded,
                color: const Color(0xFF2563EB),
              ),
              const SizedBox(width: 14),
              _buildKpiCard(
                title: 'MONTHLY PAYROLL OBLIGATION',
                value:
                    'Rs. ${_currencyFormat.format(totalMonthlyPayrollPaisa / 100)}',
                icon: Icons.account_balance_wallet_outlined,
                color: const Color(0xFF7C3AED),
              ),
            ],
          ),
        ),

        // Search & Filter Toolbar
        Container(
          margin: const EdgeInsets.fromLTRB(24, 16, 24, 12),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: const Color(0xFFE2E8F0)),
          ),
          child: Row(
            children: [
              Expanded(
                flex: 2,
                child: TextField(
                  controller: _searchController,
                  decoration: const InputDecoration(
                    hintText: 'Search staff by name or phone...',
                    prefixIcon: Icon(Icons.search, size: 20),
                    isDense: true,
                    contentPadding: EdgeInsets.symmetric(vertical: 10),
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (_) => setState(() {}),
                ),
              ),
              const SizedBox(width: 16),
              DropdownButton<String>(
                value: _roleFilter,
                underline: const SizedBox(),
                items: const [
                  DropdownMenuItem(value: 'ALL', child: Text('All Roles')),
                  DropdownMenuItem(value: 'SALESMAN', child: Text('Salesman (DSO)')),
                  DropdownMenuItem(value: 'CASHIER', child: Text('Cashier')),
                  DropdownMenuItem(value: 'SHOP_BOY', child: Text('Shop Boy')),
                  DropdownMenuItem(value: 'MANAGER', child: Text('Manager')),
                ],
                onChanged: (val) {
                  if (val != null) setState(() => _roleFilter = val);
                },
              ),
              const SizedBox(width: 16),
              DropdownButton<String>(
                value: _statusFilter,
                underline: const SizedBox(),
                items: const [
                  DropdownMenuItem(value: 'ALL', child: Text('All Status')),
                  DropdownMenuItem(value: 'ACTIVE', child: Text('Active Staff')),
                  DropdownMenuItem(value: 'INACTIVE', child: Text('Inactive Staff')),
                ],
                onChanged: (val) {
                  if (val != null) setState(() => _statusFilter = val);
                },
              ),
              if (_searchController.text.isNotEmpty ||
                  _roleFilter != 'ALL' ||
                  _statusFilter != 'ACTIVE') ...[
                const SizedBox(width: 12),
                TextButton.icon(
                  icon: const Icon(Icons.clear, size: 16),
                  label: const Text('Reset'),
                  onPressed: () {
                    setState(() {
                      _searchController.clear();
                      _roleFilter = 'ALL';
                      _statusFilter = 'ACTIVE';
                    });
                  },
                ),
              ],
            ],
          ),
        ),

        // Staff Table Card
        Expanded(
          child: Container(
            margin: const EdgeInsets.fromLTRB(24, 0, 24, 20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: Column(
              children: [
                // Table Header
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  color: const Color(0xFFF1F5F9),
                  child: const Row(
                    children: [
                      SizedBox(
                          width: 60,
                          child: Text('ID',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 11,
                                  color: Color(0xFF475569)))),
                      Expanded(
                          flex: 2,
                          child: Text('Staff Member',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 11,
                                  color: Color(0xFF475569)))),
                      SizedBox(
                          width: 140,
                          child: Text('Role',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 11,
                                  color: Color(0xFF475569)))),
                      SizedBox(
                          width: 130,
                          child: Text('Phone',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 11,
                                  color: Color(0xFF475569)))),
                      Expanded(
                          flex: 2,
                          child: Text('Assigned Route',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 11,
                                  color: Color(0xFF475569)))),
                      SizedBox(
                          width: 140,
                          child: Text('Monthly Salary',
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 11,
                                  color: Color(0xFF475569)))),
                      SizedBox(
                          width: 100,
                          child: Center(
                            child: Text('Status',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 11,
                                    color: Color(0xFF475569))),
                          )),
                      SizedBox(
                          width: 160,
                          child: Text('Actions',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 11,
                                  color: Color(0xFF475569)))),
                    ],
                  ),
                ),

                // Table List
                Expanded(
                  child: filtered.isEmpty
                      ? const Center(
                          child: Text(
                            'No staff members match the selected filters.',
                            style: TextStyle(color: Color(0xFF94A3B8)),
                          ),
                        )
                      : ListView.separated(
                          itemCount: filtered.length,
                          separatorBuilder: (_, __) => const Divider(height: 1),
                          itemBuilder: (context, i) {
                            final emp = filtered[i];
                            final assignedRoute = emp.assignedRouteId != null
                                ? routeMap[emp.assignedRouteId]
                                : null;

                            return Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10),
                              color: i % 2 == 0
                                  ? Colors.white
                                  : const Color(0xFFFAFAFA),
                              child: Row(
                                children: [
                                  SizedBox(
                                    width: 60,
                                    child: Text('#EMP-${emp.id}',
                                        style: const TextStyle(
                                            fontSize: 11,
                                            color: Color(0xFF64748B))),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: Row(
                                      children: [
                                        CircleAvatar(
                                          radius: 14,
                                          backgroundColor:
                                              const Color(0xFF0F172A),
                                          child: Text(
                                            emp.name.isNotEmpty
                                                ? emp.name[0].toUpperCase()
                                                : '?',
                                            style: const TextStyle(
                                                fontSize: 12,
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                        Expanded(
                                          child: Text(
                                            emp.name,
                                            style: const TextStyle(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 13,
                                                color: Color(0xFF0F172A)),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    width: 140,
                                    child: _buildRoleBadge(emp.role),
                                  ),
                                  SizedBox(
                                    width: 130,
                                    child: Text(
                                      emp.phone ?? '—',
                                      style: const TextStyle(
                                          fontSize: 12,
                                          color: Color(0xFF475569)),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: assignedRoute != null
                                        ? Row(
                                            children: [
                                              const Icon(
                                                  Icons.alt_route_rounded,
                                                  size: 14,
                                                  color: Color(0xFF2563EB)),
                                              const SizedBox(width: 4),
                                              Flexible(
                                                child: Text(
                                                  '${assignedRoute.name} (${assignedRoute.city})',
                                                  style: const TextStyle(
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color: Color(0xFF1E293B)),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                            ],
                                          )
                                        : const Text('Shop Based',
                                            style: TextStyle(
                                                fontSize: 12,
                                                color: Color(0xFF94A3B8))),
                                  ),
                                  SizedBox(
                                    width: 140,
                                    child: Text(
                                      'Rs. ${_currencyFormat.format(emp.monthlySalaryPaisa / 100)}',
                                      textAlign: TextAlign.right,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 13,
                                          color: Color(0xFF0F172A)),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 100,
                                    child: Center(
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8, vertical: 3),
                                        decoration: BoxDecoration(
                                          color: emp.isActive
                                              ? const Color(0xFFECFDF5)
                                              : const Color(0xFFFEF2F2),
                                          borderRadius:
                                              BorderRadius.circular(6),
                                        ),
                                        child: Text(
                                          emp.isActive ? 'Active' : 'Inactive',
                                          style: TextStyle(
                                            fontSize: 11,
                                            fontWeight: FontWeight.bold,
                                            color: emp.isActive
                                                ? const Color(0xFF059669)
                                                : const Color(0xFFDC2626),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 160,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        IconButton(
                                          icon: const Icon(
                                              Icons.payments_outlined,
                                              size: 18,
                                              color: Color(0xFF10B981)),
                                          tooltip: 'Disburse Salary',
                                          onPressed: () {
                                            setState(() {
                                              _selectedEmployeeForPayroll = emp;
                                              _tabController.animateTo(1);
                                            });
                                          },
                                        ),
                                        IconButton(
                                          icon: const Icon(Icons.edit_outlined,
                                              size: 18,
                                              color: Color(0xFF2563EB)),
                                          tooltip: 'Edit Details',
                                          onPressed: () =>
                                              _openAddEditEmployeeDialog(
                                                  employee: emp,
                                                  routes: routes),
                                        ),
                                        IconButton(
                                          icon: Icon(
                                            emp.isActive
                                                ? Icons.block_outlined
                                                : Icons.check_circle_outline,
                                            size: 18,
                                            color: emp.isActive
                                                ? const Color(0xFFEF4444)
                                                : const Color(0xFF10B981),
                                          ),
                                          tooltip: emp.isActive
                                              ? 'Deactivate Staff'
                                              : 'Reactivate Staff',
                                          onPressed: () =>
                                              _confirmToggleEmployeeStatus(emp),
                                        ),
                                      ],
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
    );
  }

  Widget _buildPayrollTab(List<Employee> allEmployees, AppDatabase db) {
    final activeEmployees = allEmployees.where((e) => e.isActive).toList();

    return StreamBuilder<List<Expense>>(
      stream: (db.select(db.expenses)
            ..where((t) => t.category.equals('PAYROLL') | t.category.equals('SALARY'))
            ..orderBy([(t) => drift.OrderingTerm.desc(t.createdAt)]))
          .watch(),
      builder: (context, snapshot) {
        final salaryExpenses = snapshot.data ?? [];

        // Compute paid this month
        final now = DateTime.now();
        final startOfMonth = DateTime(now.year, now.month, 1);
        final endOfMonth = DateTime(now.year, now.month + 1, 0, 23, 59, 59);

        final paidThisMonthPaisa = salaryExpenses
            .where((exp) =>
                exp.expenseDate.isAfter(startOfMonth) &&
                exp.expenseDate.isBefore(endOfMonth))
            .fold<int>(0, (acc, exp) => acc + exp.amountPaisa);

        final totalCommitmentPaisa = activeEmployees.fold<int>(
            0, (acc, e) => acc + e.monthlySalaryPaisa);

        final pendingPaisa = (totalCommitmentPaisa - paidThisMonthPaisa).clamp(0, totalCommitmentPaisa);

        // Pre-select employee if none selected
        if (_selectedEmployeeForPayroll == null && activeEmployees.isNotEmpty) {
          _selectedEmployeeForPayroll = activeEmployees.first;
        }

        final selectedEmp = _selectedEmployeeForPayroll;
        final baseSalaryRs = selectedEmp != null ? (selectedEmp.monthlySalaryPaisa / 100.0) : 0.0;
        final bonusRs = double.tryParse(_bonusController.text.trim()) ?? 0.0;
        final deductionRs = double.tryParse(_deductionController.text.trim()) ?? 0.0;
        final netPayableRs = (baseSalaryRs + bonusRs - deductionRs).clamp(0.0, 9999999.0);

        return Column(
          children: [
            // KPI Summary Row
            Container(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
              child: Row(
                children: [
                  _buildKpiCard(
                    title: 'MONTHLY PAYROLL BUDGET',
                    value: 'Rs. ${_currencyFormat.format(totalCommitmentPaisa / 100)}',
                    icon: Icons.calendar_month_outlined,
                    color: const Color(0xFF0F172A),
                  ),
                  const SizedBox(width: 14),
                  _buildKpiCard(
                    title: 'DISBURSED THIS MONTH (${_monthFormat.format(now)})',
                    value: 'Rs. ${_currencyFormat.format(paidThisMonthPaisa / 100)}',
                    icon: Icons.check_circle_outline,
                    color: const Color(0xFF10B981),
                  ),
                  const SizedBox(width: 14),
                  _buildKpiCard(
                    title: 'PENDING PAYROLL COMMITMENT',
                    value: 'Rs. ${_currencyFormat.format(pendingPaisa / 100)}',
                    icon: Icons.pending_actions_outlined,
                    color: pendingPaisa > 0
                        ? const Color(0xFFF59E0B)
                        : const Color(0xFF10B981),
                  ),
                ],
              ),
            ),

            // Two Column Layout
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Left Card: Disburse Salary Voucher Form
                  SizedBox(
                    width: 440,
                    child: Container(
                      margin: const EdgeInsets.all(24),
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFFE2E8F0)),
                      ),
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Row(
                              children: [
                                Icon(Icons.payments_rounded,
                                    color: Color(0xFF0F172A)),
                                SizedBox(width: 8),
                                Text(
                                  'Post Salary Voucher',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF0F172A),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),

                            // Employee Selector Dropdown
                            DropdownButtonFormField<Employee>(
                              initialValue: selectedEmp,
                              decoration: const InputDecoration(
                                labelText: 'Select Staff Member *',
                                border: OutlineInputBorder(),
                              ),
                              items: activeEmployees.map((e) {
                                return DropdownMenuItem<Employee>(
                                  value: e,
                                  child: Text(
                                    '${e.name} (${e.role}) — Rs ${_currencyFormat.format(e.monthlySalaryPaisa / 100)}',
                                    style: const TextStyle(fontSize: 13),
                                  ),
                                );
                              }).toList(),
                              onChanged: (emp) {
                                setState(() {
                                  _selectedEmployeeForPayroll = emp;
                                });
                              },
                            ),
                            const SizedBox(height: 12),

                            // Salary Month Selector
                            OutlinedButton.icon(
                              style: OutlinedButton.styleFrom(
                                side: const BorderSide(color: Color(0xFFCBD5E1)),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 12),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8)),
                              ),
                              icon: const Icon(Icons.calendar_today, size: 16),
                              label: Text(
                                'Payroll Month: ${_monthFormat.format(_salaryMonth)}',
                                style: const TextStyle(
                                    fontSize: 12, color: Color(0xFF0F172A)),
                              ),
                              onPressed: () async {
                                final picked = await showDatePicker(
                                  context: context,
                                  initialDate: _salaryMonth,
                                  firstDate: DateTime(2020),
                                  lastDate: DateTime(2050),
                                );
                                if (picked != null) {
                                  setState(() => _salaryMonth = picked);
                                }
                              },
                            ),
                            const SizedBox(height: 14),

                            // Base Salary (Readonly display)
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF8FAFC),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: const Color(0xFFE2E8F0)),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text('Monthly Base Salary:',
                                      style: TextStyle(
                                          fontSize: 13,
                                          color: Color(0xFF475569))),
                                  Text(
                                    'Rs. ${_currencyFormat.format(baseSalaryRs)}',
                                    style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF0F172A)),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 12),

                            // Adjustments: Bonus & Deductions
                            Row(
                              children: [
                                Expanded(
                                  child: TextFormField(
                                    controller: _bonusController,
                                    keyboardType: TextInputType.number,
                                    decoration: const InputDecoration(
                                      labelText: 'Bonus / Incentive (Rs)',
                                      prefixIcon: Icon(Icons.add, size: 16),
                                      border: OutlineInputBorder(),
                                    ),
                                    onChanged: (_) => setState(() {}),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: TextFormField(
                                    controller: _deductionController,
                                    keyboardType: TextInputType.number,
                                    decoration: const InputDecoration(
                                      labelText: 'Deduction / Advance (Rs)',
                                      prefixIcon: Icon(Icons.remove, size: 16),
                                      border: OutlineInputBorder(),
                                    ),
                                    onChanged: (_) => setState(() {}),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),

                            // Payment Mode
                            DropdownButtonFormField<String>(
                              initialValue: _payrollPaymentMode,
                              decoration: const InputDecoration(
                                labelText: 'Payment Mode',
                                border: OutlineInputBorder(),
                              ),
                              items: const [
                                DropdownMenuItem(value: 'CASH', child: Text('Cash')),
                                DropdownMenuItem(
                                    value: 'BANK_TRANSFER',
                                    child: Text('Bank Transfer / Cheque')),
                                DropdownMenuItem(
                                    value: 'CHEQUE',
                                    child: Text('Cheque Slip')),
                              ],
                              onChanged: (val) {
                                if (val != null) {
                                  setState(() => _payrollPaymentMode = val);
                                }
                              },
                            ),
                            const SizedBox(height: 12),

                            // Description & Remarks
                            TextField(
                              controller: _notesController,
                              decoration: const InputDecoration(
                                labelText: 'Remarks / Notes',
                                hintText: 'e.g. Monthly salary with festival bonus',
                                border: OutlineInputBorder(),
                              ),
                            ),
                            const SizedBox(height: 16),

                            // Net Payable Summary
                            Container(
                              padding: const EdgeInsets.all(14),
                              decoration: BoxDecoration(
                                color: const Color(0xFFECFDF5),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: const Color(0xFFA7F3D0)),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text('Net Disbursed Amount:',
                                      style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFF065F46))),
                                  Text(
                                    'Rs. ${_currencyFormat.format(netPayableRs)}',
                                    style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF059669)),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 18),

                            // Disburse Button
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF0F172A),
                                  foregroundColor: Colors.white,
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 14),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8)),
                                ),
                                icon: const Icon(Icons.check_circle_outline,
                                    size: 18),
                                label: const Text('Confirm & Post Salary Voucher',
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold)),
                                onPressed: _disburseSalaryVoucher,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // Right Column: Salary Disbursement Journal
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.fromLTRB(0, 24, 24, 24),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFFE2E8F0)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 12),
                            decoration: const BoxDecoration(
                              border: Border(
                                  bottom: BorderSide(color: Color(0xFFE2E8F0))),
                            ),
                            child: Row(
                              children: [
                                SegmentedButton<int>(
                                  style: ButtonStyle(
                                    visualDensity: VisualDensity.compact,
                                    textStyle: WidgetStateProperty.all(
                                        const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                                  ),
                                  segments: const [
                                    ButtonSegment(
                                      value: 0,
                                      icon: Icon(Icons.people_outline, size: 16),
                                      label: Text('Staff Monthly Balances'),
                                    ),
                                    ButtonSegment(
                                      value: 1,
                                      icon: Icon(Icons.history_rounded, size: 16),
                                      label: Text('Disbursement Journal'),
                                    ),
                                  ],
                                  selected: {_payrollRightViewIndex},
                                  onSelectionChanged: (set) {
                                    setState(() => _payrollRightViewIndex = set.first);
                                  },
                                ),
                                const Spacer(),
                                Text(
                                  _payrollRightViewIndex == 0
                                      ? '${activeEmployees.length} Active Staff'
                                      : '${salaryExpenses.length} Records',
                                  style: const TextStyle(
                                      fontSize: 12,
                                      color: Color(0xFF64748B),
                                      fontWeight: FontWeight.w600),
                                ),
                              ],
                            ),
                          ),

                          if (_payrollRightViewIndex == 0) ...[
                            // View 0: Staff Monthly Entitlement vs Disbursed vs Remaining Balance
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 10),
                              color: const Color(0xFFF1F5F9),
                              child: const Row(
                                children: [
                                  Expanded(
                                      flex: 3,
                                      child: Text('Staff Member & Role',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 11,
                                              color: Color(0xFF475569)))),
                                  Expanded(
                                      flex: 2,
                                      child: Text('Entitlement (Rs)',
                                          textAlign: TextAlign.right,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 11,
                                              color: Color(0xFF475569)))),
                                  Expanded(
                                      flex: 2,
                                      child: Text('Paid This Month',
                                          textAlign: TextAlign.right,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 11,
                                              color: Color(0xFF475569)))),
                                  Expanded(
                                      flex: 2,
                                      child: Text('Balance Due',
                                          textAlign: TextAlign.right,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 11,
                                              color: Color(0xFF475569)))),
                                  SizedBox(
                                      width: 90,
                                      child: Center(
                                        child: Text('Status',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 11,
                                                color: Color(0xFF475569))),
                                      )),
                                  SizedBox(
                                      width: 90,
                                      child: Center(
                                        child: Text('Action',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 11,
                                                color: Color(0xFF475569))),
                                      )),
                                ],
                              ),
                            ),
                            Expanded(
                              child: activeEmployees.isEmpty
                                  ? const Center(
                                      child: Text(
                                        'No active staff registered in employee directory.',
                                        style: TextStyle(color: Color(0xFF94A3B8)),
                                      ),
                                    )
                                  : ListView.separated(
                                      itemCount: activeEmployees.length,
                                      separatorBuilder: (_, __) =>
                                          const Divider(height: 1),
                                      itemBuilder: (context, i) {
                                        final emp = activeEmployees[i];
                                        final empPaidThisMonthPaisa = salaryExpenses
                                            .where((exp) =>
                                                exp.expenseDate.isAfter(startOfMonth) &&
                                                exp.expenseDate.isBefore(endOfMonth) &&
                                                (exp.description?.contains(emp.name) ?? false))
                                            .fold<int>(0, (acc, exp) => acc + exp.amountPaisa);

                                        final remainingPaisa = (emp.monthlySalaryPaisa - empPaidThisMonthPaisa).clamp(0, 999999999);
                                        final isPaid = empPaidThisMonthPaisa >= emp.monthlySalaryPaisa;
                                        final isPartial = empPaidThisMonthPaisa > 0 && !isPaid;
                                        final isSelected = _selectedEmployeeForPayroll?.id == emp.id;

                                        return Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 16, vertical: 10),
                                          color: isSelected
                                              ? const Color(0xFFEFF6FF)
                                              : (i % 2 == 0 ? Colors.white : const Color(0xFFFAFAFA)),
                                          child: Row(
                                            children: [
                                              Expanded(
                                                flex: 3,
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      emp.name,
                                                      style: const TextStyle(
                                                          fontWeight: FontWeight.bold,
                                                          fontSize: 13,
                                                          color: Color(0xFF0F172A)),
                                                    ),
                                                    Text(
                                                      emp.role,
                                                      style: const TextStyle(
                                                          fontSize: 11,
                                                          color: Color(0xFF64748B)),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Expanded(
                                                flex: 2,
                                                child: Text(
                                                  'Rs. ${_currencyFormat.format(emp.monthlySalaryPaisa / 100)}',
                                                  textAlign: TextAlign.right,
                                                  style: const TextStyle(
                                                      fontSize: 12,
                                                      fontWeight: FontWeight.w600,
                                                      color: Color(0xFF0F172A)),
                                                ),
                                              ),
                                              Expanded(
                                                flex: 2,
                                                child: Text(
                                                  'Rs. ${_currencyFormat.format(empPaidThisMonthPaisa / 100)}',
                                                  textAlign: TextAlign.right,
                                                  style: const TextStyle(
                                                      fontSize: 12,
                                                      fontWeight: FontWeight.w600,
                                                      color: Color(0xFF10B981)),
                                                ),
                                              ),
                                              Expanded(
                                                flex: 2,
                                                child: Text(
                                                  'Rs. ${_currencyFormat.format(remainingPaisa / 100)}',
                                                  textAlign: TextAlign.right,
                                                  style: TextStyle(
                                                      fontSize: 12,
                                                      fontWeight: FontWeight.bold,
                                                      color: remainingPaisa > 0
                                                          ? const Color(0xFFDC2626)
                                                          : const Color(0xFF10B981)),
                                                ),
                                              ),
                                              SizedBox(
                                                width: 90,
                                                child: Center(
                                                  child: Container(
                                                    padding: const EdgeInsets.symmetric(
                                                        horizontal: 8, vertical: 3),
                                                    decoration: BoxDecoration(
                                                      color: isPaid
                                                          ? const Color(0xFFECFDF5)
                                                          : (isPartial
                                                              ? const Color(0xFFFFFBEB)
                                                              : const Color(0xFFFEF2F2)),
                                                      borderRadius: BorderRadius.circular(4),
                                                    ),
                                                    child: Text(
                                                      isPaid ? 'PAID' : (isPartial ? 'PARTIAL' : 'PENDING'),
                                                      style: TextStyle(
                                                        fontSize: 10,
                                                        fontWeight: FontWeight.bold,
                                                        color: isPaid
                                                          ? const Color(0xFF059669)
                                                          : (isPartial
                                                              ? const Color(0xFFD97706)
                                                              : const Color(0xFFDC2626)),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                width: 90,
                                                child: Center(
                                                  child: OutlinedButton(
                                                    style: OutlinedButton.styleFrom(
                                                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                                      side: BorderSide(
                                                        color: isSelected
                                                            ? const Color(0xFF1D4ED8)
                                                            : const Color(0xFFCBD5E1),
                                                      ),
                                                      backgroundColor: isSelected
                                                          ? const Color(0xFFEFF6FF)
                                                          : Colors.white,
                                                    ),
                                                    onPressed: () {
                                                      setState(() {
                                                        _selectedEmployeeForPayroll = emp;
                                                      });
                                                    },
                                                    child: Text(
                                                      isSelected ? 'Selected' : 'Disburse',
                                                      style: TextStyle(
                                                        fontSize: 11,
                                                        fontWeight: FontWeight.bold,
                                                        color: isSelected
                                                            ? const Color(0xFF1D4ED8)
                                                            : const Color(0xFF0F172A),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                    ),
                            ),
                          ] else ...[
                            // View 1: Past Salary Disbursement Journal
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 12),
                              color: const Color(0xFFF1F5F9),
                              child: const Row(
                                children: [
                                  SizedBox(
                                      width: 130,
                                      child: Text('Date & Time',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 11,
                                              color: Color(0xFF475569)))),
                                  SizedBox(
                                      width: 90,
                                      child: Text('Mode',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 11,
                                              color: Color(0xFF475569)))),
                                  Expanded(
                                      child: Text('Disbursement Details / Staff',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 11,
                                              color: Color(0xFF475569)))),
                                  SizedBox(
                                      width: 130,
                                      child: Text('Amount (Rs)',
                                          textAlign: TextAlign.right,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 11,
                                              color: Color(0xFF475569)))),
                                  SizedBox(
                                      width: 70,
                                      child: Center(
                                        child: Text('Receipt',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 11,
                                                color: Color(0xFF475569))),
                                      )),
                                ],
                              ),
                            ),
                            Expanded(
                              child: salaryExpenses.isEmpty
                                  ? const Center(
                                      child: Text(
                                        'No salary vouchers recorded yet.',
                                        style: TextStyle(
                                            color: Color(0xFF94A3B8)),
                                      ),
                                    )
                                  : ListView.separated(
                                      itemCount: salaryExpenses.length,
                                      separatorBuilder: (_, __) =>
                                          const Divider(height: 1),
                                      itemBuilder: (context, i) {
                                        final exp = salaryExpenses[i];
                                        return Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 20, vertical: 10),
                                          color: i % 2 == 0
                                              ? Colors.white
                                              : const Color(0xFFFAFAFA),
                                          child: Row(
                                            children: [
                                              SizedBox(
                                                width: 130,
                                                child: Text(
                                                  _dateTimeFormat
                                                      .format(exp.createdAt),
                                                  style: const TextStyle(
                                                      fontSize: 12,
                                                      color: Color(0xFF334155)),
                                                ),
                                              ),
                                              SizedBox(
                                                width: 90,
                                                child: Container(
                                                  padding:
                                                      const EdgeInsets.symmetric(
                                                          horizontal: 6,
                                                          vertical: 2),
                                                  decoration: BoxDecoration(
                                                    color:
                                                        const Color(0xFFF1F5F9),
                                                    borderRadius:
                                                        BorderRadius.circular(4),
                                                  ),
                                                  child: Text(
                                                    exp.paymentMode,
                                                    style: const TextStyle(
                                                        fontSize: 10,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Color(0xFF475569)),
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                child: Text(
                                                  exp.description ??
                                                      'Staff Salary Disbursement',
                                                  style: const TextStyle(
                                                      fontSize: 12,
                                                      fontWeight: FontWeight.w500,
                                                      color: Color(0xFF0F172A)),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                              SizedBox(
                                                width: 130,
                                                child: Text(
                                                  'Rs. ${_currencyFormat.format(exp.amountPaisa / 100)}',
                                                  textAlign: TextAlign.right,
                                                  style: const TextStyle(
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: 13,
                                                      color: Color(0xFF059669)),
                                                ),
                                              ),
                                              SizedBox(
                                                width: 70,
                                                child: Center(
                                                  child: IconButton(
                                                    icon: const Icon(
                                                        Icons.receipt_long,
                                                        size: 18,
                                                        color: Color(0xFF2563EB)),
                                                    tooltip:
                                                        'View Voucher Receipt',
                                                    onPressed: () =>
                                                        _showSalarySlipDialog(exp),
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
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildKpiCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
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
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF64748B),
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    value,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0F172A),
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
