import 'dart:io' show Platform;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../health/data/drift_body_metrics_repository.dart';
import '../../health/data/drift_health_repositories.dart';
import '../../health/data/drift_vitals_repositories.dart';
import '../../health/domain/body_metric.dart';
import '../../health/domain/health_primitives.dart';
import '../../health/domain/sleep_record.dart';
import '../../health/domain/vital_record.dart';
import '../domain/biometric_deduplication_engine.dart';
import '../domain/health_data_types.dart';
import '../domain/platform_health_adapter.dart';
import 'apple_health_adapter.dart';
import 'health_connect_adapter.dart';
import 'mock_platform_health_adapter.dart';

class HealthSyncSummary {
  final int syncedSteps;
  final int syncedSleep;
  final int syncedVitals;
  final int syncedWeight;
  final DateTime timestamp;

  const HealthSyncSummary({
    this.syncedSteps = 0,
    this.syncedSleep = 0,
    this.syncedVitals = 0,
    this.syncedWeight = 0,
    required this.timestamp,
  });

  int get totalRecords => syncedSteps + syncedSleep + syncedVitals + syncedWeight;
}

class HealthIntegrationStatus {
  final bool isAvailable;
  final bool isConnected;
  final HealthSource platformSource;
  final DateTime? lastSyncTime;
  final Map<HealthDataType, HealthPermissionStatus> permissions;

  const HealthIntegrationStatus({
    required this.isAvailable,
    required this.isConnected,
    required this.platformSource,
    this.lastSyncTime,
    this.permissions = const {},
  });
}

class HealthIntegrationService {
  final PlatformHealthAdapter adapter;
  final DriftStepRepository stepRepo;
  final DriftSleepRepository sleepRepo;
  final DriftVitalsRepository vitalsRepo;
  final DriftBodyMetricsRepository bodyMetricsRepo;
  final BiometricDeduplicationEngine deduplicationEngine;

  DateTime? _lastSyncTime;

  HealthIntegrationService({
    required this.adapter,
    required this.stepRepo,
    required this.sleepRepo,
    required this.vitalsRepo,
    required this.bodyMetricsRepo,
    this.deduplicationEngine = const BiometricDeduplicationEngine(),
  });

  DateTime? get lastSyncTime => _lastSyncTime;

  Future<bool> isPlatformAvailable() => adapter.isAvailable();

  Future<Map<HealthDataType, HealthPermissionStatus>> checkPermissions([Set<HealthDataType>? types]) {
    final targetTypes = types ?? HealthDataType.values.toSet();
    return adapter.getPermissionStatus(targetTypes);
  }

  Future<bool> requestPermissions(Set<HealthDataType> types) => adapter.requestPermissions(types);

  Future<void> disconnect() async {
    await adapter.revokePermissions();
    _lastSyncTime = null;
  }

  Future<HealthIntegrationStatus> getStatus() async {
    final available = await adapter.isAvailable();
    final perms = await adapter.getPermissionStatus(HealthDataType.values.toSet());
    final hasAnyAuthorized =
        perms.values.any((HealthPermissionStatus s) => s == HealthPermissionStatus.authorized);

    return HealthIntegrationStatus(
      isAvailable: available,
      isConnected: hasAnyAuthorized,
      platformSource: adapter.sourcePlatform,
      lastSyncTime: _lastSyncTime,
      permissions: perms,
    );
  }

