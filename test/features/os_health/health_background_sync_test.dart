import 'package:flutter_test/flutter_test.dart';
import 'package:fitkarma/core/database/app_database.dart';
import 'package:fitkarma/core/logging/app_logger.dart';
import 'package:fitkarma/core/sync/outbox_queue.dart';
import 'package:fitkarma/features/health/data/drift_body_metrics_repository.dart';
import 'package:fitkarma/features/health/data/drift_health_repositories.dart';
import 'package:fitkarma/features/health/data/drift_vitals_repositories.dart';
import 'package:fitkarma/features/health/domain/health_primitives.dart';
import 'package:fitkarma/features/os_health/data/health_background_sync_manager.dart';
import 'package:fitkarma/features/os_health/data/health_integration_service.dart';
import 'package:fitkarma/features/os_health/data/mock_platform_health_adapter.dart';
import 'package:fitkarma/features/os_health/domain/health_data_types.dart';

void main() {
  group('HealthBackgroundSyncManager Tests', () {
    late AppDatabase db;
    late OutboxQueue outbox;
    late HealthIntegrationService service;
    late MockPlatformHealthAdapter mockAdapter;
    late HealthBackgroundSyncManager syncManager;

    const testUserId = 'user_bg_sync_test';

    setUp(() {
      db = AppDatabase.memory();
      outbox = OutboxQueue(db);
      mockAdapter = MockPlatformHealthAdapter();
      service = HealthIntegrationService(
        adapter: mockAdapter,
        stepRepo: DriftStepRepository(db, outbox),
        sleepRepo: DriftSleepRepository(db, outbox),
        vitalsRepo: DriftVitalsRepository(db, outbox),
        bodyMetricsRepo: DriftBodyMetricsRepository(db, outbox),
      );
      syncManager = HealthBackgroundSyncManager(
        healthService: service,
        logger: AppLogger(),
      );
    });

    tearDown(() async {
      await db.close();
    });

    test('shouldExecuteSync enforces minimum 15-minute battery conservation threshold', () {
      final now = DateTime(2026, 3, 15, 12, 0);

      // Initial execution -> allowed
      expect(syncManager.shouldExecuteSync(lastSyncTime: null, now: now), isTrue);

      // 5 minutes later -> throttled
      final fiveMinsLater = now.add(const Duration(minutes: 5));
      expect(syncManager.shouldExecuteSync(lastSyncTime: now, now: fiveMinsLater), isFalse);

      // Exactly 15 minutes later -> allowed
      final fifteenMinsLater = now.add(const Duration(minutes: 15));
      expect(syncManager.shouldExecuteSync(lastSyncTime: now, now: fifteenMinsLater), isTrue);

      // 60 minutes later -> allowed
      final hourLater = now.add(const Duration(hours: 1));
      expect(syncManager.shouldExecuteSync(lastSyncTime: now, now: hourLater), isTrue);
    });

    test('calculateBackoffDelay increases exponentially with consecutive failures', () {
      expect(syncManager.calculateBackoffDelay(0), Duration.zero);
      expect(syncManager.calculateBackoffDelay(1), const Duration(minutes: 2));
      expect(syncManager.calculateBackoffDelay(2), const Duration(minutes: 4));
      expect(syncManager.calculateBackoffDelay(3), const Duration(minutes: 8));
      expect(syncManager.calculateBackoffDelay(4), const Duration(minutes: 16));
      expect(syncManager.calculateBackoffDelay(10), const Duration(minutes: 120)); // Clamped to 120m
    });

    test('executeBackgroundSync runs successfully and resets consecutive failures', () async {
      final now = DateTime.now();
      mockAdapter.recordsMock = [
        HealthRecordPayload(
          id: 'step_bg_1',
          dataType: HealthDataType.steps,
          startTime: now.subtract(const Duration(hours: 1)),
          endTime: now,
          data: {'step_count': 3200},
          source: HealthSource.healthConnect,
          recordedAt: now,
        ),
      ];

      final result = await syncManager.executeBackgroundSync(testUserId, now: now);

      expect(result.isSuccess, isTrue);
      expect(result.importedCount, 1);
      expect(syncManager.consecutiveFailures, 0);
      expect(syncManager.lastExecutionTime, now);
    });

    test('executeBackgroundSync rejects subsequent invocation within 15 minutes as throttled', () async {
      final now = DateTime.now();

      // First run succeeds
      final first = await syncManager.executeBackgroundSync(testUserId, now: now);
      expect(first.isSuccess, isTrue);

      // Attempt 8 minutes later -> throttled
      final second = await syncManager.executeBackgroundSync(
        testUserId,
        now: now.add(const Duration(minutes: 8)),
      );
      expect(second.isThrottled, isTrue);
      expect(second.status, BackgroundSyncStatus.throttled);
    });
  });
}
