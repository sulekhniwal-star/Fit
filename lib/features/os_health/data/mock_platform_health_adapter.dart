import '../../health/domain/health_primitives.dart';
import '../domain/health_data_types.dart';
import '../domain/platform_health_adapter.dart';

class MockPlatformHealthAdapter implements PlatformHealthAdapter {
  @override
  final HealthSource sourcePlatform;
  bool isAvailableMock;
  Map<HealthDataType, HealthPermissionStatus> permissionsMock;
  List<HealthRecordPayload> recordsMock;
  HealthChangesResult? changesMock;

  Set<HealthDataType>? lastRequestedPermissions;
  int fetchRecordsCallCount = 0;
  int revokePermissionsCallCount = 0;

  MockPlatformHealthAdapter({
    this.sourcePlatform = HealthSource.healthConnect,
    this.isAvailableMock = true,
    Map<HealthDataType, HealthPermissionStatus>? initialPermissions,
    this.recordsMock = const [],
    this.changesMock,
  }) : permissionsMock = initialPermissions ??
            {
              for (final type in HealthDataType.values) type: HealthPermissionStatus.authorized,
            };

  @override
  Future<bool> isAvailable() async => isAvailableMock;

  @override
  Future<Map<HealthDataType, HealthPermissionStatus>> getPermissionStatus(Set<HealthDataType> types) async {
    return {
      for (final type in types) type: permissionsMock[type] ?? HealthPermissionStatus.notDetermined,
    };
  }

  @override
  Future<bool> requestPermissions(Set<HealthDataType> types) async {
    lastRequestedPermissions = types;
    for (final type in types) {
      permissionsMock[type] = HealthPermissionStatus.authorized;
    }
    return true;
  }

  @override
  Future<List<HealthRecordPayload>> fetchRecords({
    required HealthDataType type,
    required DateTime startTime,
    required DateTime endTime,
  }) async {
    fetchRecordsCallCount++;
    return recordsMock
        .where((r) =>
            r.dataType == type &&
            !r.startTime.isBefore(startTime) &&
            !r.endTime.isAfter(endTime))
        .toList();
  }

  @override
  Future<HealthChangesResult> fetchChanges(String? changeToken) async {
    return changesMock ??
        const HealthChangesResult(
          upsertedRecords: [],
          deletedRecordIds: [],
          nextChangeToken: 'token_mock_123',
        );
  }

  @override
  Future<void> revokePermissions() async {
    revokePermissionsCallCount++;
    for (final type in HealthDataType.values) {
      permissionsMock[type] = HealthPermissionStatus.denied;
    }
  }
}
