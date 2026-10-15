import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart' as drift;

import 'core/localization/locale_provider.dart';
import 'core/security/idle_lock_service.dart';
import 'core/db/app_database.dart';
import 'features/about/about_dialog_widget.dart';
import 'features/auth/login_screen.dart';
import 'features/inventory/parts_master_screen.dart';
import 'features/purchases/grn_screen.dart';
import 'features/pos/pos_screen.dart';
import 'features/returns/returns_screen.dart';
import 'features/expenses/expenses_screen.dart';
import 'features/employees/employees_screen.dart';
import 'features/reports/reports_screen.dart';
import 'features/settings/settings_screen.dart';
import 'features/dashboard/executive_dashboard_screen.dart';
import 'features/khata/khata_screen.dart';
import 'features/routes/routes_screen.dart';
import 'l10n/app_localizations.dart';

class AppShell extends ConsumerStatefulWidget {
  final String userRole;
  final String? currentUsername;
  const AppShell({super.key, required this.userRole, this.currentUsername});

  @override
  ConsumerState<AppShell> createState() => _AppShellState();
}

class _AppShellState extends ConsumerState<AppShell> {
  int _selectedIndex = 0;
  IdleLockService? _idleLockService;

  @override
  void initState() {
    super.initState();
    _initIdleLock();
  }

  Future<void> _initIdleLock() async {
    final db = ref.read(dbProvider);
    final minutesStr = await db.getConfig('IDLE_LOCK_MINUTES');
    final minutes = int.tryParse(minutesStr ?? '10') ?? 10;
    if (mounted) {
      setState(() {
        _idleLockService = IdleLockService(
          timeoutMinutes: minutes,
          onLock: _handleAutoLock,
        );
      });
    }
  }

  void _handleAutoLock() async {
    final db = ref.read(dbProvider);
    try {
      await db.into(db.auditLogs).insert(
        AuditLogsCompanion.insert(
          actionType: 'AUTO_LOCK',
          details: 'Session automatically locked due to inactivity timeout',
          usernameSnapshot: drift.Value(widget.currentUsername),
          roleSnapshot: drift.Value(widget.userRole),
        ),
      );
    } catch (_) {}

    if (mounted) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const LoginScreen()),
        (route) => false,
      );
    }
  }

  @override
  void dispose() {
    _idleLockService?.dispose();
    super.dispose();
  }

  Widget _getScreen(int index) {
    if (widget.userRole == 'Operator') {
      // Restricted operator view
      switch (index) {
        case 0:
          return const Center(child: Text('Dashboard (Restricted)'));
        case 1:
          return const PosScreen();
        case 2:
          return const PartsMasterScreen();
        case 3:
          return const ReturnsScreen();
        default:
          return const Center(child: Text('Unauthorized'));
      }
    } else {
      // Manager view
      switch (index) {
        case 0:
          return const ExecutiveDashboardScreen();
        case 1:
          return const PosScreen();
        case 2:
          return const PartsMasterScreen();
        case 3:
          return const GrnScreen();
        case 4:
          return const KhataScreen();
        case 5:
          return const ReturnsScreen();
        case 6:
          return const ExpensesScreen();
        case 7:
          return const EmployeesScreen();
        case 8:
          return const RoutesScreen();
        case 9:
          return const ReportsScreen();
        case 10:
          return const SettingsRecoveryScreen();
        default:
          return const Center(child: Text('Not Found'));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(localeProvider);
    final l10n = AppLocalizations.of(context);

    final managerDestinations = [
      NavigationRailDestination(
          icon: const Icon(Icons.dashboard), label: Text(l10n?.dashboard ?? 'Dashboard')),
      NavigationRailDestination(
          icon: const Icon(Icons.point_of_sale), label: Text(l10n?.posTerminal ?? 'POS Terminal')),
      NavigationRailDestination(
          icon: const Icon(Icons.inventory), label: Text(l10n?.partsCatalog ?? 'Parts Catalog')),
      NavigationRailDestination(
          icon: const Icon(Icons.shopping_cart), label: Text(l10n?.purchasesGrn ?? 'Purchases / GRN')),
      NavigationRailDestination(
          icon: const Icon(Icons.book), label: Text(l10n?.khataLedger ?? 'Khata Ledger')),
      NavigationRailDestination(
          icon: const Icon(Icons.assignment_return), label: Text(l10n?.returnsClaims ?? 'Returns & Claims')),
      NavigationRailDestination(
          icon: const Icon(Icons.money_off), label: Text(l10n?.expenseJournal ?? 'Expense Journal')),
      NavigationRailDestination(
          icon: const Icon(Icons.people), label: Text(l10n?.employeesHr ?? 'Employees & HR')),
      NavigationRailDestination(
          icon: const Icon(Icons.map), label: Text(l10n?.routesAreas ?? 'Routes & Areas')),
      NavigationRailDestination(
          icon: const Icon(Icons.analytics), label: Text(l10n?.reportsAnalytics ?? 'Reports & Analytics')),
      NavigationRailDestination(
          icon: const Icon(Icons.settings), label: Text(l10n?.settingsSecurity ?? 'Settings & Security')),
    ];

    final operatorDestinations = [
      NavigationRailDestination(
          icon: const Icon(Icons.dashboard), label: Text(l10n?.dashboard ?? 'Dashboard')),
      NavigationRailDestination(
          icon: const Icon(Icons.point_of_sale), label: Text(l10n?.posTerminal ?? 'POS Terminal')),
      NavigationRailDestination(
          icon: const Icon(Icons.inventory), label: Text(l10n?.partsCatalog ?? 'Parts Catalog')),
      NavigationRailDestination(
          icon: const Icon(Icons.assignment_return), label: Text(l10n?.returnsClaims ?? 'Returns & Claims')),
    ];

    final destinations = widget.userRole == 'Manager'
        ? managerDestinations
        : operatorDestinations;

    return Listener(
      behavior: HitTestBehavior.translucent,
      onPointerDown: (_) => _idleLockService?.handleUserInteraction(),
      onPointerMove: (_) => _idleLockService?.handleUserInteraction(),
      onPointerSignal: (_) => _idleLockService?.handleUserInteraction(),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Arham Autos — ${widget.userRole}'),
          actions: [
            if (widget.currentUsername != null)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: Center(
                  child: Chip(
                    label: Text(
                      '${widget.currentUsername} (${widget.userRole})',
                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                    ),
                    backgroundColor: const Color(0xFFF1F5F9),
                  ),
                ),
              ),
            IconButton(
              icon: const Icon(Icons.language),
              tooltip: 'Toggle Language',
              onPressed: () {
                final current = ref.read(localeProvider);
                ref.read(localeProvider.notifier).state =
                    current.languageCode == 'en'
                        ? const Locale('ur')
                        : const Locale('en');
              },
            ),
            IconButton(
              icon: const Icon(Icons.info_outline),
              tooltip: 'About',
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => const AboutDialogWidget(),
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.lock_outline),
              tooltip: 'Lock Session / Logout',
              onPressed: () {
                _idleLockService?.dispose();
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (_) => const LoginScreen()),
                  (route) => false,
                );
              },
            ),
          ],
        ),
        body: Row(
          children: [
            NavigationRail(
              selectedIndex: _selectedIndex,
              onDestinationSelected: (int index) {
                setState(() {
                  _selectedIndex = index;
                });
              },
              labelType: NavigationRailLabelType.all,
              destinations: destinations,
              extended: true,
            ),
            const VerticalDivider(thickness: 1, width: 1),
            Expanded(
              child: _getScreen(_selectedIndex),
            ),
          ],
        ),
      ),
    );
  }
}
