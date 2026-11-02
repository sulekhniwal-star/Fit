import 'package:drift/drift.dart';

class OutboxMutations extends Table {
  TextColumn get id => text()();
  TextColumn get entityType => text()();
  TextColumn get operationType => text()();
  TextColumn get payloadJson => text()();
  TextColumn get idempotencyKey => text()();
  DateTimeColumn get createdAt => dateTime()();
  IntColumn get retryCount => integer().withDefault(const Constant(0))();
  TextColumn get status => text().withDefault(const Constant('pending'))();
  TextColumn get lastError => text().nullable()();
  TextColumn get dependencyId => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

