import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:file_selector/file_selector.dart';
import 'package:drift/drift.dart' as drift;
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:intl/intl.dart';

import '../../core/db/app_database.dart';
import '../../core/crypto/master_key.dart';
import '../../core/crypto/kdf.dart';
import '../../core/localization/locale_provider.dart';
import '../auth/login_screen.dart';
import '../inventory/parts_master_screen.dart'; // contains dbProvider

class SetupWizardScreen extends ConsumerStatefulWidget {
  const SetupWizardScreen({super.key});

  @override
  ConsumerState<SetupWizardScreen> createState() => _SetupWizardScreenState();
}

class _SetupWizardScreenState extends ConsumerState<SetupWizardScreen> {
  int _currentStep = 0;

  // Step 1: Language
  String _selectedLanguage = 'en';

  // Step 2: Backup Location
  String? _selectedBackupDir;

  // Step 3: Master Key
  late String _masterKey;
  bool _isKeyConfirmed = false;
  bool _isPrinting = false;

  // Step 4: Manager Account
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController(text: 'manager');
  final _displayNameController = TextEditingController(text: 'Store Administrator');
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _pinController = TextEditingController();
  final _confirmPinController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscurePin = true;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _masterKey = MasterKey.generate();
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _displayNameController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _pinController.dispose();
    _confirmPinController.dispose();
    super.dispose();
  }

  Future<void> _pickBackupDirectory() async {
    final String? path = await getDirectoryPath();
    if (path != null) {
      setState(() {
        _selectedBackupDir = path;
      });
    }
  }

  Future<void> _printCertificate() async {
    setState(() => _isPrinting = true);
    try {
      final doc = pw.Document();
      final nowFormatted = DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());

      doc.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a4,
          margin: const pw.EdgeInsets.all(36),
          build: (pw.Context context) {
            return pw.Container(
              padding: const pw.EdgeInsets.all(24),
              decoration: pw.BoxDecoration(
                border: pw.Border.all(color: PdfColors.blueGrey800, width: 2),
                borderRadius: pw.BorderRadius.circular(8),
              ),
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  // Title / Header
                  pw.Center(
                    child: pw.Column(
                      children: [
                        pw.Text(
                          'ARHAM AUTOS',
                          style: pw.TextStyle(
                            fontSize: 22,
                            fontWeight: pw.FontWeight.bold,
                            color: PdfColors.blueGrey900,
                          ),
                        ),
                        pw.SizedBox(height: 4),
                        pw.Text(
                          'MASTER SECURITY KEY CERTIFICATE',
                          style: pw.TextStyle(
                            fontSize: 16,
                            fontWeight: pw.FontWeight.bold,
                            color: PdfColors.blue900,
                            letterSpacing: 1.2,
                          ),
                        ),
                        pw.SizedBox(height: 2),
                        pw.Text(
                          'Official Offline Cryptographic Root Credential',
                          style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey700),
                        ),
                      ],
                    ),
                  ),
                  pw.SizedBox(height: 16),
                  pw.Divider(thickness: 1, color: PdfColors.blueGrey300),
                  pw.SizedBox(height: 12),

                  // Warning Banner
                  pw.Container(
                    padding: const pw.EdgeInsets.all(12),
                    decoration: pw.BoxDecoration(
                      color: PdfColors.red50,
                      border: pw.Border.all(color: PdfColors.red700, width: 1),
                      borderRadius: pw.BorderRadius.circular(6),
                    ),
                    child: pw.Row(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text(
                          'CRITICAL WARNING: ',
                          style: pw.TextStyle(
                            fontSize: 11,
                            fontWeight: pw.FontWeight.bold,
                            color: PdfColors.red900,
                          ),
                        ),
                        pw.Expanded(
                          child: pw.Text(
                            'Store this physical sheet in a locked safe. Because this system operates 100% offline, this 16-digit Master Key cannot be recovered online.',
                            style: pw.TextStyle(
                              fontSize: 10,
                              fontWeight: pw.FontWeight.bold,
                              color: PdfColors.red900,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  pw.SizedBox(height: 24),

                  // Master Key Box
                  pw.Center(
                    child: pw.Text(
                      '16-DIGIT MASTER SECURITY KEY',
                      style: pw.TextStyle(
                        fontSize: 11,
                        fontWeight: pw.FontWeight.bold,
                        color: PdfColors.blueGrey800,
                        letterSpacing: 1.5,
                      ),
                    ),
                  ),
                  pw.SizedBox(height: 8),
                  pw.Container(
                    width: double.infinity,
                    padding: const pw.EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                    decoration: pw.BoxDecoration(
                      color: PdfColors.grey100,
                      border: pw.Border.all(color: PdfColors.blueGrey700, width: 1.5),
                      borderRadius: pw.BorderRadius.circular(8),
                    ),
                    child: pw.Center(
                      child: pw.Text(
                        _masterKey,
                        style: pw.TextStyle(
                          font: pw.Font.courierBold(),
                          fontSize: 26,
                          fontWeight: pw.FontWeight.bold,
                          color: PdfColors.black,
                          letterSpacing: 4.0,
                        ),
                      ),
                    ),
                  ),
                  pw.SizedBox(height: 24),

                  // Metadata Table
                  pw.Table(
                    border: pw.TableBorder.all(color: PdfColors.grey400, width: 0.5),
                    children: [
                      pw.TableRow(
                        decoration: const pw.BoxDecoration(color: PdfColors.grey100),
                        children: [
                          pw.Padding(
                            padding: const pw.EdgeInsets.all(6),
                            child: pw.Text('Metadata Field', style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold)),
                          ),
                          pw.Padding(
                            padding: const pw.EdgeInsets.all(6),
                            child: pw.Text('Recorded Specification', style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold)),
                          ),
                        ],
                      ),
                      pw.TableRow(
                        children: [
                          pw.Padding(
                            padding: const pw.EdgeInsets.all(6),
                            child: pw.Text('System Identifier', style: const pw.TextStyle(fontSize: 9)),
                          ),
                          pw.Padding(
                            padding: const pw.EdgeInsets.all(6),
                            child: pw.Text('Arham Autos POS & Inventory Suite (Offline Terminal)', style: const pw.TextStyle(fontSize: 9)),
                          ),
                        ],
                      ),
                      pw.TableRow(
                        children: [
                          pw.Padding(
                            padding: const pw.EdgeInsets.all(6),
                            child: pw.Text('Generation Timestamp', style: const pw.TextStyle(fontSize: 9)),
                          ),
                          pw.Padding(
                            padding: const pw.EdgeInsets.all(6),
                            child: pw.Text(nowFormatted, style: const pw.TextStyle(fontSize: 9)),
                          ),
                        ],
                      ),
                      pw.TableRow(
                        children: [
                          pw.Padding(
                            padding: const pw.EdgeInsets.all(6),
                            child: pw.Text('Assigned Backup Directory', style: const pw.TextStyle(fontSize: 9)),
                          ),
                          pw.Padding(
                            padding: const pw.EdgeInsets.all(6),
                            child: pw.Text(_selectedBackupDir ?? 'N/A', style: const pw.TextStyle(fontSize: 9)),
                          ),
                        ],
                      ),
                      pw.TableRow(
                        children: [
                          pw.Padding(
                            padding: const pw.EdgeInsets.all(6),
                            child: pw.Text('Cryptographic Standard', style: const pw.TextStyle(fontSize: 9)),
                          ),
                          pw.Padding(
                            padding: const pw.EdgeInsets.all(6),
                            child: pw.Text('PBKDF2-HMAC-SHA256 (210,000 iterations) + SQLCipher AES-256', style: const pw.TextStyle(fontSize: 9)),
                          ),
                        ],
                      ),
                    ],
                  ),
                  pw.SizedBox(height: 20),

                  // Guidelines
                  pw.Text(
                    'Operational Protocols:',
                    style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold, color: PdfColors.blueGrey900),
                  ),
                  pw.SizedBox(height: 4),
                  pw.Bullet(text: 'This certificate is required for factory data purges and database restore operations.', style: const pw.TextStyle(fontSize: 9)),
                  pw.Bullet(text: 'Never store this 16-digit key in plain text on internet-connected devices or public cloud drives.', style: const pw.TextStyle(fontSize: 9)),
                  pw.Bullet(text: 'If the system administrator forgets the Manager PIN, this physical key provides the only step-up override.', style: const pw.TextStyle(fontSize: 9)),
                  
                  pw.Spacer(),

                  // Signatures
                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Container(width: 180, decoration: const pw.BoxDecoration(border: pw.Border(bottom: pw.BorderSide(color: PdfColors.grey600, width: 1)))),
                          pw.SizedBox(height: 4),
                          pw.Text('Authorized Store Owner Signature', style: const pw.TextStyle(fontSize: 8, color: PdfColors.grey700)),
                        ],
                      ),
                      pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Container(width: 180, decoration: const pw.BoxDecoration(border: pw.Border(bottom: pw.BorderSide(color: PdfColors.grey600, width: 1)))),
                          pw.SizedBox(height: 4),
                          pw.Text('AlphaSync Systems Verification', style: const pw.TextStyle(fontSize: 8, color: PdfColors.grey700)),
                        ],
                      ),
                    ],
                  ),
                  pw.SizedBox(height: 16),
                  pw.Divider(thickness: 0.5, color: PdfColors.grey400),
                  pw.SizedBox(height: 6),

                  // Footer
                  pw.Center(
                    child: pw.Text(
                      'For Account Solution Contact AlphaSync Systems: 03140486627 | info@alphasync.codes',
                      style: pw.TextStyle(fontSize: 9, fontWeight: pw.FontWeight.bold, color: PdfColors.blueGrey800),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      );

      await Printing.layoutPdf(
        onLayout: (PdfPageFormat format) async => doc.save(),
        name: 'ArhamAutos_MasterKey_Certificate.pdf',
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error generating certificate: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isPrinting = false);
    }
  }

  Future<void> _handleStepContinue() async {
    final db = ref.read(dbProvider);

    if (_currentStep == 0) {
      // Step 1: Language
      await db.setConfig('DEFAULT_LOCALE', _selectedLanguage);
      ref.read(localeProvider.notifier).state = Locale(_selectedLanguage);
      setState(() => _currentStep += 1);
    } else if (_currentStep == 1) {
      // Step 2: Backup Location
      if (_selectedBackupDir == null || _selectedBackupDir!.trim().isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select a mandatory local backup folder to proceed.')),
        );
        return;
      }
      await db.setConfig('BACKUP_DIR', _selectedBackupDir!);
      setState(() => _currentStep += 1);
    } else if (_currentStep == 2) {
      // Step 3: Master Key Confirmation
      if (!_isKeyConfirmed) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please confirm that you have printed or saved your 16-digit Master Key.')),
        );
        return;
      }

      // Hash and persist master key
      final keyHash = await Kdf.hashPassword(_masterKey);
      await db.setConfig('MASTER_KEY_HASH', keyHash);
      await db.setConfig('MASTER_KEY', _masterKey); // Kept for backward compatibility
      setState(() => _currentStep += 1);
    } else if (_currentStep == 3) {
      // Step 4: Manager Account
      if (!_formKey.currentState!.validate()) return;

      setState(() => _isSubmitting = true);

      try {
        final username = _usernameController.text.trim();
        final displayName = _displayNameController.text.trim();
        final password = _passwordController.text;
        final pin = _pinController.text.trim();

        final passwordHash = await Kdf.hashPassword(password);
        final pinHash = await Kdf.hashPassword(pin);

        // Insert Manager into users table
        final userId = await db.into(db.users).insert(
          UsersCompanion(
            username: drift.Value(username),
            displayName: drift.Value(displayName),
            role: const drift.Value('MANAGER'),
            passwordHash: drift.Value(passwordHash),
            pinHash: drift.Value(pinHash),
            isActive: const drift.Value(true),
          ),
        );

        // Mark setup completed
        await db.setConfig('IS_SETUP_COMPLETED', 'true');

        // Write Audit Log
        await db.into(db.auditLogs).insert(
          AuditLogsCompanion.insert(
            actionType: 'SETUP_COMPLETED',
            details: 'Initial system setup completed and Manager account created ($username)',
            userId: drift.Value(userId),
            usernameSnapshot: drift.Value(username),
            roleSnapshot: const drift.Value('MANAGER'),
          ),
        );

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Setup completed successfully! Please login.')),
          );
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => const LoginScreen()),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Setup failed: $e')),
          );
        }
      } finally {
        if (mounted) setState(() => _isSubmitting = false);
      }
    }
  }

  void _handleStepCancel() {
    if (_currentStep > 0) {
      setState(() => _currentStep -= 1);
    }
  }

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF0F172A);

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text(
          'Arham Autos — Initial System Setup',
          style: TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.bold),
        ),
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 860),
          margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: const Color(0xFFE2E8F0)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 20,
                offset: const Offset(0, 8),
              )
            ],
          ),
          child: Stepper(
            type: StepperType.horizontal,
            currentStep: _currentStep,
            onStepContinue: _isSubmitting ? null : _handleStepContinue,
            onStepCancel: _currentStep > 0 && !_isSubmitting ? _handleStepCancel : null,
            controlsBuilder: (context, details) {
              return Padding(
                padding: const EdgeInsets.only(top: 24.0),
                child: Row(
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      onPressed: details.onStepContinue,
                      child: _isSubmitting
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                            )
                          : Text(
                              _currentStep == 3 ? 'Complete Setup' : 'Continue',
                              style: const TextStyle(fontWeight: FontWeight.w600),
                            ),
                    ),
                    if (_currentStep > 0) ...[
                      const SizedBox(width: 12),
                      OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          side: const BorderSide(color: Color(0xFFCBD5E1)),
                        ),
                        onPressed: details.onStepCancel,
                        child: const Text('Back', style: TextStyle(color: Color(0xFF475569))),
                      ),
                    ],
                  ],
                ),
              );
            },
            steps: [
              // Step 1: Language
              Step(
                title: const Text('Language'),
                isActive: _currentStep >= 0,
                state: _currentStep > 0 ? StepState.complete : StepState.indexed,
                content: _buildLanguageStep(),
              ),
              // Step 2: Backup Location
              Step(
                title: const Text('Backup'),
                isActive: _currentStep >= 1,
                state: _currentStep > 1 ? StepState.complete : StepState.indexed,
                content: _buildBackupStep(),
              ),
              // Step 3: Master Key
              Step(
                title: const Text('Master Key'),
                isActive: _currentStep >= 2,
                state: _currentStep > 2 ? StepState.complete : StepState.indexed,
                content: _buildMasterKeyStep(),
              ),
              // Step 4: Manager Account
              Step(
                title: const Text('Manager'),
                isActive: _currentStep >= 3,
                state: _currentStep == 3 ? StepState.indexed : StepState.complete,
                content: _buildManagerStep(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLanguageStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Select System Display Language',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
        ),
        const SizedBox(height: 6),
        const Text(
          'Choose your preferred language. You can change this later from the top navigation bar.',
          style: TextStyle(fontSize: 14, color: Color(0xFF64748B)),
        ),
        const SizedBox(height: 24),
        Row(
          children: [
            Expanded(
              child: _buildLanguageCard(
                code: 'en',
                title: 'English',
                subtitle: 'Standard Left-to-Right (LTR)',
                icon: Icons.language,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildLanguageCard(
                code: 'ur',
                title: 'اردو (Urdu)',
                subtitle: 'دائیں سے بائیں (RTL Nastaliq)',
                icon: Icons.translate,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildLanguageCard({
    required String code,
    required String title,
    required String subtitle,
    required IconData icon,
  }) {
    final isSelected = _selectedLanguage == code;

    return InkWell(
      onTap: () {
        setState(() => _selectedLanguage = code);
        ref.read(localeProvider.notifier).state = Locale(code);
      },
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFF1F5F9) : Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected ? const Color(0xFF0F172A) : const Color(0xFFE2E8F0),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: isSelected ? const Color(0xFF0F172A) : const Color(0xFFF1F5F9),
              foregroundColor: isSelected ? Colors.white : const Color(0xFF475569),
              child: Icon(icon, size: 20),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0F172A),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(subtitle, style: const TextStyle(fontSize: 12, color: Color(0xFF64748B))),
                ],
              ),
            ),
            if (isSelected) const Icon(Icons.check_circle, color: Color(0xFF0F172A)),
          ],
        ),
      ),
    );
  }

  Widget _buildBackupStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Configure Mandatory Backup Directory',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
        ),
        const SizedBox(height: 6),
        const Text(
          'Select a dedicated local directory or external USB drive where encrypted daily snapshots (.bak) will be stored.',
          style: TextStyle(fontSize: 14, color: Color(0xFF64748B)),
        ),
        const SizedBox(height: 24),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: const Color(0xFFF8FAFC),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: const Color(0xFFE2E8F0)),
          ),
          child: Row(
            children: [
              const Icon(Icons.folder_special_outlined, size: 40, color: Color(0xFF334155)),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Selected Backup Directory:', style: TextStyle(fontSize: 12, color: Color(0xFF64748B))),
                    const SizedBox(height: 4),
                    Text(
                      _selectedBackupDir ?? 'No directory chosen yet',
                      style: TextStyle(
                        fontFamily: 'Courier',
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: _selectedBackupDir != null ? const Color(0xFF0F172A) : Colors.red,
                      ),
                    ),
                  ],
                ),
              ),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0F172A),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                onPressed: _pickBackupDirectory,
                icon: const Icon(Icons.folder_open, size: 18),
                label: const Text('Browse...'),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMasterKeyStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Cryptographic Master Security Key',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
        ),
        const SizedBox(height: 6),
        const Text(
          'This 16-digit alphanumeric key is required for disaster recovery, factory data resets, and emergency administrative step-up.',
          style: TextStyle(fontSize: 14, color: Color(0xFF64748B)),
        ),
        const SizedBox(height: 20),

        // Warning banner
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: const Color(0xFFFEF2F2),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: const Color(0xFFFCA5A5)),
          ),
          child: const Row(
            children: [
              Icon(Icons.warning_amber_rounded, color: Color(0xFFDC2626), size: 28),
              SizedBox(width: 12),
              Expanded(
                child: Text(
                  'CRITICAL: Store this physical sheet in a locked safe. Because this system operates 100% offline, this 16-digit Master Key cannot be recovered online.',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF991B1B),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),

        // Key Display Box
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
          decoration: BoxDecoration(
            color: const Color(0xFFF8FAFC),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: const Color(0xFFCBD5E1), width: 1.5),
          ),
          child: Column(
            children: [
              const Text(
                'YOUR 16-DIGIT MASTER KEY',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.5,
                  color: Color(0xFF64748B),
                ),
              ),
              const SizedBox(height: 10),
              SelectableText(
                _masterKey,
                style: const TextStyle(
                  fontFamily: 'Courier',
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 4.0,
                  color: Color(0xFF0F172A),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),

        // Prominent Print Certificate Button
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFD4AF37),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              elevation: 0,
            ),
            onPressed: _isPrinting ? null : _printCertificate,
            icon: _isPrinting
                ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                : const Icon(Icons.print_outlined),
            label: Text(
              _isPrinting ? 'Preparing Certificate...' : 'Print / Export Recovery Certificate (PDF)',
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        const SizedBox(height: 16),

        // Confirmation Checkbox
        CheckboxListTile(
          value: _isKeyConfirmed,
          onChanged: (val) => setState(() => _isKeyConfirmed = val ?? false),
          activeColor: const Color(0xFF0F172A),
          contentPadding: EdgeInsets.zero,
          title: const Text(
            'I have printed or safely stored this 16-digit Master Security Key in an offline location.',
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF1E293B)),
          ),
          controlAffinity: ListTileControlAffinity.leading,
        ),
      ],
    );
  }

  Widget _buildManagerStep() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Create Primary Manager Account',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
          ),
          const SizedBox(height: 6),
          const Text(
            'This administrator account will have full access to financial reports, inventory pricing, and system configurations.',
            style: TextStyle(fontSize: 14, color: Color(0xFF64748B)),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _usernameController,
                  decoration: const InputDecoration(
                    labelText: 'Username *',
                    prefixIcon: Icon(Icons.person_outline),
                    border: OutlineInputBorder(),
                  ),
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) return 'Username required';
                    if (v.trim().length < 3) return 'Min 3 characters';
                    return null;
                  },
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: TextFormField(
                  controller: _displayNameController,
                  decoration: const InputDecoration(
                    labelText: 'Display Name *',
                    prefixIcon: Icon(Icons.badge_outlined),
                    border: OutlineInputBorder(),
                  ),
                  validator: (v) => v == null || v.trim().isEmpty ? 'Display name required' : null,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  decoration: InputDecoration(
                    labelText: 'Master Password *',
                    prefixIcon: const Icon(Icons.lock_outline),
                    suffixIcon: IconButton(
                      icon: Icon(_obscurePassword ? Icons.visibility_outlined : Icons.visibility_off_outlined),
                      onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                    ),
                    border: const OutlineInputBorder(),
                  ),
                  validator: (v) {
                    if (v == null || v.isEmpty) return 'Password required';
                    if (v.length < 5) return 'At least 5 characters required';
                    return null;
                  },
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: TextFormField(
                  controller: _confirmPasswordController,
                  obscureText: _obscurePassword,
                  decoration: const InputDecoration(
                    labelText: 'Confirm Password *',
                    prefixIcon: Icon(Icons.lock_outline),
                    border: OutlineInputBorder(),
                  ),
                  validator: (v) {
                    if (v != _passwordController.text) return 'Passwords do not match';
                    return null;
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _pinController,
                  obscureText: _obscurePin,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Manager PIN (4-6 Digits) *',
                    hintText: 'e.g. 1234',
                    prefixIcon: const Icon(Icons.pin_outlined),
                    suffixIcon: IconButton(
                      icon: Icon(_obscurePin ? Icons.visibility_outlined : Icons.visibility_off_outlined),
                      onPressed: () => setState(() => _obscurePin = !_obscurePin),
                    ),
                    border: const OutlineInputBorder(),
                  ),
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) return 'PIN required';
                    if (v.trim().length < 4 || v.trim().length > 6) return 'PIN must be 4–6 digits';
                    if (int.tryParse(v.trim()) == null) return 'Must be numeric digits';
                    return null;
                  },
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: TextFormField(
                  controller: _confirmPinController,
                  obscureText: _obscurePin,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Confirm PIN *',
                    prefixIcon: Icon(Icons.pin_outlined),
                    border: OutlineInputBorder(),
                  ),
                  validator: (v) {
                    if (v != _pinController.text) return 'PINs do not match';
                    return null;
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
