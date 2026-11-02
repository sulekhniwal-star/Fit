import 'dart:math';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../database/app_database.dart';
import 'models/outbox_mutation.dart';
import 'outbox_queue.dart';
import 'sync_state.dart';

typedef SyncDispatcher = Future<void> Function(SyncMutation mutation);

final outboxQueueProvider = Provider<OutboxQueue>((ref) {
  final db = ref.watch(appDatabaseProvider);
  return OutboxQueue(db);
});

class SyncCoordinator extends StateNotifier<SyncState> {
  final OutboxQueue _queue;
  SyncDispatcher? _dispatcher;
  bool _isOnline;
  int _consecutiveFailures = 0;

  SyncCoordinator(
    this._queue, {
    this._dispatcher,
    bool initialOnline = true,
  })  : _isOnline = initialOnline,
        super(const SyncIdle()) {
    if (!_isOnline) {
      _checkOfflinePending();
    }
  }

  bool get isOnline => _isOnline;
  int get consecutiveFailures => _consecutiveFailures;

  void setDispatcher(SyncDispatcher dispatcher) {
    _dispatcher = dispatcher;
  }

  Future<void> _checkOfflinePending() async {
    final count = await _queue.getPendingCount();
    state = SyncOffline(pendingCount: count);
  }

  /// Sets connectivity state. Reconnection automatically triggers an outbox flush.
  Future<void> setOnline(bool online) async {
    _isOnline = online;
    if (!online) {
      await _checkOfflinePending();
    } else {
      await triggerSync();
    }
  }

  /// Calculates exponential backoff in seconds (2^(failures-1), max 60s).
  static int calculateBackoffSeconds(int failures) {
    if (failures <= 0) return 0;
    final exp = pow(2, failures - 1).toInt();
    return exp.clamp(1, 60);
  }

  /// Triggers outbox synchronization cycle.
  Future<void> triggerSync() async {
    if (!_isOnline) {
      await _checkOfflinePending();
      return;
    }

    if (state is Syncing) return;

    final pending = await _queue.fetchPending();
    if (pending.isEmpty) {
      state = Synced(syncedAt: DateTime.now(), itemsSynced: 0);
      return;
    }

    state = Syncing(pendingCount: pending.length);
    await _queue.markInFlight(pending.map((m) => m.id).toList());

    int syncedCount = 0;
    for (final mutation in pending) {
      try {
        if (_dispatcher != null) {
          await _dispatcher!(mutation);
        }
        await _queue.markCompleted(mutation.id);
        syncedCount++;
      } catch (e) {
        _consecutiveFailures++;
        final backoff = calculateBackoffSeconds(_consecutiveFailures);
        await _queue.markFailed(mutation.id, error: e.toString(), retryable: true);
        state = SyncErrorState(
          message: e.toString(),
          retryAfterSeconds: backoff,
        );
        return;
      }
    }

    _consecutiveFailures = 0;
    state = Synced(syncedAt: DateTime.now(), itemsSynced: syncedCount);
  }

  /// Manually reports a data conflict requiring user reconciliation.
  void reportConflict(String entityType, String entityId) {
    state = SyncConflictState(entityType: entityType, entityId: entityId);
  }
}

final syncCoordinatorProvider = StateNotifierProvider<SyncCoordinator, SyncState>((ref) {
  final queue = ref.watch(outboxQueueProvider);
  return SyncCoordinator(queue);
});

final pendingOutboxCountProvider = FutureProvider<int>((ref) async {
  final queue = ref.watch(outboxQueueProvider);
  return queue.getPendingCount();
});
