import 'package:drift/drift.dart';

class ExercisesTable extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get hindiName => text().withDefault(const Constant(''))();
  TextColumn get primaryMuscle => text()();
  TextColumn get secondaryMusclesJson => text().withDefault(const Constant('[]'))();
  TextColumn get equipment => text()();
  TextColumn get workoutType => text()();
  TextColumn get difficulty => text().withDefault(const Constant('beginner'))();
  TextColumn get instructions => text().withDefault(const Constant(''))();
  BoolColumn get isHomeFriendly => boolean().withDefault(const Constant(true))();
  BoolColumn get isSystem => boolean().withDefault(const Constant(true))();

  @override
  Set<Column> get primaryKey => {id};
}

class WorkoutSessionsTable extends Table {
  TextColumn get id => text()();
  TextColumn get userId => text()();
  TextColumn get title => text()();
  TextColumn get workoutType => text()();
  DateTimeColumn get startedAt => dateTime()();
  DateTimeColumn get endedAt => dateTime().nullable()();
  RealColumn get totalVolumeKg => real().withDefault(const Constant(0.0))();
  IntColumn get durationSeconds => integer().withDefault(const Constant(0))();
  RealColumn get caloriesBurned => real().withDefault(const Constant(0.0))();
  TextColumn get status => text().withDefault(const Constant('inProgress'))(); // inProgress, completed, discarded
  TextColumn get notes => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

class WorkoutSetsTable extends Table {
  TextColumn get id => text()();
  TextColumn get sessionId => text()();
  TextColumn get exerciseId => text()();
  TextColumn get exerciseName => text()();
  IntColumn get setNumber => integer()();
  RealColumn get weightKg => real().withDefault(const Constant(0.0))();
  IntColumn get reps => integer().withDefault(const Constant(0))();
  BoolColumn get isWarmup => boolean().withDefault(const Constant(false))();
  BoolColumn get isCompleted => boolean().withDefault(const Constant(false))();
  IntColumn get rpe => integer().nullable()(); // 1-10
  DateTimeColumn get completedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

