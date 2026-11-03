/// Contract boundary for local persistence (Drift + SQLCipher).
abstract interface class LocalDatabaseContract {
  Future<void> initialize();
  Future<void> close();
  Future<void> clearAllData();
  bool get isOpen;
}

