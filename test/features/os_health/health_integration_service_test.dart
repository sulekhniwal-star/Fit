import 'package:flutter_test/flutter_test.dart';
import 'package:fitkarma/core/database/app_database.dart';
import 'package:fitkarma/core/sync/outbox_queue.dart';
import 'package:fitkarma/features/health/data/drift_body_metrics_repository.dart';
import 'package:fitkarma/features/health/data/drift_health_repositories.dart';
import 'package:fitkarma/features/health/data/drift_vitals_repositories.dart';
import 'package:fitkarma/features/health/domain/body_metric.dart';
import 'package:fitkarma/features/health/domain/health_primitives.dart';
import 'package:fitkarma/features/health/domain/step_record.dart';
import 'package:fitkarma/features/os_health/data/health_integration_service.dart';
import 'package:fitkarma/features/os_health/data/mock_platform_health_adapter.dart';
import 'package:fitkarma/features/os_health/domain/health_data_types.dart';

void main() {
  group('HealthIntegrationService Integration Tests', () {
    late AppDatabase db;
    late OutboxQueue outbox;
    late DriftStepRepository stepRepo;
    late DriftSleepRepository sleepRepo;
    late DriftVitalsRepository vitalsRepo;
    late DriftBodyMetricsRepository bodyMetricsRepo;
    late MockPlatformHealthAdapter mockAdapter;
    late HealthIntegrationService service;

    const testUserId = 'user_os_sync_1';

    setUp(() {
      db = AppDatabase.memory();
      outbox = OutboxQueue(db);
      stepRepo = DriftStepRepository(db, outbox);
      sleepRepo = DriftSleepRepository(db, outbox);
      vitalsRepo = DriftVitalsRepository(db, outbox);
      bodyMetricsRepo = DriftBodyMetricsRepository(db, outbox);

      mockAdapter = MockPlatformHealthAdapter();
      service = HealthIntegrationService(
        adapter: mockAdapter,
        stepRepo: stepRepo,
        sleepRepo: sleepRepo,
        vitalsRepo: vitalsRepo,
        bodyMetricsRepo: bodyMetricsRepo,
      );
    });

    tearDown(() async {
      await db.close();
    });

    test('syncHealthData ingests steps, sleep, weight, and vitals into Drift tables', () async {
      final now = DateTime.now();

      // Configure mock observations
      mockAdapter.recordsMock = [
        HealthRecordPayload(
          id: 'ext_step_1',
          dataType: HealthDataType.steps,
          startTime: now.subtract(const Duration(hours: 3)),
          endTime: now.subtract(const Duration(hours: 2)),
          data: {'step_count': 6400},
          source: HealthSource.healthConnect,
          recordedAt: now,
        ),
        HealthRecordPayload(
          id: 'ext_sleep_1',
          dataType: HealthDataType.sleep,
          startTime: now.subtract(const Duration(hours: 9)),
          endTime: now.subtract(const Duration(hours: 1)),
          data: {
            'duration_minutes': 480,
            'quality_rating': 4,
            'deep_sleep_minutes': 120,
            'rem_sleep_minutes': 100,
          },
          source: HealthSource.healthConnect,
          recordedAt: now,
        ),
        HealthRecordPayload(
          id: 'ext_wt_1',
          dataType: HealthDataType.weight,
          startTime: now.subtract(const Duration(hours: 4)),
          endTime: now.subtract(const Duration(hours: 4)),
          data: {'weight_kg': 75.2},
          source: HealthSource.healthConnect,
          recordedAt: now.subtract(const Duration(hours: 4)),
        ),
        HealthRecordPayload(
          id: 'ext_hr_1',
          dataType: HealthDataType.heartRate,
          startTime: now.subtract(const Duration(hours: 1)),
          endTime: now.subtract(const Duration(hours: 1)),
          data: {'pulse': 68},
          source: HealthSource.healthConnect,
          recordedAt: now.subtract(const Duration(hours: 1)),
        ),
      ];

      final summary = await service.syncHealthData(userId: testUserId);

      expect(summary.syncedSteps, 1);
      expect(summary.syncedSleep, 1);
      expect(summary.syncedWeight, 1);
      expect(summary.syncedVitals, 1);
      expect(summary.totalRecords, 4);

      // Verify steps in Drift
      final stepRes = await stepRepo.getForDate(testUserId, now);
      expect(stepRes.dataOrNull?.stepCount, 6400);
      expect(stepRes.dataOrNull?.source, HealthSource.healthConnect);

      // Verify sleep in Drift
      final sleepRes = await sleepRepo.getHistory(testUserId);
      expect(sleepRes.dataOrNull?.length, 1);
      expect(sleepRes.dataOrNull?.first.deepSleepMinutes, 120);

      // Verify weight in Drift
      final wtRes = await bodyMetricsRepo.getHistory(userId: testUserId, metricType: BodyMetricType.weight);
      expect(wtRes.dataOrNull?.length, 1);
      expect(wtRes.dataOrNull?.first.value, 75.2);
    });

    test('syncHealthData protects higher manual step logs from lower wearable telemetry', () async {
      final now = DateTime.now();

      // Pre-seed manual step log of 10,000 steps
      await stepRepo.saveLocal(StepRecord(
        id: 'manual_steps',
        userId: testUserId,
        date: DateTime(now.year, now.month, now.day),
        stepCount: 10000,
        source: HealthSource.manual,
      ));

      // Mock wearable returns 6,500 steps
      mockAdapter.recordsMock = [
        HealthRecordPayload(
          id: 'ext_step_low',
          dataType: HealthDataType.steps,
          startTime: now.subtract(const Duration(hours: 2)),
          endTime: now,
          data: {'step_count': 6500},
          source: HealthSource.healthConnect,
          recordedAt: now,
        ),
      ];

      await service.syncHealthData(userId: testUserId);

      // Manual 10,000 steps must be preserved
      final stepRes = await stepRepo.getForDate(testUserId, now);
      expect(stepRes.dataOrNull?.stepCount, 10000);
      expect(stepRes.dataOrNull?.source, HealthSource.manual);
    });

    test('getStatus and disconnect reflect authorization and revocation state', () async {
      final status = await service.getStatus();
      expect(status.isAvailable, isTrue);
      expect(status.isConnected, isTrue);

      await service.disconnect();

      final postDisconnect = await service.getStatus();
      expect(postDisconnect.isConnected, isFalse);
      expect(service.lastSyncTime, isNull);
    });
  });
}
