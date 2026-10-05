import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/localization/locale_provider.dart';
import 'features/about/about_dialog_widget.dart';
import 'features/inventory/parts_master_screen.dart';
import 'features/purchases/grn_screen.dart';
import 'features/barcode_studio/barcode_studio_screen.dart';
import 'features/pos/pos_screen.dart';
import 'features/returns/returns_screen.dart';
import 'features/expenses/expenses_screen.dart';
import 'features/employees/employees_screen.dart';
import 'features/reports/reports_screen.dart';
import 'features/settings/settings_screen.dart';
import 'features/dashboard/executive_dashboard_screen.dart';

class AppShell extends ConsumerStatefulWidget {
  final String userRole;
  const AppShell({super.key, required this.userRole});

  @override
  ConsumerState<AppShell> createState() => _AppShellState();
}

class _AppShellState extends ConsumerState<AppShell> {
  int _selectedIndex = 0;

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
          return const Center(child: Text('Khata Ledger'));
        case 5:
          return const ReturnsScreen();
        case 6:
          return const ExpensesScreen();
        case 7:
          return const EmployeesScreen();
        case 8:
          return const Center(child: Text('Routes & Areas'));
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
    final locale = ref.watch(localeProvider);
    final isRtl = locale.languageCode == 'ur';

    final managerDestinations = [
      const NavigationRailDestination(
          icon: Icon(Icons.dashboard), label: Text('Dashboard')),
      const NavigationRailDestination(
          icon: Icon(Icons.point_of_sale), label: Text('POS Terminal')),
      const NavigationRailDestination(
          icon: Icon(Icons.inventory), label: Text('Parts Catalog')),
      const NavigationRailDestination(
          icon: Icon(Icons.shopping_cart), label: Text('Purchases / GRN')),
      const NavigationRailDestination(
          icon: Icon(Icons.book), label: Text('Khata Ledger')),
      const NavigationRailDestination(
          icon: Icon(Icons.assignment_return), label: Text('Returns & Claims')),
      const NavigationRailDestination(
          icon: Icon(Icons.money_off), label: Text('Expense Journal')),
      const NavigationRailDestination(
          icon: Icon(Icons.people), label: Text('Employees & HR')),
      const NavigationRailDestination(
          icon: Icon(Icons.map), label: Text('Routes & Areas')),
      const NavigationRailDestination(
          icon: Icon(Icons.analytics), label: Text('Reports & Analytics')),
      const NavigationRailDestination(
          icon: Icon(Icons.settings), label: Text('Settings & Recovery')),
    ];

    final operatorDestinations = [
      const NavigationRailDestination(
          icon: Icon(Icons.dashboard), label: Text('Dashboard')),
      const NavigationRailDestination(
          icon: Icon(Icons.point_of_sale), label: Text('POS Terminal')),
      const NavigationRailDestination(
          icon: Icon(Icons.inventory), label: Text('Parts Catalog')),
      const NavigationRailDestination(
          icon: Icon(Icons.assignment_return), label: Text('Returns & Claims')),
    ];

    final destinations = widget.userRole == 'Manager'
        ? managerDestinations
        : operatorDestinations;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Arham Autos'),
        actions: [
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
    );
  }
}
