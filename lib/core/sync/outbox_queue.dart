import 'dart:convert';
import 'package:drift/drift.dart';
import '../database/app_database.dart';
import 'models/outbox_mutation.dart';

class OutboxQueue {
  final AppDatabase _db;

  const OutboxQueue(this._db);

  /// Enqueues a mutation. If an identical [idempotencyKey] is already recorded,
  /// the mutation is ignored to guarantee idempotent write-safety.
  Future<void> enqueue(SyncMutation mutation) async {
    final existing = await (_db.select(_db.outboxMutations)
          ..where((tbl) => tbl.idempotencyKey.equals(mutation.idempotencyKey)))
        .getSingleOrNull();

    if (existing != null) {
      return; // Deduplicated
    }

    await _db.into(_db.outboxMutations).insert(
          OutboxMutationsCompanion.insert(
            id: mutation.id,
            entityType: mutation.entityType,
            operationType: mutation.operation.name,
            payloadJson: mutation.payloadJson,
            idempotencyKey: mutation.idempotencyKey,
            createdAt: mutation.createdAt,
            retryCount: Value(mutation.retryCount),
            status: Value(mutation.status.name),
            lastError: Value(mutation.lastError),
            dependencyId: Value(mutation.dependencyId),
          ),
        );
  }

  /// Fetches pending mutations ordered by creation time.
  Future<List<SyncMutation>> fetchPending({int limit = 50}) async {
    final rows = await (_db.select(_db.outboxMutations)
          ..where((tbl) => tbl.status.equals(OutboxStatus.pending.name))
          ..orderBy([(tbl) => OrderingTerm.asc(tbl.createdAt)])
          ..limit(limit))
        .get();

    return rows.map(_fromRow).toList();
  }

  /// Transitions mutations to in_flight status before network dispatch.
  Future<void> markInFlight(List<String> ids) async {
    if (ids.isEmpty) return;
    await (_db.update(_db.outboxMutations)..where((tbl) => tbl.id.isIn(ids))).write(
      OutboxMutationsCompanion(
        status: Value(OutboxStatus.inFlight.name),
      ),
    );
  }

  /// Marks a successfully processed mutation as completed.
  Future<void> markCompleted(String id) async {
    await (_db.update(_db.outboxMutations)..where((tbl) => tbl.id.equals(id))).write(
      OutboxMutationsCompanion(
        status: Value(OutboxStatus.completed.name),
      ),
    );
  }

  /// Records mutation failure, increments retry count, and handles permanent failure limits.
  Future<void> markFailed(
    String id, {
    required String error,
    bool retryable = true,
    int maxRetries = 5,
  }) async {
    final existing = await (_db.select(_db.outboxMutations)..where((tbl) => tbl.id.equals(id)))
        .getSingleOrNull();
    if (existing == null) return;

    final newRetryCount = existing.retryCount + 1;
    final isPermanent = !retryable || newRetryCount >= maxRetries;
    final nextStatus = isPermanent ? OutboxStatus.failed : OutboxStatus.pending;

    await (_db.update(_db.outboxMutations)..where((tbl) => tbl.id.equals(id))).write(
      OutboxMutationsCompanion(
        retryCount: Value(newRetryCount),
        status: Value(nextStatus.name),
        lastError: Value(error),
      ),
    );
  }

  /// Startup recovery: Resets in_flight mutations to pending if app was terminated mid-sync.
  Future<int> resetInFlightToPending() async {
    return (_db.update(_db.outboxMutations)
          ..where((tbl) => tbl.status.equals(OutboxStatus.inFlight.name)))
        .write(
      OutboxMutationsCompanion(
        status: Value(OutboxStatus.pending.name),
      ),
    );
  }

  /// Returns total count of pending and in-flight mutations.
  Future<int> getPendingCount() async {
    final count = await (_db.selectOnly(_db.outboxMutations)
          ..addColumns([_db.outboxMutations.id.count()])
          ..where(_db.outboxMutations.status.isIn([
            OutboxStatus.pending.name,
            OutboxStatus.inFlight.name,
          ])))
        .getSingle();

    return count.read(_db.outboxMutations.id.count()) ?? 0;
  }

  /// Purges all completed mutations from local storage.
  Future<int> purgeCompleted() async {
    return (_db.delete(_db.outboxMutations)
          ..where((tbl) => tbl.status.equals(OutboxStatus.completed.name)))
        .go();
  }

  SyncMutation _fromRow(OutboxMutation row) {
    return SyncMutation(
      id: row.id,
      entityType: row.entityType,
      operation: OutboxOperation.values.firstWhere(
        (o) => o.name == row.operationType,
        orElse: () => OutboxOperation.insert,
      ),
      payload: jsonDecode(row.payloadJson) as Map<String, dynamic>,
      idempotencyKey: row.idempotencyKey,
      createdAt: row.createdAt,
      retryCount: row.retryCount,
      status: OutboxStatus.values.firstWhere(
        (s) => s.name == row.status,
        orElse: () => OutboxStatus.pending,
      ),
      lastError: row.lastError,
      dependencyId: row.dependencyId,
    );
  }
}
