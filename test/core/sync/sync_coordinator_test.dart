import 'package:flutter_test/flutter_test.dart';
import 'package:fitkarma/core/database/app_database.dart';
import 'package:fitkarma/core/sync/models/outbox_mutation.dart';
import 'package:fitkarma/core/sync/outbox_queue.dart';
import 'package:fitkarma/core/sync/sync_coordinator.dart';
import 'package:fitkarma/core/sync/sync_state.dart';

void main() {
  group('SyncCoordinator Unit Tests', () {
    late AppDatabase db;
    late OutboxQueue queue;
    late SyncCoordinator coordinator;

    setUp(() {
      db = AppDatabase.memory();
      queue = OutboxQueue(db);
      coordinator = SyncCoordinator(queue, initialOnline: true);
    });

    tearDown(() async {
      await db.close();
    });

    test('initial state is SyncIdle when online with empty outbox', () {
      expect(coordinator.state, isA<SyncIdle>());
    });

    test('transitions to SyncOffline when network is dropped', () async {
      final mutation = SyncMutation(
        id: 'm1',
        entityType: 'user_profile',
        operation: OutboxOperation.insert,
        payload: {'name': 'Test'},
        idempotencyKey: 'idemp-1',
        createdAt: DateTime.now(),
      );
      await queue.enqueue(mutation);

      await coordinator.setOnline(false);

      expect(coordinator.state, isA<SyncOffline>());
      final offlineState = coordinator.state as SyncOffline;
      expect(offlineState.pendingCount, equals(1));
    });

    test('triggers sync successfully when online and flushes outbox', () async {
      final mutation = SyncMutation(
        id: 'm1',
        entityType: 'user_profile',
        operation: OutboxOperation.insert,
        payload: {'name': 'Test'},
        idempotencyKey: 'idemp-1',
        createdAt: DateTime.now(),
      );
      await queue.enqueue(mutation);

      bool dispatcherCalled = false;
      coordinator.setDispatcher((mut) async {
        dispatcherCalled = true;
        expect(mut.id, equals('m1'));
      });

      await coordinator.triggerSync();

      expect(dispatcherCalled, isTrue);
      expect(coordinator.state, isA<Synced>());
      final syncedState = coordinator.state as Synced;
      expect(syncedState.itemsSynced, equals(1));

      // Outbox no longer has pending items
      expect(await queue.getPendingCount(), equals(0));
    });

    test('transitions to SyncErrorState on dispatcher failure with backoff', () async {
      final mutation = SyncMutation(
        id: 'm1',
        entityType: 'user_profile',
        operation: OutboxOperation.insert,
        payload: {'name': 'Test'},
        idempotencyKey: 'idemp-1',
        createdAt: DateTime.now(),
      );
      await queue.enqueue(mutation);

      coordinator.setDispatcher((mut) async {
        throw Exception('Network connection refused');
      });

      await coordinator.triggerSync();

      expect(coordinator.state, isA<SyncErrorState>());
      final errorState = coordinator.state as SyncErrorState;
      expect(errorState.message, contains('Network connection refused'));
      expect(errorState.retryAfterSeconds, equals(1)); // 2^(1-1) = 1s
    });

    test('exponential backoff scales predictably and clamps at 60 seconds', () {
      expect(SyncCoordinator.calculateBackoffSeconds(0), equals(0));
      expect(SyncCoordinator.calculateBackoffSeconds(1), equals(1));
      expect(SyncCoordinator.calculateBackoffSeconds(2), equals(2));
      expect(SyncCoordinator.calculateBackoffSeconds(3), equals(4));
      expect(SyncCoordinator.calculateBackoffSeconds(4), equals(8));
      expect(SyncCoordinator.calculateBackoffSeconds(5), equals(16));
      expect(SyncCoordinator.calculateBackoffSeconds(6), equals(32));
      expect(SyncCoordinator.calculateBackoffSeconds(7), equals(60)); // Clamped to 60s
      expect(SyncCoordinator.calculateBackoffSeconds(10), equals(60));
    });

    test('reconnection flushes pending items automatically', () async {
      await coordinator.setOnline(false);

      final mutation = SyncMutation(
        id: 'm1',
        entityType: 'test',
        operation: OutboxOperation.insert,
        payload: {},
        idempotencyKey: 'k1',
        createdAt: DateTime.now(),
      );
      await queue.enqueue(mutation);

      bool flushed = false;
      coordinator.setDispatcher((_) async {
        flushed = true;
      });

      // Turn online
      await coordinator.setOnline(true);

      expect(flushed, isTrue);
      expect(coordinator.state, isA<Synced>());
    });

    test('reportConflict transitions to SyncConflictState', () {
      coordinator.reportConflict('user_profile', 'u123');
      expect(coordinator.state, isA<SyncConflictState>());
      final conflict = coordinator.state as SyncConflictState;
      expect(conflict.entityType, equals('user_profile'));
      expect(conflict.entityId, equals('u123'));
    });
  });
}

