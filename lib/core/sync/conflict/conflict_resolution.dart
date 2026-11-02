enum ConflictResolutionChoice {
  keepClient,
  keepServer,
  merge,
}

class ConflictData<T> {
  final String entityType;
  final String entityId;
  final T clientVersion;
  final T serverVersion;
  final DateTime clientTimestamp;
  final DateTime serverTimestamp;

  const ConflictData({
    required this.entityType,
    required this.entityId,
    required this.clientVersion,
    required this.serverVersion,
    required this.clientTimestamp,
    required this.serverTimestamp,
  });
}

class ConflictResolver {
  const ConflictResolver();

  /// Resolves conflict according to the selected user choice without silent overwriting.
  T resolve<T>({
    required ConflictData<T> conflict,
    required ConflictResolutionChoice choice,
    T Function(T client, T server)? customMergeStrategy,
  }) {
    switch (choice) {
      case ConflictResolutionChoice.keepClient:
        return conflict.clientVersion;
      case ConflictResolutionChoice.keepServer:
        return conflict.serverVersion;
      case ConflictResolutionChoice.merge:
        if (customMergeStrategy != null) {
          return customMergeStrategy(conflict.clientVersion, conflict.serverVersion);
        }
        return conflict.clientVersion;
    }
  }
}
