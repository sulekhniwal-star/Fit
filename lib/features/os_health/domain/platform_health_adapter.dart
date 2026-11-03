import '../../health/domain/health_primitives.dart';
import 'health_data_types.dart';

class HealthChangesResult {
  final List<HealthRecordPayload> upsertedRecords;
  final List<String> deletedRecordIds;
  final String nextChangeToken;

  const HealthChangesResult({
    this.upsertedRecords = const [],
    this.deletedRecordIds = const [],
    required this.nextChangeToken,
  });
}

abstract class PlatformHealthAdapter {
  /// Source identifier: either HealthSource.healthConnect or HealthSource.appleHealth
  HealthSource get sourcePlatform;

  /// Checks if the underlying OS health subsystem is available on this device
  Future<bool> isAvailable();

  /// Inspects current authorization state across specified health types
  Future<Map<HealthDataType, HealthPermissionStatus>> getPermissionStatus(Set<HealthDataType> types);

  /// Requests authorization from the user via the OS system dialog
  Future<bool> requestPermissions(Set<HealthDataType> types);

  /// Reads observations for a specific data type within an interval window
  Future<List<HealthRecordPayload>> fetchRecords({
    required HealthDataType type,
    required DateTime startTime,
    required DateTime endTime,
  });

  /// Reads delta changes using an incremental change token
  Future<HealthChangesResult> fetchChanges(String? changeToken);

  /// Revokes granted permissions or resets integration state gracefully
  Future<void> revokePermissions();
}
