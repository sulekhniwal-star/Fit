import 'dart:convert';
import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/database/app_database.dart';
import '../../../core/errors/failures.dart';
import '../../../core/errors/result.dart';
import '../../../core/sync/models/outbox_mutation.dart';
import '../../../core/sync/outbox_queue.dart';
import '../../../core/sync/sync_coordinator.dart';
import '../../../core/sync/syncable_repository.dart';
import '../domain/health_primitives.dart';
import '../domain/mood_log.dart';
import '../domain/sleep_record.dart';
import '../domain/step_record.dart';
import '../domain/water_log.dart';

// --- STEP REPOSITORY ---
class DriftStepRepository extends SyncableRepository<StepRecord, String> {
  final AppDatabase _db;
  DriftStepRepository(this._db, OutboxQueue outboxQueue) : super(outboxQueue);

  @override
  String get entityType => 'step_records';

  @override
  Future<Result<StepRecord>> getLocal(String id) async {
    final row = await (_db.select(_db.stepRecordsTable)..where((tbl) => tbl.id.equals(id))).getSingleOrNull();
    if (row == null) return const Result.failure(ValidationFailure(message: 'Step record not found'));
    return Result.success(_fromRow(row));
  }

  @override
  Future<Result<void>> saveLocal(StepRecord entity) async {
    await _db.into(_db.stepRecordsTable).insertOnConflictUpdate(
          StepRecordsTableCompanion.insert(
            id: entity.id,
            userId: entity.userId,
            date: entity.date,
            stepCount: entity.stepCount,
            goal: Value(entity.goal),
            source: Value(entity.source.name),
          ),
        );

    final mutation = SyncMutation(
      id: 'mut_step_${entity.id}',
      entityType: entityType,
      operation: OutboxOperation.insert,
      payload: entity.toJson(),
      idempotencyKey: 'steps_${entity.userId}_${entity.date.millisecondsSinceEpoch}',
      createdAt: DateTime.now(),
    );
    await outboxQueue.enqueue(mutation);
    return const Result.success(null);
  }

  @override
  Future<Result<void>> deleteLocal(String id) async {
    await (_db.delete(_db.stepRecordsTable)..where((tbl) => tbl.id.equals(id))).go();
    return const Result.success(null);
  }

  Future<Result<StepRecord?>> getForDate(String userId, DateTime date) async {
    final startOfDay = DateTime(date.year, date.month, date.day);
    final endOfDay = DateTime(date.year, date.month, date.day, 23, 59, 59);

    final row = await (_db.select(_db.stepRecordsTable)
          ..where((tbl) => tbl.userId.equals(userId) & tbl.date.isBetweenValues(startOfDay, endOfDay)))
        .getSingleOrNull();

    return Result.success(row != null ? _fromRow(row) : null);
  }

  @override
  Future<Result<void>> pushRemote(SyncMutation mutation) async => const Result.success(null);

  @override
  Future<Result<int>> pullRemote(DateTime since) async => const Result.success(0);

  StepRecord _fromRow(StepRecordsTableData row) {
    return StepRecord(
      id: row.id,
      userId: row.userId,
      date: row.date,
      stepCount: row.stepCount,
      goal: row.goal,
      source: HealthSource.values.firstWhere((s) => s.name == row.source, orElse: () => HealthSource.manual),
    );
  }
}

// --- SLEEP REPOSITORY ---
class DriftSleepRepository extends SyncableRepository<SleepRecord, String> {
  final AppDatabase _db;
  DriftSleepRepository(this._db, OutboxQueue outboxQueue) : super(outboxQueue);

  @override
  String get entityType => 'sleep_records';

  @override
  Future<Result<SleepRecord>> getLocal(String id) async {
    final row = await (_db.select(_db.sleepRecordsTable)..where((tbl) => tbl.id.equals(id))).getSingleOrNull();
    if (row == null) return const Result.failure(ValidationFailure(message: 'Sleep record not found'));
    return Result.success(_fromRow(row));
  }

