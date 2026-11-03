import 'package:flutter_test/flutter_test.dart';
import 'package:fitkarma/features/brain/domain/dip_models.dart';
import 'package:fitkarma/features/brain/domain/daily_readiness_calculator.dart';
import 'package:fitkarma/features/health/domain/sleep_record.dart';

void main() {
  group('DailyReadinessCalculator Unit Tests', () {
    const calculator = DailyReadinessCalculator();
    final testDate = DateTime(2026, 11, 3, 8, 30); // 8:30 AM

    test('Computes Peak Readiness with high sleep, calm RHR, and optimal ACWR', () {
      final input = DipContextInput(
        userId: 'user_1',
        timestamp: testDate,
        sleep: SleepRecord(
          id: 'sleep_1',
          userId: 'user_1',
          startTime: DateTime(2026, 11, 2, 22, 30),
          endTime: DateTime(2026, 11, 3, 6, 30),
          durationMinutes: 480, // 8.0 hrs
          qualityRating: 5,
        ),
        restingHeartRate: 58.0,
        acuteWorkload: 10000.0,
        chronicWorkload: 10000.0, // ACWR = 1.0 (Optimal)
        consumedWaterMl: 500,
        targetWaterMl: 3000,
      );

      final result = calculator.calculateReadiness(input);

      expect(result.score, greaterThanOrEqualTo(85));
      expect(result.tier, equals(ReadinessTier.peak));
      expect(result.headline, contains('Peak Recovery'));
      expect(result.statutoryDisclaimer, contains('Wellness indicator only'));
      expect(result.factors.length, equals(4));
      expect(result.factors.every((f) => !f.isMissing), isTrue);
    });

    test('Computes Recovery Priority with sleep deficit, high RHR, and high strain', () {
      final input = DipContextInput(
        userId: 'user_2',
        timestamp: testDate,
        sleep: SleepRecord(
          id: 'sleep_2',
          userId: 'user_2',
          startTime: DateTime(2026, 11, 3, 2, 0),
          endTime: DateTime(2026, 11, 3, 6, 0),
          durationMinutes: 240, // 4.0 hrs
          qualityRating: 2,
        ),
        restingHeartRate: 85.0,
        acuteWorkload: 18000.0,
        chronicWorkload: 10000.0, // ACWR = 1.8 (High strain)
        consumedWaterMl: 100,
        targetWaterMl: 3000,
      );

      final result = calculator.calculateReadiness(input);

      expect(result.score, lessThan(50));
      expect(result.tier, equals(ReadinessTier.recovery));
      expect(result.headline, contains('Recovery Priority'));
    });

    test('Gracefully handles missing sleep and heart rate with dynamic weight normalization', () {
      final input = DipContextInput(
        userId: 'user_3',
        timestamp: testDate,
        sleep: null, // Missing sleep
        restingHeartRate: null, // Missing wearable
        acuteWorkload: 0.0,
        chronicWorkload: 0.0,
        consumedWaterMl: 600,
        targetWaterMl: 3000,
      );

      final result = calculator.calculateReadiness(input);

      expect(result.score, inInclusiveRange(60, 85));
      expect(result.factors.where((f) => f.isMissing).length, greaterThanOrEqualTo(2));
      expect(result.statutoryDisclaimer, isNotEmpty);
    });

    test('DIP Domain Models JSON serialization and deserialization roundtrip', () {
      const factor = ReadinessFactor(
        name: 'Sleep',
        score: 85,
        weight: 0.35,
        summary: '7.5 hrs recorded',
        isMissing: false,
      );

      final factorJson = factor.toJson();
      final factorBack = ReadinessFactor.fromJson(factorJson);
      expect(factorBack.name, equals('Sleep'));
      expect(factorBack.score, equals(85));
      expect(factorBack.weight, equals(0.35));

      const microAction = DipMicroAction(
        id: 'action_shatapawali',
        title: 'Take a 10-minute Shatapawali walk',
        description: 'Post-lunch walk to assist digestive rhythm',
        category: DipActionCategory.movement,
        priority: 45.0,
        actionLabel: 'Start Walk',
        culturalContext: 'Indian Shatapawali post-meal strolling tradition',
      );

      final actionJson = microAction.toJson();
      final actionBack = DipMicroAction.fromJson(actionJson);
      expect(actionBack.id, equals('action_shatapawali'));
      expect(actionBack.culturalContext, contains('Shatapawali'));

      final score = DailyReadinessScore(
        score: 88,
        tier: ReadinessTier.peak,
        headline: 'Peak Recovery State',
        explanation: 'Everything looks optimal',
        factors: [factor],
        statutoryDisclaimer: DailyReadinessScore.defaultDisclaimer,
        calculatedAt: testDate,
      );

      final scoreJson = score.toJson();
      final scoreBack = DailyReadinessScore.fromJson(scoreJson);
      expect(scoreBack.score, equals(88));
      expect(scoreBack.tier, equals(ReadinessTier.peak));

      final dip = DailyIntelligencePackage(
        date: testDate,
        readinessScore: score,
        primaryFocus: const DipFocusSignal(
          title: 'Prime Training Day',
          subtitle: 'Push progressive overload on compound lifts',
          badge: 'High Energy',
        ),
        topActions: [microAction],
        summaryMetrics: const DipSummaryMetrics(
          todaySteps: 3400,
          consumedCalories: 650.0,
          consumedWaterMl: 1250,
        ),
      );

      final dipJson = dip.toJson();
      final dipBack = DailyIntelligencePackage.fromJson(dipJson);
      expect(dipBack.topActions.length, equals(1));
      expect(dipBack.primaryFocus.title, equals('Prime Training Day'));
      expect(dipBack.summaryMetrics.todaySteps, equals(3400));
    });
  });
}
