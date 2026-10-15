import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Employee & HR Payroll Tracker Tests', () {
    test('Calculates active staff monthly payroll commitment correctly', () {
      final staff = [
        {'id': 1, 'name': 'Tariq Mehmood', 'role': 'SALESMAN', 'salaryPaisa': 3500000, 'isActive': true},
        {'id': 2, 'name': 'Bilal Ahmad', 'role': 'CASHIER', 'salaryPaisa': 3000000, 'isActive': true},
        {'id': 3, 'name': 'Ali Raza', 'role': 'SHOP_BOY', 'salaryPaisa': 2000000, 'isActive': true},
        {'id': 4, 'name': 'Former Employee', 'role': 'SALESMAN', 'salaryPaisa': 3000000, 'isActive': false},
      ];

      final activeStaff = staff.where((e) => e['isActive'] as bool).toList();
      final totalMonthlyPayrollPaisa = activeStaff.fold<int>(0, (sum, e) => sum + (e['salaryPaisa'] as int));

      expect(activeStaff.length, equals(3));
      expect(totalMonthlyPayrollPaisa, equals(8500000)); // Rs 85,000
    });

    test('Computes net salary payable with bonus and deduction adjustments', () {
      const double baseSalaryRs = 35000.0;
      const double bonusRs = 5000.0;
      const double deductionRs = 2500.0;

      const double netPayableRs = baseSalaryRs + bonusRs - deductionRs;
      final int amountPaisa = (netPayableRs * 100).toInt();

      expect(netPayableRs, equals(37500.0));
      expect(amountPaisa, equals(3750000));
    });

    test('Computes pending payroll commitment after partial disbursements', () {
      const int totalCommitmentPaisa = 8500000; // Rs 85,000
      final disbursementsThisMonth = [
        {'id': 101, 'category': 'SALARY', 'amountPaisa': 3750000}, // Rs 37,500
        {'id': 102, 'category': 'SALARY', 'amountPaisa': 3000000}, // Rs 30,000
      ];

      final int paidThisMonthPaisa = disbursementsThisMonth.fold<int>(0, (sum, e) => sum + (e['amountPaisa'] as int));
      final int pendingPayrollPaisa = totalCommitmentPaisa - paidThisMonthPaisa;

      expect(paidThisMonthPaisa, equals(6750000)); // Rs 67,500
      expect(pendingPayrollPaisa, equals(1750000)); // Rs 17,500
    });
  });
}
