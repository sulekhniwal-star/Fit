import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fitkarma/features/onboarding/presentation/onboarding_wizard_screen.dart';
import 'package:fitkarma/features/profile/data/local_profile_repository.dart';
import 'package:fitkarma/shared/widgets/action_button.dart';

void main() {
  Widget buildTestWidget({
    required LocalProfileRepository profileRepository,
    VoidCallback? onCompleted,
  }) {
    return ProviderScope(
      overrides: [
        profileRepositoryProvider.overrideWithValue(profileRepository),
      ],
      child: MaterialApp(
        home: OnboardingWizardScreen(onCompleted: onCompleted),
      ),
    );
  }

  group('OnboardingWizardScreen Widget Tests', () {
    late LocalProfileRepository profileRepository;

    setUp(() {
      profileRepository = LocalProfileRepository();
    });

    testWidgets('navigates through steps and enforces DPDP consent before completion', (tester) async {
      bool completed = false;

      await tester.pumpWidget(
        buildTestWidget(
          profileRepository: profileRepository,
          onCompleted: () => completed = true,
        ),
      );

      // Step 1: Language
      expect(find.text('Step 1 of 5'), findsOneWidget);
      expect(find.text('English'), findsOneWidget);
      await tester.tap(find.byKey(const Key('language_next_button')));
      await tester.pumpAndSettle();

      // Step 2: Biometrics
      expect(find.text('Step 2 of 5'), findsOneWidget);
      expect(find.text('Physical Biometrics'), findsOneWidget);
      await tester.tap(find.byKey(const Key('biometrics_next_button')));
      await tester.pumpAndSettle();

      // Step 3: Diet & Lifestyle
      expect(find.text('Step 3 of 5'), findsOneWidget);
      expect(find.text('Diet & Lifestyle'), findsOneWidget);
      await tester.tap(find.byKey(const Key('diet_next_button')));
      await tester.pumpAndSettle();

      // Step 4: Health Goals & Ayurveda
      expect(find.text('Step 4 of 5'), findsOneWidget);
      expect(find.text('Health Goals & Ayurveda'), findsOneWidget);
      await tester.tap(find.byKey(const Key('goals_next_button')));
      await tester.pumpAndSettle();

      // Step 5: DPDP Consent
      expect(find.text('Step 5 of 5'), findsOneWidget);
      expect(find.text('DPDP Privacy & Consent'), findsOneWidget);

      // Verify button is disabled initially
      var finishButton = tester.widget<ActionButton>(find.byKey(const Key('finish_onboarding_button')));
      expect(finishButton.onPressed, isNull);

      // Check DPDP affirmative consent checkbox
      await tester.tap(find.byKey(const Key('dpdp_consent_checkbox')));
      await tester.pumpAndSettle();

      // Verify button is now enabled
      finishButton = tester.widget<ActionButton>(find.byKey(const Key('finish_onboarding_button')));
      expect(finishButton.onPressed, isNotNull);

      // Tap finish
      await tester.tap(find.byKey(const Key('finish_onboarding_button')));
      await tester.pumpAndSettle();

      expect(completed, isTrue);

      // Verify profile is stored in repository with DPDP consent
      final profileResult = await profileRepository.getProfile('local-user');
      expect(profileResult.isSuccess, isTrue);
      profileResult.when(
        onSuccess: (profile) {
          expect(profile.hasAcceptedDpdpConsent, isTrue);
          expect(profile.age, equals(26));
          expect(profile.heightCm, equals(172.0));
          expect(profile.weightKg, equals(70.0));
        },
        onFailure: (_) => fail('Expected profile to be saved'),
      );
    });
  });
}
