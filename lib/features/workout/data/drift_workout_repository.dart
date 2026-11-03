import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/database/app_database.dart';
import '../../../core/errors/failures.dart';
import '../../../core/errors/result.dart';
import '../../../core/sync/models/outbox_mutation.dart';
import '../../../core/sync/outbox_queue.dart';
import '../../../core/sync/sync_coordinator.dart';
import '../../../core/sync/syncable_repository.dart';
import '../domain/exercise.dart';
import '../domain/workout_session.dart';
import '../domain/workout_set.dart';

class DriftWorkoutRepository extends SyncableRepository<WorkoutSession, String> {
  final AppDatabase _db;

  DriftWorkoutRepository(this._db, OutboxQueue outboxQueue) : super(outboxQueue);

  @override
  String get entityType => 'workout_sessions';

  @override
  Future<Result<WorkoutSession>> getLocal(String id) async {
    try {
      final sessionRow = await (_db.select(_db.workoutSessionsTable)
            ..where((tbl) => tbl.id.equals(id)))
          .getSingleOrNull();

      if (sessionRow == null) {
        return const Result.failure(DatabaseFailure('Workout session not found'));
      }

      final setRows = await (_db.select(_db.workoutSetsTable)
            ..where((tbl) => tbl.sessionId.equals(id))
            ..orderBy([(tbl) => OrderingTerm.asc(tbl.setNumber)]))
          .get();

      final sets = setRows.map(_mapSetRow).toList();
      return Result.success(_mapSessionRow(sessionRow, sets));
    } catch (e) {
      return Result.failure(DatabaseFailure('Failed to get workout session: $e'));
    }
  }

  @override
  Future<Result<void>> saveLocal(WorkoutSession entity) async {
    if (!entity.isValid) {
      return const Result.failure(ValidationFailure(message: 'Invalid workout session values'));
    }

    try {
      final computedVol = entity.computeTotalVolume();
      final duration = entity.computeDurationSeconds();
      final calories = entity.estimateCaloriesBurned();

      await _db.into(_db.workoutSessionsTable).insertOnConflictUpdate(
            WorkoutSessionsTableCompanion.insert(
              id: entity.id,
              userId: entity.userId,
              title: entity.title,
              workoutType: entity.workoutType.name,
              startedAt: entity.startedAt,
              endedAt: Value(entity.endedAt),
              totalVolumeKg: Value(computedVol),
              durationSeconds: Value(duration),
              caloriesBurned: Value(calories),
              status: Value(entity.status.name),
              notes: Value(entity.notes),
            ),
          );

      if (entity.sets.isNotEmpty) {
        await _db.batch((batch) {
          batch.insertAllOnConflictUpdate(
            _db.workoutSetsTable,
            entity.sets.map((s) => WorkoutSetsTableCompanion.insert(
                  id: s.id,
                  sessionId: entity.id,
                  exerciseId: s.exerciseId,
                  exerciseName: s.exerciseName,
                  setNumber: s.setNumber,
                  weightKg: Value(s.weightKg),
                  reps: Value(s.reps),
                  isWarmup: Value(s.isWarmup),
                  isCompleted: Value(s.isCompleted),
                  rpe: Value(s.rpe),
                  completedAt: Value(s.completedAt),
                )),
          );
        });
      }

      return const Result.success(null);
    } catch (e) {
      return Result.failure(DatabaseFailure('Failed to save workout session: $e'));
    }
  }

