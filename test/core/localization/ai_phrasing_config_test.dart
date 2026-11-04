import 'package:fitkarma/core/localization/ai_phrasing_config.dart';
import 'package:fitkarma/core/localization/app_language.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AiPhrasingConfig & LLM Directive Separation', () {
    test(
      'HinglishMixRatio defines correct percentage ratios and descriptions',
      () {
        expect(HinglishMixRatio.subtle.ratio, 0.15);
        expect(HinglishMixRatio.balanced.ratio, 0.45);
        expect(HinglishMixRatio.vernacular.ratio, 0.75);

        expect(HinglishMixRatio.fromRatio(0.10), HinglishMixRatio.subtle);
        expect(HinglishMixRatio.fromRatio(0.25), HinglishMixRatio.subtle);
        expect(HinglishMixRatio.fromRatio(0.40), HinglishMixRatio.balanced);
        expect(HinglishMixRatio.fromRatio(0.60), HinglishMixRatio.balanced);
        expect(HinglishMixRatio.fromRatio(0.70), HinglishMixRatio.vernacular);
        expect(HinglishMixRatio.fromRatio(0.95), HinglishMixRatio.vernacular);

        expect(HinglishMixRatio.fromName('subtle'), HinglishMixRatio.subtle);
        expect(
          HinglishMixRatio.fromName('BALANCED'),
          HinglishMixRatio.balanced,
        );
        expect(
          HinglishMixRatio.fromName('vernacular'),
          HinglishMixRatio.vernacular,
        );
        expect(HinglishMixRatio.fromName('unknown'), HinglishMixRatio.balanced);
      },
    );

    test('CoachingTone provides distinct persona guidelines', () {
      expect(CoachingTone.supportiveElder.guidance, contains('family elder'));
      expect(CoachingTone.peerBuddy.guidance, contains('fitness partner'));
      expect(
        CoachingTone.clinicalSpecialist.guidance,
        contains('evidence-based'),
      );

      expect(CoachingTone.fromName('peerBuddy'), CoachingTone.peerBuddy);
      expect(
        CoachingTone.fromName('clinicalSpecialist'),
        CoachingTone.clinicalSpecialist,
      );
      expect(CoachingTone.fromName('unknown'), CoachingTone.supportiveElder);
    });

    test('AiPhrasingConfig defaults provide balanced India-first coaching', () {
      const config = AiPhrasingConfig();

      expect(config.dialect, AppLanguage.english);
      expect(config.hinglishMixRatio, HinglishMixRatio.balanced);
      expect(config.coachingTone, CoachingTone.supportiveElder);
      expect(config.fastingAwareness, isTrue);
    });

    test('copyWith updates individual parameters cleanly', () {
      const initial = AiPhrasingConfig();

      final updated = initial.copyWith(
        dialect: AppLanguage.hindi,
        hinglishMixRatio: HinglishMixRatio.vernacular,
        coachingTone: CoachingTone.peerBuddy,
        fastingAwareness: false,
      );

      expect(updated.dialect, AppLanguage.hindi);
      expect(updated.hinglishMixRatio, HinglishMixRatio.vernacular);
      expect(updated.coachingTone, CoachingTone.peerBuddy);
      expect(updated.fastingAwareness, isFalse);
    });

    test('serialization roundtrip via toJson and fromJson preserves state', () {
      const original = AiPhrasingConfig(
        dialect: AppLanguage.hindi,
        hinglishMixRatio: HinglishMixRatio.subtle,
        coachingTone: CoachingTone.clinicalSpecialist,
        fastingAwareness: false,
      );

      final json = original.toJson();
      expect(json['dialect'], 'hi');
      expect(json['hinglish_mix_ratio'], 'subtle');
      expect(json['coaching_tone'], 'clinicalSpecialist');
      expect(json['fasting_awareness'], isFalse);

      final reconstructed = AiPhrasingConfig.fromJson(json);
      expect(reconstructed, equals(original));
      expect(reconstructed.hashCode, equals(original.hashCode));
    });

    test(
      'toSystemPromptSnippet includes dialect, ratio, tone, and fasting rules',
      () {
        const config = AiPhrasingConfig(
          dialect: AppLanguage.hindi,
          hinglishMixRatio: HinglishMixRatio.balanced,
          coachingTone: CoachingTone.supportiveElder,
          fastingAwareness: true,
        );

        final promptSnippet = config.toSystemPromptSnippet();

        expect(
          promptSnippet,
          contains('### AI CONVERSATIONAL PHRASING DIRECTIVE'),
        );
        expect(promptSnippet, contains('Primary Dialect: Hindi (hi)'));
        expect(promptSnippet, contains('Hinglish Mix Ratio: Balanced (45%)'));
        expect(promptSnippet, contains('Coaching Persona: Supportive Elder'));
        expect(
          promptSnippet,
          contains('Fasting & Religious Calendar Awareness: ACTIVE'),
        );
        expect(promptSnippet, contains('Navratri phalahari'));
        expect(promptSnippet, contains('Ramadan Suhoor/Iftar'));
        expect(promptSnippet, contains('Ekadashi grain restrictions'));
      },
    );

    test('toSystemPromptSnippet handles inactive fasting awareness', () {
      const config = AiPhrasingConfig(fastingAwareness: false);

      final promptSnippet = config.toSystemPromptSnippet();
      expect(promptSnippet, contains('Fasting Calendar Awareness: INACTIVE'));
    });
  });
}
