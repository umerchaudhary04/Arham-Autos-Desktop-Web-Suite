import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/db/app_database.dart';
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
import 'package:drift/native.dart';

import 'dart:io';
import 'core/db/connection/connection.dart';

import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void main() {
  final dbFile = File('arham_autos_placeholder.db');
  final dummyKey = List.filled(64, '0').join();
  final db = AppDatabase(openConnection(dummyKey, dbFile));
  
  runApp(
    ProviderScope(
      overrides: [
        dbProvider.overrideWithValue(db),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = ref.watch(localeProvider);
    
    return MaterialApp(
      title: 'Arham Autos',
      locale: locale,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en'),
        Locale('ur'),
      ],
      builder: (context, child) {
        return Directionality(
          textDirection: locale.languageCode == 'ur' ? TextDirection.rtl : TextDirection.ltr,
          child: child!,
        );
      },
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamilyFallback: const ['Noto Nastaliq Urdu'],
        scrollbarTheme: ScrollbarThemeData(
          thumbVisibility: MaterialStateProperty.all(true),
          trackVisibility: MaterialStateProperty.all(true),
          thickness: MaterialStateProperty.all(8.0),
          interactive: true,
        ),
      ),
      home: const DashboardScreen(),
    );
  }
}

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Arham Autos - Dashboard (Phase 2)'),
        actions: [
          IconButton(
            icon: const Icon(Icons.language),
            tooltip: 'Toggle Language',
            onPressed: () {
              final current = ref.read(localeProvider);
              ref.read(localeProvider.notifier).state = 
                  current.languageCode == 'en' ? const Locale('ur') : const Locale('en');
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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const PartsMasterScreen())),
              child: const Text('1. Parts Catalog & Inventory'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const GrnScreen())),
              child: const Text('2. Purchases / GRN'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const BarcodeStudioScreen())),
              child: const Text('3. Barcode Studio'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const PosScreen())),
              child: const Text('4. POS Terminal (Phase 3)'),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ReturnsScreen())),
                  child: const Text('Returns (Phase 4)'),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ExpensesScreen())),
                  child: const Text('Expenses (Phase 4)'),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const EmployeesScreen())),
                  child: const Text('Employees (Phase 4)'),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ReportsScreen())),
                  child: const Text('Reports (Phase 4)'),
                ),
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.orange.shade100),
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SettingsRecoveryScreen())),
              child: const Text('Settings & Recovery (Phase 5)'),
            )
          ],
        ),
      ),
    );
  }
}
