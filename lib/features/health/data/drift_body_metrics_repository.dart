import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/database/app_database.dart';
import '../../../core/errors/failures.dart';
import '../../../core/errors/result.dart';
import '../../../core/sync/models/outbox_mutation.dart';
import '../../../core/sync/outbox_queue.dart';
import '../../../core/sync/sync_coordinator.dart';
import '../../../core/sync/syncable_repository.dart';
import '../domain/body_metric.dart';
import '../domain/health_primitives.dart';

class DriftBodyMetricsRepository extends SyncableRepository<BodyMetricEntry, String> {
  final AppDatabase _db;

  DriftBodyMetricsRepository(this._db, OutboxQueue outboxQueue) : super(outboxQueue);

  @override
  String get entityType => 'body_metrics';

  @override
  Future<Result<BodyMetricEntry>> getLocal(String id) async {
    final row = await (_db.select(_db.bodyMetricEntriesTable)
          ..where((tbl) => tbl.id.equals(id)))
        .getSingleOrNull();

    if (row == null) {
      return const Result.failure(
        ValidationFailure(message: 'Metric entry not found.'),
      );
    }

    return Result.success(_fromRow(row));
  }

  @override
  Future<Result<void>> saveLocal(BodyMetricEntry entity) async {
    if (!entity.isValid) {
      return const Result.failure(
        ValidationFailure(message: 'Metric value is outside acceptable physiological boundaries.'),
      );
    }

    await _db.into(_db.bodyMetricEntriesTable).insertOnConflictUpdate(
          BodyMetricEntriesTableCompanion.insert(
            id: entity.id,
            userId: entity.userId,
            metricType: entity.metricType.name,
            value: entity.value,
            unit: entity.unit.name,
            recordedAt: entity.recordedAt,
            source: Value(entity.source.name),
            notes: Value(entity.notes),
          ),
        );

    final idempotencyKey = 'body_metric_${entity.id}_${entity.recordedAt.millisecondsSinceEpoch}';
    final mutation = SyncMutation(
      id: 'mut_bm_${entity.id}',
      entityType: entityType,
      operation: OutboxOperation.insert,
      payload: entity.toJson(),
      idempotencyKey: idempotencyKey,
      createdAt: DateTime.now(),
    );

    await outboxQueue.enqueue(mutation);
    return const Result.success(null);
  }

  @override
  Future<Result<void>> deleteLocal(String id) async {
    await (_db.delete(_db.bodyMetricEntriesTable)..where((tbl) => tbl.id.equals(id))).go();

    final mutation = SyncMutation(
      id: 'mut_del_bm_$id',
      entityType: entityType,
      operation: OutboxOperation.delete,
      payload: {'id': id},
      idempotencyKey: 'bm_del_${id}_${DateTime.now().millisecondsSinceEpoch}',
      createdAt: DateTime.now(),
    );

    await outboxQueue.enqueue(mutation);
    return const Result.success(null);
  }

  /// Fetches historical metrics filtered by user and optionally metricType.
  Future<Result<List<BodyMetricEntry>>> getHistory({
    required String userId,
    BodyMetricType? metricType,
    DateTime? startDate,
  }) async {
    var query = _db.select(_db.bodyMetricEntriesTable)..where((tbl) => tbl.userId.equals(userId));

    if (metricType != null) {
      query = query..where((tbl) => tbl.metricType.equals(metricType.name));
    }
    if (startDate != null) {
      query = query..where((tbl) => tbl.recordedAt.isBiggerOrEqualValue(startDate));
    }

    query = query..orderBy([(tbl) => OrderingTerm.asc(tbl.recordedAt)]);
    final rows = await query.get();
    return Result.success(rows.map(_fromRow).toList());
  }

  @override
  Future<Result<void>> pushRemote(SyncMutation mutation) async {
    return const Result.success(null);
  }

  @override
  Future<Result<int>> pullRemote(DateTime since) async {
    return const Result.success(0);
  }

  BodyMetricEntry _fromRow(BodyMetricEntriesTableData row) {
    return BodyMetricEntry(
      id: row.id,
      userId: row.userId,
      metricType: BodyMetricType.values.firstWhere(
        (m) => m.name == row.metricType,
        orElse: () => BodyMetricType.weight,
      ),
      value: row.value,
      unit: HealthUnit.values.firstWhere(
        (u) => u.name == row.unit,
        orElse: () => HealthUnit.kg,
      ),
      recordedAt: row.recordedAt,
      source: HealthSource.values.firstWhere(
        (s) => s.name == row.source,
        orElse: () => HealthSource.manual,
      ),
      notes: row.notes,
    );
  }
}

final bodyMetricsRepositoryProvider = Provider<DriftBodyMetricsRepository>((ref) {
  final db = ref.watch(appDatabaseProvider);
  final queue = ref.watch(outboxQueueProvider);
  return DriftBodyMetricsRepository(db, queue);
});
