import '../../core/errors/result.dart';
import 'models/outbox_mutation.dart';
import 'outbox_queue.dart';

abstract class SyncableRepository<T, ID> {
  final OutboxQueue outboxQueue;

  const SyncableRepository(this.outboxQueue);

  /// Target entity identifier used in outbox records (e.g., 'user_profiles', 'nutrition_logs').
  String get entityType;

  /// Retrieves an entity by its identifier from the local store.
  Future<Result<T>> getLocal(ID id);

  /// Saves an entity locally and enqueues an outbox synchronization mutation atomically.
  Future<Result<void>> saveLocal(T entity);

  /// Deletes an entity locally and enqueues a deletion outbox mutation.
  Future<Result<void>> deleteLocal(ID id);

  /// Pushes a specific outbox mutation to the remote backend.
  Future<Result<void>> pushRemote(SyncMutation mutation);

  /// Pulls remote delta updates since [since] and merges them into the local store.
  Future<Result<int>> pullRemote(DateTime since);
}

