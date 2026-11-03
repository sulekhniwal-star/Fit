class DynamicTdeeResult {
  final double bmr;
  final double estimatedTdee;
  final double activityMultiplier;
  final String confidenceLevel; // 'low', 'medium', 'high'
  final bool isUserOverride;
  final String notes;

  const DynamicTdeeResult({
    required this.bmr,
    required this.estimatedTdee,
    required this.activityMultiplier,
    this.confidenceLevel = 'medium',
    this.isUserOverride = false,
    this.notes = 'Calculated from biometric baselines and activity telemetry',
  });
}

class DynamicTdeeCalculator {
  const DynamicTdeeCalculator();

  /// Computes basal metabolic rate via Mifflin-St Jeor.
  double calculateBmr({
    required double weightKg,
    required double heightCm,
    required int age,
    required bool isMale,
  }) {
    if (weightKg <= 0 || heightCm <= 0 || age <= 0) return 1500.0;

    if (isMale) {
      return (10.0 * weightKg) + (6.25 * heightCm) - (5.0 * age) + 5.0;
    } else {
      return (10.0 * weightKg) + (6.25 * heightCm) - (5.0 * age) - 161.0;
    }
  }

  /// Calculates activity factor derived from daily step telemetry.
  double calculateActivityMultiplier(int dailySteps) {
    if (dailySteps < 5000) {
      return 1.20; // Sedentary
    } else if (dailySteps < 7500) {
      return 1.375; // Lightly active
    } else if (dailySteps < 10000) {
      return 1.55; // Moderately active
    } else {
      return 1.725; // Highly active
    }
  }

  /// Dynamically computes Total Daily Energy Expenditure (TDEE).
  /// Integrates Phase 5 weight trend and average caloric intake when available.
  DynamicTdeeResult calculate({
    required double weightKg,
    required double heightCm,
    required int age,
    required bool isMale,
    required int dailySteps,
    double? weeklyWeightChangeKg,
    double? averageDailyIntakeKcal,
    double? userOverrideTdee,
  }) {
    if (userOverrideTdee != null && userOverrideTdee > 500.0) {
      final bmr = calculateBmr(weightKg: weightKg, heightCm: heightCm, age: age, isMale: isMale);
      return DynamicTdeeResult(
        bmr: double.parse(bmr.toStringAsFixed(0)),
        estimatedTdee: double.parse(userOverrideTdee.toStringAsFixed(0)),
        activityMultiplier: 1.0,
        confidenceLevel: 'high',
        isUserOverride: true,
        notes: 'User custom target override applied',
      );
    }

    final bmr = calculateBmr(weightKg: weightKg, heightCm: heightCm, age: age, isMale: isMale);
    final multiplier = calculateActivityMultiplier(dailySteps);
    final baselineTdee = bmr * multiplier;

    // If empirical intake and weight change are available, dynamically adjust
    if (weeklyWeightChangeKg != null && averageDailyIntakeKcal != null && averageDailyIntakeKcal > 800.0) {
      // 1 kg body mass ~ 7700 kcal
      final dailyDeficitOrSurplus = (weeklyWeightChangeKg * 7700.0) / 7.0;
      final empiricalTdee = averageDailyIntakeKcal - dailyDeficitOrSurplus;

      // Blend 60% empirical with 40% physiological baseline to prevent erratic variance
      final blendedTdee = (empiricalTdee * 0.60) + (baselineTdee * 0.40);

      return DynamicTdeeResult(
        bmr: double.parse(bmr.toStringAsFixed(0)),
        estimatedTdee: double.parse(blendedTdee.toStringAsFixed(0)),
        activityMultiplier: multiplier,
        confidenceLevel: 'high',
        notes: 'Calibrated from 7-day weight trend and logged calorie intake',
      );
    }

    return DynamicTdeeResult(
      bmr: double.parse(bmr.toStringAsFixed(0)),
      estimatedTdee: double.parse(baselineTdee.toStringAsFixed(0)),
      activityMultiplier: multiplier,
      confidenceLevel: 'medium',
      notes: 'Estimated from Mifflin-St Jeor equation and daily step telemetry',
    );
  }
}

