import 'package:flutter_test/flutter_test.dart';
import 'package:fitkarma/features/cultural/domain/aqi_models.dart';
import 'package:fitkarma/features/cultural/domain/aqi_workout_advisory.dart';

void main() {
  group('CPCB NAQI Domain Tests', () {
    test('accurately classifies AQI across all 6 CPCB bands', () {
      expect(CpcbAqiBand.fromAqi(30).category, CpcbAqiCategory.good);
      expect(CpcbAqiBand.fromAqi(50).category, CpcbAqiCategory.good);
      expect(CpcbAqiBand.fromAqi(51).category, CpcbAqiCategory.satisfactory);
      expect(CpcbAqiBand.fromAqi(100).category, CpcbAqiCategory.satisfactory);
      expect(CpcbAqiBand.fromAqi(101).category, CpcbAqiCategory.moderate);
      expect(CpcbAqiBand.fromAqi(200).category, CpcbAqiCategory.moderate);
      expect(CpcbAqiBand.fromAqi(201).category, CpcbAqiCategory.poor);
      expect(CpcbAqiBand.fromAqi(300).category, CpcbAqiCategory.poor);
      expect(CpcbAqiBand.fromAqi(301).category, CpcbAqiCategory.veryPoor);
      expect(CpcbAqiBand.fromAqi(400).category, CpcbAqiCategory.veryPoor);
      expect(CpcbAqiBand.fromAqi(450).category, CpcbAqiCategory.severe);
    });

    test('isOutdoorSafe is true only for Good and Satisfactory bands', () {
      final goodReading = AqiReading(
        aqi: 40,
        category: CpcbAqiCategory.good,
        city: 'Bengaluru',
        recordedAt: DateTime.now(),
      );
      final satisfactoryReading = AqiReading(
        aqi: 80,
        category: CpcbAqiCategory.satisfactory,
        city: 'Pune',
        recordedAt: DateTime.now(),
      );
      final poorReading = AqiReading(
        aqi: 250,
        category: CpcbAqiCategory.poor,
        city: 'Delhi NCR',
        recordedAt: DateTime.now(),
      );

      expect(goodReading.isOutdoorSafe, isTrue);
      expect(satisfactoryReading.isOutdoorSafe, isTrue);
      expect(poorReading.isOutdoorSafe, isFalse);
    });

    test('AqiWorkoutAdvisory generates indoor alternatives when AQI >= 201', () {
      final poorReading = AqiReading(
        aqi: 285,
        category: CpcbAqiCategory.poor,
        city: 'Delhi NCR',
        recordedAt: DateTime.now(),
      );

      final advisory = AqiWorkoutAdvisory.generateAdvisory(poorReading);

      expect(advisory.isOutdoorWorkoutSafe, isFalse);
      expect(advisory.primaryRecommendation, contains('Poor'));
      expect(advisory.indoorAlternatives, isNotEmpty);
      expect(advisory.indoorAlternatives.any((alt) => alt.title.contains('HIIT')), isTrue);
      expect(advisory.respiratorySafetyTips, isNotEmpty);
      expect(advisory.respiratorySafetyTips.any((tip) => tip.contains('N95')), isTrue);
    });

    test('AqiReading serialization and deserialization round-trip', () {
      final reading = AqiReading(
        aqi: 240,
        category: CpcbAqiCategory.poor,
        pm25: 125.4,
        pm10: 210.8,
        city: 'Kolkata',
        stationName: 'Victoria Memorial CPCB',
        recordedAt: DateTime(2026, 11, 3, 14, 0),
        isStale: false,
        source: 'CPCB',
      );

      final json = reading.toJson();
      final fromJson = AqiReading.fromJson(json);

      expect(fromJson.aqi, reading.aqi);
      expect(fromJson.category, reading.category);
      expect(fromJson.pm25, reading.pm25);
      expect(fromJson.pm10, reading.pm10);
      expect(fromJson.city, reading.city);
      expect(fromJson.stationName, reading.stationName);
    });
  });
}
