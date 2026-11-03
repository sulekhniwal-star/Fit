import 'daily_readiness_calculator.dart';
import 'dip_models.dart';

abstract class DipRule {
  String get id;
  List<DipMicroAction> evaluate(
    DipContextInput input,
    DailyReadinessScore readiness,
  );
}

class HydrationDeficitRule implements DipRule {
  @override
  String get id => 'RULE_HYDRATION_DEFICIT';

  @override
  List<DipMicroAction> evaluate(
    DipContextInput input,
    DailyReadinessScore readiness,
  ) {
    if (input.timestamp.hour >= 12 &&
        input.consumedWaterMl < (input.targetWaterMl * 0.40)) {
      return [
        const DipMicroAction(
          id: 'action_hydration_deficit',
          title: 'Drink 500ml Water',
          description:
              'You are behind on mid-day hydration pace. A glass of water now boosts focus and physical energy.',
          category: DipActionCategory.hydration,
          priority: 75.0,
          actionLabel: 'Log Water',
          actionRoute: '/dashboard',
        ),
      ];
    }
    return const [];
  }
}

class PostMealShatapawaliRule implements DipRule {
  @override
  String get id => 'RULE_POST_MEAL_WALK';

  @override
  List<DipMicroAction> evaluate(
    DipContextInput input,
    DailyReadinessScore readiness,
  ) {
    if (input.recentMealTimestamp != null) {
      final minutesSinceMeal =
          input.timestamp.difference(input.recentMealTimestamp!).inMinutes;
      final calories = input.recentMealCalories ?? 0.0;

      if (minutesSinceMeal >= 0 && minutesSinceMeal <= 60 && calories >= 450.0) {
        return [
          const DipMicroAction(
            id: 'action_shatapawali',
            title: 'Take a 10-Minute Shatapawali Walk',
            description:
                'A gentle 100-step stroll after eating eases digestion and blunts post-prandial glycemic spikes.',
            category: DipActionCategory.movement,
            priority: 80.0,
            actionLabel: 'Start Walk',
            actionRoute: '/workouts',
            culturalContext: 'Indian Shatapawali post-meal strolling tradition',
          ),
        ];
      }
    }
    return const [];
  }
}

class SedentaryBreakRule implements DipRule {
  @override
  String get id => 'RULE_SEDENTARY_BREAK';

  @override
  List<DipMicroAction> evaluate(
    DipContextInput input,
    DailyReadinessScore readiness,
  ) {
    if (input.timestamp.hour >= 16 && input.todaySteps < 3500) {
      return [
        DipMicroAction(
          id: 'action_sedentary_break',
          title: '15-Minute Movement Refresh',
          description:
              'You have logged ${input.todaySteps} steps so far. A short brisk walk before twilight lifts circulation and posture.',
          category: DipActionCategory.movement,
          priority: 70.0,
          actionLabel: 'Step Outside',
          actionRoute: '/workouts',
        ),
      ];
    }
    return const [];
  }
}

class HighFatigueRecoveryRule implements DipRule {
  @override
  String get id => 'RULE_HIGH_FATIGUE_REST';

  @override
  List<DipMicroAction> evaluate(
    DipContextInput input,
    DailyReadinessScore readiness,
  ) {
    final isAcwrHigh = input.chronicWorkload > 0 &&
        (input.acuteWorkload / input.chronicWorkload) > 1.5;

    if (readiness.tier == ReadinessTier.recovery || isAcwrHigh) {
      return [
        const DipMicroAction(
          id: 'action_high_fatigue_recovery',
          title: 'Active Recovery & Gentle Asana',
          description:
              'Elevated physiological fatigue detected. Favor mobility drills, gentle stretching (Shavasana), and adequate hydration over heavy volume.',
          category: DipActionCategory.recovery,
          priority: 92.0,
          actionLabel: 'Rest & Stretch',
          actionRoute: '/workouts',
          culturalContext: 'Yogic restorative asana',
        ),
      ];
    }
    return const [];
  }
}

class DinnerLogReminderRule implements DipRule {
  @override
  String get id => 'RULE_DINNER_LOG_REMINDER';

  @override
  List<DipMicroAction> evaluate(
    DipContextInput input,
    DailyReadinessScore readiness,
  ) {
    if (input.timestamp.hour >= 20) {
      final hasRecentDinner = input.recentMealTimestamp != null &&
          input.recentMealTimestamp!.hour >= 18;
      if (!hasRecentDinner) {
        return [
          const DipMicroAction(
            id: 'action_dinner_log_reminder',
            title: "Log Today's Dinner",
            description:
                'Recording your dinner now keeps your daily nutritional split and calories accurate.',
            category: DipActionCategory.nutrition,
            priority: 65.0,
            actionLabel: 'Log Meal',
            actionRoute: '/nutrition',
          ),
        ];
      }
    }
    return const [];
  }
}

