import '../../health/domain/body_metric.dart';
import '../../health/domain/health_primitives.dart';
import '../../health/domain/sleep_record.dart';
import '../../health/domain/step_record.dart';

class BiometricDeduplicationEngine {
  const BiometricDeduplicationEngine();

  /// Consolidates step counts between manual user logs and incoming wearable telemetry
  StepRecord deduplicateSteps({
    required StepRecord? existing,
    required int incomingSteps,
    required HealthSource incomingSource,
    required DateTime date,
    required String userId,
  }) {
    if (existing == null) {
      return StepRecord(
        id: 'step_${userId}_${date.year}${date.month.toString().padLeft(2, '0')}${date.day.toString().padLeft(2, '0')}',
        userId: userId,
        date: DateTime(date.year, date.month, date.day),
        stepCount: incomingSteps,
        source: incomingSource,
      );
    }

    // If existing record was entered manually by the user
    if (existing.source == HealthSource.manual) {
      // If incoming wearable step count is higher, elevate to the higher step count
      if (incomingSteps > existing.stepCount) {
        return existing.copyWith(
          stepCount: incomingSteps,
          source: incomingSource,
        );
      }
      // Otherwise preserve manual user override
      return existing;
    }

    // Between automated sources, take the maximum consolidated count to prevent duplicate truncation
    final resolvedCount = incomingSteps > existing.stepCount ? incomingSteps : existing.stepCount;
    return existing.copyWith(
      stepCount: resolvedCount,
      source: incomingSource,
    );
  }

  /// Reconciles sleep interval overlap between manual logs and wearable telemetry.
  /// If mutual overlap exceeds 80%, merges sleep stage metrics into a unified session.
  SleepRecord deduplicateSleep({
    required List<SleepRecord> existingRecords,
    required SleepRecord incoming,
  }) {
    for (final existing in existingRecords) {
      // Check interval intersection
      final latestStart = incoming.startTime.isAfter(existing.startTime) ? incoming.startTime : existing.startTime;
      final earliestEnd = incoming.endTime.isBefore(existing.endTime) ? incoming.endTime : existing.endTime;

      if (latestStart.isBefore(earliestEnd)) {
        final overlapMinutes = earliestEnd.difference(latestStart).inMinutes;
        final minDuration = incoming.durationMinutes < existing.durationMinutes
            ? incoming.durationMinutes
            : existing.durationMinutes;

        if (minDuration > 0) {
          final overlapRatio = overlapMinutes / minDuration;

          if (overlapRatio >= 0.8) {
            // High overlap: merge sleep stage telemetry from wearable while keeping quality rating
            return existing.copyWith(
              startTime: incoming.startTime.isBefore(existing.startTime) ? incoming.startTime : existing.startTime,
              endTime: incoming.endTime.isAfter(existing.endTime) ? incoming.endTime : existing.endTime,
              durationMinutes: incoming.durationMinutes > existing.durationMinutes
                  ? incoming.durationMinutes
                  : existing.durationMinutes,
              deepSleepMinutes: incoming.deepSleepMinutes ?? existing.deepSleepMinutes,
              remSleepMinutes: incoming.remSleepMinutes ?? existing.remSleepMinutes,
              source: incoming.source,
            );
          }
        }
      }
    }

    // No significant collision: retain incoming record as distinct session (e.g. afternoon nap)
    return incoming;
  }

  /// Detects whether an incoming weight reading is a duplicate within a 15-minute window
  bool isDuplicateWeight({
    required List<BodyMetricEntry> existingEntries,
    required double incomingWeightKg,
    required DateTime timestamp,
    Duration timeThreshold = const Duration(minutes: 15),
    double weightDifferenceThresholdKg = 0.2,
  }) {
    for (final entry in existingEntries) {
      if (entry.metricType != BodyMetricType.weight) continue;

      final timeDiff = entry.recordedAt.difference(timestamp).abs();
      if (timeDiff <= timeThreshold) {
        final valDiff = (entry.value - incomingWeightKg).abs();
        if (valDiff <= weightDifferenceThresholdKg) {
          return true; // Duplicate detected
        }
      }
    }

    return false;
  }
}
