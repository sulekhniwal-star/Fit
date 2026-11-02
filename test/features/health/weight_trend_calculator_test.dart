import 'package:flutter_test/flutter_test.dart';
import 'package:fitkarma/features/health/domain/body_metric.dart';
import 'package:fitkarma/features/health/domain/health_primitives.dart';
import 'package:fitkarma/features/health/domain/weight_trend_calculator.dart';

void main() {
  group('WeightTrendCalculator Tests', () {
    const calculator = WeightTrendCalculator();

    test('returns null when entries list is empty', () {
      expect(calculator.calculate([]), isNull);
    });

    test('calculates 7-day moving average accurately', () {
      final now = DateTime(2026, 11, 2);
      final entries = [
        BodyMetricEntry(
          id: '1',
          userId: 'u1',
          metricType: BodyMetricType.weight,
          value: 70.0,
          unit: HealthUnit.kg,
          recordedAt: now.subtract(const Duration(days: 3)),
        ),
        BodyMetricEntry(
          id: '2',
          userId: 'u1',
          metricType: BodyMetricType.weight,
          value: 71.0,
          unit: HealthUnit.kg,
          recordedAt: now.subtract(const Duration(days: 1)),
        ),
        BodyMetricEntry(
          id: '3',
          userId: 'u1',
          metricType: BodyMetricType.weight,
          value: 72.0,
          unit: HealthUnit.kg,
          recordedAt: now,
        ),
      ];

      final trend = calculator.calculate(entries);
      expect(trend, isNotNull);
      expect(trend!.currentWeightKg, equals(72.0));
      expect(trend.movingAverage7DayKg, equals(71.0)); // (70+71+72)/3
      expect(trend.totalEntries, equals(3));
    });

    test('calculates rate of change per week across 14-day history', () {
      final now = DateTime(2026, 11, 2);
      final entries = [
        // Prior week average: 75.0 kg
        BodyMetricEntry(
          id: 'p1',
          userId: 'u1',
          metricType: BodyMetricType.weight,
          value: 75.0,
          unit: HealthUnit.kg,
          recordedAt: now.subtract(const Duration(days: 10)),
        ),
        // Recent week average: 74.0 kg
        BodyMetricEntry(
          id: 'r1',
          userId: 'u1',
          metricType: BodyMetricType.weight,
          value: 74.0,
          unit: HealthUnit.kg,
          recordedAt: now.subtract(const Duration(days: 2)),
        ),
      ];

      final trend = calculator.calculate(entries);
      expect(trend, isNotNull);
      expect(trend!.rateOfChangeKgPerWeek, equals(-1.0)); // 74.0 - 75.0 = -1.0 kg/week
    });
  });
}

