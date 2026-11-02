import 'package:flutter_test/flutter_test.dart';
import 'package:fitkarma/features/health/domain/body_metric.dart';
import 'package:fitkarma/features/health/domain/health_primitives.dart';

void main() {
  group('HealthPrimitives Tests', () {
    test('converts kg to lbs and vice versa accurately', () {
      const weightKg = HealthQuantity(value: 70.0, unit: HealthUnit.kg);
      final weightLbs = weightKg.toUnit(HealthUnit.lbs);
      expect(weightLbs.value, closeTo(154.32, 0.05));

      final convertedBack = weightLbs.toUnit(HealthUnit.kg);
      expect(convertedBack.value, closeTo(70.0, 0.01));
    });

    test('converts cm to inches accurately', () {
      const lengthCm = HealthQuantity(value: 175.0, unit: HealthUnit.cm);
      final lengthInches = lengthCm.toUnit(HealthUnit.inch);
      expect(lengthInches.value, closeTo(68.89, 0.05));

      final convertedBack = lengthInches.toUnit(HealthUnit.cm);
      expect(convertedBack.value, closeTo(175.0, 0.01));
    });
  });

  group('BodyMetricEntry Tests', () {
    test('validates metric boundaries accurately', () {
      final validWeight = BodyMetricEntry(
        id: '1',
        userId: 'u1',
        metricType: BodyMetricType.weight,
        value: 72.5,
        unit: HealthUnit.kg,
        recordedAt: DateTime.now(),
      );
      expect(validWeight.isValid, isTrue);

      final invalidLowWeight = validWeight.copyWith(value: 15.0);
      expect(invalidLowWeight.isValid, isFalse);

      final invalidHighWeight = validWeight.copyWith(value: 500.0);
      expect(invalidHighWeight.isValid, isFalse);

      final validWaist = BodyMetricEntry(
        id: '2',
        userId: 'u1',
        metricType: BodyMetricType.waist,
        value: 32.0,
        unit: HealthUnit.inch,
        recordedAt: DateTime.now(),
      );
      expect(validWaist.isValid, isTrue);
    });

    test('normalizes imperial entry to base metric unit', () {
      final entryLbs = BodyMetricEntry(
        id: '1',
        userId: 'u1',
        metricType: BodyMetricType.weight,
        value: 154.32,
        unit: HealthUnit.lbs,
        recordedAt: DateTime.now(),
      );

      final base = entryLbs.toBaseUnit();
      expect(base.unit, equals(HealthUnit.kg));
      expect(base.value, closeTo(70.0, 0.05));
    });
  });
}
