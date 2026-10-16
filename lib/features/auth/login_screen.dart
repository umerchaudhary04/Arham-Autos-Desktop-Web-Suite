import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../app_shell.dart';
import 'package:drift/drift.dart' as drift;
import '../../core/db/app_database.dart';
import '../../core/crypto/kdf.dart';
import '../inventory/parts_master_screen.dart'; // For dbProvider

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isError = false;
  bool _isLoading = false;
  bool _obscurePassword = true;

  Future<void> _login() async {
    final username = _usernameController.text.trim();
    final password = _passwordController.text;

    setState(() {
      _isLoading = true;
      _isError = false;
    });

    final db = ref.read(dbProvider);
    final usersCount = await db.select(db.users).get();
    String? role;

    if (usersCount.isEmpty) {
      // Fallback for initial setup if no users exist
      if (username == 'manager' && password == 'admin') {
        role = 'Manager';
      } else if (username == 'operator' && password == '123') {
        role = 'Operator';
      }
    } else {
      final userQuery = await (db.select(db.users)
            ..where((t) => t.username.equals(username)))
          .getSingleOrNull();
      if (userQuery != null) {
        bool isValid = false;
        if (userQuery.passwordHash != null) {
          isValid = await Kdf.verifyPassword(password, userQuery.passwordHash!);
        }
        if (!isValid && userQuery.pinHash.isNotEmpty) {
          isValid = await Kdf.verifyPassword(password, userQuery.pinHash);
        }
        if (isValid && userQuery.isActive) {
          role = userQuery.role == 'MANAGER' ? 'Manager' : 'Operator';
          // Record successful login
          await (db.update(db.users)..where((t) => t.id.equals(userQuery.id))).write(
            UsersCompanion(
              lastLoginAt: drift.Value(DateTime.now()),
              failedAttempts: const drift.Value(0),
            ),
          );
        }
      }
    }

    if (mounted) {
      setState(() {
        _isLoading = false;
      });
      if (role != null) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (_) => AppShell(userRole: role!, currentUsername: username),
          ),
        );
      } else {
        setState(() {
          _isError = true;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: Center(
        child: Container(
          width: double.infinity,
          constraints: const BoxConstraints(maxWidth: 400),
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 40),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: const Color(0xFFE2E8F0)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.06),
                blurRadius: 24,
                offset: const Offset(0, 8),
              )
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Top Brand Monogram Badge with Asset Fallback
              Container(
                width: 58,
                height: 58,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.08),
                      blurRadius: 16,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(18),
                  child: Image.asset(
                    'assets/images/arham_logo.png',
                    width: 58,
                    height: 58,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) =>
                        const ArhamMonogramBadge(size: 58),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              // Typography & Header
              const Text(
                'Arham Autos',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0F172A),
                  fontFamily: 'Inter',
                ),
              ),
              const SizedBox(height: 32),
              // Input Fields
              TextField(
                controller: _usernameController,
                style: const TextStyle(color: Color(0xFF0F172A)),
                decoration: InputDecoration(
                  hintText: 'Username',
                  hintStyle: const TextStyle(color: Color(0xFF94A3B8)),
                  prefixIcon: const Icon(Icons.person_outline, color: Color(0xFF64748B)),
                  filled: true,
                  fillColor: const Color(0xFFF8FAFC),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(color: Color(0xFF0F172A)),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _passwordController,
                obscureText: _obscurePassword,
                style: const TextStyle(color: Color(0xFF0F172A)),
                decoration: InputDecoration(
                  hintText: 'Password',
                  hintStyle: const TextStyle(color: Color(0xFF94A3B8)),
                  prefixIcon: const Icon(Icons.lock_outline, color: Color(0xFF64748B)),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                      color: const Color(0xFF64748B),
                    ),
                    onPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                  ),
                  filled: true,
                  fillColor: const Color(0xFFF8FAFC),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(color: Color(0xFF0F172A)),
                  ),
                ),
                onSubmitted: (_) => _login(),
              ),
              const SizedBox(height: 24),
              if (_isError)
                const Padding(
                  padding: EdgeInsets.only(bottom: 16),
                  child: Text(
                    'Invalid credentials',
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              // Action Button
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0F172A),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    elevation: 0,
                  ),
                  onPressed: _isLoading ? null : _login,
                  child: _isLoading
                      ? const SizedBox(
                          height: 24,
                          width: 24,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : const Text(
                          'Login',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
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

/// Custom stylized "AA" automotive monogram badge used as default brand emblem.
class ArhamMonogramBadge extends StatelessWidget {
  final double size;
  const ArhamMonogramBadge({super.key, this.size = 56});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF0F172A), Color(0xFF1E293B)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(size * 0.30),
        border: Border.all(color: const Color(0xFF334155), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0F172A).withValues(alpha: 0.25),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Subtle automotive gear / wheel accent ring
          Container(
            width: size * 0.76,
            height: size * 0.76,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: const Color(0xFF0EA5E9).withValues(alpha: 0.35),
                width: 1.2,
              ),
            ),
          ),
          // Stylized bold "AA" Monogram
          Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'A',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: size * 0.42,
                  fontWeight: FontWeight.w900,
                  letterSpacing: -1.5,
                  fontFamily: 'Inter',
                ),
              ),
              Transform.translate(
                offset: const Offset(-2, 2),
                child: Text(
                  'A',
                  style: TextStyle(
                    color: const Color(0xFF38BDF8), // vibrant automotive cyan/teal
                    fontSize: size * 0.36,
                    fontWeight: FontWeight.w900,
                    letterSpacing: -1.0,
                    fontFamily: 'Inter',
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
