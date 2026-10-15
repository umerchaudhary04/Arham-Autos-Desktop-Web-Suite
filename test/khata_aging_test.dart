import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Khata FIFO Aging Algorithm Tests', () {
    test('Calculates 0-30, 31-60, and 60+ days overdue buckets accurately with FIFO allocation', () {
      final now = DateTime.now();

      // Simulated customer outstanding balance: Rs 45,000 (4,500,000 paisa)
      const int currentBalancePaisa = 4500000;

      // Invoices in reverse chronological order (newest first):
      final invoices = [
        // 10 days ago: Rs 15,000
        {'amountPaisa': 1500000, 'date': now.subtract(const Duration(days: 10))},
        // 45 days ago: Rs 20,000
        {'amountPaisa': 2000000, 'date': now.subtract(const Duration(days: 45))},
        // 75 days ago: Rs 25,000
        {'amountPaisa': 2500000, 'date': now.subtract(const Duration(days: 75))},
      ];

      int remainingPaisa = currentBalancePaisa;
      int bucket0to30Paisa = 0;
      int bucket31to60Paisa = 0;
      int bucket60PlusPaisa = 0;

      for (final inv in invoices) {
        if (remainingPaisa <= 0) break;
        final debit = inv['amountPaisa'] as int;
        final allocated = debit < remainingPaisa ? debit : remainingPaisa;
        final days = now.difference(inv['date'] as DateTime).inDays;

        if (days <= 30) {
          bucket0to30Paisa += allocated;
        } else if (days <= 60) {
          bucket31to60Paisa += allocated;
        } else {
          bucket60PlusPaisa += allocated;
        }

        remainingPaisa -= allocated;
      }

      if (remainingPaisa > 0) {
        bucket60PlusPaisa += remainingPaisa;
      }

      // Expected allocation of Rs 45,000:
      // - Most recent (10 days): takes 15,000 -> 0-30 bucket = Rs 15,000
      // - Next (45 days): takes 20,000 -> 31-60 bucket = Rs 20,000
      // - Remaining 10,000 comes from 75 days invoice -> 60+ bucket = Rs 10,000
      expect(bucket0to30Paisa, equals(1500000));
      expect(bucket31to60Paisa, equals(2000000));
      expect(bucket60PlusPaisa, equals(1000000));
      expect(bucket0to30Paisa + bucket31to60Paisa + bucket60PlusPaisa, equals(currentBalancePaisa));
    });

    test('Allocates unreferenced/opening debt to 60+ days bucket', () {
      final now = DateTime.now();
      const int currentBalancePaisa = 3000000; // Rs 30,000

      // Only one recent invoice of Rs 10,000; the rest Rs 20,000 is legacy debt
      final invoices = [
        {'amountPaisa': 1000000, 'date': now.subtract(const Duration(days: 5))},
      ];

      int remainingPaisa = currentBalancePaisa;
      int bucket0to30Paisa = 0;
      int bucket31to60Paisa = 0;
      int bucket60PlusPaisa = 0;

      for (final inv in invoices) {
        if (remainingPaisa <= 0) break;
        final debit = inv['amountPaisa'] as int;
        final allocated = debit < remainingPaisa ? debit : remainingPaisa;
        final days = now.difference(inv['date'] as DateTime).inDays;

        if (days <= 30) {
          bucket0to30Paisa += allocated;
        } else if (days <= 60) {
          bucket31to60Paisa += allocated;
        } else {
          bucket60PlusPaisa += allocated;
        }

        remainingPaisa -= allocated;
      }

      if (remainingPaisa > 0) {
        bucket60PlusPaisa += remainingPaisa;
      }

      expect(bucket0to30Paisa, equals(1000000)); // Rs 10,000
      expect(bucket31to60Paisa, equals(0));
      expect(bucket60PlusPaisa, equals(2000000)); // Rs 20,000 legacy/opening balance
      expect(bucket0to30Paisa + bucket31to60Paisa + bucket60PlusPaisa, equals(currentBalancePaisa));
    });
  });
}
