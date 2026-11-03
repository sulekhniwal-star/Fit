import 'package:flutter/services.dart';
import '../../health/domain/health_primitives.dart';
import '../domain/health_data_types.dart';
import '../domain/platform_health_adapter.dart';

class HealthConnectAdapter implements PlatformHealthAdapter {
  static const MethodChannel _channel = MethodChannel('fitkarma/health_connect');

  final MethodChannel? overrideChannel;

  HealthConnectAdapter({this.overrideChannel});

  MethodChannel get _activeChannel => overrideChannel ?? _channel;

  @override
  HealthSource get sourcePlatform => HealthSource.healthConnect;

  @override
  Future<bool> isAvailable() async {
    try {
      final available = await _activeChannel.invokeMethod<bool>('isAvailable');
      return available ?? false;
    } on MissingPluginException {
      return false;
    } catch (_) {
      return false;
    }
  }

  @override
  Future<Map<HealthDataType, HealthPermissionStatus>> getPermissionStatus(Set<HealthDataType> types) async {
    final Map<HealthDataType, HealthPermissionStatus> statuses = {};
    try {
      final res = await _activeChannel.invokeMapMethod<String, String>(
        'getPermissionStatus',
        {'types': types.map((t) => t.name).toList()},
      );

      for (final type in types) {
        final raw = res?[type.name];
        statuses[type] = _mapStatus(raw);
      }
    } on PlatformException catch (e) {
      // SecurityException or permission rejection handled gracefully
      for (final type in types) {
        statuses[type] = e.code == 'SECURITY_EXCEPTION'
            ? HealthPermissionStatus.denied
            : HealthPermissionStatus.unsupported;
      }
    } catch (_) {
      for (final type in types) {
        statuses[type] = HealthPermissionStatus.notDetermined;
      }
    }
    return statuses;
  }

  @override
  Future<bool> requestPermissions(Set<HealthDataType> types) async {
    try {
      final granted = await _activeChannel.invokeMethod<bool>(
        'requestPermissions',
        {'types': types.map((t) => t.name).toList()},
      );
      return granted ?? false;
    } on PlatformException {
      return false;
    } catch (_) {
      return false;
    }
  }

  @override
  Future<List<HealthRecordPayload>> fetchRecords({
    required HealthDataType type,
    required DateTime startTime,
    required DateTime endTime,
  }) async {
    try {
      final rawRecords = await _activeChannel.invokeListMethod<Map<dynamic, dynamic>>(
        'fetchRecords',
        {
          'type': type.name,
          'startTime': startTime.toIso8601String(),
          'endTime': endTime.toIso8601String(),
        },
      );

      if (rawRecords == null) return [];

      return rawRecords.map((r) => _mapRawToPayload(Map<String, dynamic>.from(r), type)).toList();
    } on PlatformException {
      return [];
    } catch (_) {
      return [];
    }
  }

  @override
  Future<HealthChangesResult> fetchChanges(String? changeToken) async {
    try {
      final res = await _activeChannel.invokeMapMethod<String, dynamic>(
        'fetchChanges',
        {'changeToken': changeToken},
      );

      if (res == null) {
        return const HealthChangesResult(nextChangeToken: '');
      }

      final rawUpserted = res['upserted'] as List<dynamic>? ?? [];
      final deletedIds = (res['deleted'] as List<dynamic>? ?? []).cast<String>();
      final nextToken = res['nextChangeToken'] as String? ?? '';

      final upserted = rawUpserted.map((item) {
        final map = Map<String, dynamic>.from(item as Map);
        final rawType = map['data_type'] as String? ?? 'steps';
        final type = HealthDataType.values.firstWhere(
          (t) => t.name == rawType,
          orElse: () => HealthDataType.steps,
        );
        return _mapRawToPayload(map, type);
      }).toList();

      return HealthChangesResult(
        upsertedRecords: upserted,
        deletedRecordIds: deletedIds,
        nextChangeToken: nextToken,
      );
    } catch (_) {
      return const HealthChangesResult(nextChangeToken: '');
    }
  }

  @override
  Future<void> revokePermissions() async {
    try {
      await _activeChannel.invokeMethod<void>('revokePermissions');
    } catch (_) {
      // Ignored: best-effort reset
    }
  }

  HealthPermissionStatus _mapStatus(String? raw) {
    switch (raw) {
      case 'authorized':
        return HealthPermissionStatus.authorized;
      case 'denied':
        return HealthPermissionStatus.denied;
      case 'partiallyAuthorized':
        return HealthPermissionStatus.partiallyAuthorized;
      case 'unsupported':
        return HealthPermissionStatus.unsupported;
      default:
        return HealthPermissionStatus.notDetermined;
    }
  }

  HealthRecordPayload _mapRawToPayload(Map<String, dynamic> raw, HealthDataType type) {
    final start = DateTime.tryParse(raw['startTime'] as String? ?? '') ?? DateTime.now();
    final end = DateTime.tryParse(raw['endTime'] as String? ?? '') ?? start;
    final recordedAt = DateTime.tryParse(raw['recordedAt'] as String? ?? '') ?? end;

    return HealthRecordPayload(
      id: raw['id'] as String? ?? 'hc_${DateTime.now().millisecondsSinceEpoch}',
      dataType: type,
      startTime: start,
      endTime: end,
      data: Map<String, dynamic>.from(raw['data'] as Map? ?? {}),
      source: HealthSource.healthConnect,
      deviceAttribution: raw['deviceAttribution'] as String?,
      sourceApp: raw['sourceApp'] as String?,
      recordedAt: recordedAt,
      syncToken: raw['syncToken'] as String?,
    );
  }
}
