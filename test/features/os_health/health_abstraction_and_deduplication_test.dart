import 'package:flutter_test/flutter_test.dart';
import 'package:fitkarma/features/health/domain/body_metric.dart';
import 'package:fitkarma/features/health/domain/health_primitives.dart';
import 'package:fitkarma/features/health/domain/sleep_record.dart';
import 'package:fitkarma/features/health/domain/step_record.dart';
import 'package:fitkarma/features/os_health/data/mock_platform_health_adapter.dart';
import 'package:fitkarma/features/os_health/domain/biometric_deduplication_engine.dart';
import 'package:fitkarma/features/os_health/domain/health_data_types.dart';

void main() {
  group('Health Types & Payload Tests', () {
    test('HealthRecordPayload serialization and deserialization roundtrip', () {
      final now = DateTime(2026, 3, 15, 10, 0);
      final payload = HealthRecordPayload(
        id: 'rec_steps_101',
        dataType: HealthDataType.steps,
        startTime: now.subtract(const Duration(hours: 1)),
        endTime: now,
        data: {'step_count': 1250},
        source: HealthSource.healthConnect,
        deviceAttribution: 'Pixel Watch 3',
        sourceApp: 'com.google.android.apps.fitness',
        recordedAt: now,
        syncToken: 'token_abc_1',
      );

      final json = payload.toJson();
      final roundtrip = HealthRecordPayload.fromJson(json);

      expect(roundtrip.id, 'rec_steps_101');
      expect(roundtrip.dataType, HealthDataType.steps);
      expect(roundtrip.data['step_count'], 1250);
      expect(roundtrip.source, HealthSource.healthConnect);
      expect(roundtrip.deviceAttribution, 'Pixel Watch 3');
      expect(roundtrip.sourceApp, 'com.google.android.apps.fitness');
      expect(roundtrip.syncToken, 'token_abc_1');
    });
  });

  group('BiometricDeduplicationEngine Tests', () {
    const engine = BiometricDeduplicationEngine();
    final today = DateTime(2026, 3, 15);

    test('deduplicateSteps creates record when no existing step log exists', () {
      final result = engine.deduplicateSteps(
        existing: null,
        incomingSteps: 5000,
        incomingSource: HealthSource.healthConnect,
        date: today,
        userId: 'user_1',
      );

      expect(result.stepCount, 5000);
      expect(result.source, HealthSource.healthConnect);
    });

    test('deduplicateSteps elevates step count if wearable exceeds manual entry', () {
      final manual = StepRecord(
        id: 's_man',
        userId: 'user_1',
        date: today,
        stepCount: 4000,
        source: HealthSource.manual,
      );

      final result = engine.deduplicateSteps(
        existing: manual,
        incomingSteps: 7500,
        incomingSource: HealthSource.healthConnect,
        date: today,
        userId: 'user_1',
      );

      expect(result.stepCount, 7500);
      expect(result.source, HealthSource.healthConnect);
    });

    test('deduplicateSteps preserves manual entry if incoming wearable count is lower', () {
      final manual = StepRecord(
        id: 's_man',
        userId: 'user_1',
        date: today,
        stepCount: 8000,
        source: HealthSource.manual,
      );

      final result = engine.deduplicateSteps(
        existing: manual,
        incomingSteps: 6200,
        incomingSource: HealthSource.healthConnect,
        date: today,
        userId: 'user_1',
      );

      expect(result.stepCount, 8000);
      expect(result.source, HealthSource.manual);
    });

    test('deduplicateSleep merges wearable stages when overlap exceeds 80%', () {
      final manualSleep = SleepRecord(
        id: 'slp_manual',
        userId: 'user_1',
        startTime: DateTime(2026, 3, 14, 23, 0),
        endTime: DateTime(2026, 3, 15, 7, 0),
        durationMinutes: 480,
        qualityRating: 4,
        source: HealthSource.manual,
      );

      final wearableSleep = SleepRecord(
        id: 'slp_watch',
        userId: 'user_1',
        startTime: DateTime(2026, 3, 14, 23, 10),
        endTime: DateTime(2026, 3, 15, 6, 55),
        durationMinutes: 465,
        qualityRating: 3,
        deepSleepMinutes: 110,
        remSleepMinutes: 95,
        source: HealthSource.appleHealth,
      );

      final merged = engine.deduplicateSleep(
        existingRecords: [manualSleep],
        incoming: wearableSleep,
      );

      expect(merged.deepSleepMinutes, 110);
      expect(merged.remSleepMinutes, 95);
      expect(merged.qualityRating, 4); // preserved quality rating
    });

    test('deduplicateSleep preserves distinct afternoon nap as independent record', () {
      final nightSleep = SleepRecord(
        id: 'slp_night',
        userId: 'user_1',
        startTime: DateTime(2026, 3, 14, 23, 0),
        endTime: DateTime(2026, 3, 15, 7, 0),
        durationMinutes: 480,
        qualityRating: 4,
      );

      final afternoonNap = SleepRecord(
        id: 'slp_nap',
        userId: 'user_1',
        startTime: DateTime(2026, 3, 15, 14, 0),
        endTime: DateTime(2026, 3, 15, 14, 45),
        durationMinutes: 45,
        qualityRating: 3,
        source: HealthSource.healthConnect,
      );

      final result = engine.deduplicateSleep(
        existingRecords: [nightSleep],
        incoming: afternoonNap,
      );

      expect(result.id, 'slp_nap');
      expect(result.durationMinutes, 45);
    });

    test('isDuplicateWeight detects duplicate transmission within 15 mins', () {
      final now = DateTime(2026, 3, 15, 8, 30);
      final existingEntry = BodyMetricEntry(
        id: 'bm_1',
        userId: 'user_1',
        metricType: BodyMetricType.weight,
        value: 72.4,
        unit: HealthUnit.kg,
        recordedAt: now,
      );

      // Within 5 minutes, same weight -> duplicate
      final isDup = engine.isDuplicateWeight(
        existingEntries: [existingEntry],
        incomingWeightKg: 72.45,
        timestamp: now.add(const Duration(minutes: 5)),
      );
      expect(isDup, isTrue);

      // 4 hours later -> not duplicate
      final isNotDupTime = engine.isDuplicateWeight(
        existingEntries: [existingEntry],
        incomingWeightKg: 72.4,
        timestamp: now.add(const Duration(hours: 4)),
      );
      expect(isNotDupTime, isFalse);

      // Within 5 minutes, but significantly different weight (e.g. spouse weighed in) -> not duplicate
      final isNotDupWeight = engine.isDuplicateWeight(
        existingEntries: [existingEntry],
        incomingWeightKg: 65.0,
        timestamp: now.add(const Duration(minutes: 2)),
      );
      expect(isNotDupWeight, isFalse);
    });
  });

  group('MockPlatformHealthAdapter Tests', () {
    late MockPlatformHealthAdapter adapter;

    setUp(() {
      adapter = MockPlatformHealthAdapter();
    });

    test('isAvailable and getPermissionStatus report initial states', () async {
      expect(await adapter.isAvailable(), isTrue);
      final perms = await adapter.getPermissionStatus({HealthDataType.steps, HealthDataType.sleep});
      expect(perms[HealthDataType.steps], HealthPermissionStatus.authorized);
      expect(perms[HealthDataType.sleep], HealthPermissionStatus.authorized);
    });

    test('revokePermissions marks permissions denied', () async {
      await adapter.revokePermissions();
      expect(adapter.revokePermissionsCallCount, 1);
      final perms = await adapter.getPermissionStatus({HealthDataType.steps});
      expect(perms[HealthDataType.steps], HealthPermissionStatus.denied);
    });

    test('fetchRecords filters by type and time interval', () async {
      final now = DateTime(2026, 3, 15, 12, 0);
      adapter.recordsMock = [
        HealthRecordPayload(
          id: 'rec_1',
          dataType: HealthDataType.steps,
          startTime: now.subtract(const Duration(hours: 2)),
          endTime: now.subtract(const Duration(hours: 1)),
          data: {'step_count': 1000},
          source: HealthSource.healthConnect,
          recordedAt: now,
        ),
        HealthRecordPayload(
          id: 'rec_old',
          dataType: HealthDataType.steps,
          startTime: now.subtract(const Duration(days: 5)),
          endTime: now.subtract(const Duration(days: 5, hours: -1)),
          data: {'step_count': 2000},
          source: HealthSource.healthConnect,
          recordedAt: now.subtract(const Duration(days: 5)),
        ),
      ];

      final results = await adapter.fetchRecords(
        type: HealthDataType.steps,
        startTime: now.subtract(const Duration(hours: 3)),
        endTime: now,
      );

      expect(results.length, 1);
      expect(results.first.id, 'rec_1');
    });
  });
}
