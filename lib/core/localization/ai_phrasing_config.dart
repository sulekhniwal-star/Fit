library;

import 'package:fitkarma/core/localization/app_language.dart';

/// Hinglish lexical mixing ratio for AI coaching and conversational interactions.
enum HinglishMixRatio {
  /// Natural Indian English with occasional familiar culinary/cultural terms (e.g. roti, dal, sabzi).
  subtle(
    ratio: 0.15,
    label: 'Subtle (15%)',
    description:
        'Primarily Indian English with familiar culinary and lifestyle terms.',
  ),

  /// Everyday comfortable conversational Hinglish mixing Hindi vocabulary with English health terms.
  balanced(
    ratio: 0.45,
    label: 'Balanced (45%)',
    description: 'Natural bilingual conversational blend mixing Hindi idioms with English metrics.',
  ),

  /// Vernacular-forward Hindi/Hinglish with cultural warmth, proverbs, and colloquial encouragement.
  vernacular(
    ratio: 0.75,
    label: 'Vernacular (75%)',
    description: 'Deep regional phrasing with vernacular encouragement and familiar cultural touchpoints.',
  );

  const HinglishMixRatio({
    required this.ratio,
    required this.label,
    required this.description,
  });

  /// Approximate numerical proportion of Hindi/vernacular vocabulary tokens.
  final double ratio;

  /// Human-readable label for UI settings.
  final String label;

  /// Editorial description for prompt synthesis.
  final String description;

  /// Resolves [HinglishMixRatio] from a ratio value or name.
  static HinglishMixRatio fromRatio(double value) {
    if (value <= 0.25) return HinglishMixRatio.subtle;
    if (value <= 0.60) return HinglishMixRatio.balanced;
    return HinglishMixRatio.vernacular;
  }

  /// Resolves [HinglishMixRatio] from serialized string name.
  static HinglishMixRatio fromName(String? name) {
    for (final ratio in HinglishMixRatio.values) {
      if (ratio.name.toLowerCase() == name?.toLowerCase()) {
        return ratio;
      }
    }
    return HinglishMixRatio.balanced;
  }
}

/// AI health coaching persona and conversational tone.
enum CoachingTone {
  /// Empathetic, caring, respectful, warm guidance like a wise elder or supportive family member.
  supportiveElder(
    label: 'Supportive Elder',
    guidance: 'Warm, respectful, patient, and caring like a wise family elder. Use nurturing encouragement rather than stern commands.',
  ),

  /// Energetic, direct, celebratory, relatable like a gym partner or running buddy.
  peerBuddy(
    label: 'Peer Buddy',
    guidance: 'High-energy, direct, fun, and celebratory like a trusted fitness partner. Use concise check-ins, playful banter, and high-fives.',
  ),

  /// Objective, precise, evidence-based, structured metrics and metabolic science.
  clinicalSpecialist(
    label: 'Clinical Specialist',
    guidance: 'Objective, measured, evidence-based, and clinically precise. Emphasize metabolic biomarkers, glycemic variance, and scientific rationale.',
  );

  const CoachingTone({required this.label, required this.guidance});

  /// Display label for profile configuration.
  final String label;

  /// Guidance injected into LLM system prompts.
  final String guidance;

  /// Resolves [CoachingTone] from string name.
  static CoachingTone fromName(String? name) {
    for (final tone in CoachingTone.values) {
      if (tone.name.toLowerCase() == name?.toLowerCase()) {
        return tone;
      }
    }
    return CoachingTone.supportiveElder;
  }
}

/// Independent configuration for AI-generated conversational phrasing, LLM tone,
/// Hinglish lexical blending, and cultural fasting awareness.
///
/// Kept strictly separated from static UI string localization catalogs.
class AiPhrasingConfig {
  const AiPhrasingConfig({
    this.dialect = AppLanguage.english,
    this.hinglishMixRatio = HinglishMixRatio.balanced,
    this.coachingTone = CoachingTone.supportiveElder,
    this.fastingAwareness = true,
  });

  /// Primary dialect/language for conversational responses.
  final AppLanguage dialect;

  /// Lexical blending proportion for Hinglish responses.
  final HinglishMixRatio hinglishMixRatio;

  /// AI coaching personality persona.
  final CoachingTone coachingTone;

  /// Whether LLM meal advice must account for fasting practices (e.g. Navratri, Ramadan, Ekadashi).
  final bool fastingAwareness;

  /// Creates a copy with the given fields replaced by the new values.
  AiPhrasingConfig copyWith({
    AppLanguage? dialect,
    HinglishMixRatio? hinglishMixRatio,
    CoachingTone? coachingTone,
    bool? fastingAwareness,
  }) {
    return AiPhrasingConfig(
      dialect: dialect ?? this.dialect,
      hinglishMixRatio: hinglishMixRatio ?? this.hinglishMixRatio,
      coachingTone: coachingTone ?? this.coachingTone,
      fastingAwareness: fastingAwareness ?? this.fastingAwareness,
    );
  }

  /// Synthesizes prompt instructions for LLM conversational guidance.
  String toSystemPromptSnippet() {
    final buffer = StringBuffer();
    buffer.writeln('### AI CONVERSATIONAL PHRASING DIRECTIVE');
    buffer.writeln(
      '- Primary Dialect: ${dialect.englishName} (${dialect.code})',
    );
    buffer.writeln(
      '- Hinglish Mix Ratio: ${hinglishMixRatio.label} -> ${hinglishMixRatio.description}',
    );
    buffer.writeln(
      '- Coaching Persona: ${coachingTone.label} -> ${coachingTone.guidance}',
    );
    if (fastingAwareness) {
      buffer.writeln(
        '- Fasting & Religious Calendar Awareness: ACTIVE. Validate meals against religious fasting protocols (e.g. Navratri phalahari items, Ramadan Suhoor/Iftar timings, Ekadashi grain restrictions, Jain nocturnal eating rules) before suggesting caloric or macro adjustments.',
      );
    } else {
      buffer.writeln(
        '- Fasting Calendar Awareness: INACTIVE. Standard caloric and macro guidelines apply.',
      );
    }
    return buffer.toString().trim();
  }

  /// Serializes configuration to JSON.
  Map<String, dynamic> toJson() {
    return {
      'dialect': dialect.code,
      'hinglish_mix_ratio': hinglishMixRatio.name,
      'coaching_tone': coachingTone.name,
      'fasting_awareness': fastingAwareness,
    };
  }

  /// Deserializes configuration from JSON with safe defaults.
  factory AiPhrasingConfig.fromJson(Map<String, dynamic> json) {
    return AiPhrasingConfig(
      dialect: AppLanguage.fromCode(json['dialect'] as String?),
      hinglishMixRatio: HinglishMixRatio.fromName(
        json['hinglish_mix_ratio'] as String?,
      ),
      coachingTone: CoachingTone.fromName(json['coaching_tone'] as String?),
      fastingAwareness: json['fasting_awareness'] as bool? ?? true,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AiPhrasingConfig &&
          runtimeType == other.runtimeType &&
          dialect == other.dialect &&
          hinglishMixRatio == other.hinglishMixRatio &&
          coachingTone == other.coachingTone &&
          fastingAwareness == other.fastingAwareness;

  @override
  int get hashCode =>
      Object.hash(dialect, hinglishMixRatio, coachingTone, fastingAwareness);

  @override
  String toString() =>
      'AiPhrasingConfig(dialect: ${dialect.code}, mixRatio: ${hinglishMixRatio.name}, tone: ${coachingTone.name}, fasting: $fastingAwareness)';
}
