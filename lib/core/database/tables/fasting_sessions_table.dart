import 'package:drift/drift.dart';

class FastingSessionsTable extends Table {
  TextColumn get id => text()();
  TextColumn get userId => text()();
  TextColumn get protocolType => text()();
  DateTimeColumn get startTime => dateTime()();
  DateTimeColumn get plannedEndTime => dateTime()();
  DateTimeColumn get actualEndTime => dateTime().nullable()();
  TextColumn get status => text().withDefault(const Constant('active'))();
  BoolColumn get isWaterless => boolean().withDefault(const Constant(false))();
  BoolColumn get hydrationReminders => boolean().withDefault(const Constant(true))();
  TextColumn get notes => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

