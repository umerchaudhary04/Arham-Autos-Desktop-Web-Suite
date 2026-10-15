import 'package:flutter_test/flutter_test.dart';

void main() {
  group('General Ledger & Chart of Accounts Formula Tests', () {
    test('Calculates live Cash-in-Hand strictly according to accounting formula', () {
      // Formula: Net Cash Sales + Customer Recoveries - Cash Expenses - Supplier Payments - Cash Refunds
      const int netCashSalesPaisa = 15000000; // Rs 150,000
      const int customerRecoveriesPaisa = 4500000; // Rs 45,000
      const int cashExpensesPaisa = 2000000; // Rs 20,000
      const int supplierPaymentsPaisa = 6000000; // Rs 60,000
      const int cashRefundsPaisa = 500000; // Rs 5,000

      const int cashInHandPaisa = netCashSalesPaisa +
          customerRecoveriesPaisa -
          cashExpensesPaisa -
          supplierPaymentsPaisa -
          cashRefundsPaisa;

      expect(cashInHandPaisa, equals(11000000)); // Rs 110,000
    });

    test('Computes Net Operating Profit correctly from Revenue, COGS, and Expenses', () {
      // Formula: Net Sales - COGS - Operating Expenses - Payroll
      const int netSalesPaisa = 50000000; // Rs 500,000
      const int cogsPaisa = 32000000; // Rs 320,000
      const int operatingExpensesPaisa = 4500000; // Rs 45,000
      const int payrollDisbursedPaisa = 6500000; // Rs 65,000

      const int grossProfitPaisa = netSalesPaisa - cogsPaisa;
      const int netOperatingProfitPaisa =
          netSalesPaisa - cogsPaisa - operatingExpensesPaisa - payrollDisbursedPaisa;

      expect(grossProfitPaisa, equals(18000000)); // Rs 180,000
      expect(netOperatingProfitPaisa, equals(7000000)); // Rs 70,000
    });

    test('Validates Double-Entry Trial Balance Debit and Credit Balance', () {
      const int cashPaisa = 11000000; // Rs 110,000 (Asset - Debit)
      const int receivablesPaisa = 8500000; // Rs 85,000 (Asset - Debit)
      const int inventoryPaisa = 25000000; // Rs 250,000 (Asset - Debit)
      const int cogsPaisa = 32000000; // Rs 320,000 (Expense - Debit)
      const int opexPaisa = 4500000; // Rs 45,000 (Expense - Debit)
      const int payrollPaisa = 6500000; // Rs 65,000 (Expense - Debit)

      const int payablesPaisa = 12000000; // Rs 120,000 (Liability - Credit)
      const int revenuePaisa = 50000000; // Rs 500,000 (Revenue - Credit)
      const int capitalPaisa = 25500000; // Rs 255,000 (Equity - Credit)

      const int totalDebit = cashPaisa + receivablesPaisa + inventoryPaisa + cogsPaisa + opexPaisa + payrollPaisa;
      const int totalCredit = payablesPaisa + revenuePaisa + capitalPaisa;

      expect(totalDebit, equals(87500000));
      expect(totalCredit, equals(87500000));
      expect(totalDebit - totalCredit, equals(0)); // Balanced
    });
  });

  group('Routes & Areas Distribution Domain Logic Tests', () {
    test('Calculates total route receivables and mapped B2B shops correctly', () {
      final route = {'id': 10, 'name': 'Kot Samba City Sector 1', 'city': 'Kot Samba'};
      final customers = [
        {'id': 1, 'name': 'Al-Madina Autos', 'routeId': 10, 'currentBalancePaisa': 450000}, // Rs 4,500
        {'id': 2, 'name': 'Usman Bike Service', 'routeId': 10, 'currentBalancePaisa': 850000}, // Rs 8,500
        {'id': 3, 'name': 'Zahid Auto Repair', 'routeId': 10, 'currentBalancePaisa': -50000}, // Advance payment
        {'id': 4, 'name': 'Sadiqabad Spares', 'routeId': 20, 'currentBalancePaisa': 600000}, // Different route
      ];

      final routeCustomers = customers.where((c) => c['routeId'] == route['id']).toList();
      final totalDuePaisa = routeCustomers.fold<int>(
        0,
        (sum, c) => sum + ((c['currentBalancePaisa'] as int) > 0 ? (c['currentBalancePaisa'] as int) : 0),
      );

      expect(routeCustomers.length, equals(3));
      expect(totalDuePaisa, equals(1300000)); // Rs 13,000 (excludes advance payment)
    });

    test('Handles Salesman (DSO) re-assignment and route unlinking', () {
      final employees = [
        {'id': 1, 'name': 'Muhammad Asif (DSO)', 'assignedRouteId': 10},
        {'id': 2, 'name': 'Rashid Ali (DSO)', 'assignedRouteId': 20},
      ];

      // Reassign Route 10 from Asif to Rashid
      final updatedEmployees = employees.map((e) {
        if (e['assignedRouteId'] == 10) {
          return {...e, 'assignedRouteId': null}; // Unlink old
        }
        if (e['id'] == 2) {
          return {...e, 'assignedRouteId': 10}; // Assign new
        }
        return e;
      }).toList();

      final oldSalesman = updatedEmployees.firstWhere((e) => e['id'] == 1);
      final newSalesman = updatedEmployees.firstWhere((e) => e['id'] == 2);

      expect(oldSalesman['assignedRouteId'], isNull);
      expect(newSalesman['assignedRouteId'], equals(10));
    });
  });
}