  /// Ingests external observations into local SQLite tables via the DeduplicationEngine
  Future<HealthSyncSummary> syncHealthData({
    required String userId,
    DateTime? since,
  }) async {
    final perms = await adapter.getPermissionStatus(HealthDataType.values.toSet());
    final now = DateTime.now();
    final startTime = since ?? now.subtract(const Duration(days: 7));

    int stepsCount = 0;
    int sleepCount = 0;
    int vitalsCount = 0;
    int weightCount = 0;

    // 1. Ingest Steps
    if (perms[HealthDataType.steps]?.isAuthorized == true) {
      final stepPayloads = await adapter.fetchRecords(
        type: HealthDataType.steps,
        startTime: startTime,
        endTime: now,
      );

      // Group steps by date
      final Map<DateTime, int> dailySteps = {};
      for (final p in stepPayloads) {
        final d = DateTime(p.startTime.year, p.startTime.month, p.startTime.day);
        final count = (p.data['step_count'] as num?)?.toInt() ?? 0;
        dailySteps[d] = (dailySteps[d] ?? 0) + count;
      }

      for (final entry in dailySteps.entries) {
        final date = entry.key;
        final incomingCount = entry.value;

        final existingRes = await stepRepo.getForDate(userId, date);
        final existing = existingRes.dataOrNull;

        final resolved = deduplicationEngine.deduplicateSteps(
          existing: existing,
          incomingSteps: incomingCount,
          incomingSource: adapter.sourcePlatform,
          date: date,
          userId: userId,
        );

        await stepRepo.saveLocal(resolved);
        stepsCount++;
      }
    }

    // 2. Ingest Sleep
    if (perms[HealthDataType.sleep]?.isAuthorized == true) {
      final sleepPayloads = await adapter.fetchRecords(
        type: HealthDataType.sleep,
        startTime: startTime,
        endTime: now,
      );

      final historyRes = await sleepRepo.getHistory(userId, limit: 30);
      final existingSleep = historyRes.dataOrNull ?? [];

      for (final p in sleepPayloads) {
        final duration = (p.data['duration_minutes'] as num?)?.toInt() ??
            p.endTime.difference(p.startTime).inMinutes;

        final sleepIncoming = SleepRecord(
          id: p.id,
          userId: userId,
          startTime: p.startTime,
          endTime: p.endTime,
          durationMinutes: duration,
          qualityRating: (p.data['quality_rating'] as num?)?.toInt() ?? 3,
          deepSleepMinutes: (p.data['deep_sleep_minutes'] as num?)?.toInt(),
          remSleepMinutes: (p.data['rem_sleep_minutes'] as num?)?.toInt(),
          source: adapter.sourcePlatform,
        );

        final resolvedSleep = deduplicationEngine.deduplicateSleep(
          existingRecords: existingSleep,
          incoming: sleepIncoming,
        );

        await sleepRepo.saveLocal(resolvedSleep);
        sleepCount++;
      }
    }

    // 3. Ingest Weight
    if (perms[HealthDataType.weight]?.isAuthorized == true) {
      final weightPayloads = await adapter.fetchRecords(
        type: HealthDataType.weight,
        startTime: startTime,
        endTime: now,
      );

      final historyRes = await bodyMetricsRepo.getHistory(
        userId: userId,
        metricType: BodyMetricType.weight,
        startDate: startTime,
      );
      final existingWeights = historyRes.dataOrNull ?? [];

      for (final p in weightPayloads) {
        final weightKg = (p.data['weight_kg'] as num?)?.toDouble() ?? 0.0;
        if (weightKg <= 0.0) continue;

        final isDup = deduplicationEngine.isDuplicateWeight(
          existingEntries: existingWeights,
          incomingWeightKg: weightKg,
          timestamp: p.recordedAt,
        );

        if (!isDup) {
          final entry = BodyMetricEntry(
            id: p.id,
            userId: userId,
            metricType: BodyMetricType.weight,
            value: weightKg,
            unit: HealthUnit.kg,
            recordedAt: p.recordedAt,
            source: adapter.sourcePlatform,
          );
          await bodyMetricsRepo.saveLocal(entry);
          weightCount++;
        }
      }
    }

    // 4. Ingest Heart Rate / Vitals
    if (perms[HealthDataType.heartRate]?.isAuthorized == true) {
      final hrPayloads = await adapter.fetchRecords(
        type: HealthDataType.heartRate,
        startTime: startTime,
        endTime: now,
      );

      for (final p in hrPayloads) {
        final pulse = (p.data['pulse'] as num?)?.toInt();
        if (pulse != null && pulse > 0) {
          final vital = VitalRecord(
            id: p.id,
            userId: userId,
            recordedAt: p.recordedAt,
            vitalType: VitalType.bloodPressure,
            pulse: pulse,
            source: adapter.sourcePlatform,
          );
          await vitalsRepo.saveLocal(vital);
          vitalsCount++;
        }
      }
    }

    _lastSyncTime = now;

    return HealthSyncSummary(
      syncedSteps: stepsCount,
      syncedSleep: sleepCount,
      syncedVitals: vitalsCount,
      syncedWeight: weightCount,
      timestamp: now,
    );
  }
}

final platformHealthAdapterProvider = Provider<PlatformHealthAdapter>((ref) {
  try {
    if (Platform.isAndroid) {
      return HealthConnectAdapter();
    } else if (Platform.isIOS) {
      return AppleHealthAdapter();
    }
  } catch (_) {
    // Non-mobile platforms (Windows, Linux, macOS dev) fallback cleanly to Mock
  }
  return MockPlatformHealthAdapter();
});

final healthIntegrationServiceProvider = Provider<HealthIntegrationService>((ref) {
  final adapter = ref.watch(platformHealthAdapterProvider);
  final stepRepo = ref.watch(stepRepositoryProvider);
  final sleepRepo = ref.watch(sleepRepositoryProvider);
  final vitalsRepo = ref.watch(vitalsRepositoryProvider);
  final bodyMetricsRepo = ref.watch(bodyMetricsRepositoryProvider);

  return HealthIntegrationService(
    adapter: adapter,
    stepRepo: stepRepo,
    sleepRepo: sleepRepo,
    vitalsRepo: vitalsRepo,
    bodyMetricsRepo: bodyMetricsRepo,
  );
});
