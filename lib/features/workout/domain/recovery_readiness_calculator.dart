enum ReadinessTier {
  high,
  moderate,
  recovery;

  String get displayName {
    switch (this) {
      case ReadinessTier.high:
        return 'High Readiness';
      case ReadinessTier.moderate:
        return 'Moderate Readiness';
      case ReadinessTier.recovery:
        return 'Active Recovery';
    }
  }
}

class ReadinessScore {
  final int score; // 1 - 100
  final ReadinessTier tier;
  final String guidance;
  final String disclaimer;

  const ReadinessScore({
    required this.score,
    required this.tier,
    required this.guidance,
    this.disclaimer =
        'The recovery readiness score is an algorithmic wellness indicator based on recent volume and logged rest. It is not medical or physical therapy clearance.',
  });
}

class RecoveryReadinessCalculator {
  const RecoveryReadinessCalculator();

  /// Evaluates readiness based on sleep duration, acute/chronic workload ratio (ACWR), and optional mood
  ReadinessScore calculateReadiness({
    required int sleepMinutes,
    required double acuteWorkloadKg,
    required double chronicWorkloadKg,
    int? subjectiveMoodScore, // 1 to 5
  }) {
    // 1. Sleep Component (Max 50 points)
    // 7+ hours (420+ mins) is optimal
    double sleepPoints;
    if (sleepMinutes >= 450) {
      sleepPoints = 50.0;
    } else if (sleepMinutes >= 420) {
      sleepPoints = 46.0;
    } else if (sleepMinutes >= 360) {
      sleepPoints = 36.0;
    } else if (sleepMinutes >= 300) {
      sleepPoints = 25.0;
    } else {
      sleepPoints = 12.0;
    }

    // 2. Acute-to-Chronic Workload Ratio (Max 40 points)
    // Optimal sweet spot: 0.8 - 1.3
    double workloadPoints;
    if (chronicWorkloadKg <= 0.0) {
      workloadPoints = 35.0; // Baseline when no history exists
    } else {
      final acwr = acuteWorkloadKg / chronicWorkloadKg;
      if (acwr >= 0.8 && acwr <= 1.3) {
        workloadPoints = 40.0;
      } else if (acwr > 1.3 && acwr <= 1.5) {
        workloadPoints = 26.0; // Elevated acute load
      } else if (acwr > 1.5) {
        workloadPoints = 14.0; // High fatigue / spike
      } else {
        workloadPoints = 34.0; // Low acute load / well rested
      }
    }

    // 3. Subjective Mood / Wellbeing (Max 10 points)
    final moodPoints = subjectiveMoodScore != null
        ? (subjectiveMoodScore.clamp(1, 5) * 2.0)
        : 7.0;

    final rawScore = (sleepPoints + workloadPoints + moodPoints).round().clamp(1, 100);

    final ReadinessTier tier;
    final String guidance;

    if (rawScore >= 75) {
      tier = ReadinessTier.high;
      guidance = 'Peak Condition. Excellent readiness for high-intensity or hypertrophy training.';
    } else if (rawScore >= 50) {
      tier = ReadinessTier.moderate;
      guidance = 'Optimal Baseline. Suitable for standard volume and progressive overload.';
    } else {
      tier = ReadinessTier.recovery;
      guidance = 'Active Recovery Recommended. Focus on restorative sleep, light mobility, or yoga flows.';
    }

    return ReadinessScore(
      score: rawScore,
      tier: tier,
      guidance: guidance,
    );
  }
}

