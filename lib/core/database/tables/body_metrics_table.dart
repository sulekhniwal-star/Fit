import 'package:drift/drift.dart';

class BodyMetricEntriesTable extends Table {
  TextColumn get id => text()();
  TextColumn get userId => text()();
  TextColumn get metricType => text()();
  RealColumn get value => real()();
  TextColumn get unit => text()();
  DateTimeColumn get recordedAt => dateTime()();
  TextColumn get source => text().withDefault(const Constant('manual'))();
  TextColumn get notes => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}