class SleepWindDownRule implements DipRule {
  @override
  String get id => 'RULE_SLEEP_PREP';

  @override
  List<DipMicroAction> evaluate(
    DipContextInput input,
    DailyReadinessScore readiness,
  ) {
    if (input.timestamp.hour >= 22) {
      return [
        const DipMicroAction(
          id: 'action_sleep_wind_down',
          title: 'Begin Sleep Wind-Down',
          description:
              'Dim indoor lights, avoid digital screens, and relax the nervous system for deep restorative rest.',
          category: DipActionCategory.mindset,
          priority: 62.0,
          actionLabel: 'Wind Down',
        ),
      ];
    }
    return const [];
  }
}

class ColdStartOnboardingRule implements DipRule {
  @override
  String get id => 'RULE_COLD_START_ONBOARD';

  @override
  List<DipMicroAction> evaluate(
    DipContextInput input,
    DailyReadinessScore readiness,
  ) {
    if (input.todaySteps == 0 &&
        input.consumedWaterMl == 0 &&
        input.consumedCalories == 0 &&
        input.sleep == null) {
      return [
        const DipMicroAction(
          id: 'action_cold_start',
          title: 'Morning Check-In & Hydration',
          description:
              'Start your morning with a glass of water and review your daily physical activity goals.',
          category: DipActionCategory.mindset,
          priority: 85.0,
          actionLabel: 'Log First Habit',
          actionRoute: '/dashboard',
        ),
      ];
    }
    return const [];
  }
}

class DipRuleEngine {
  final List<DipRule> _rules;
  final DailyReadinessCalculator _calculator;

  DipRuleEngine({
    List<DipRule>? rules,
    DailyReadinessCalculator? calculator,
  })  : _rules = rules ??
            [
              HighFatigueRecoveryRule(),
              PostMealShatapawaliRule(),
              ColdStartOnboardingRule(),
              HydrationDeficitRule(),
              SedentaryBreakRule(),
              DinnerLogReminderRule(),
              SleepWindDownRule(),
            ],
        _calculator = calculator ?? const DailyReadinessCalculator();

  DailyIntelligencePackage assemblePackage(DipContextInput input) {
    final readiness = _calculator.calculateReadiness(input);

    // Evaluate rules
    final candidateActions = <DipMicroAction>[];
    for (final rule in _rules) {
      candidateActions.addAll(rule.evaluate(input, readiness));
    }

    // Default action if none triggered
    if (candidateActions.isEmpty) {
      candidateActions.add(
        const DipMicroAction(
          id: 'action_steady_pace',
          title: 'Maintain Steady Habit Pace',
          description:
              'You are tracking well today. Continue your balanced hydration, meals, and active steps.',
          category: DipActionCategory.movement,
          priority: 50.0,
          actionLabel: 'View Progress',
          actionRoute: '/dashboard',
        ),
      );
    }

    // Sort descending by priority
    candidateActions.sort((a, b) => b.priority.compareTo(a.priority));

    // Clamp to at most 3 items (Cognitive Load Fence)
    final topActions = candidateActions.take(3).toList();

    // Primary Focus Signal synthesis
    final primaryFocus = _synthesizePrimaryFocus(readiness, topActions.first);

    // Summary metrics snapshot
    final summaryMetrics = DipSummaryMetrics(
      todaySteps: input.todaySteps,
      stepGoal: input.stepGoal,
      consumedCalories: input.consumedCalories,
      targetCalories: input.targetCalories,
      sleepMinutes: input.sleep?.durationMinutes,
      consumedWaterMl: input.consumedWaterMl,
      targetWaterMl: input.targetWaterMl,
    );

    return DailyIntelligencePackage(
      date: input.timestamp,
      readinessScore: readiness,
      primaryFocus: primaryFocus,
      topActions: topActions,
      summaryMetrics: summaryMetrics,
    );
  }

  DipFocusSignal _synthesizePrimaryFocus(
    DailyReadinessScore readiness,
    DipMicroAction topAction,
  ) {
    if (readiness.tier == ReadinessTier.recovery) {
      return const DipFocusSignal(
        title: 'Focus on Recovery',
        subtitle: 'Muscular restoration & sleep hygiene are your priorities today.',
        badge: 'Recovery Mode',
      );
    }

    if (topAction.priority >= 75.0) {
      return DipFocusSignal(
        title: topAction.title,
        subtitle: topAction.description,
        badge: topAction.category.name.toUpperCase(),
      );
    }

    return DipFocusSignal(
      title: readiness.headline,
      subtitle: readiness.explanation,
      badge: readiness.tier.name.toUpperCase(),
    );
  }
}

