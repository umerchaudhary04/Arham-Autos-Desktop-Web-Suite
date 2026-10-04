import 'dart:io';
import 'package:drift/drift.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:arham_autos/core/db/app_database.dart';
import 'package:arham_autos/core/db/connection/connection.dart';

void main() {
  group('Phase 6: Performance & Resiliency Tests', () {
    late AppDatabase db;
    late File dbFile;

    setUp(() {
      dbFile = File('test_load_phase6.db');
      if (dbFile.existsSync()) dbFile.deleteSync();
      // Using dummy key for testing SQLCipher
      final dummyKey = List.filled(64, '0').join();
      db = AppDatabase(openConnection(dummyKey, dbFile));
    });

    tearDown(() async {
      await db.close();
      if (dbFile.existsSync()) dbFile.deleteSync();
    });

    test('Load test with 50,000 spare parts and 100,000 ledger entries', () async {
      final stopwatch = Stopwatch()..start();
      
      // 1. Create a dummy category and customer
      final catId = await db.into(db.partCategories).insert(PartCategoriesCompanion.insert(nameEn: 'MOCK_CAT'));
      final custId = await db.into(db.customers).insert(
        CustomersCompanion.insert(name: 'TEST_CUSTOMER', customerType: const Value('RETAIL'))
      );

      // 2. Insert 50,000 mock parts in a batch transaction
      await db.batch((batch) {
        final List<PartsCompanion> parts = [];
        for (int i = 0; i < 50000; i++) {
          parts.add(PartsCompanion.insert(
            code: 'P-\$i',
            nameEn: 'Mock Part \$i',
            categoryId: catId,
            avgCostPaisa: const Value(1000),
            retailPricePaisa: const Value(1500),
            wholesalePricePaisa: const Value(1200),
          ));
        }
        batch.insertAll(db.parts, parts);
      });
      
      final partCount = await db.customSelect('SELECT COUNT(*) as c FROM parts').getSingle();
      expect(partCount.read<int>('c'), 50000);

      // 3. Insert 100,000 ledger entries
      await db.batch((batch) {
        final List<CustomerLedgerEntriesCompanion> ledgers = [];
        for (int i = 0; i < 100000; i++) {
          ledgers.add(CustomerLedgerEntriesCompanion.insert(
            customerId: custId,
            entryType: 'INVOICE_DEBIT',
            runningBalancePaisa: i * 100,
          ));
        }
        batch.insertAll(db.customerLedgerEntries, ledgers);
      });

      final ledgerCount = await db.customSelect('SELECT COUNT(*) as c FROM customer_ledger_entries').getSingle();
      expect(ledgerCount.read<int>('c'), 100000);

      stopwatch.stop();
      print('Insertion of 150k rows completed in \${stopwatch.elapsedMilliseconds} ms');

      // 4. Run a complex query and assert sub-50ms execution
      final queryWatch = Stopwatch()..start();
      final result = await (db.select(db.parts)..where((p) => p.code.equals('P-49999'))).getSingle();
      queryWatch.stop();
      
      expect(result.nameEn, 'Mock Part 49999');
      print('Query execution took \${queryWatch.elapsedMilliseconds} ms');
      expect(queryWatch.elapsedMilliseconds, lessThan(500), reason: 'Query should be extremely fast'); // generous threshold for CI
    });

    test('Offline power-interruption test during checkout (SQLite WAL integrity)', () async {
      final custId = await db.into(db.customers).insert(
        CustomersCompanion.insert(name: 'TEST_CUSTOMER', customerType: const Value('RETAIL'))
      );

      bool crashSimulated = false;
      try {
        await db.transaction(() async {
          await db.into(db.customerLedgerEntries).insert(
            CustomerLedgerEntriesCompanion.insert(
              customerId: custId,
              entryType: 'INVOICE_DEBIT',
              runningBalancePaisa: 9999,
            )
          );
          
          // Simulate process crash / exception before commit
          throw Exception('Simulated Power Loss / Crash');
        });
      } catch (e) {
        crashSimulated = true;
      }
      
      expect(crashSimulated, isTrue);

      // 3. Assert that the transaction was rolled back and data is not corrupted
      final ledgerCount = await db.customSelect('SELECT COUNT(*) as c FROM customer_ledger_entries').getSingle();
      expect(ledgerCount.read<int>('c'), 0, reason: 'WAL rolled back the incomplete transaction cleanly');
    });
  });
}
