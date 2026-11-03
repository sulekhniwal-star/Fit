/// Contract boundary for the offline-first sync engine and outbox processor.
abstract interface class SyncEngineContract {
  Future<void> enqueueOutboxOperation({
    required String operationId,
    required String entityType,
    required Map<String, dynamic> payload,
  });

  Future<void> processOutbox();
  Stream<bool> get isSyncingStream;
}
