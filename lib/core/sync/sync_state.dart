sealed class SyncState {
  const SyncState();
}

class SyncIdle extends SyncState {
  final DateTime? lastSyncedAt;
  const SyncIdle({this.lastSyncedAt});
}

class SyncOffline extends SyncState {
  final int pendingCount;
  const SyncOffline({this.pendingCount = 0});
}

class Syncing extends SyncState {
  final int pendingCount;
  const Syncing({required this.pendingCount});
}

class Synced extends SyncState {
  final DateTime syncedAt;
  final int itemsSynced;
  const Synced({required this.syncedAt, this.itemsSynced = 0});
}

class SyncErrorState extends SyncState {
  final String message;
  final int retryAfterSeconds;
  final bool isPermanent;

  const SyncErrorState({
    required this.message,
    this.retryAfterSeconds = 0,
    this.isPermanent = false,
  });
}

class SyncConflictState extends SyncState {
  final String entityType;
  final String entityId;
  const SyncConflictState({required this.entityType, required this.entityId});
}
