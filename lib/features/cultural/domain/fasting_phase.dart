// ============================================================================
// METABOLIC FASTING PHASES & DYNAMIC CALCULATOR
// ============================================================================

enum FastingStage {
  anabolic, // 0 - 4h: Blood sugar elevated, insulin storing glucose
  digestion, // 4 - 8h: Blood sugar stabilizes, glycogen breakdown starts
  gluconeogenesis, // 8 - 12h: Glycogen depletes, liver generates glucose from amino acids
  ketosisTransition, // 12 - 16h: Insulin hits baseline, fat mobilization starts
  fatBurning, // 16 - 24h: Active fat burning and ketone production
  deepAutophagy, // 24h+: Cellular recycling, autophagy, deep mitochondrial repair
}

class FastingStageInfo {
  final FastingStage stage;
  final String title;
  final String subtitle;
  final String biologicalDescription;
  final double startHours;
  final double endHours;
  final String iconAsset;

  const FastingStageInfo({
    required this.stage,
    required this.title,
    required this.subtitle,
    required this.biologicalDescription,
    required this.startHours,
    required this.endHours,
    required this.iconAsset,
  });
}

class FastingPhaseCalculator {
  static const Map<FastingStage, FastingStageInfo> stages = {
    FastingStage.anabolic: FastingStageInfo(
      stage: FastingStage.anabolic,
      title: 'Anabolic (Fed Stage)',
      subtitle: 'Nutrient absorption & insulin storage',
      biologicalDescription: 'Your body is actively processing nutrients from your last meal. Blood glucose and insulin are elevated.',
      startHours: 0.0,
      endHours: 4.0,
      iconAsset: 'local_fire_department',
    ),
    FastingStage.digestion: FastingStageInfo(
      stage: FastingStage.digestion,
      title: 'Digestion & Stabilization',
      subtitle: 'Blood glucose normalizes',
      biologicalDescription: 'Insulin levels begin to decrease. Your liver starts mobilizing stored glycogen to sustain resting energy.',
      startHours: 4.0,
      endHours: 8.0,
      iconAsset: 'access_time',
    ),
    FastingStage.gluconeogenesis: FastingStageInfo(
      stage: FastingStage.gluconeogenesis,
      title: 'Early Fasting Stage',
      subtitle: 'Glycogen depletion underway',
      biologicalDescription: 'Stored glycogen runs low. The liver initiates gluconeogenesis, producing energy from amino acids and glycerol.',
      startHours: 8.0,
      endHours: 12.0,
      iconAsset: 'bolt',
    ),
    FastingStage.ketosisTransition: FastingStageInfo(
      stage: FastingStage.ketosisTransition,
      title: 'Ketosis Transition',
      subtitle: 'Fat breakdown accelerates',
      biologicalDescription: 'Insulin approaches baseline. Adipose tissue releases fatty acids, and mild ketone bodies enter circulation.',
      startHours: 12.0,
      endHours: 16.0,
      iconAsset: 'fitness_center',
    ),
    FastingStage.fatBurning: FastingStageInfo(
      stage: FastingStage.fatBurning,
      title: 'Active Fat Burning',
      subtitle: 'Elevated ketones & lipolysis',
      biologicalDescription: 'Fat serves as the primary metabolic fuel. Mental focus sharpens as the brain utilizes ketones for clean energy.',
      startHours: 16.0,
      endHours: 24.0,
      iconAsset: 'whatshot',
    ),
    FastingStage.deepAutophagy: FastingStageInfo(
      stage: FastingStage.deepAutophagy,
      title: 'Cellular Autophagy',
      subtitle: 'Mitochondrial repair & renewal',
      biologicalDescription: 'Cellular cleanup kicks into high gear. Damaged cellular proteins and dysfunctional organelles are broken down and recycled.',
      startHours: 24.0,
      endHours: 999.0,
      iconAsset: 'auto_awesome',
    ),
  };

  /// Returns the current metabolic stage given elapsed hours.
  static FastingStage getStage(double elapsedHours) {
    if (elapsedHours < 4.0) return FastingStage.anabolic;
    if (elapsedHours < 8.0) return FastingStage.digestion;
    if (elapsedHours < 12.0) return FastingStage.gluconeogenesis;
    if (elapsedHours < 16.0) return FastingStage.ketosisTransition;
    if (elapsedHours < 24.0) return FastingStage.fatBurning;
    return FastingStage.deepAutophagy;
  }

  /// Returns the descriptive metadata object for the stage.
  static FastingStageInfo getStageInfo(double elapsedHours) {
    final stage = getStage(elapsedHours);
    return stages[stage]!;
  }

  /// Computes fractional progress (0.0 to 1.0, or > 1.0 when exceeded target).
  static double calculateProgress({
    required DateTime startTime,
    required DateTime plannedEndTime,
    DateTime? currentTime,
  }) {
    final now = currentTime ?? DateTime.now();
    final totalPlannedMs = plannedEndTime.difference(startTime).inMilliseconds;
    if (totalPlannedMs <= 0) return 1.0;

    final elapsedMs = now.difference(startTime).inMilliseconds;
    return (elapsedMs / totalPlannedMs).clamp(0.0, 5.0);
  }
}
