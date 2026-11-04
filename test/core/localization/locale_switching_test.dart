import 'package:fitkarma/core/localization/ai_phrasing_config.dart';
import 'package:fitkarma/core/localization/app_language.dart';
import 'package:fitkarma/core/localization/app_locale_notifier.dart';
import 'package:fitkarma/core/localization/app_strings.dart';
import 'package:fitkarma/core/providers/app_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AppLocaleNotifier & State Unit Tests', () {
    test('initializes with English as default language', () {
      final notifier = AppLocaleNotifier();
      expect(notifier.state, AppLanguage.english);
    });

    test(
        'transitions language via setLanguage and avoids redundant states', () {
      final notifier = AppLocaleNotifier();
      var stateChangeCount = 0;
      notifier.addListener((_) => stateChangeCount++);

      // Initial subscription triggers listener once
      expect(stateChangeCount, 1);

      notifier.setLanguage(AppLanguage.hindi);
      expect(notifier.state, AppLanguage.hindi);
      expect(stateChangeCount, 2);

      // Redundant setLanguage does not fire listener
      notifier.setLanguage(AppLanguage.hindi);
      expect(stateChangeCount, 2);

      notifier.setLanguage(AppLanguage.english);
      expect(notifier.state, AppLanguage.english);
      expect(stateChangeCount, 3);
    });

    test('transitions language via setLocale', () {
      final notifier = AppLocaleNotifier();
      notifier.setLocale(const Locale('hi'));
      expect(notifier.state, AppLanguage.hindi);

      notifier.setLocale(const Locale('en'));
      expect(notifier.state, AppLanguage.english);
    });

    test('toggleLanguage alternates between English and Hindi', () {
      final notifier = AppLocaleNotifier();
      expect(notifier.state, AppLanguage.english);

      notifier.toggleLanguage();
      expect(notifier.state, AppLanguage.hindi);

      notifier.toggleLanguage();
      expect(notifier.state, AppLanguage.english);
    });
  });

  group('AiPhrasingConfigNotifier Unit Tests', () {
    test('manages AI phrasing state modifications', () {
      final notifier = AiPhrasingConfigNotifier();
      expect(notifier.state.dialect, AppLanguage.english);
      expect(notifier.state.hinglishMixRatio, HinglishMixRatio.balanced);

      notifier.updateDialect(AppLanguage.hindi);
      expect(notifier.state.dialect, AppLanguage.hindi);

      notifier.updateHinglishMixRatio(HinglishMixRatio.vernacular);
      expect(notifier.state.hinglishMixRatio, HinglishMixRatio.vernacular);

      notifier.updateCoachingTone(CoachingTone.peerBuddy);
      expect(notifier.state.coachingTone, CoachingTone.peerBuddy);

      notifier.setFastingAwareness(enabled: false);
      expect(notifier.state.fastingAwareness, isFalse);
    });
  });

  group('Riverpod Locale & Strings Reactive Providers', () {
    test('appLanguageProvider drives appLocaleProvider and appStringsProvider',
        () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      expect(container.read(appLanguageProvider), AppLanguage.english);
      expect(container.read(appLocaleProvider), const Locale('en'));
      expect(container.read(appStringsProvider), isA<EnglishStrings>());

      // Switch to Hindi
      container
          .read(appLanguageProvider.notifier)
          .setLanguage(AppLanguage.hindi);

      expect(container.read(appLanguageProvider), AppLanguage.hindi);
      expect(container.read(appLocaleProvider), const Locale('hi'));
      expect(container.read(appStringsProvider), isA<HindiStrings>());
      expect(container.read(appStringsProvider).dashboard, 'डैशबोर्ड');
    });
  });

  group('Dynamic UI Locale Switching Widget Test', () {
    testWidgets(
      'UI immediately updates between English and Hindi without app restart',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          ProviderScope(
            child: Consumer(
              builder: (context, ref, child) {
                final locale = ref.watch(appLocaleProvider);
                final strings = ref.watch(appStringsProvider);

                return MaterialApp(
                  locale: locale,
                  supportedLocales: AppLanguage.supportedLocales,
                  localizationsDelegates: const [
                    AppStrings.delegate,
                    GlobalMaterialLocalizations.delegate,
                    GlobalWidgetsLocalizations.delegate,
                    GlobalCupertinoLocalizations.delegate,
                  ],
                  home: Scaffold(
                    appBar: AppBar(title: Text(strings.appTitle)),
                    body: Column(
                      children: [
                        Text('Active Tab: ${strings.dashboard}'),
                        Text('Score: ${strings.dailyScore}'),
                        ElevatedButton(
                          onPressed: () {
                            ref
                                .read(appLanguageProvider.notifier)
                                .toggleLanguage();
                          },
                          child: Text(strings.save),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        );

        // 1. Initial English assertions
        expect(find.text('FitKarma'), findsOneWidget);
        expect(find.text('Active Tab: Dashboard'), findsOneWidget);
        expect(find.text('Score: Daily Score'), findsOneWidget);
        expect(find.text('Save'), findsOneWidget);

        // 2. Tap to toggle to Hindi
        await tester.tap(find.text('Save'));
        await tester.pumpAndSettle();

        // 3. Immediate Hindi assertions in-memory without restart
        expect(find.text('फिटकर्मा'), findsOneWidget);
        expect(find.text('Active Tab: डैशबोर्ड'), findsOneWidget);
        expect(find.text('Score: दैनिक स्कोर'), findsOneWidget);
        expect(find.text('सहेजें'), findsOneWidget);

        // 4. Tap again to toggle back to English
        await tester.tap(find.text('सहेजें'));
        await tester.pumpAndSettle();

        expect(find.text('FitKarma'), findsOneWidget);
        expect(find.text('Active Tab: Dashboard'), findsOneWidget);
        expect(find.text('Save'), findsOneWidget);
      },
    );
  });
}