  /// Incremental set update: persists single set and recalculates session volume immediately
  Future<Result<void>> saveSet(WorkoutSet set) async {
    if (!set.isValid) {
      return const Result.failure(ValidationFailure(message: 'Invalid workout set values'));
    }

    try {
      await _db.into(_db.workoutSetsTable).insertOnConflictUpdate(
            WorkoutSetsTableCompanion.insert(
              id: set.id,
              sessionId: set.sessionId,
              exerciseId: set.exerciseId,
              exerciseName: set.exerciseName,
              setNumber: set.setNumber,
              weightKg: Value(set.weightKg),
              reps: Value(set.reps),
              isWarmup: Value(set.isWarmup),
              isCompleted: Value(set.isCompleted),
              rpe: Value(set.rpe),
              completedAt: Value(set.completedAt),
            ),
          );

      // Recalculate session volume
      final setRows = await (_db.select(_db.workoutSetsTable)
            ..where((tbl) => tbl.sessionId.equals(set.sessionId)))
          .get();

      final sets = setRows.map(_mapSetRow).toList();
      final totalVol = sets
          .where((s) => s.isCompleted && !s.isWarmup)
          .fold<double>(0.0, (sum, s) => sum + s.volumeKg);

      await (_db.update(_db.workoutSessionsTable)
            ..where((tbl) => tbl.id.equals(set.sessionId)))
          .write(WorkoutSessionsTableCompanion(
        totalVolumeKg: Value(totalVol),
      ));

      return const Result.success(null);
    } catch (e) {
      return Result.failure(DatabaseFailure('Failed to save set: $e'));
    }
  }

  /// Deletes a set from a session
  Future<Result<void>> deleteSet(String setId, String sessionId) async {
    try {
      await (_db.delete(_db.workoutSetsTable)..where((tbl) => tbl.id.equals(setId))).go();
      return const Result.success(null);
    } catch (e) {
      return Result.failure(DatabaseFailure('Failed to delete set: $e'));
    }
  }

  /// Finds active in-progress workout session for user if one exists
  Future<Result<WorkoutSession?>> getActiveSession(String userId) async {
    try {
      final sessionRow = await (_db.select(_db.workoutSessionsTable)
            ..where((tbl) => tbl.userId.equals(userId) & tbl.status.equals(WorkoutSessionStatus.inProgress.name))
            ..orderBy([(tbl) => OrderingTerm.desc(tbl.startedAt)])
            ..limit(1))
          .getSingleOrNull();

      if (sessionRow == null) {
        return const Result.success(null);
      }

      final setRows = await (_db.select(_db.workoutSetsTable)
            ..where((tbl) => tbl.sessionId.equals(sessionRow.id))
            ..orderBy([(tbl) => OrderingTerm.asc(tbl.setNumber)]))
          .get();

      final sets = setRows.map(_mapSetRow).toList();
      return Result.success(_mapSessionRow(sessionRow, sets));
    } catch (e) {
      return Result.failure(DatabaseFailure('Failed to check active workout session: $e'));
    }
  }

  /// Gets recent completed or in-progress workouts for history and progression analytics
  Future<Result<List<WorkoutSession>>> getRecentSessions(String userId, {int limit = 30}) async {
    try {
      final sessionRows = await (_db.select(_db.workoutSessionsTable)
            ..where((tbl) => tbl.userId.equals(userId))
            ..orderBy([(tbl) => OrderingTerm.desc(tbl.startedAt)])
            ..limit(limit))
          .get();

      final List<WorkoutSession> results = [];
      for (final sRow in sessionRows) {
        final setRows = await (_db.select(_db.workoutSetsTable)
              ..where((tbl) => tbl.sessionId.equals(sRow.id))
              ..orderBy([(tbl) => OrderingTerm.asc(tbl.setNumber)]))
            .get();
        results.add(_mapSessionRow(sRow, setRows.map(_mapSetRow).toList()));
      }

      return Result.success(results);
    } catch (e) {
      return Result.failure(DatabaseFailure('Failed to fetch recent workout sessions: $e'));
    }
  }

