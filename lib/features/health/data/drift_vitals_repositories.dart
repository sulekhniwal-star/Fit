import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/database/app_database.dart';
import '../../../core/errors/failures.dart';
import '../../../core/errors/result.dart';
import '../../../core/sync/models/outbox_mutation.dart';
import '../../../core/sync/outbox_queue.dart';
import '../../../core/sync/sync_coordinator.dart';
import '../../../core/sync/syncable_repository.dart';
import '../domain/habit_entry.dart';
import '../domain/health_primitives.dart';
import '../domain/medication_entry.dart';
import '../domain/vital_record.dart';

// --- VITALS REPOSITORY ---
class DriftVitalsRepository extends SyncableRepository<VitalRecord, String> {
  final AppDatabase _db;

  DriftVitalsRepository(this._db, OutboxQueue outboxQueue) : super(outboxQueue);

  @override
  String get entityType => 'vital_records';

  @override
  Future<Result<VitalRecord>> getLocal(String id) async {
    final row = await (_db.select(_db.vitalRecordsTable)..where((tbl) => tbl.id.equals(id))).getSingleOrNull();
    if (row == null) return const Result.failure(ValidationFailure(message: 'Vital record not found'));
    return Result.success(_fromRow(row));
  }

  @override
  Future<Result<void>> saveLocal(VitalRecord entity) async {
    if (!entity.isValid) {
      return const Result.failure(ValidationFailure(message: 'Vital values are outside acceptable physiological limits.'));
    }

    await _db.into(_db.vitalRecordsTable).insertOnConflictUpdate(
          VitalRecordsTableCompanion.insert(
            id: entity.id,
            userId: entity.userId,
            recordedAt: entity.recordedAt,
            vitalType: entity.vitalType.name,
            systolic: Value(entity.systolic),
            diastolic: Value(entity.diastolic),
            pulse: Value(entity.pulse),
            glucoseMgDl: Value(entity.glucoseMgDl),
            contextTag: Value(entity.contextTag),
            source: Value(entity.source.name),
          ),
        );

    final mutation = SyncMutation(
      id: 'mut_vital_${entity.id}',
      entityType: entityType,
      operation: OutboxOperation.insert,
      payload: entity.toJson(),
      idempotencyKey: 'vital_${entity.userId}_${entity.recordedAt.millisecondsSinceEpoch}',
      createdAt: DateTime.now(),
    );

    await outboxQueue.enqueue(mutation);
    return const Result.success(null);
  }

  @override
  Future<Result<void>> deleteLocal(String id) async {
    await (_db.delete(_db.vitalRecordsTable)..where((tbl) => tbl.id.equals(id))).go();
    return const Result.success(null);
  }

  Future<Result<List<VitalRecord>>> getRecent(String userId, {int limit = 10}) async {
    final rows = await (_db.select(_db.vitalRecordsTable)
          ..where((tbl) => tbl.userId.equals(userId))
          ..orderBy([(tbl) => OrderingTerm.desc(tbl.recordedAt)])
          ..limit(limit))
        .get();

    return Result.success(rows.map(_fromRow).toList());
  }

  @override
  Future<Result<void>> pushRemote(SyncMutation mutation) async => const Result.success(null);

  @override
  Future<Result<int>> pullRemote(DateTime since) async => const Result.success(0);

  VitalRecord _fromRow(VitalRecordsTableData row) {
    return VitalRecord(
      id: row.id,
      userId: row.userId,
      recordedAt: row.recordedAt,
      vitalType: VitalType.values.firstWhere((v) => v.name == row.vitalType, orElse: () => VitalType.bloodPressure),
      systolic: row.systolic,
      diastolic: row.diastolic,
      pulse: row.pulse,
      glucoseMgDl: row.glucoseMgDl,
      contextTag: row.contextTag,
      source: HealthSource.values.firstWhere((s) => s.name == row.source, orElse: () => HealthSource.manual),
    );
  }
}

// --- MEDICATION REPOSITORY ---
class DriftMedicationRepository extends SyncableRepository<MedicationEntry, String> {
  final AppDatabase _db;

  DriftMedicationRepository(this._db, OutboxQueue outboxQueue) : super(outboxQueue);

  @override
  String get entityType => 'medication_entries';

  @override
  Future<Result<MedicationEntry>> getLocal(String id) async {
    final row = await (_db.select(_db.medicationEntriesTable)..where((tbl) => tbl.id.equals(id))).getSingleOrNull();
    if (row == null) return const Result.failure(ValidationFailure(message: 'Medication entry not found'));
    return Result.success(_fromRow(row));
  }

  @override
  Future<Result<void>> saveLocal(MedicationEntry entity) async {
    await _db.into(_db.medicationEntriesTable).insertOnConflictUpdate(
          MedicationEntriesTableCompanion.insert(
            id: entity.id,
            userId: entity.userId,
            name: entity.name,
            dosage: entity.dosage,
            timeOfDay: entity.timeOfDay.name,
            status: Value(entity.status.name),
            scheduledDate: entity.scheduledDate,
          ),
        );

    final mutation = SyncMutation(
      id: 'mut_med_${entity.id}',
      entityType: entityType,
      operation: OutboxOperation.insert,
      payload: entity.toJson(),
      idempotencyKey: 'med_${entity.userId}_${entity.scheduledDate.millisecondsSinceEpoch}',
      createdAt: DateTime.now(),
    );

    await outboxQueue.enqueue(mutation);
    return const Result.success(null);
  }

