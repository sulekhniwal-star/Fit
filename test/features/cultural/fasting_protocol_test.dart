import 'package:flutter_test/flutter_test.dart';
import 'package:fitkarma/features/cultural/domain/fasting_phase.dart';
import 'package:fitkarma/features/cultural/domain/fasting_protocol.dart';
import 'package:fitkarma/features/cultural/domain/fasting_session.dart';
import 'package:fitkarma/features/cultural/domain/safe_refeeding_guide.dart';

void main() {
  group('Fasting Protocol Domain Tests', () {
    test('all 11 protocols have valid hours and cultural metadata', () {
      expect(FastingProtocol.allProtocols.length, 11);

      for (final p in FastingProtocol.allProtocols) {
        expect(p.displayName, isNotEmpty);
        expect(p.hindiDisplayName, isNotEmpty);
        expect(p.defaultFastHours, greaterThan(0));
        expect(p.culturalContext, isNotEmpty);
        expect(p.dietaryGuidelines, isNotEmpty);
      }
    });

    test('waterless fasts (Karwa Chauth and Ramadan) are correctly flagged', () {
      final karwa = FastingProtocol.fromType(FastingProtocolType.karwaChauth);
      final ramadan = FastingProtocol.fromType(FastingProtocolType.ramadanRoza);
      final if16 = FastingProtocol.fromType(FastingProtocolType.if16_8);
      final navratri = FastingProtocol.fromType(FastingProtocolType.navratri);

      expect(karwa.isWaterless, isTrue);
      expect(ramadan.isWaterless, isTrue);
      expect(if16.isWaterless, isFalse);
      expect(navratri.isWaterless, isFalse);
    });

    test('FastingPhaseCalculator correctly maps metabolic stages by elapsed hours', () {
      expect(FastingPhaseCalculator.getStage(2.5), FastingStage.anabolic);
      expect(FastingPhaseCalculator.getStage(6.0), FastingStage.digestion);
      expect(FastingPhaseCalculator.getStage(10.5), FastingStage.gluconeogenesis);
      expect(FastingPhaseCalculator.getStage(14.0), FastingStage.ketosisTransition);
      expect(FastingPhaseCalculator.getStage(20.0), FastingStage.fatBurning);
      expect(FastingPhaseCalculator.getStage(30.0), FastingStage.deepAutophagy);
    });

    test('FastingPhaseCalculator progress calculation clamps safely', () {
      final start = DateTime(2026, 11, 3, 8, 0);
      final plannedEnd = DateTime(2026, 11, 3, 24, 0); // 16 hours

      // At start (0 hours)
      final p0 = FastingPhaseCalculator.calculateProgress(
        startTime: start,
        plannedEndTime: plannedEnd,
        currentTime: start,
      );
      expect(p0, 0.0);

      // Halfway (8 hours)
      final p50 = FastingPhaseCalculator.calculateProgress(
        startTime: start,
        plannedEndTime: plannedEnd,
        currentTime: DateTime(2026, 11, 3, 16, 0),
      );
      expect(p50, closeTo(0.5, 0.01));

      // At target (16 hours)
      final p100 = FastingPhaseCalculator.calculateProgress(
        startTime: start,
        plannedEndTime: plannedEnd,
        currentTime: plannedEnd,
      );
      expect(p100, closeTo(1.0, 0.01));
    });

    test('SafeRefeedingGuide contains gentle Indian recovery options and clinical disclaimer', () {
      expect(SafeRefeedingGuide.gentleBreakFastMeals, isNotEmpty);
      expect(SafeRefeedingGuide.foodsToAvoidImmediately, isNotEmpty);
      expect(SafeRefeedingGuide.clinicalDisclaimer, contains('Statutory Advisory'));

      final khichdi = SafeRefeedingGuide.gentleBreakFastMeals.firstWhere(
        (m) => m.title.contains('Khichdi'),
      );
      expect(khichdi.proteinGrams, greaterThan(5.0));
      expect(khichdi.estimatedCalories, lessThan(250));
    });

    test('FastingSession serialization round-trips correctly', () {
      final session = FastingSession(
        id: 'fast_test_1',
        userId: 'user_123',
        protocolType: FastingProtocolType.if16_8,
        startTime: DateTime(2026, 11, 3, 10, 0),
        plannedEndTime: DateTime(2026, 11, 4, 2, 0),
        status: FastingSessionStatus.active,
        isWaterless: false,
        hydrationRemindersEnabled: true,
        notes: 'Feeling energized',
        createdAt: DateTime(2026, 11, 3, 10, 0),
        updatedAt: DateTime(2026, 11, 3, 10, 0),
      );

      final json = session.toJson();
      final roundTrip = FastingSession.fromJson(json);

      expect(roundTrip.id, session.id);
      expect(roundTrip.userId, session.userId);
      expect(roundTrip.protocolType, session.protocolType);
      expect(roundTrip.status, session.status);
      expect(roundTrip.isWaterless, session.isWaterless);
      expect(roundTrip.notes, session.notes);
    });
  });
}

