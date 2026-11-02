import 'package:drift/drift.dart';

class StepRecordsTable extends Table {
  TextColumn get id => text()();
  TextColumn get userId => text()();
  DateTimeColumn get date => dateTime()();
  IntColumn get stepCount => integer()();
  IntColumn get goal => integer().withDefault(const Constant(10000))();
  TextColumn get source => text().withDefault(const Constant('manual'))();

  @override
  Set<Column> get primaryKey => {id};
}

class SleepRecordsTable extends Table {
  TextColumn get id => text()();
  TextColumn get userId => text()();
  DateTimeColumn get startTime => dateTime()();
  DateTimeColumn get endTime => dateTime()();
  IntColumn get durationMinutes => integer()();
  IntColumn get qualityRating => integer().withDefault(const Constant(3))();
  IntColumn get deepSleepMinutes => integer().nullable()();
  IntColumn get remSleepMinutes => integer().nullable()();
  TextColumn get source => text().withDefault(const Constant('manual'))();

  @override
  Set<Column> get primaryKey => {id};
}

class WaterLogsTable extends Table {
  TextColumn get id => text()();
  TextColumn get userId => text()();
  DateTimeColumn get recordedAt => dateTime()();
  IntColumn get amountMl => integer()();
  IntColumn get dailyGoalMl => integer().withDefault(const Constant(2500))();

  @override
  Set<Column> get primaryKey => {id};
}

class MoodLogsTable extends Table {
  TextColumn get id => text()();
  TextColumn get userId => text()();
  DateTimeColumn get recordedAt => dateTime()();
  IntColumn get moodScore => integer()(); // 1 to 5
  TextColumn get notes => text().nullable()();
  TextColumn get tagsJson => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}
