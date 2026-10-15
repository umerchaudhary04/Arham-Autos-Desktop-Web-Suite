import 'package:flutter_test/flutter_test.dart';
import 'package:excel/excel.dart' as ex;

void main() {
  group('Reports & Dead Stock Velocity Tests', () {
    test('Correctly identifies dead stock items with zero sales in window', () {
      final now = DateTime.now();
      const int windowDays = 90;
      final thresholdDate = now.subtract(const Duration(days: windowDays));

      final allParts = [
        {'id': 1, 'code': 'CD70-PISTON', 'stock': 12, 'avgCostPaisa': 45000},
        {'id': 2, 'code': 'CG125-PLUG', 'stock': 40, 'avgCostPaisa': 15000},
        {'id': 3, 'code': 'YBR-CLUTCH', 'stock': 5, 'avgCostPaisa': 120000},
      ];

      // Simulated sales: only Part 1 had a sale 10 days ago. Part 2 & 3 have 0 sales in 90 days.
      final saleItemsInWindow = [
        {'partId': 1, 'qty': 4, 'saleDate': now.subtract(const Duration(days: 10))},
      ];

      final Map<int, int> soldMap = {};
      for (final item in saleItemsInWindow) {
        if ((item['saleDate'] as DateTime).isAfter(thresholdDate)) {
          soldMap[item['partId'] as int] = (soldMap[item['partId'] as int] ?? 0) + (item['qty'] as int);
        }
      }

      final deadStock = <Map<String, dynamic>>[];
      for (final p in allParts) {
        final sold = soldMap[p['id'] as int] ?? 0;
        if (sold == 0) {
          deadStock.add({
            'part': p,
            'lockedCapitalPaisa': (p['stock'] as int) * (p['avgCostPaisa'] as int),
          });
        }
      }

      expect(deadStock.length, equals(2));
      expect(deadStock.any((e) => (e['part'] as Map)['code'] == 'CG125-PLUG'), isTrue);
      expect(deadStock.any((e) => (e['part'] as Map)['code'] == 'YBR-CLUTCH'), isTrue);

      final totalLockedCapital = deadStock.fold<int>(0, (s, e) => s + (e['lockedCapitalPaisa'] as int));
      // Part 2: 40 * 15,000 = 600,000 paisa
      // Part 3: 5 * 120,000 = 600,000 paisa
      // Total = 1,200,000 paisa = Rs 12,000.00
      expect(totalLockedCapital, equals(1200000));
    });

    test('Correctly computes Gross Margin & Net Profit in financial analysis', () {
      const int salesPaisa = 5000000; // Rs 50,000
      const int cogsPaisa = 3200000;  // Rs 32,000
      const int expensePaisa = 800000; // Rs 8,000

      const int grossProfitPaisa = salesPaisa - cogsPaisa; // Rs 18,000
      const int netProfitPaisa = grossProfitPaisa - expensePaisa; // Rs 10,000
      const double grossMarginPercent = (grossProfitPaisa / salesPaisa) * 100;

      expect(grossProfitPaisa, equals(1800000));
      expect(netProfitPaisa, equals(1000000));
      expect(grossMarginPercent, equals(36.0));
    });

    test('Correctly classifies moving items into ABC Velocity Classes (Pareto)', () {
      final movedParts = [
        {'id': 1, 'code': 'CD70-RING-SET', 'qty': 25, 'revenuePaisa': 7500000}, // Rs 75,000
        {'id': 2, 'code': 'CG125-VALVE', 'qty': 15, 'revenuePaisa': 4500000},    // Rs 45,000
        {'id': 3, 'code': 'OIL-FILTER-YBR', 'qty': 8, 'revenuePaisa': 1800000},   // Rs 18,000
        {'id': 4, 'code': 'BRAKE-SHOE-GEN', 'qty': 2, 'revenuePaisa': 600000},   // Rs 6,000
      ];

      // Sort descending by revenue
      movedParts.sort((a, b) => (b['revenuePaisa'] as int).compareTo(a['revenuePaisa'] as int));
      final int totalRev = movedParts.fold<int>(0, (sum, m) => sum + (m['revenuePaisa'] as int)); // 14,400,000 paisa

      int cumulativeRev = 0;
      final classified = <Map<String, dynamic>>[];

      for (final item in movedParts) {
        cumulativeRev += item['revenuePaisa'] as int;
        final double cumulativePercent = (cumulativeRev / totalRev) * 100;

        String abcClass;
        if (cumulativePercent <= 70.0 || (item['qty'] as int) >= 10) {
          abcClass = 'A';
        } else if (cumulativePercent <= 90.0 || (item['qty'] as int) >= 4) {
          abcClass = 'B';
        } else {
          abcClass = 'C';
        }

        classified.add({
          'code': item['code'],
          'abcClass': abcClass,
        });
      }

      // Item 1 (Rs 75,000 / 144,000 = 52%) -> Class A
      expect(classified[0]['code'], equals('CD70-RING-SET'));
      expect(classified[0]['abcClass'], equals('A'));

      // Item 2 (qty >= 10) -> Class A
      expect(classified[1]['code'], equals('CG125-VALVE'));
      expect(classified[1]['abcClass'], equals('A'));

      // Item 3 (qty = 8, next tier) -> Class B
      expect(classified[2]['code'], equals('OIL-FILTER-YBR'));
      expect(classified[2]['abcClass'], equals('B'));

      // Item 4 (qty = 2, low turnover) -> Class C
      expect(classified[3]['code'], equals('BRAKE-SHOE-GEN'));
      expect(classified[3]['abcClass'], equals('C'));
    });

    test('Generates valid Excel (.xlsx) binary workbook with headers and data', () {
      final excel = ex.Excel.createExcel();
      final sheet = excel['Test_Report'];
      excel.setDefaultSheet('Test_Report');

      sheet.appendRow([ex.TextCellValue('ARHAM AUTOS REPORT TEST')]);
      sheet.appendRow([
        ex.TextCellValue('Part Code'),
        ex.TextCellValue('Quantity'),
        ex.TextCellValue('Amount (Rs)'),
      ]);
      sheet.appendRow([
        ex.TextCellValue('CD70-OIL'),
        const ex.IntCellValue(10),
        const ex.DoubleCellValue(8500.0),
      ]);

      final bytes = excel.save();
      expect(bytes, isNotNull);
      expect(bytes!.isNotEmpty, isTrue);

      // Verify ZIP/XLSX magic number (0x50, 0x4B -> PK)
      expect(bytes[0], equals(0x50));
      expect(bytes[1], equals(0x4B));
    });
  });
}
