import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/db/app_database.dart';
import 'features/inventory/parts_master_screen.dart';
import 'features/purchases/grn_screen.dart';
import 'features/barcode_studio/barcode_studio_screen.dart';
import 'package:drift/native.dart';

void main() {
  // Use in-memory db for testing UI quickly
  final db = AppDatabase(NativeDatabase.memory());
  
  runApp(
    ProviderScope(
      overrides: [
        dbProvider.overrideWithValue(db),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Arham Autos',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const DashboardScreen(),
    );
  }
}

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Arham Autos - Dashboard (Phase 2)')),
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
          ],
        ),
      ),
    );
  }
}
