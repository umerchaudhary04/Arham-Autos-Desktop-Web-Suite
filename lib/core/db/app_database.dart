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
}