  @override
  Future<Result<void>> saveLocal(SleepRecord entity) async {
    await _db.into(_db.sleepRecordsTable).insertOnConflictUpdate(
          SleepRecordsTableCompanion.insert(
            id: entity.id,
            userId: entity.userId,
            startTime: entity.startTime,
            endTime: entity.endTime,
            durationMinutes: entity.durationMinutes,
            qualityRating: Value(entity.qualityRating),
            deepSleepMinutes: Value(entity.deepSleepMinutes),
            remSleepMinutes: Value(entity.remSleepMinutes),
            source: Value(entity.source.name),
          ),
        );

    final mutation = SyncMutation(
      id: 'mut_sleep_${entity.id}',
      entityType: entityType,
      operation: OutboxOperation.insert,
      payload: entity.toJson(),
      idempotencyKey: 'sleep_${entity.userId}_${entity.startTime.millisecondsSinceEpoch}',
      createdAt: DateTime.now(),
    );
    await outboxQueue.enqueue(mutation);
    return const Result.success(null);
  }

  @override
  Future<Result<void>> deleteLocal(String id) async {
    await (_db.delete(_db.sleepRecordsTable)..where((tbl) => tbl.id.equals(id))).go();
    return const Result.success(null);
  }

  Future<Result<List<SleepRecord>>> getHistory(String userId, {int limit = 7}) async {
    final rows = await (_db.select(_db.sleepRecordsTable)
          ..where((tbl) => tbl.userId.equals(userId))
          ..orderBy([(tbl) => OrderingTerm.desc(tbl.endTime)])
          ..limit(limit))
        .get();

    return Result.success(rows.map(_fromRow).toList());
  }

  @override
  Future<Result<void>> pushRemote(SyncMutation mutation) async => const Result.success(null);

  @override
  Future<Result<int>> pullRemote(DateTime since) async => const Result.success(0);

  SleepRecord _fromRow(SleepRecordsTableData row) {
    return SleepRecord(
      id: row.id,
      userId: row.userId,
      startTime: row.startTime,
      endTime: row.endTime,
      durationMinutes: row.durationMinutes,
      qualityRating: row.qualityRating,
      deepSleepMinutes: row.deepSleepMinutes,
      remSleepMinutes: row.remSleepMinutes,
      source: HealthSource.values.firstWhere((s) => s.name == row.source, orElse: () => HealthSource.manual),
    );
  }
}

// --- WATER REPOSITORY ---
class DriftWaterRepository extends SyncableRepository<WaterLog, String> {
  final AppDatabase _db;
  DriftWaterRepository(this._db, OutboxQueue outboxQueue) : super(outboxQueue);

  @override
  String get entityType => 'water_logs';

  @override
  Future<Result<WaterLog>> getLocal(String id) async {
    final row = await (_db.select(_db.waterLogsTable)..where((tbl) => tbl.id.equals(id))).getSingleOrNull();
    if (row == null) return const Result.failure(ValidationFailure(message: 'Water log not found'));
    return Result.success(_fromRow(row));
  }

  @override
  Future<Result<void>> saveLocal(WaterLog entity) async {
    await _db.into(_db.waterLogsTable).insertOnConflictUpdate(
          WaterLogsTableCompanion.insert(
            id: entity.id,
            userId: entity.userId,
            recordedAt: entity.recordedAt,
            amountMl: entity.amountMl,
            dailyGoalMl: Value(entity.dailyGoalMl),
          ),
        );

    final mutation = SyncMutation(
      id: 'mut_water_${entity.id}',
      entityType: entityType,
      operation: OutboxOperation.insert,
      payload: entity.toJson(),
      idempotencyKey: 'water_${entity.userId}_${entity.recordedAt.millisecondsSinceEpoch}',
      createdAt: DateTime.now(),
    );
    await outboxQueue.enqueue(mutation);
    return const Result.success(null);
  }

  @override
  Future<Result<void>> deleteLocal(String id) async {
    await (_db.delete(_db.waterLogsTable)..where((tbl) => tbl.id.equals(id))).go();
    return const Result.success(null);
  }

  Future<Result<int>> getDailyTotalMl(String userId, DateTime date) async {
    final startOfDay = DateTime(date.year, date.month, date.day);
    final endOfDay = DateTime(date.year, date.month, date.day, 23, 59, 59);

    final rows = await (_db.select(_db.waterLogsTable)
          ..where((tbl) => tbl.userId.equals(userId) & tbl.recordedAt.isBetweenValues(startOfDay, endOfDay)))
        .get();

    final total = rows.fold<int>(0, (sum, row) => sum + row.amountMl);
    return Result.success(total);
  }

