// ============================================================================
// DRIFT FASTING REPOSITORY (OFFLINE-FIRST & SYNCABLE)
// ============================================================================

import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/database/app_database.dart';
import '../../../core/errors/failures.dart';
import '../../../core/errors/result.dart';
import '../../../core/sync/models/outbox_mutation.dart';
import '../../../core/sync/outbox_queue.dart';
import '../../../core/sync/sync_coordinator.dart';
import '../../../core/sync/syncable_repository.dart';
import '../domain/fasting_protocol.dart';
import '../domain/fasting_session.dart';

class DriftFastingRepository extends SyncableRepository<FastingSession, String> {
  final AppDatabase _db;

  DriftFastingRepository(this._db, OutboxQueue outboxQueue) : super(outboxQueue);

  @override
  String get entityType => 'fasting_sessions';

  @override
  Future<Result<FastingSession>> getLocal(String id) async {
    try {
      final row = await (_db.select(_db.fastingSessionsTable)..where((tbl) => tbl.id.equals(id))).getSingleOrNull();
      if (row == null) {
        return const Result.failure(ValidationFailure(message: 'Fasting session not found'));
      }
      return Result.success(_fromRow(row));
    } catch (e) {
      return Result.failure(DatabaseFailure('Failed to retrieve fasting session: $e'));
    }
  }

  @override
  Future<Result<void>> saveLocal(FastingSession entity) async {
    try {
      await _db.into(_db.fastingSessionsTable).insertOnConflictUpdate(
            FastingSessionsTableCompanion.insert(
              id: entity.id,
              userId: entity.userId,
              protocolType: entity.protocolType.name,
              startTime: entity.startTime,
              plannedEndTime: entity.plannedEndTime,
              actualEndTime: Value(entity.actualEndTime),
              status: Value(entity.status.name),
              isWaterless: Value(entity.isWaterless),
              hydrationReminders: Value(entity.hydrationRemindersEnabled),
              notes: Value(entity.notes),
              createdAt: entity.createdAt,
              updatedAt: entity.updatedAt,
            ),
          );

      final mutation = SyncMutation(
        id: 'mut_fast_${entity.id}_${DateTime.now().microsecondsSinceEpoch}',
        entityType: entityType,
        operation: OutboxOperation.insert,
        payload: entity.toJson(),
        idempotencyKey: 'fast_${entity.id}_${entity.updatedAt.millisecondsSinceEpoch}_${DateTime.now().microsecondsSinceEpoch}',
        createdAt: DateTime.now(),
      );

      await outboxQueue.enqueue(mutation);
      return const Result.success(null);
    } catch (e) {
      return Result.failure(DatabaseFailure('Failed to save fasting session: $e'));
    }
  }

  @override
  Future<Result<void>> deleteLocal(String id) async {
    try {
      await (_db.delete(_db.fastingSessionsTable)..where((tbl) => tbl.id.equals(id))).go();

      final mutation = SyncMutation(
        id: 'mut_del_fast_${id}_${DateTime.now().microsecondsSinceEpoch}',
        entityType: entityType,
        operation: OutboxOperation.delete,
        payload: {'id': id},
        idempotencyKey: 'del_fast_${id}_${DateTime.now().microsecondsSinceEpoch}',
        createdAt: DateTime.now(),
      );

      await outboxQueue.enqueue(mutation);
      return const Result.success(null);
    } catch (e) {
      return Result.failure(DatabaseFailure('Failed to delete fasting session: $e'));
    }
  }

  @override
  Future<Result<void>> pushRemote(SyncMutation mutation) async => const Result.success(null);

  @override
  Future<Result<int>> pullRemote(DateTime since) async => const Result.success(0);

  Future<Result<FastingSession?>> getActiveSession(String userId) async {
    try {
      final query = _db.select(_db.fastingSessionsTable)
        ..where((tbl) => tbl.userId.equals(userId) & tbl.status.equals('active'))
        ..orderBy([(tbl) => OrderingTerm.desc(tbl.startTime)])
        ..limit(1);

      final row = await query.getSingleOrNull();
      if (row == null) return const Result.success(null);
      return Result.success(_fromRow(row));
    } catch (e) {
      return Result.failure(DatabaseFailure('Failed to fetch active fasting session: $e'));
    }
  }

  Stream<FastingSession?> watchActiveSession(String userId) {
    final query = _db.select(_db.fastingSessionsTable)
      ..where((tbl) => tbl.userId.equals(userId) & tbl.status.equals('active'))
      ..orderBy([(tbl) => OrderingTerm.desc(tbl.startTime)])
      ..limit(1);

    return query.watchSingleOrNull().map((row) => row != null ? _fromRow(row) : null);
  }

  Future<Result<FastingSession>> startSession(FastingSession session) async {
    // 1. Cancel any currently active sessions for the user
    final activeResult = await getActiveSession(session.userId);
    final existing = activeResult.dataOrNull;
    if (existing != null) {
      await cancelSession(existing.id);
    }

    // 2. Save new active session
    final saveRes = await saveLocal(session);
    if (saveRes.isFailure) {
      return Result.failure(saveRes.failureOrNull!);
    }
    return Result.success(session);
  }

  Future<Result<FastingSession>> completeSession(String sessionId, {DateTime? endTime}) async {
    final getRes = await getLocal(sessionId);
    if (getRes.isFailure) {
      return Result.failure(getRes.failureOrNull!);
    }
    final session = getRes.dataOrNull!;
    final completed = session.copyWith(
      status: FastingSessionStatus.completed,
      actualEndTime: endTime ?? DateTime.now(),
      updatedAt: DateTime.now(),
    );
    final saveRes = await saveLocal(completed);
    if (saveRes.isFailure) {
      return Result.failure(saveRes.failureOrNull!);
    }
    return Result.success(completed);
  }

  Future<Result<void>> cancelSession(String sessionId) async {
    final getRes = await getLocal(sessionId);
    if (getRes.isFailure) {
      return Result.failure(getRes.failureOrNull!);
    }
    final session = getRes.dataOrNull!;
    final cancelled = session.copyWith(
      status: FastingSessionStatus.cancelled,
      actualEndTime: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    return saveLocal(cancelled);
  }

  Future<Result<List<FastingSession>>> getSessionHistory(String userId, {int limit = 20}) async {
    try {
      final query = _db.select(_db.fastingSessionsTable)
        ..where((tbl) => tbl.userId.equals(userId))
        ..orderBy([(tbl) => OrderingTerm.desc(tbl.startTime)])
        ..limit(limit);

      final rows = await query.get();
      return Result.success(rows.map(_fromRow).toList());
    } catch (e) {
      return Result.failure(DatabaseFailure('Failed to fetch fasting history: $e'));
    }
  }

  FastingSession _fromRow(FastingSessionsTableData row) {
    return FastingSession(
      id: row.id,
      userId: row.userId,
      protocolType: FastingProtocolType.values.byName(row.protocolType),
      startTime: row.startTime,
      plannedEndTime: row.plannedEndTime,
      actualEndTime: row.actualEndTime,
      status: FastingSessionStatus.values.byName(row.status),
      isWaterless: row.isWaterless,
      hydrationRemindersEnabled: row.hydrationReminders,
      notes: row.notes,
      createdAt: row.createdAt,
      updatedAt: row.updatedAt,
    );
  }
}

final fastingRepositoryProvider = Provider<DriftFastingRepository>((ref) {
  final db = ref.watch(appDatabaseProvider);
  final outbox = ref.watch(outboxQueueProvider);
  return DriftFastingRepository(db, outbox);
});
