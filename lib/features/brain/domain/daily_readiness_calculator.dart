import 'dart:math';
import 'dip_models.dart';

class DailyReadinessCalculator {
  const DailyReadinessCalculator();

  DailyReadinessScore calculateReadiness(DipContextInput input) {
    // 1. Sleep Factor (Nominal weight 0.35)
    final sleepFactor = _computeSleepFactor(input);

    // 2. Vitals Factor (Nominal weight 0.25)
    final vitalsFactor = _computeVitalsFactor(input);

    // 3. Workload Strain Factor (Nominal weight 0.25)
    final strainFactor = _computeStrainFactor(input);

    // 4. Hydration/Nutrition Factor (Nominal weight 0.15)
    final nutritionFactor = _computeNutritionFactor(input);

    final factors = [
      sleepFactor,
      vitalsFactor,
      strainFactor,
      nutritionFactor,
    ];

    final nonMissing = factors.where((f) => !f.isMissing).toList();

    // Dynamic weight normalization for available factors with uncertainty prior for missing telemetry
    int finalScore;
    if (nonMissing.isEmpty) {
      finalScore = 70; // Baseline fallback
    } else {
      double totalWeight = 0.0;
      double weightedSum = 0.0;

      for (final f in factors) {
        if (!f.isMissing) {
          totalWeight += f.weight;
          weightedSum += f.score * f.weight;
        } else {
          // Impute uncertainty prior with 30% of nominal weight at neutral baseline
          final priorWeight = f.weight * 0.3;
          totalWeight += priorWeight;
          weightedSum += f.score * priorWeight;
        }
      }
      finalScore = (weightedSum / totalWeight).round().clamp(0, 100);
    }

    final tier = _determineTier(finalScore);
    final (headline, explanation) = _getNarrative(tier, nonMissing);

    return DailyReadinessScore(
      score: finalScore,
      tier: tier,
      headline: headline,
      explanation: explanation,
      factors: factors,
      statutoryDisclaimer: DailyReadinessScore.defaultDisclaimer,
      calculatedAt: input.timestamp,
    );
  }

  ReadinessFactor _computeSleepFactor(DipContextInput input) {
    if (input.sleep == null) {
      return const ReadinessFactor(
        name: 'Sleep',
        score: 70,
        weight: 0.35,
        summary: 'No sleep record logged',
        isMissing: true,
      );
    }

    final sleep = input.sleep!;
    // Target 8 hours = 480 minutes
    final durationScore = ((sleep.durationMinutes / 480.0) * 100.0).clamp(0.0, 100.0);
    final qualityScore = (sleep.qualityRating * 20.0).clamp(20.0, 100.0);

    final combined = (durationScore * 0.7 + qualityScore * 0.3).round().clamp(0, 100);
    final hours = (sleep.durationMinutes / 60.0).toStringAsFixed(1);

    return ReadinessFactor(
      name: 'Sleep',
      score: combined,
      weight: 0.35,
      summary: '$hours hrs (${sleep.qualityRating}/5 quality)',
      isMissing: false,
    );
  }

  ReadinessFactor _computeVitalsFactor(DipContextInput input) {
    if (input.restingHeartRate == null) {
      return const ReadinessFactor(
        name: 'Vitals (RHR)',
        score: 75,
        weight: 0.25,
        summary: 'No resting heart rate sensor',
        isMissing: true,
      );
    }

    final rhr = input.restingHeartRate!;
    int score;
    if (rhr <= 65) {
      score = 98;
    } else if (rhr <= 72) {
      score = 88;
    } else if (rhr <= 80) {
      score = 75;
    } else {
      score = max(40, 100 - ((rhr - 65) * 2.5)).round().clamp(0, 100);
    }

    return ReadinessFactor(
      name: 'Vitals (RHR)',
      score: score,
      weight: 0.25,
      summary: '${rhr.round()} bpm resting HR',
      isMissing: false,
    );
  }

  ReadinessFactor _computeStrainFactor(DipContextInput input) {
    if (input.chronicWorkload <= 0.0) {
      if (input.acuteWorkload > 0.0) {
        return const ReadinessFactor(
          name: 'Strain & Workload',
          score: 82,
          weight: 0.25,
          summary: 'Baseline workload establishing',
          isMissing: false,
        );
      }
      return const ReadinessFactor(
        name: 'Strain & Workload',
        score: 85,
        weight: 0.25,
        summary: 'No recent workout fatigue',
        isMissing: true,
      );
    }

    final acwr = input.acuteWorkload / input.chronicWorkload;
    int score;
    String summary;

    if (acwr >= 0.8 && acwr <= 1.3) {
      score = 100;
      summary = 'Optimal workload ratio (${acwr.toStringAsFixed(2)})';
    } else if (acwr > 1.3 && acwr <= 1.5) {
      score = 70;
      summary = 'Elevated acute strain (${acwr.toStringAsFixed(2)})';
    } else if (acwr > 1.5) {
      score = 42;
      summary = 'High acute fatigue (${acwr.toStringAsFixed(2)})';
    } else {
      score = 90;
      summary = 'Well rested (${acwr.toStringAsFixed(2)})';
    }

    return ReadinessFactor(
      name: 'Strain & Workload',
      score: score,
      weight: 0.25,
      summary: summary,
      isMissing: false,
    );
  }

  ReadinessFactor _computeNutritionFactor(DipContextInput input) {
    final hour = input.timestamp.hour;
    // Expected active pacing fraction from 06:00 to 22:00 (16 hours)
    final progressPace = ((hour - 6).clamp(0, 16) / 16.0);
    final expectedWater = (input.targetWaterMl * progressPace).round();

    double hydrationRatio;
    if (expectedWater <= 0) {
      hydrationRatio = 1.0;
    } else {
      hydrationRatio = (input.consumedWaterMl / expectedWater).clamp(0.0, 1.3);
    }

    final score = (hydrationRatio * 90.0).round().clamp(30, 100);

    return ReadinessFactor(
      name: 'Hydration Pacing',
      score: score,
      weight: 0.15,
      summary: '${input.consumedWaterMl}ml logged (${(hydrationRatio * 100).round()}% pace)',
      isMissing: false,
    );
  }

  ReadinessTier _determineTier(int score) {
    if (score >= 85) return ReadinessTier.peak;
    if (score >= 70) return ReadinessTier.optimal;
    if (score >= 50) return ReadinessTier.moderate;
    return ReadinessTier.recovery;
  }

  (String, String) _getNarrative(
    ReadinessTier tier,
    List<ReadinessFactor> nonMissing,
  ) {
    switch (tier) {
      case ReadinessTier.peak:
        return (
          'Peak Recovery State',
          'Your biometric markers show high restoration. Great day for progressive overload or intense training.',
        );
      case ReadinessTier.optimal:
        return (
          'Balanced Readiness',
          'Good physiological baseline. Ready for normal training cadence and scheduled daily activity.',
        );
      case ReadinessTier.moderate:
        return (
          'Moderate Strain',
          'Mild residual fatigue detected. Focus on controlled technique, accessory volume, or active mobility.',
        );
      case ReadinessTier.recovery:
        return (
          'Recovery Priority',
          'Significant accumulated strain or recovery deficit. Favor restorative sleep, stretching, and hydration.',
        );
    }
  }
}
