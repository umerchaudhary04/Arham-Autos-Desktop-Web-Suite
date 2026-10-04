import 'package:drift/drift.dart';

class SystemConfigs extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get configKey => text().unique()();
  TextColumn get configValue => text()();
  DateTimeColumn get updatedAt => dateTime().clientDefault(() => DateTime.now())();
}
