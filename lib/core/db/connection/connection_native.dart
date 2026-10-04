import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';

QueryExecutor openConnection(String hexKey, File dbFile) {
  return NativeDatabase.createInBackground(dbFile, setup: (db) {
    final result = db.select('PRAGMA cipher');
    if (result.isEmpty) {
      throw StateError('sqlite3mc is not loaded.');
    }
    db.execute("PRAGMA cipher='sqlcipher';");
    db.execute("PRAGMA legacy=4;");
    db.execute("PRAGMA hexkey='$hexKey';");

    db.select('SELECT count(*) FROM sqlite_master');

    db.execute("PRAGMA foreign_keys=ON;");
    db.execute("PRAGMA journal_mode=WAL;");
    db.execute("PRAGMA synchronous=FULL;");
    db.execute("PRAGMA busy_timeout=5000;");
  });
}