  @override
  Future<Result<void>> pushRemote(SyncMutation mutation) async => const Result.success(null);

  @override
  Future<Result<int>> pullRemote(DateTime since) async => const Result.success(0);

  WaterLog _fromRow(WaterLogsTableData row) {
    return WaterLog(
      id: row.id,
      userId: row.userId,
      recordedAt: row.recordedAt,
      amountMl: row.amountMl,
      dailyGoalMl: row.dailyGoalMl,
    );
  }
}

// --- MOOD REPOSITORY ---
class DriftMoodRepository extends SyncableRepository<MoodLog, String> {
  final AppDatabase _db;
  DriftMoodRepository(this._db, OutboxQueue outboxQueue) : super(outboxQueue);

  @override
  String get entityType => 'mood_logs';

  @override
  Future<Result<MoodLog>> getLocal(String id) async {
    final row = await (_db.select(_db.moodLogsTable)..where((tbl) => tbl.id.equals(id))).getSingleOrNull();
    if (row == null) return const Result.failure(ValidationFailure(message: 'Mood log not found'));
    return Result.success(_fromRow(row));
  }

  @override
  Future<Result<void>> saveLocal(MoodLog entity) async {
    await _db.into(_db.moodLogsTable).insertOnConflictUpdate(
          MoodLogsTableCompanion.insert(
            id: entity.id,
            userId: entity.userId,
            recordedAt: entity.recordedAt,
            moodScore: entity.mood.score,
            notes: Value(entity.note),
            tagsJson: Value(entity.tagsJson),
          ),
        );

    final mutation = SyncMutation(
      id: 'mut_mood_${entity.id}',
      entityType: entityType,
      operation: OutboxOperation.insert,
      payload: entity.toJson(),
      idempotencyKey: 'mood_${entity.userId}_${entity.recordedAt.millisecondsSinceEpoch}',
      createdAt: DateTime.now(),
    );
    await outboxQueue.enqueue(mutation);
    return const Result.success(null);
  }

  @override
  Future<Result<void>> deleteLocal(String id) async {
    await (_db.delete(_db.moodLogsTable)..where((tbl) => tbl.id.equals(id))).go();
    return const Result.success(null);
  }

  Future<Result<MoodLog?>> getLatest(String userId) async {
    final row = await (_db.select(_db.moodLogsTable)
          ..where((tbl) => tbl.userId.equals(userId))
          ..orderBy([(tbl) => OrderingTerm.desc(tbl.recordedAt)])
          ..limit(1))
        .getSingleOrNull();

    return Result.success(row != null ? _fromRow(row) : null);
  }

  @override
  Future<Result<void>> pushRemote(SyncMutation mutation) async => const Result.success(null);

  @override
  Future<Result<int>> pullRemote(DateTime since) async => const Result.success(0);

  MoodLog _fromRow(MoodLogsTableData row) {
    List<String> tags = [];
    if (row.tagsJson != null && row.tagsJson!.isNotEmpty) {
      try {
        tags = (jsonDecode(row.tagsJson!) as List<dynamic>).map((e) => e.toString()).toList();
      } catch (_) {}
    }

    return MoodLog(
      id: row.id,
      userId: row.userId,
      recordedAt: row.recordedAt,
      mood: MoodState.fromScore(row.moodScore),
      note: row.notes,
      tags: tags,
    );
  }
}

// Providers
final stepRepositoryProvider = Provider<DriftStepRepository>((ref) {
  final db = ref.watch(appDatabaseProvider);
  final queue = ref.watch(outboxQueueProvider);
  return DriftStepRepository(db, queue);
});

final sleepRepositoryProvider = Provider<DriftSleepRepository>((ref) {
  final db = ref.watch(appDatabaseProvider);
  final queue = ref.watch(outboxQueueProvider);
  return DriftSleepRepository(db, queue);
});

final waterRepositoryProvider = Provider<DriftWaterRepository>((ref) {
  final db = ref.watch(appDatabaseProvider);
  final queue = ref.watch(outboxQueueProvider);
  return DriftWaterRepository(db, queue);
});

final moodRepositoryProvider = Provider<DriftMoodRepository>((ref) {
  final db = ref.watch(appDatabaseProvider);
  final queue = ref.watch(outboxQueueProvider);
  return DriftMoodRepository(db, queue);
});
