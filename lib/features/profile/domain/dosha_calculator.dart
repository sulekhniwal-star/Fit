enum DoshaType {
  vata,
  pitta,
  kapha,
  triDoshic,
}

class DoshaProfile {
  final DoshaType primaryDosha;
  final DoshaType? secondaryDosha;
  final int vataScore;
  final int pittaScore;
  final int kaphaScore;

  /// Statutory disclaimer distinguishing Ayurvedic wellness from medical diagnosis.
  static const String nonMedicalDisclaimer =
      'Ayurvedic Dosha profiling provides traditional lifestyle and wellness balance insights. '
      'It does not constitute medical diagnosis, clinical treatment, or healthcare advice.';

  const DoshaProfile({
    required this.primaryDosha,
    this.secondaryDosha,
    required this.vataScore,
    required this.pittaScore,
    required this.kaphaScore,
  });

  Map<String, dynamic> toJson() => {
        'primary_dosha': primaryDosha.name,
        'secondary_dosha': secondaryDosha?.name,
        'vata_score': vataScore,
        'pitta_score': pittaScore,
        'kapha_score': kaphaScore,
        'disclaimer': nonMedicalDisclaimer,
      };

  factory DoshaProfile.fromJson(Map<String, dynamic> json) {
    return DoshaProfile(
      primaryDosha: DoshaType.values.firstWhere(
        (d) => d.name == json['primary_dosha'],
        orElse: () => DoshaType.vata,
      ),
      secondaryDosha: json['secondary_dosha'] != null
          ? DoshaType.values.firstWhere(
              (d) => d.name == json['secondary_dosha'],
              orElse: () => DoshaType.vata,
            )
          : null,
      vataScore: json['vata_score'] as int? ?? 0,
      pittaScore: json['pitta_score'] as int? ?? 0,
      kaphaScore: json['kapha_score'] as int? ?? 0,
    );
  }
}

class DoshaCalculator {
  const DoshaCalculator();

  /// Deterministically calculates dominant Dosha based on questionnaire scores.
  DoshaProfile calculate({
    required int vataPoints,
    required int pittaPoints,
    required int kaphaPoints,
  }) {
    // If all scores are equal, classify as tri-doshic
    if (vataPoints == pittaPoints && pittaPoints == kaphaPoints && vataPoints > 0) {
      return DoshaProfile(
        primaryDosha: DoshaType.triDoshic,
        vataScore: vataPoints,
        pittaScore: pittaPoints,
        kaphaScore: kaphaPoints,
      );
    }

    final scores = [
      MapEntry(DoshaType.vata, vataPoints),
      MapEntry(DoshaType.pitta, pittaPoints),
      MapEntry(DoshaType.kapha, kaphaPoints),
    ]..sort((a, b) => b.value.compareTo(a.value));

    final primary = scores[0].key;
    final secondary = scores[1].value > 0 && scores[1].value >= (scores[0].value * 0.75)
        ? scores[1].key
        : null;

    return DoshaProfile(
      primaryDosha: primary,
      secondaryDosha: secondary,
      vataScore: vataPoints,
      pittaScore: pittaPoints,
      kaphaScore: kaphaPoints,
    );
  }
}

