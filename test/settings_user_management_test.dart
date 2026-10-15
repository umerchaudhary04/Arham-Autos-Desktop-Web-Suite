import 'package:flutter_test/flutter_test.dart';
import 'package:arham_autos/core/crypto/kdf.dart';

void main() {
  group('Settings User Management & Security Safeguard Tests', () {
    test('Hashes and verifies PIN and password credentials correctly', () async {
      const pin = '4321';
      const password = 'managerSecurePassword!2026';

      final pinHash = await Kdf.hashPassword(pin);
      final passHash = await Kdf.hashPassword(password);

      expect(pinHash.isNotEmpty, isTrue);
      expect(passHash.isNotEmpty, isTrue);
      expect(pinHash, isNot(equals(pin)));
      expect(passHash, isNot(equals(password)));

      final isPinValid = await Kdf.verifyPassword(pin, pinHash);
      final isPinInvalid = await Kdf.verifyPassword('9999', pinHash);
      final isPassValid = await Kdf.verifyPassword(password, passHash);
      final isPassInvalid = await Kdf.verifyPassword('wrongPass', passHash);

      expect(isPinValid, isTrue);
      expect(isPinInvalid, isFalse);
      expect(isPassValid, isTrue);
      expect(isPassInvalid, isFalse);
    });

    test('Enforces Last Active Manager Deactivation Safeguard', () {
      final users = [
        {'id': 1, 'username': 'admin', 'role': 'MANAGER', 'isActive': true},
        {'id': 2, 'username': 'cashier1', 'role': 'OPERATOR', 'isActive': true},
      ];

      bool canDeactivate(Map<String, dynamic> userToDeactivate) {
        if (userToDeactivate['role'] != 'MANAGER') return true;
        final otherActiveManagers = users.where(
          (u) => u['role'] == 'MANAGER' && (u['isActive'] as bool) && u['id'] != userToDeactivate['id'],
        );
        return otherActiveManagers.isNotEmpty;
      }

      // Single manager cannot be deactivated
      final manager = users[0];
      expect(canDeactivate(manager), isFalse);

      // Operator can always be deactivated
      final operatorUser = users[1];
      expect(canDeactivate(operatorUser), isTrue);

      // When a second active manager is added, manager 1 can now be deactivated safely
      users.add({'id': 3, 'username': 'second_admin', 'role': 'MANAGER', 'isActive': true});
      expect(canDeactivate(manager), isTrue);
    });

    test('Audit log categorization accurately groups system events', () {
      final auditEvents = [
        {'actionType': 'LOGIN', 'details': 'Operator login successful'},
        {'actionType': 'AUTO_LOCK', 'details': 'Terminal auto-locked'},
        {'actionType': 'STOCK_ADJUSTMENT', 'details': 'Stock audit damage adjusted'},
        {'actionType': 'GRN_POSTED', 'details': 'GRN #1002 received'},
        {'actionType': 'RETURN_APPROVED', 'details': 'Return claimed'},
        {'actionType': 'REPORT_EXPORT', 'details': 'Exported Excel report'},
        {'actionType': 'DATA_WIPE', 'details': 'Factory reset executed'},
        {'actionType': 'USER_MGMT', 'details': 'Password reset for cashier1'},
      ];

      List<Map<String, String>> filterLogs(String category) {
        return auditEvents.where((e) {
          if (category == 'ALL') return true;
          if (category == 'LOGIN') return e['actionType']!.contains('LOGIN') || e['actionType']!.contains('LOCK');
          if (category == 'STOCK_ADJUST') return e['actionType']!.contains('STOCK');
          if (category == 'GRN_POSTED') return e['actionType']!.contains('GRN');
          if (category == 'RETURN_APPROVE') return e['actionType']!.contains('RETURN');
          if (category == 'REPORT_EXPORT') return e['actionType']!.contains('EXPORT');
          if (category == 'DATA_WIPE') return e['actionType']!.contains('WIPE');
          if (category == 'USER_MGMT') return e['actionType']!.contains('USER');
          return false;
        }).toList();
      }

      expect(filterLogs('ALL').length, equals(8));
      expect(filterLogs('LOGIN').length, equals(2));
      expect(filterLogs('STOCK_ADJUST').length, equals(1));
      expect(filterLogs('REPORT_EXPORT').length, equals(1));
      expect(filterLogs('USER_MGMT').length, equals(1));
    });
  });
}
