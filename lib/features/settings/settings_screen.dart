import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:file_selector/file_selector.dart';
import 'package:drift/drift.dart' as drift;
import 'package:intl/intl.dart';

import '../../core/db/app_database.dart';
import '../../core/crypto/kdf.dart';
import '../../core/widgets/erp_page_header.dart';
import '../inventory/parts_master_screen.dart'; // Contains dbProvider

class SettingsRecoveryScreen extends ConsumerStatefulWidget {
  const SettingsRecoveryScreen({super.key});

  @override
  ConsumerState<SettingsRecoveryScreen> createState() => _SettingsRecoveryScreenState();
}

class _SettingsRecoveryScreenState extends ConsumerState<SettingsRecoveryScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  int _idleLockMinutes = 10;
  String _printMode = 'LASER_A5'; // 'LASER_A5', 'THERMAL_80MM', 'THERMAL_58MM'
  bool _isLoadingPreferences = true;

  // Audit Logs Tab State
  final TextEditingController _auditSearchController = TextEditingController();
  String _selectedAuditAction = 'ALL';

  final DateFormat _dateFormat = DateFormat('yyyy-MM-dd HH:mm:ss');

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadPreferences();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _auditSearchController.dispose();
    super.dispose();
  }

  Future<void> _loadPreferences() async {
    final db = ref.read(dbProvider);
    final lockVal = await db.getConfig('IDLE_LOCK_MINUTES');
    final printVal = await db.getConfig('DEFAULT_PRINT_FORMAT') ?? await db.getConfig('PRINT_MODE');

    if (mounted) {
      setState(() {
        _idleLockMinutes = int.tryParse(lockVal ?? '10') ?? 10;
        _printMode = (printVal == 'A5_2UP' ? 'LASER_A5' : printVal) ?? 'LASER_A5';
        _isLoadingPreferences = false;
      });
    }
  }

  Future<void> _updateIdleLockMinutes(int minutes) async {
    final db = ref.read(dbProvider);
    await db.setConfig('IDLE_LOCK_MINUTES', '$minutes');
    try {
      await db.into(db.auditLogs).insert(
        AuditLogsCompanion.insert(
          actionType: 'CONFIG_CHANGED',
          details: 'Idle auto-lock timeout updated to $minutes minutes',
        ),
      );
    } catch (_) {}

    if (mounted) {
      setState(() => _idleLockMinutes = minutes);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Auto-lock timeout set to $minutes minutes.')),
      );
    }
  }

  Future<void> _updatePrintMode(String mode) async {
    final db = ref.read(dbProvider);
    await db.setConfig('PRINT_MODE', mode);
    await db.setConfig('DEFAULT_PRINT_FORMAT', mode);
    try {
      await db.into(db.auditLogs).insert(
        AuditLogsCompanion.insert(
          actionType: 'CONFIG_CHANGED',
          details: 'Default invoice print profile set to $mode',
        ),
      );
    } catch (_) {}

    String label;
    switch (mode) {
      case 'THERMAL_80MM':
        label = '80mm Continuous Thermal Receipt';
        break;
      case 'THERMAL_58MM':
        label = '58mm Compact Thermal Receipt';
        break;
      case 'LASER_A5':
      case 'A5_2UP':
      default:
        label = '2-Up Half-Page A4/A5 Laser';
        break;
    }

    if (mounted) {
      setState(() => _printMode = mode);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Print profile updated to $label'),
          backgroundColor: Colors.green.shade800,
        ),
      );
    }
  }

  Future<void> _handleBackup() async {
    final String? path = await getDirectoryPath();
    if (path != null) {
      final db = ref.read(dbProvider);
      final timestamp = DateTime.now().toIso8601String().replaceAll(RegExp(r'[:-]'), '').split('.').first.replaceFirst('T', '_');
      final destPath = '$path/ArhamAutos_Backup_$timestamp.bak';
      try {
        await db.backupDatabase(destPath);
        await db.into(db.auditLogs).insert(
          AuditLogsCompanion.insert(
            actionType: 'BACKUP_CREATED',
            details: 'Encrypted backup exported to $destPath',
          ),
        );
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Backup successful: $destPath'),
              backgroundColor: Colors.green.shade800,
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Backup failed: $e'), backgroundColor: Colors.red),
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
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Verify & Reset'),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      final pin = pinController.text.trim();
      final masterKey = masterKeyController.text.trim();

      if (pin.isEmpty || masterKey.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please enter both PIN and Master Key.')),
        );
        return;
      }

      final db = ref.read(dbProvider);

      try {
        bool isMasterKeyValid = false;
        final hashConfig = await db.getConfig('MASTER_KEY_HASH');
        if (hashConfig != null) {
          isMasterKeyValid = await Kdf.verifyPassword(masterKey, hashConfig);
        }
        if (!isMasterKeyValid) {
          final plainConfig = await db.getConfig('MASTER_KEY');
          isMasterKeyValid = plainConfig == masterKey;
        }

        if (!isMasterKeyValid) {
          throw Exception('Invalid 16-digit Master Security Key.');
        }

        final managers = await (db.select(db.users)..where((u) => u.role.equals('MANAGER'))).get();
        User? verifiedManager;
        for (final m in managers) {
          bool isPinValid = false;
          if (m.pinHash.isNotEmpty) {
            isPinValid = await Kdf.verifyPassword(pin, m.pinHash);
          }
          if (!isPinValid && m.pinHash == pin) {
            isPinValid = true;
          }
          if (isPinValid) {
            verifiedManager = m;
            break;
          }
        }

        if (verifiedManager == null) {
          throw Exception('Invalid Manager PIN.');
        }

        await db.factoryReset();

        await db.into(db.auditLogs).insert(AuditLogsCompanion.insert(
          actionType: 'DATA_WIPE',
          details: 'Factory reset performed by ${verifiedManager.username}',
          userId: drift.Value(verifiedManager.id),
        ));

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Factory Reset Successful. Non-audit data cleared.')),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Verification failed: $e'), backgroundColor: Colors.red),
          );
        }
      }
    }
  }

  // ==========================================
  // USER MANAGEMENT ACTIONS & SAFEGUARDS (ITEM 19)
  // ==========================================
  Future<bool> _canDeactivateOrDemote(User user) async {
    if (user.role != 'MANAGER') return true;
    final db = ref.read(dbProvider);
    final otherActiveManagers = await (db.select(db.users)
          ..where((u) => u.role.equals('MANAGER') & u.isActive.equals(true) & u.id.equals(user.id).not()))
        .get();
    return otherActiveManagers.isNotEmpty;
  }

  Future<void> _toggleUserActiveStatus(User user, bool newStatus) async {
    if (!newStatus) {
      final canDeactivate = await _canDeactivateOrDemote(user);
      if (!canDeactivate) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Security Safeguard: Cannot deactivate the last active Manager account!'),
              backgroundColor: Color(0xFFDC2626),
            ),
          );
        }
        return;
      }
    }

    final db = ref.read(dbProvider);
    await (db.update(db.users)..where((u) => u.id.equals(user.id))).write(
      UsersCompanion(
        isActive: drift.Value(newStatus),
        updatedAt: drift.Value(DateTime.now()),
      ),
    );

    await db.into(db.auditLogs).insert(
      AuditLogsCompanion.insert(
        actionType: 'USER_MGMT',
        details: 'User ${user.username} ${newStatus ? 'activated' : 'deactivated'} by administrator',
      ),
    );

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('User "${user.username}" ${newStatus ? 'activated' : 'deactivated'}'),
          backgroundColor: newStatus ? Colors.green.shade800 : Colors.orange.shade800,
        ),
      );
    }
  }

  Future<void> _openResetCredentialsDialog(User user) async {
    final pinCtrl = TextEditingController();
    final passCtrl = TextEditingController();
    final formKey = GlobalKey<FormState>();

    final result = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Row(
          children: [
            const Icon(Icons.lock_reset, color: Color(0xFF0F172A)),
            const SizedBox(width: 8),
            Expanded(child: Text('Reset Credentials: ${user.username}')),
          ],
        ),
        content: SizedBox(
          width: 400,
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Set a new 4–6 digit PIN and/or password for ${user.displayName ?? user.username} (${user.role}):',
                  style: const TextStyle(fontSize: 13, color: Color(0xFF64748B)),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: pinCtrl,
                  decoration: const InputDecoration(
                    labelText: 'New 4-6 Digit PIN',
                    hintText: 'e.g. 1234',
                    prefixIcon: Icon(Icons.dialpad_outlined),
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  obscureText: true,
                  validator: (v) {
                    if (v != null && v.isNotEmpty && (v.length < 4 || v.length > 6)) {
                      return 'PIN must be between 4 and 6 digits';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: passCtrl,
                  decoration: const InputDecoration(
                    labelText: 'New Password',
                    hintText: 'At least 4 characters',
                    prefixIcon: Icon(Icons.password_outlined),
                    border: OutlineInputBorder(),
                  ),
                  obscureText: true,
                  validator: (v) {
                    if (v != null && v.isNotEmpty && v.length < 4) {
                      return 'Password must be at least 4 characters';
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF0F172A), foregroundColor: Colors.white),
            onPressed: () async {
              if (!formKey.currentState!.validate()) return;
              if (pinCtrl.text.trim().isEmpty && passCtrl.text.trim().isEmpty) {
                ScaffoldMessenger.of(ctx).showSnackBar(const SnackBar(content: Text('Please enter a new PIN or Password')));
                return;
              }

              final db = ref.read(dbProvider);
              final UsersCompanion companion = UsersCompanion(
                updatedAt: drift.Value(DateTime.now()),
                pinHash: pinCtrl.text.trim().isNotEmpty
                    ? drift.Value(await Kdf.hashPassword(pinCtrl.text.trim()))
                    : const drift.Value.absent(),
                passwordHash: passCtrl.text.trim().isNotEmpty
                    ? drift.Value(await Kdf.hashPassword(passCtrl.text.trim()))
                    : const drift.Value.absent(),
              );

              await (db.update(db.users)..where((u) => u.id.equals(user.id))).write(companion);

              await db.into(db.auditLogs).insert(
                AuditLogsCompanion.insert(
                  actionType: 'USER_MGMT',
                  details: 'Credentials reset for user ${user.username} by administrator',
                ),
              );

              if (ctx.mounted) Navigator.pop(ctx, true);
            },
            child: const Text('Save Credentials'),
          ),
        ],
      ),
    );

    if (result == true && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Credentials for "${user.username}" reset successfully'), backgroundColor: Colors.green.shade800),
      );
    }
  }

  Future<void> _openUserDialog([User? user]) async {
    final isEdit = user != null;
    final usernameCtrl = TextEditingController(text: user?.username ?? '');
    final displayNameCtrl = TextEditingController(text: user?.displayName ?? '');
    final pinCtrl = TextEditingController();
    final passCtrl = TextEditingController();
    String role = user?.role ?? 'OPERATOR';
    bool isActive = user?.isActive ?? true;
    final formKey = GlobalKey<FormState>();

    final saved = await showDialog<bool>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Text(isEdit ? 'Edit System User: ${user.username}' : 'Add New System User'),
          content: SizedBox(
            width: 440,
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: usernameCtrl,
                    enabled: !isEdit,
                    decoration: const InputDecoration(
                      labelText: 'Username *',
                      prefixIcon: Icon(Icons.account_circle_outlined),
                      border: OutlineInputBorder(),
                    ),
                    validator: (v) {
                      if (v == null || v.trim().length < 3) return 'Username must be at least 3 characters';
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: displayNameCtrl,
                    decoration: const InputDecoration(
                      labelText: 'Full / Display Name',
                      prefixIcon: Icon(Icons.badge_outlined),
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    decoration: const InputDecoration(labelText: 'User Role', border: OutlineInputBorder()),
                    value: role,
                    items: const [
                      DropdownMenuItem(value: 'MANAGER', child: Text('Manager (Full Admin Access)')),
                      DropdownMenuItem(value: 'OPERATOR', child: Text('Operator (POS & Lookup Only)')),
                    ],
                    onChanged: (v) => setDialogState(() => role = v ?? 'OPERATOR'),
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: pinCtrl,
                    decoration: InputDecoration(
                      labelText: isEdit ? 'Change 4-6 Digit PIN (Leave blank to keep)' : '4-6 Digit PIN *',
                      prefixIcon: const Icon(Icons.dialpad_outlined),
                      border: const OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    obscureText: true,
                    validator: (v) {
                      if (!isEdit && (v == null || v.trim().length < 4 || v.trim().length > 6)) {
                        return 'PIN must be between 4 and 6 digits';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: passCtrl,
                    decoration: InputDecoration(
                      labelText: isEdit ? 'Change Password (Leave blank to keep)' : 'Password *',
                      prefixIcon: const Icon(Icons.lock_outline),
                      border: const OutlineInputBorder(),
                    ),
                    obscureText: true,
                    validator: (v) {
                      if (!isEdit && (v == null || v.trim().length < 4)) {
                        return 'Password must be at least 4 characters';
                      }
                      return null;
                    },
                  ),
                  if (isEdit) ...[
                    const SizedBox(height: 8),
                    SwitchListTile(
                      title: const Text('Account Active', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                      value: isActive,
                      onChanged: (v) => setDialogState(() => isActive = v),
                    ),
                  ],
                ],
              ),
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF0F172A), foregroundColor: Colors.white),
              onPressed: () async {
                if (!formKey.currentState!.validate()) return;
                final db = ref.read(dbProvider);

                if (!isEdit) {
                  final pinHash = await Kdf.hashPassword(pinCtrl.text.trim());
                  final passHash = await Kdf.hashPassword(passCtrl.text.trim());

                  await db.into(db.users).insert(
                    UsersCompanion(
                      username: drift.Value(usernameCtrl.text.trim().toLowerCase()),
                      displayName: drift.Value(displayNameCtrl.text.trim().isEmpty ? null : displayNameCtrl.text.trim()),
                      role: drift.Value(role),
                      pinHash: drift.Value(pinHash),
                      passwordHash: drift.Value(passHash),
                      isActive: const drift.Value(true),
                    ),
                  );

                  await db.into(db.auditLogs).insert(
                    AuditLogsCompanion.insert(
                      actionType: 'USER_MGMT',
                      details: 'User ${usernameCtrl.text.trim()} created with role $role',
                    ),
                  );
                } else {
                  // Safeguard: check if changing manager role or deactivating
                  if (user.role == 'MANAGER' && (role != 'MANAGER' || !isActive)) {
                    final canChange = await _canDeactivateOrDemote(user);
                    if (!canChange) {
                      if (ctx.mounted) {
                        ScaffoldMessenger.of(ctx).showSnackBar(
                          const SnackBar(
                            content: Text('Cannot demote or deactivate the last active Manager account!'),
                            backgroundColor: Color(0xFFDC2626),
                          ),
                        );
                      }
                      return;
                    }
                  }

                  final companion = UsersCompanion(
                    displayName: drift.Value(displayNameCtrl.text.trim().isEmpty ? null : displayNameCtrl.text.trim()),
                    role: drift.Value(role),
                    isActive: drift.Value(isActive),
                    pinHash: pinCtrl.text.trim().isNotEmpty
                        ? drift.Value(await Kdf.hashPassword(pinCtrl.text.trim()))
                        : const drift.Value.absent(),
                    passwordHash: passCtrl.text.trim().isNotEmpty
                        ? drift.Value(await Kdf.hashPassword(passCtrl.text.trim()))
                        : const drift.Value.absent(),
                    updatedAt: drift.Value(DateTime.now()),
                  );

                  await (db.update(db.users)..where((u) => u.id.equals(user.id))).write(companion);

                  await db.into(db.auditLogs).insert(
                    AuditLogsCompanion.insert(
                      actionType: 'USER_MGMT',
                      details: 'User ${user.username} updated (Role: $role, Active: $isActive)',
                    ),
                  );
                }

                if (ctx.mounted) Navigator.pop(ctx, true);
              },
              child: Text(isEdit ? 'Save Changes' : 'Create User'),
            ),
          ],
        ),
      ),
    );

    if (saved == true && mounted) {
      setState(() {});
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(isEdit ? 'User updated successfully' : 'User created successfully'), backgroundColor: Colors.green.shade800),
      );
    }
  }

  // ==========================================
  // AUDIT LOG HELPER: COLOR BADGES
  // ==========================================
  Color _getAuditBadgeColor(String actionType) {
    if (actionType.contains('LOGIN') || actionType.contains('LOCK')) {
      return const Color(0xFF16A34A); // Green
    }
    if (actionType.contains('STOCK') || actionType.contains('ADJUST')) {
      return const Color(0xFFD97706); // Amber
    }
    if (actionType.contains('GRN') || actionType.contains('PURCHASE')) {
      return const Color(0xFF4F46E5); // Indigo
    }
    if (actionType.contains('RETURN')) {
      return const Color(0xFF0D9488); // Teal
    }
    if (actionType.contains('EXPORT') || actionType.contains('REPORT')) {
      return const Color(0xFF2563EB); // Blue
    }
    if (actionType.contains('WIPE') || actionType.contains('RESET') || actionType.contains('PURGE')) {
      return const Color(0xFFDC2626); // Red
    }
    if (actionType.contains('USER') || actionType.contains('CONFIG')) {
      return const Color(0xFF7C3AED); // Purple
    }
    return const Color(0xFF0F172A); // Dark Slate
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: Column(
        children: [
          // Unified ERP Header Bar
          ErpPageHeader(
            icon: Icons.admin_panel_settings_rounded,
            title: 'Settings, Users & Security',
            subtitle: 'User accounts, security safeguards, print engine defaults & immutable audit trail',
            trailing: Container(
              height: 40,
              decoration: BoxDecoration(
                color: const Color(0xFFF1F5F9),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0xFFCBD5E1)),
              ),
              child: TabBar(
                controller: _tabController,
                isScrollable: true,
                indicator: BoxDecoration(
                  color: const Color(0xFF0F172A),
                  borderRadius: BorderRadius.circular(6),
                ),
                labelColor: Colors.white,
                unselectedLabelColor: const Color(0xFF475569),
                labelStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                indicatorSize: TabBarIndicatorSize.tab,
                tabs: const [
                  Tab(text: 'Preferences & User Management'),
                  Tab(text: 'Audit Trail & System Logs'),
                ],
              ),
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildPreferencesAndUsersTab(),
                _buildAuditLogsTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================
  // TAB 1: PREFERENCES & USER MANAGEMENT (ITEM 19)
  // ==========================================
  Widget _buildPreferencesAndUsersTab() {
    final db = ref.watch(dbProvider);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 960),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Hardware Profiles & Terminal Preferences',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
              ),
              const SizedBox(height: 14),

              // Card 1: Dual-Print Engine (Item 28)
              Card(
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: const BorderSide(color: Color(0xFFE2E8F0)),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Row(
                    children: [
                      const CircleAvatar(
                        backgroundColor: Color(0xFFEFF6FF),
                        foregroundColor: Color(0xFF1D4ED8),
                        child: Icon(Icons.print_outlined),
                      ),
                      const SizedBox(width: 16),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Invoice Print Profile (Dual-Engine)',
                              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                            ),
                            SizedBox(height: 4),
                            Text(
                              'Switch between standard 2-Up Half-Page A4 laser layout, 80mm continuous thermal receipts, and 58mm compact slips.',
                              style: TextStyle(fontSize: 12, color: Color(0xFF64748B)),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      _isLoadingPreferences
                          ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 2))
                          : DropdownButton<String>(
                              value: _printMode,
                              items: const [
                                DropdownMenuItem(value: 'LASER_A5', child: Text('2-Up Half-Page A4/A5 Laser')),
                                DropdownMenuItem(value: 'THERMAL_80MM', child: Text('80mm Thermal Receipt Slip')),
                                DropdownMenuItem(value: 'THERMAL_58MM', child: Text('58mm Compact Thermal Receipt')),
                              ],
                              onChanged: (val) {
                                if (val != null) _updatePrintMode(val);
                              },
                            ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // Card 2: Terminal Inactivity Auto-Lock
              Card(
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: const BorderSide(color: Color(0xFFE2E8F0)),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Row(
                    children: [
                      const CircleAvatar(
                        backgroundColor: Color(0xFFF1F5F9),
                        foregroundColor: Color(0xFF0F172A),
                        child: Icon(Icons.timer_outlined),
                      ),
                      const SizedBox(width: 16),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Terminal Inactivity Auto-Lock',
                              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                            ),
                            SizedBox(height: 4),
                            Text(
                              'Automatically lock terminal session back to login screen upon keyboard/mouse inactivity.',
                              style: TextStyle(fontSize: 12, color: Color(0xFF64748B)),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      _isLoadingPreferences
                          ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 2))
                          : DropdownButton<int>(
                              value: _idleLockMinutes,
                              items: const [
                                DropdownMenuItem(value: 5, child: Text('5 Minutes')),
                                DropdownMenuItem(value: 10, child: Text('10 Minutes')),
                                DropdownMenuItem(value: 15, child: Text('15 Minutes')),
                                DropdownMenuItem(value: 30, child: Text('30 Minutes')),
                              ],
                              onChanged: (val) {
                                if (val != null) _updateIdleLockMinutes(val);
                              },
                            ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Section 2: User Management (Item 19)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'User Management (Managers & Operators)',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                      ),
                      Text(
                        'Manage staff credentials, role-based privileges, and account activations.',
                        style: TextStyle(fontSize: 12, color: Color(0xFF64748B)),
                      ),
                    ],
                  ),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0F172A),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    icon: const Icon(Icons.person_add, size: 16),
                    label: const Text('Add User', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                    onPressed: () => _openUserDialog(),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Users List Card
              Card(
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: const BorderSide(color: Color(0xFFE2E8F0)),
                ),
                child: StreamBuilder<List<User>>(
                  stream: db.select(db.users).watch(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) return const Padding(padding: EdgeInsets.all(20), child: Center(child: CircularProgressIndicator()));
                    final users = snapshot.data!;

                    return ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: users.length,
                      separatorBuilder: (_, __) => const Divider(height: 1, color: Color(0xFFF1F5F9)),
                      itemBuilder: (context, i) {
                        final u = users[i];
                        final isManager = u.role == 'MANAGER';

                        return Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          child: Row(
                            children: [
                              CircleAvatar(
                                radius: 20,
                                backgroundColor: isManager ? const Color(0xFF0F172A) : const Color(0xFFF1F5F9),
                                child: Icon(isManager ? Icons.security : Icons.person, color: isManager ? Colors.white : const Color(0xFF475569), size: 18),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                flex: 3,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Text(u.displayName ?? u.username, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFF0F172A))),
                                        const SizedBox(width: 8),
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                          decoration: BoxDecoration(
                                            color: isManager ? const Color(0xFFEFF6FF) : const Color(0xFFF1F5F9),
                                            borderRadius: BorderRadius.circular(4),
                                            border: Border.all(color: isManager ? const Color(0xFF93C5FD) : const Color(0xFFCBD5E1)),
                                          ),
                                          child: Text(
                                            u.role,
                                            style: TextStyle(
                                              fontSize: 10,
                                              fontWeight: FontWeight.bold,
                                              color: isManager ? const Color(0xFF1D4ED8) : const Color(0xFF475569),
                                            ),
                                          ),
                                        ),
                                        if (!u.isActive) ...[
                                          const SizedBox(width: 8),
                                          Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                            decoration: BoxDecoration(color: const Color(0xFFFEF2F2), borderRadius: BorderRadius.circular(4), border: Border.all(color: const Color(0xFFFCA5A5))),
                                            child: const Text('DEACTIVATED', style: TextStyle(color: Color(0xFFDC2626), fontSize: 9, fontWeight: FontWeight.bold)),
                                          ),
                                        ],
                                      ],
                                    ),
                                    const SizedBox(height: 2),
                                    Text('Username: ${u.username} • Created: ${_dateFormat.format(u.createdAt)}', style: const TextStyle(fontSize: 11, color: Color(0xFF64748B))),
                                  ],
                                ),
                              ),
                              // Active / Inactive Switch with last manager safeguard
                              Row(
                                children: [
                                  Text(u.isActive ? 'Active' : 'Inactive', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: u.isActive ? const Color(0xFF16A34A) : const Color(0xFF94A3B8))),
                                  Switch(
                                    value: u.isActive,
                                    activeColor: const Color(0xFF16A34A),
                                    onChanged: (val) => _toggleUserActiveStatus(u, val),
                                  ),
                                ],
                              ),
                              const SizedBox(width: 8),
                              // Reset PIN / Password Button
                              OutlinedButton.icon(
                                style: OutlinedButton.styleFrom(
                                  side: const BorderSide(color: Color(0xFFCBD5E1)),
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                                ),
                                icon: const Icon(Icons.lock_reset, size: 14),
                                label: const Text('Reset PIN / Pass', style: TextStyle(fontSize: 11)),
                                onPressed: () => _openResetCredentialsDialog(u),
                              ),
                              const SizedBox(width: 8),
                              // Edit User Button
                              OutlinedButton.icon(
                                style: OutlinedButton.styleFrom(
                                  side: const BorderSide(color: Color(0xFFCBD5E1)),
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                                ),
                                icon: const Icon(Icons.edit, size: 14),
                                label: const Text('Edit', style: TextStyle(fontSize: 11)),
                                onPressed: () => _openUserDialog(u),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
              const SizedBox(height: 24),

              // Section 3: Maintenance & Audits (Item 20)
              const Text(
                'Data Maintenance & Recovery',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
              ),
              const SizedBox(height: 12),

              // Card: Encrypted Backup
              Card(
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: const BorderSide(color: Color(0xFFE2E8F0)),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Row(
                    children: [
                      const CircleAvatar(
                        backgroundColor: Color(0xFFEFF6FF),
                        foregroundColor: Color(0xFF1D4ED8),
                        child: Icon(Icons.backup_outlined),
                      ),
                      const SizedBox(width: 16),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Encrypted Database Backup (.bak)',
                              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                            ),
                            SizedBox(height: 4),
                            Text(
                              'Export an AES-256 encrypted snapshot of the database via SQLite VACUUM INTO.',
                              style: TextStyle(fontSize: 12, color: Color(0xFF64748B)),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF0F172A),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                        onPressed: _handleBackup,
                        icon: const Icon(Icons.download, size: 18),
                        label: const Text('Backup Now'),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // Card: Factory Reset
              Card(
                elevation: 0,
                color: const Color(0xFFFEF2F2),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: const BorderSide(color: Color(0xFFFCA5A5)),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Row(
                    children: [
                      const CircleAvatar(
                        backgroundColor: Color(0xFFFEE2E2),
                        foregroundColor: Color(0xFFDC2626),
                        child: Icon(Icons.delete_forever_outlined),
                      ),
                      const SizedBox(width: 16),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Factory Reset & Data Purge',
                              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF991B1B)),
                            ),
                            SizedBox(height: 4),
                            Text(
                              'Purge transaction & inventory data while preserving immutable audit logs. Requires Manager PIN & 16-digit Master Security Key.',
                              style: TextStyle(fontSize: 12, color: Color(0xFFB91C1C)),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFDC2626),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                        onPressed: _handleFactoryReset,
                        icon: const Icon(Icons.warning_amber_rounded, size: 18),
                        label: const Text('Factory Reset'),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ==========================================
  // TAB 2: IMMUTABLE AUDIT TRAIL VIEWER (ITEM 20)
  // ==========================================
  Widget _buildAuditLogsTab() {
    final db = ref.watch(dbProvider);

    return Column(
      children: [
        // Controls Header
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          decoration: const BoxDecoration(
            color: Colors.white,
            border: Border(bottom: BorderSide(color: Color(0xFFE2E8F0))),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.security, size: 22, color: Color(0xFF0F172A)),
                  const SizedBox(width: 10),
                  const Text(
                    'Immutable System Audit Trail',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                  ),
                  const SizedBox(width: 10),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF1F5F9),
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: const Color(0xFFCBD5E1)),
                    ),
                    child: const Text('Read-Only & Non-Deletable', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF475569))),
                  ),
                  const Spacer(),
                  // Search Bar
                  SizedBox(
                    width: 320,
                    child: TextField(
                      controller: _auditSearchController,
                      decoration: InputDecoration(
                        hintText: 'Search audit action or details...',
                        hintStyle: const TextStyle(fontSize: 12),
                        prefixIcon: const Icon(Icons.search, size: 18),
                        suffixIcon: _auditSearchController.text.isNotEmpty
                            ? IconButton(
                                icon: const Icon(Icons.clear, size: 16),
                                onPressed: () => setState(() => _auditSearchController.clear()),
                              )
                            : null,
                        isDense: true,
                        filled: true,
                        fillColor: const Color(0xFFF8FAFC),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Color(0xFFCBD5E1))),
                      ),
                      onChanged: (_) => setState(() {}),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              // Action Filter Chips
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    const Text('Action Category:', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF475569))),
                    const SizedBox(width: 8),
                    ...[
                      {'id': 'ALL', 'label': 'All Actions'},
                      {'id': 'LOGIN', 'label': 'Logins & Locks'},
                      {'id': 'STOCK_ADJUST', 'label': 'Stock Adjustments'},
                      {'id': 'GRN_POSTED', 'label': 'GRN Purchases'},
                      {'id': 'RETURN_APPROVE', 'label': 'Returns & Claims'},
                      {'id': 'REPORT_EXPORT', 'label': 'Report Exports'},
                      {'id': 'DATA_WIPE', 'label': 'Data Wipes & Resets'},
                      {'id': 'USER_MGMT', 'label': 'User & Security Config'},
                    ].map((act) {
                      final isSelected = _selectedAuditAction == act['id'];
                      return Padding(
                        padding: const EdgeInsets.only(right: 6),
                        child: ChoiceChip(
                          label: Text(act['label']!, style: TextStyle(fontSize: 11, fontWeight: isSelected ? FontWeight.bold : FontWeight.normal)),
                          selected: isSelected,
                          selectedColor: const Color(0xFF0F172A),
                          labelStyle: TextStyle(color: isSelected ? Colors.white : const Color(0xFF334155)),
                          onSelected: (sel) {
                            if (sel) setState(() => _selectedAuditAction = act['id']!);
                          },
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ],
          ),
        ),

        // Live Audit Stream Table
        Expanded(
          child: StreamBuilder<List<AuditLog>>(
            stream: (db.select(db.auditLogs)..orderBy([(t) => drift.OrderingTerm.desc(t.createdAt)])).watch(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
              final allLogs = snapshot.data!;
              final search = _auditSearchController.text.toLowerCase().trim();

              final filtered = allLogs.where((log) {
                // Category match
                bool matchesCategory = true;
                if (_selectedAuditAction == 'LOGIN') {
                  matchesCategory = log.actionType.contains('LOGIN') || log.actionType.contains('LOCK');
                } else if (_selectedAuditAction == 'STOCK_ADJUST') {
                  matchesCategory = log.actionType.contains('STOCK') || log.actionType.contains('ADJUST');
                } else if (_selectedAuditAction == 'GRN_POSTED') {
                  matchesCategory = log.actionType.contains('GRN') || log.actionType.contains('PURCHASE');
                } else if (_selectedAuditAction == 'RETURN_APPROVE') {
                  matchesCategory = log.actionType.contains('RETURN');
                } else if (_selectedAuditAction == 'REPORT_EXPORT') {
                  matchesCategory = log.actionType.contains('EXPORT') || log.actionType.contains('REPORT');
                } else if (_selectedAuditAction == 'DATA_WIPE') {
                  matchesCategory = log.actionType.contains('WIPE') || log.actionType.contains('RESET') || log.actionType.contains('PURGE');
                } else if (_selectedAuditAction == 'USER_MGMT') {
                  matchesCategory = log.actionType.contains('USER') || log.actionType.contains('CONFIG');
                }

                if (!matchesCategory) return false;

                // Keyword match
                if (search.isEmpty) return true;
                return log.actionType.toLowerCase().contains(search) ||
                    log.details.toLowerCase().contains(search) ||
                    (log.usernameSnapshot?.toLowerCase().contains(search) ?? false);
              }).toList();

              if (filtered.isEmpty) {
                return const Center(child: Text('No audit events found for selected criteria', style: TextStyle(color: Color(0xFF94A3B8))));
              }

              return ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                itemCount: filtered.length,
                separatorBuilder: (_, __) => const Divider(height: 1, color: Color(0xFFF1F5F9)),
                itemBuilder: (context, i) {
                  final log = filtered[i];
                  final badgeColor = _getAuditBadgeColor(log.actionType);

                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    decoration: BoxDecoration(
                      color: i % 2 == 0 ? Colors.white : const Color(0xFFFAFAFA),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Timestamp Column
                        SizedBox(
                          width: 150,
                          child: Text(
                            _dateFormat.format(log.createdAt),
                            style: const TextStyle(fontSize: 11, fontFamily: 'monospace', color: Color(0xFF64748B), fontWeight: FontWeight.w600),
                          ),
                        ),
                        // Action Badge
                        Container(
                          width: 140,
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: badgeColor.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(color: badgeColor.withValues(alpha: 0.3)),
                          ),
                          child: Center(
                            child: Text(
                              log.actionType,
                              style: TextStyle(
                                fontSize: 9.5,
                                fontWeight: FontWeight.bold,
                                color: badgeColor,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                        const SizedBox(width: 14),
                        // User & Terminal
                        SizedBox(
                          width: 160,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                log.usernameSnapshot ?? 'SYSTEM',
                                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                              ),
                              Text(
                                '${log.roleSnapshot ?? "ADMIN"} • ${log.ipOrTerminal}',
                                style: const TextStyle(fontSize: 10, color: Color(0xFF94A3B8)),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 14),
                        // Details text
                        Expanded(
                          child: Text(
                            log.details,
                            style: const TextStyle(fontSize: 12, color: Color(0xFF334155)),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
