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
        scaffoldBackgroundColor: Colors.white,
        canvasColor: Colors.white,
        cardColor: Colors.white,
        dialogBackgroundColor: Colors.white,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF171717),
          primary: const Color(0xFF171717),
          secondary: const Color(0xFF404040),
          surface: Colors.white,
          background: Colors.white,
        ),
        fontFamily: 'Inter',
        fontFamilyFallback: const ['Noto Nastaliq Urdu'],
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: Color(0xFF171717),
          elevation: 0,
          centerTitle: false,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF171717),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
        ),
        dataTableTheme: DataTableThemeData(
          headingRowColor: WidgetStateProperty.all(const Color(0xFFF9FAFB)),
          dataRowColor: WidgetStateProperty.all(Colors.white),
          headingTextStyle: const TextStyle(fontWeight: FontWeight.w600, color: Color(0xFF171717)),
        ),
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
