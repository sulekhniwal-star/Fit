import 'package:flutter_test/flutter_test.dart';
import 'package:fitkarma/core/database/app_database.dart';
import 'package:fitkarma/core/sync/models/outbox_mutation.dart';
import 'package:fitkarma/core/sync/outbox_queue.dart';

void main() {
  group('OutboxQueue Unit Tests', () {
    late AppDatabase db;
    late OutboxQueue queue;

    setUp(() {
      db = AppDatabase.memory();
      queue = OutboxQueue(db);
    });

    tearDown(() async {
      await db.close();
    });

    test('enqueue stores mutation and rejects duplicate idempotencyKey', () async {
      final mutation = SyncMutation(
        id: 'mut-1',
        entityType: 'user_profiles',
        operation: OutboxOperation.insert,
        payload: {'name': 'Aarav', 'age': 28},
        idempotencyKey: 'idemp-001',
        createdAt: DateTime.now(),
      );

      await queue.enqueue(mutation);
      expect(await queue.getPendingCount(), equals(1));

      // Attempt to enqueue identical idempotency key with different id
      final duplicate = mutation.copyWith(id: 'mut-2');
      await queue.enqueue(duplicate);

      // Count remains 1 due to idempotency deduplication
      expect(await queue.getPendingCount(), equals(1));
    });

    test('fetchPending returns mutations in chronological order', () async {
      final now = DateTime.now();
      final m1 = SyncMutation(
        id: 'm1',
        entityType: 't1',
        operation: OutboxOperation.insert,
        payload: {},
        idempotencyKey: 'k1',
        createdAt: now.subtract(const Duration(minutes: 5)),
      );
      final m2 = SyncMutation(
        id: 'm2',
        entityType: 't1',
        operation: OutboxOperation.update,
        payload: {},
        idempotencyKey: 'k2',
        createdAt: now.subtract(const Duration(minutes: 1)),
      );

      await queue.enqueue(m2);
      await queue.enqueue(m1);

      final pending = await queue.fetchPending();
      expect(pending.length, equals(2));
      expect(pending.first.id, equals('m1'));
      expect(pending.last.id, equals('m2'));
    });

    test('markInFlight updates status and fetchPending ignores in_flight', () async {
      final mutation = SyncMutation(
        id: 'm1',
        entityType: 't1',
        operation: OutboxOperation.insert,
        payload: {},
        idempotencyKey: 'k1',
        createdAt: DateTime.now(),
      );
      await queue.enqueue(mutation);

      await queue.markInFlight(['m1']);
      final pending = await queue.fetchPending();
      expect(pending, isEmpty);

      // Pending count includes in_flight items
      expect(await queue.getPendingCount(), equals(1));
    });

    test('markFailed increments retry count and sets failed when exceeding limit', () async {
      final mutation = SyncMutation(
        id: 'm1',
        entityType: 't1',
        operation: OutboxOperation.insert,
        payload: {},
        idempotencyKey: 'k1',
        createdAt: DateTime.now(),
      );
      await queue.enqueue(mutation);

      // First retryable failure -> status pending, retryCount = 1
      await queue.markFailed('m1', error: 'Connection timeout', retryable: true, maxRetries: 2);
      var pending = await queue.fetchPending();
      expect(pending.length, equals(1));
      expect(pending.first.retryCount, equals(1));

      // Second retryable failure -> reaches maxRetries (2) -> status failed
      await queue.markFailed('m1', error: 'Connection timeout', retryable: true, maxRetries: 2);
      pending = await queue.fetchPending();
      expect(pending, isEmpty); // No longer in pending state
    });

    test('resetInFlightToPending resets orphaned in_flight records on startup', () async {
      final mutation = SyncMutation(
        id: 'm1',
        entityType: 't1',
        operation: OutboxOperation.insert,
        payload: {},
        idempotencyKey: 'k1',
        createdAt: DateTime.now(),
      );
      await queue.enqueue(mutation);
      await queue.markInFlight(['m1']);

      // Before reset
      expect(await queue.fetchPending(), isEmpty);

      // Reset
      final resetCount = await queue.resetInFlightToPending();
      expect(resetCount, equals(1));

      // After reset
      final pending = await queue.fetchPending();
      expect(pending.length, equals(1));
      expect(pending.first.id, equals('m1'));
    });

    test('markCompleted and purgeCompleted clears finished items', () async {
      final mutation = SyncMutation(
        id: 'm1',
        entityType: 't1',
        operation: OutboxOperation.insert,
        payload: {},
        idempotencyKey: 'k1',
        createdAt: DateTime.now(),
      );
      await queue.enqueue(mutation);

      await queue.markCompleted('m1');
      expect(await queue.getPendingCount(), equals(0));

      final purged = await queue.purgeCompleted();
      expect(purged, equals(1));
    });
  });
}
