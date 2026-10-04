import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'core/db/app_database.dart';
import 'core/localization/locale_provider.dart';
import 'features/auth/login_screen.dart';
import 'package:drift/native.dart';
import 'dart:io';
import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'core/db/connection/connection.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'l10n/app_localizations.dart';
import 'app_shell.dart';
import 'features/inventory/parts_master_screen.dart'; // Contains dbProvider

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  const storage = FlutterSecureStorage();
  String? masterKey = await storage.read(key: 'db_master_key');
  if (masterKey == null) {
    final keyBytes = List<int>.generate(32, (i) => DateTime.now().microsecondsSinceEpoch % 256);
    masterKey = sha256.convert(keyBytes).toString();
    await storage.write(key: 'db_master_key', value: masterKey);
  }

  final dbFile = File('arham_autos.db');
  final db = AppDatabase(openConnection(masterKey, dbFile));
  
  runApp(
    ProviderScope(
      overrides: [
        dbProvider.overrideWithValue(db),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = ref.watch(localeProvider);
    
    return MaterialApp(
      title: 'Arham Autos',
      debugShowCheckedModeBanner: false,
      locale: locale,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en'),
        Locale('ur'),
      ],
      builder: (context, child) {
        return Directionality(
          textDirection: locale.languageCode == 'ur' ? TextDirection.rtl : TextDirection.ltr,
          child: child!,
        );
      },
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamilyFallback: const ['Noto Nastaliq Urdu'],
        scrollbarTheme: ScrollbarThemeData(
          thumbVisibility: WidgetStateProperty.all(true),
          trackVisibility: WidgetStateProperty.all(true),
          thickness: WidgetStateProperty.all(8.0),
          interactive: true,
        ),
      ),
      home: const LoginScreen(),
    );
  }
}
