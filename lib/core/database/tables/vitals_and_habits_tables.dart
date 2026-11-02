import 'package:drift/drift.dart';

class VitalRecordsTable extends Table {
  TextColumn get id => text()();
  TextColumn get userId => text()();
  DateTimeColumn get recordedAt => dateTime()();
  TextColumn get vitalType => text()(); // bloodPressure, bloodGlucose
  IntColumn get systolic => integer().nullable()();
  IntColumn get diastolic => integer().nullable()();
  IntColumn get pulse => integer().nullable()();
  RealColumn get glucoseMgDl => real().nullable()();
  TextColumn get contextTag => text().nullable()(); // fasting, postPrandial
  TextColumn get source => text().withDefault(const Constant('manual'))();

  @override
  Set<Column> get primaryKey => {id};
}

class MedicationEntriesTable extends Table {
  TextColumn get id => text()();
  TextColumn get userId => text()();
  TextColumn get name => text()();
  TextColumn get dosage => text()();
  TextColumn get timeOfDay => text()(); // morning, afternoon, evening, night
  TextColumn get status => text().withDefault(const Constant('scheduled'))(); // scheduled, taken, skipped
  DateTimeColumn get scheduledDate => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

class HabitEntriesTable extends Table {
  TextColumn get id => text()();
  TextColumn get userId => text()();
  TextColumn get title => text()();
  TextColumn get frequency => text().withDefault(const Constant('daily'))();
  IntColumn get targetDays => integer().withDefault(const Constant(7))();
  IntColumn get currentStreak => integer().withDefault(const Constant(0))();
  IntColumn get bestStreak => integer().withDefault(const Constant(0))();
  DateTimeColumn get lastCompletedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

