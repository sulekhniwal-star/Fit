import 'package:flutter_test/flutter_test.dart';
import 'package:fitkarma/features/brain/domain/daily_readiness_calculator.dart';
import 'package:fitkarma/features/brain/domain/dip_models.dart';
import 'package:fitkarma/features/brain/domain/dip_rule_engine.dart';
import 'package:fitkarma/features/health/domain/sleep_record.dart';

void main() {
  group('DipRuleEngine Deterministic Rules Tests', () {
    const calculator = DailyReadinessCalculator();
    final engine = DipRuleEngine();

    test('HydrationDeficitRule triggers afternoon hydration prompt when behind pace', () {
      final input = DipContextInput(
        userId: 'u1',
        timestamp: DateTime(2026, 11, 3, 14, 0), // 2:00 PM
        consumedWaterMl: 600, // < 40% of 3000ml (1200ml)
        targetWaterMl: 3000,
      );

      final readiness = calculator.calculateReadiness(input);
      final actions = HydrationDeficitRule().evaluate(input, readiness);

      expect(actions.length, equals(1));
      expect(actions.first.id, equals('action_hydration_deficit'));
      expect(actions.first.category, equals(DipActionCategory.hydration));
      expect(actions.first.priority, equals(75.0));
    });

    test('PostMealShatapawaliRule triggers after heavy meal within 60 minutes', () {
      final now = DateTime(2026, 11, 3, 13, 30); // 1:30 PM
      final input = DipContextInput(
        userId: 'u2',
        timestamp: now,
        recentMealTimestamp: now.subtract(const Duration(minutes: 25)),
        recentMealCalories: 650.0,
      );

      final readiness = calculator.calculateReadiness(input);
      final actions = PostMealShatapawaliRule().evaluate(input, readiness);

      expect(actions.length, equals(1));
      expect(actions.first.id, equals('action_shatapawali'));
      expect(actions.first.culturalContext, contains('Shatapawali'));
      expect(actions.first.priority, equals(80.0));
    });

    test('SedentaryBreakRule triggers late afternoon if step count is low', () {
      final input = DipContextInput(
        userId: 'u3',
        timestamp: DateTime(2026, 11, 3, 16, 45), // 4:45 PM
        todaySteps: 2100, // < 3500
      );

      final readiness = calculator.calculateReadiness(input);
      final actions = SedentaryBreakRule().evaluate(input, readiness);

      expect(actions.length, equals(1));
      expect(actions.first.id, equals('action_sedentary_break'));
      expect(actions.first.category, equals(DipActionCategory.movement));
    });

    test('HighFatigueRecoveryRule triggers when ACWR exceeds 1.5 or recovery tier', () {
      final input = DipContextInput(
        userId: 'u4',
        timestamp: DateTime(2026, 11, 3, 9, 0),
        acuteWorkload: 16000.0,
        chronicWorkload: 10000.0, // ACWR = 1.6
      );

      final readiness = calculator.calculateReadiness(input);
      final actions = HighFatigueRecoveryRule().evaluate(input, readiness);

      expect(actions.length, equals(1));
      expect(actions.first.id, equals('action_high_fatigue_recovery'));
      expect(actions.first.category, equals(DipActionCategory.recovery));
      expect(actions.first.priority, equals(92.0));
    });

    test('DinnerLogReminderRule triggers at 8 PM if dinner is not logged', () {
      final input = DipContextInput(
        userId: 'u5',
        timestamp: DateTime(2026, 11, 3, 20, 30), // 8:30 PM
        recentMealTimestamp: DateTime(2026, 11, 3, 13, 0), // Lunch only
      );

      final readiness = calculator.calculateReadiness(input);
      final actions = DinnerLogReminderRule().evaluate(input, readiness);

      expect(actions.length, equals(1));
      expect(actions.first.id, equals('action_dinner_log_reminder'));
    });

    test('SleepWindDownRule triggers at 10 PM', () {
      final input = DipContextInput(
        userId: 'u6',
        timestamp: DateTime(2026, 11, 3, 22, 15), // 10:15 PM
      );

      final readiness = calculator.calculateReadiness(input);
      final actions = SleepWindDownRule().evaluate(input, readiness);

      expect(actions.length, equals(1));
      expect(actions.first.id, equals('action_sleep_wind_down'));
    });

    test('ColdStartOnboardingRule triggers on fresh day with 0 logs', () {
      final input = DipContextInput(
        userId: 'u7',
        timestamp: DateTime(2026, 11, 3, 7, 0),
        todaySteps: 0,
        consumedWaterMl: 0,
        consumedCalories: 0,
        sleep: null,
      );

      final readiness = calculator.calculateReadiness(input);
      final actions = ColdStartOnboardingRule().evaluate(input, readiness);

      expect(actions.length, equals(1));
      expect(actions.first.id, equals('action_cold_start'));
    });

    test('DipRuleEngine clamps topActions strictly to at most 3 items (Cognitive Load Fence)', () {
      // Create a scenario where multiple rules would trigger simultaneously
      final now = DateTime(2026, 11, 3, 22, 30);
      final input = DipContextInput(
        userId: 'u_busy',
        timestamp: now,
        todaySteps: 1200, // Triggers SedentaryBreak
        consumedWaterMl: 500, // Triggers HydrationDeficit
        recentMealTimestamp: now.subtract(const Duration(minutes: 15)),
        recentMealCalories: 600.0, // Triggers Shatapawali
        sleep: SleepRecord(
          id: 's_bad',
          userId: 'u_busy',
          startTime: now.subtract(const Duration(hours: 4)),
          endTime: now,
          durationMinutes: 200,
          qualityRating: 1,
        ), // Triggers HighFatigueRecovery
      );

      final dip = engine.assemblePackage(input);

      expect(dip.topActions.length, lessThanOrEqualTo(3));
      expect(dip.topActions.length, greaterThan(0));
      // First action should be highest priority
      expect(dip.topActions[0].priority, greaterThanOrEqualTo(dip.topActions[1].priority));
      if (dip.topActions.length > 2) {
        expect(dip.topActions[1].priority, greaterThanOrEqualTo(dip.topActions[2].priority));
      }
      expect(dip.primaryFocus.title, isNotEmpty);
    });

    test('DipRuleEngine provides default action when user is completely on track', () {
      final input = DipContextInput(
        userId: 'u_ontrack',
        timestamp: DateTime(2026, 11, 3, 11, 0),
        todaySteps: 6000,
        consumedWaterMl: 1500,
        sleep: SleepRecord(
          id: 's_good',
          userId: 'u_ontrack',
          startTime: DateTime(2026, 11, 2, 23, 0),
          endTime: DateTime(2026, 11, 3, 7, 0),
          durationMinutes: 480,
          qualityRating: 5,
        ),
      );

      final dip = engine.assemblePackage(input);

      expect(dip.topActions.length, greaterThanOrEqualTo(1));
      expect(dip.topActions.first.id, equals('action_steady_pace'));
    });
  });
}

