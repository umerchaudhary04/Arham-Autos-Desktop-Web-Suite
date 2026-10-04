import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../app_shell.dart';
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
      final userQuery = await (db.select(db.users)..where((t) => t.username.equals(username))).getSingleOrNull();
      if (userQuery != null && userQuery.passwordHash != null) {
        bool isValid = await Kdf.verifyPassword(password, userQuery.passwordHash!);
        if (isValid) {
          role = userQuery.role == 'MANAGER' ? 'Manager' : 'Operator';
        }
      } else if (userQuery != null && userQuery.passwordHash == null) {
          // If for some reason passwordHash is null, assume legacy pin-based or dev env
          if (password == 'admin' && userQuery.role == 'MANAGER') role = 'Manager';
      }
    }

    if (mounted) {
      setState(() {
        _isLoading = false;
      });
      if (role != null) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => AppShell(userRole: role!)),
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
      body: Center(
        child: Container(
          width: 400,
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 20,
                offset: Offset(0, 10),
              )
            ]
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Arham Autos V2', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              const SizedBox(height: 32),
              TextField(
                controller: _usernameController,
                decoration: const InputDecoration(labelText: 'Username', border: OutlineInputBorder()),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(labelText: 'Password', border: OutlineInputBorder()),
                onSubmitted: (_) => _login(),
              ),
              const SizedBox(height: 24),
              if (_isError)
                const Padding(
                  padding: EdgeInsets.only(bottom: 16),
                  child: Text('Invalid credentials', style: TextStyle(color: Colors.red)),
                ),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFD4AF37), foregroundColor: Colors.white),
                  onPressed: _isLoading ? null : _login,
                  child: _isLoading ? const CircularProgressIndicator(color: Colors.white) : const Text('Login'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
