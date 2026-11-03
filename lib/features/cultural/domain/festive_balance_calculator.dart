// ============================================================================
// FESTIVE BALANCE & SHAME-FREE MACRO REDISTRIBUTION CALCULATOR
// ============================================================================

class FeastBalancePlan {
  final int estimatedFeastCalories;
  final int redistributionDays;
  final double dailyCalorieAdjustment;
  final List<String> preFeastGuidelines;
  final List<String> duringFeastMindfulTips;
  final List<String> postFeastRecoveryTips;
  final String shameFreeAffirmation;

  const FeastBalancePlan({
    required this.estimatedFeastCalories,
    required this.redistributionDays,
    required this.dailyCalorieAdjustment,
    required this.preFeastGuidelines,
    required this.duringFeastMindfulTips,
    required this.postFeastRecoveryTips,
    required this.shameFreeAffirmation,
  });
}

class FestiveBalanceCalculator {
  static FeastBalancePlan calculatePlan({
    required int estimatedFeastCalories,
    int redistributionDays = 3,
  }) {
    final validDays = redistributionDays.clamp(2, 5);
    final dailyAdjustment = (estimatedFeastCalories / validDays).roundToDouble();

    return FeastBalancePlan(
      estimatedFeastCalories: estimatedFeastCalories,
      redistributionDays: validDays,
      dailyCalorieAdjustment: dailyAdjustment,
      preFeastGuidelines: const [
        'Hydration loading: Drink 2 tall glasses of water 30 minutes before festive gatherings.',
        'Pre-load with raw fiber: Eat a small cucumber, carrot, or sprout bowl to prime satiety hormones.',
        'Do not starve before the feast: Skipping breakfast or lunch causes extreme reactive overeating.',
      ],
      duringFeastMindfulTips: const [
        'Savor the first 2 bites: Mindfully enjoy the aroma, texture, and sweetness of your favorite mithai.',
        'Fill half your plate with salad, raita, or dal before reaching for fried snacks.',
        'Eat slowly while conversing with loved ones to give satiety cues time to register.',
      ],
      postFeastRecoveryTips: const [
        'Shatapawali (शतावली): Take a 15–20 minute gentle walk after dinner to improve glucose disposal.',
        'Sip warm water or ajwain-jeera tea before bed to support gastric digestion.',
        'Return to your normal wholesome routine the next morning without restrictive punishment.',
      ],
      shameFreeAffirmation:
          'Festivals celebrate family, tradition, and joy. '
          'One or two festive meals will not derail your fitness journey. Enjoy with gratitude!',
    );
  }
}

