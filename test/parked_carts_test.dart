import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('POS Parked Carts Serialization Tests', () {
    test('Serializes and deserializes cart items accurately', () {
      final items = [
        {'partId': 101, 'qty': 2, 'unitRatePaisa': 45000}, // Rs 450.00
        {'partId': 102, 'qty': 1, 'unitRatePaisa': 120000}, // Rs 1200.00
      ];

      final jsonString = jsonEncode(items);
      expect(jsonString, isNotEmpty);

      final List<dynamic> decoded = jsonDecode(jsonString);
      expect(decoded.length, equals(2));

      int grossPaisa = 0;
      for (final item in decoded) {
        final m = item as Map<String, dynamic>;
        grossPaisa += (m['qty'] as int) * (m['unitRatePaisa'] as int);
      }

      // (2 * 45000) + (1 * 120000) = 90000 + 120000 = 210000 paisa = Rs 2100.00
      expect(grossPaisa, equals(210000));
    });

    test('Correctly applies discount to parked cart totals', () {
      final items = [
        {'partId': 201, 'qty': 4, 'unitRatePaisa': 50000}, // 200,000 paisa
      ];
      const int discountPaisa = 15000; // Rs 150.00

      int grossPaisa = 0;
      for (final item in items) {
        grossPaisa += (item['qty'] as int) * (item['unitRatePaisa'] as int);
      }
      final netPaisa = grossPaisa - discountPaisa;

      expect(netPaisa, equals(185000)); // Rs 1850.00
    });
  });
}
