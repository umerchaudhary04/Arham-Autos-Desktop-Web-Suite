import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:file_selector/file_selector.dart';
import 'package:drift/drift.dart' as drift;
import '../../core/db/app_database.dart';
import '../inventory/parts_master_screen.dart'; // Contains dbProvider

class SettingsRecoveryScreen extends ConsumerStatefulWidget {
  const SettingsRecoveryScreen({super.key});

  @override
  ConsumerState<SettingsRecoveryScreen> createState() => _SettingsRecoveryScreenState();
}

class _SettingsRecoveryScreenState extends ConsumerState<SettingsRecoveryScreen> {
  Future<void> _handleBackup() async {
    final String? path = await getDirectoryPath();
    if (path != null) {
      final db = ref.read(dbProvider);
      final timestamp = DateTime.now().toIso8601String().replaceAll(RegExp(r'[:-]'), '').split('.').first.replaceFirst('T', '_');
      final destPath = '$path/ArhamAutos_Backup_$timestamp.bak';
      try {
        await db.backupDatabase(destPath);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Backup successful!')),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Backup failed: $e')),
          );
        }
      }
    }
  }

  Future<void> _handleFactoryReset() async {
    final pinController = TextEditingController();
    final masterKeyController = TextEditingController();

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Factory Reset Verification'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: pinController,
              decoration: const InputDecoration(labelText: 'Manager PIN'),
              obscureText: true,
            ),
            TextField(
              controller: masterKeyController,
              decoration: const InputDecoration(labelText: '16-digit Master Key'),
              obscureText: true,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Verify & Reset'),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      final pin = pinController.text;
      final masterKey = masterKeyController.text;

      if (pin.isEmpty || masterKey.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please enter both PIN and Master Key.')),
        );
        return;
      }

      final db = ref.read(dbProvider);

      try {
        final configRecord = await (db.select(db.systemConfigs)..where((c) => c.key.equals('MASTER_KEY'))).getSingleOrNull();
        if (configRecord == null || configRecord.value != masterKey) {
          throw Exception('Invalid Master Key.');
        }

        final managerUser = await (db.select(db.users)..where((u) => u.role.equals('MANAGER') & u.pinHash.equals(pin))).getSingleOrNull();
        if (managerUser == null) {
          throw Exception('Invalid Manager PIN or user not found.');
        }

        await db.factoryReset();

        await db.into(db.auditLogs).insert(AuditLogsCompanion.insert(
          action: 'DATA_WIPE',
          details: const drift.Value('Factory reset performed'),
          userId: drift.Value(managerUser.id),
        ));

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Factory Reset Successful.')),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Verification failed: $e')),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings & Recovery (Phase 5)'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Card(
                child: ListTile(
                  leading: const Icon(Icons.backup, size: 40),
                  title: const Text('Backup Database'),
                  subtitle: const Text('Generate an encrypted backup (.bak) of the current system data.'),
                  trailing: ElevatedButton(
                    onPressed: _handleBackup,
                    child: const Text('Backup Now'),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Card(
                color: Colors.red.shade50,
                child: ListTile(
                  leading: const Icon(Icons.warning, color: Colors.red, size: 40),
                  title: const Text('Factory Reset', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
                  subtitle: const Text('Wipe all data except audit logs and settings. Requires Manager PIN & Master Key.'),
                  trailing: ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
                    onPressed: _handleFactoryReset,
                    child: const Text('Factory Reset'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
