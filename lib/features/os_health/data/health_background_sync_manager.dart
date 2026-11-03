import 'dart:math';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/logging/app_logger.dart';
import 'health_integration_service.dart';

enum BackgroundSyncStatus {
  success,
  throttled,
  error,
  unavailable,
}

class BackgroundSyncResult {
  final BackgroundSyncStatus status;
  final int importedCount;
  final String message;
  final DateTime timestamp;

  const BackgroundSyncResult({
    required this.status,
    this.importedCount = 0,
    required this.message,
    required this.timestamp,
  });

  bool get isSuccess => status == BackgroundSyncStatus.success;
  bool get isThrottled => status == BackgroundSyncStatus.throttled;
}

class HealthBackgroundSyncManager {
  static const Duration minimumSyncInterval = Duration(minutes: 15);

  final HealthIntegrationService healthService;
  final AppLogger logger;

  DateTime? _lastExecutionTime;
  int _consecutiveFailures = 0;

  HealthBackgroundSyncManager({
    required this.healthService,
    required this.logger,
  });

  int get consecutiveFailures => _consecutiveFailures;
  DateTime? get lastExecutionTime => _lastExecutionTime;

  /// Checks if minimum 15-minute battery-saving threshold has elapsed
  bool shouldExecuteSync({DateTime? lastSyncTime, DateTime? now}) {
    final effectiveLast = lastSyncTime ?? _lastExecutionTime;
    if (effectiveLast == null) return true;

    final current = now ?? DateTime.now();
    return current.difference(effectiveLast) >= minimumSyncInterval;
  }

  /// Exponential backoff delay for retries: 2^failures minutes (clamped between 2 and 120 minutes)
  Duration calculateBackoffDelay(int failures) {
    if (failures <= 0) return Duration.zero;
    final exponent = min(failures, 7);
    final minutes = pow(2, exponent).toInt().clamp(2, 120);
    return Duration(minutes: minutes);
  }

  /// Safely runs background sync with battery safeguards and failure backoff
  Future<BackgroundSyncResult> executeBackgroundSync(
    String userId, {
    DateTime? now,
  }) async {
    final current = now ?? DateTime.now();

    // 1. Throttling Check
    if (!shouldExecuteSync(now: current)) {
      final elapsed = current.difference(_lastExecutionTime ?? current).inMinutes;
      logger.debug('OS health background sync throttled ($elapsed min elapsed, minimum is 15 min).');
      return BackgroundSyncResult(
        status: BackgroundSyncStatus.throttled,
        message: 'Sync throttled. Minimum interval of 15 minutes not reached.',
        timestamp: current,
      );
    }

    // 2. Failure Backoff Check
    if (_consecutiveFailures > 0 && _lastExecutionTime != null) {
      final requiredDelay = calculateBackoffDelay(_consecutiveFailures);
      final elapsedSinceFailure = current.difference(_lastExecutionTime!);
      if (elapsedSinceFailure < requiredDelay) {
        return BackgroundSyncResult(
          status: BackgroundSyncStatus.throttled,
          message: 'Retry backed off due to $_consecutiveFailures consecutive errors. Next attempt in ${requiredDelay.inMinutes - elapsedSinceFailure.inMinutes} mins.',
          timestamp: current,
        );
      }
    }

    // 3. Platform Availability Check
    final isAvailable = await healthService.isPlatformAvailable();
    if (!isAvailable) {
      logger.debug('OS health aggregator unavailable on this platform/device.');
      return BackgroundSyncResult(
        status: BackgroundSyncStatus.unavailable,
        message: 'Platform health aggregator unavailable.',
        timestamp: current,
      );
    }

    // 4. Execute Ingestion
    try {
      final summary = await healthService.syncHealthData(userId: userId);
      _lastExecutionTime = current;
      _consecutiveFailures = 0;

      logger.info('OS health background sync completed: ${summary.totalRecords} records synced.');
      return BackgroundSyncResult(
        status: BackgroundSyncStatus.success,
        importedCount: summary.totalRecords,
        message: 'Successfully imported ${summary.totalRecords} records.',
        timestamp: current,
      );
    } catch (e, stack) {
      _lastExecutionTime = current;
      _consecutiveFailures++;

      logger.error('OS health background sync failed: $e', error: e, stackTrace: stack);
      return BackgroundSyncResult(
        status: BackgroundSyncStatus.error,
        message: 'Background health sync failed: $e',
        timestamp: current,
      );
    }
  }
}

final healthBackgroundSyncManagerProvider = Provider<HealthBackgroundSyncManager>((ref) {
  final healthService = ref.watch(healthIntegrationServiceProvider);
  final logger = ref.watch(appLoggerProvider);
  return HealthBackgroundSyncManager(
    healthService: healthService,
    logger: logger,
  );
});