  /// Completes session, updates totals, and dispatches sync mutation
  Future<Result<WorkoutSession>> completeSession(
    String sessionId, {
    DateTime? endedAt,
    String? notes,
  }) async {
    final getRes = await getLocal(sessionId);
    if (getRes.isFailure) return Result.failure(getRes.failureOrNull!);

    final session = getRes.dataOrNull!;
    final finish = endedAt ?? DateTime.now();
    final duration = finish.difference(session.startedAt).inSeconds.clamp(0, 86400 * 7);
    final volume = session.computeTotalVolume();
    final calories = (duration / 60.0 * 6.0).clamp(0.0, 3000.0);

    final completedSession = session.copyWith(
      endedAt: finish,
      status: WorkoutSessionStatus.completed,
      durationSeconds: duration,
      totalVolumeKg: volume,
      caloriesBurned: calories,
      notes: notes ?? session.notes,
    );

    // Save locally and enqueue mutation
    final saveRes = await saveLocal(completedSession);
    if (saveRes.isFailure) return Result.failure(saveRes.failureOrNull!);

    final mutation = SyncMutation(
      id: 'mut_workout_${completedSession.id}',
      entityType: entityType,
      operation: OutboxOperation.insert,
      payload: completedSession.toJson(),
      idempotencyKey: 'mut_workout_${completedSession.id}',
      createdAt: DateTime.now(),
    );
    await outboxQueue.enqueue(mutation);

    return Result.success(completedSession);
  }

  @override
  Future<Result<void>> deleteLocal(String id) async {
    try {
      await (_db.delete(_db.workoutSetsTable)..where((tbl) => tbl.sessionId.equals(id))).go();
      await (_db.delete(_db.workoutSessionsTable)..where((tbl) => tbl.id.equals(id))).go();

      final mutation = SyncMutation(
        id: 'mut_del_workout_$id',
        entityType: entityType,
        operation: OutboxOperation.delete,
        payload: {'id': id},
        idempotencyKey: 'del_workout_${id}_${DateTime.now().millisecondsSinceEpoch}',
        createdAt: DateTime.now(),
      );
      await outboxQueue.enqueue(mutation);
      return const Result.success(null);
    } catch (e) {
      return Result.failure(DatabaseFailure('Failed to delete workout: $e'));
    }
  }

  @override
  Future<Result<void>> pushRemote(SyncMutation mutation) async => const Result.success(null);

  @override
  Future<Result<int>> pullRemote(DateTime since) async => const Result.success(0);

  /// Discards an in-progress session
  Future<Result<void>> discardSession(String sessionId) async {
    try {
      await (_db.update(_db.workoutSessionsTable)
            ..where((tbl) => tbl.id.equals(sessionId)))
          .write(WorkoutSessionsTableCompanion(
        status: Value(WorkoutSessionStatus.discarded.name),
      ));
      return const Result.success(null);
    } catch (e) {
      return Result.failure(DatabaseFailure('Failed to discard session: $e'));
    }
  }

  WorkoutSession _mapSessionRow(WorkoutSessionsTableData row, List<WorkoutSet> sets) {
    return WorkoutSession(
      id: row.id,
      userId: row.userId,
      title: row.title,
      workoutType: WorkoutType.values.firstWhere(
        (w) => w.name == row.workoutType,
        orElse: () => WorkoutType.strength,
      ),
      startedAt: row.startedAt,
      endedAt: row.endedAt,
      sets: sets,
      totalVolumeKg: row.totalVolumeKg,
      durationSeconds: row.durationSeconds,
      caloriesBurned: row.caloriesBurned,
      status: WorkoutSessionStatus.values.firstWhere(
        (s) => s.name == row.status,
        orElse: () => WorkoutSessionStatus.inProgress,
      ),
      notes: row.notes,
    );
  }

  WorkoutSet _mapSetRow(WorkoutSetsTableData row) {
    return WorkoutSet(
      id: row.id,
      sessionId: row.sessionId,
      exerciseId: row.exerciseId,
      exerciseName: row.exerciseName,
      setNumber: row.setNumber,
      weightKg: row.weightKg,
      reps: row.reps,
      isWarmup: row.isWarmup,
      isCompleted: row.isCompleted,
      rpe: row.rpe,
      completedAt: row.completedAt,
    );
  }
}

final workoutRepositoryProvider = Provider<DriftWorkoutRepository>((ref) {
  final db = ref.watch(appDatabaseProvider);
  final outbox = ref.watch(outboxQueueProvider);
  return DriftWorkoutRepository(db, outbox);
});
