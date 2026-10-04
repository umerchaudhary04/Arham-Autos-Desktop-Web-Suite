// App Database (Drift)
import 'package:drift/drift.dart';
import 'tables/users.dart';
import 'tables/system_configs.dart';
import 'tables/all_tables.dart';

part 'app_database.g.dart';

@DriftDatabase(tables: [
  Users,
  SystemConfigs,
  AuditLogs,
  PartCategories,
  Parts,
  StockMovements,
  Customers,
  CustomerLedgerEntries,
  Sales,
  SaleItems,
  Expenses,
  Routes,
  Employees,
  ReturnClaims,
  ReturnClaimItems,
  Suppliers,
  Purchases,
  PurchaseItems,
])
class AppDatabase extends _$AppDatabase {
  AppDatabase(super.e);
  @override
  int get schemaVersion => 1;

  Future<void> backupDatabase(String destinationPath) async {
    await customStatement('VACUUM INTO ?', [destinationPath]);
  }

  Future<void> factoryReset() async {
    await transaction(() async {
      await customStatement('PRAGMA foreign_keys = OFF;');
      
      final tablesToClear = allTables.where((t) => 
        t.actualTableName != 'audit_logs' && 
        t.actualTableName != 'system_configs'
      );
      
      for (final table in tablesToClear) {
        await customStatement('DELETE FROM ${table.actualTableName};');
      }
      
      await customStatement('PRAGMA foreign_keys = ON;');
    });
  }
}