  @override
  Future<Result<void>> deleteLocal(String id) async {
    await (_db.delete(_db.medicationEntriesTable)..where((tbl) => tbl.id.equals(id))).go();
    return const Result.success(null);
  }

  Future<Result<List<MedicationEntry>>> getForDay(String userId, DateTime date) async {
    final startOfDay = DateTime(date.year, date.month, date.day);
    final endOfDay = DateTime(date.year, date.month, date.day, 23, 59, 59);

    final rows = await (_db.select(_db.medicationEntriesTable)
          ..where((tbl) => tbl.userId.equals(userId) & tbl.scheduledDate.isBetweenValues(startOfDay, endOfDay)))
        .get();

    return Result.success(rows.map(_fromRow).toList());
  }

  @override
  Future<Result<void>> pushRemote(SyncMutation mutation) async => const Result.success(null);

  @override
  Future<Result<int>> pullRemote(DateTime since) async => const Result.success(0);

  MedicationEntry _fromRow(MedicationEntriesTableData row) {
    return MedicationEntry(
      id: row.id,
      userId: row.userId,
      name: row.name,
      dosage: row.dosage,
      timeOfDay: MedicationTimeOfDay.values.firstWhere((t) => t.name == row.timeOfDay, orElse: () => MedicationTimeOfDay.morning),
      status: MedicationStatus.values.firstWhere((s) => s.name == row.status, orElse: () => MedicationStatus.scheduled),
      scheduledDate: row.scheduledDate,
    );
  }
}

// --- HABITS REPOSITORY ---
class DriftHabitsRepository extends SyncableRepository<HabitEntry, String> {
  final AppDatabase _db;

  DriftHabitsRepository(this._db, OutboxQueue outboxQueue) : super(outboxQueue);

  @override
  String get entityType => 'habit_entries';

  @override
  Future<Result<HabitEntry>> getLocal(String id) async {
    final row = await (_db.select(_db.habitEntriesTable)..where((tbl) => tbl.id.equals(id))).getSingleOrNull();
    if (row == null) return const Result.failure(ValidationFailure(message: 'Habit not found'));
    return Result.success(_fromRow(row));
  }

  @override
  Future<Result<void>> saveLocal(HabitEntry entity) async {
    await _db.into(_db.habitEntriesTable).insertOnConflictUpdate(
          HabitEntriesTableCompanion.insert(
            id: entity.id,
            userId: entity.userId,
            title: entity.title,
            frequency: Value(entity.frequency),
            targetDays: Value(entity.targetDays),
            currentStreak: Value(entity.currentStreak),
            bestStreak: Value(entity.bestStreak),
            lastCompletedAt: Value(entity.lastCompletedAt),
          ),
        );

    final mutation = SyncMutation(
      id: 'mut_habit_${entity.id}',
      entityType: entityType,
      operation: OutboxOperation.insert,
      payload: entity.toJson(),
      idempotencyKey: 'habit_${entity.id}_${DateTime.now().millisecondsSinceEpoch}',
      createdAt: DateTime.now(),
    );

    await outboxQueue.enqueue(mutation);
    return const Result.success(null);
  }

  @override
  Future<Result<void>> deleteLocal(String id) async {
    await (_db.delete(_db.habitEntriesTable)..where((tbl) => tbl.id.equals(id))).go();
    return const Result.success(null);
  }

  Future<Result<List<HabitEntry>>> getAll(String userId) async {
    final rows = await (_db.select(_db.habitEntriesTable)..where((tbl) => tbl.userId.equals(userId))).get();
    return Result.success(rows.map(_fromRow).toList());
  }

  @override
  Future<Result<void>> pushRemote(SyncMutation mutation) async => const Result.success(null);

  @override
  Future<Result<int>> pullRemote(DateTime since) async => const Result.success(0);

  HabitEntry _fromRow(HabitEntriesTableData row) {
    return HabitEntry(
      id: row.id,
      userId: row.userId,
      title: row.title,
      frequency: row.frequency,
      targetDays: row.targetDays,
      currentStreak: row.currentStreak,
      bestStreak: row.bestStreak,
      lastCompletedAt: row.lastCompletedAt,
    );
  }
}

// Providers
final vitalsRepositoryProvider = Provider<DriftVitalsRepository>((ref) {
  final db = ref.watch(appDatabaseProvider);
  final queue = ref.watch(outboxQueueProvider);
  return DriftVitalsRepository(db, queue);
});

final medicationRepositoryProvider = Provider<DriftMedicationRepository>((ref) {
  final db = ref.watch(appDatabaseProvider);
  final queue = ref.watch(outboxQueueProvider);
  return DriftMedicationRepository(db, queue);
});

final habitsRepositoryProvider = Provider<DriftHabitsRepository>((ref) {
  final db = ref.watch(appDatabaseProvider);
  final queue = ref.watch(outboxQueueProvider);
  return DriftHabitsRepository(db, queue);
});
