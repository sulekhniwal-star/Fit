import 'dart:io';

import 'package:fitkarma/core/localization/app_language.dart';
import 'package:fitkarma/core/localization/app_strings.dart';
import 'package:fitkarma/shared/presentation/widgets/app_state_views.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('No Hardcoded Strings in Reusable UI Widgets', () {
    testWidgets(
      'AppEmptyState, AppLoadingView, and AppErrorView default to English strings in English locale',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            locale: const Locale('en'),
            supportedLocales: AppLanguage.supportedLocales,
            localizationsDelegates: const [
              AppStrings.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            home: Scaffold(
              body: Column(
                children: [
                  const AppEmptyState(),
                  const AppLoadingView(),
                  AppErrorView(message: 'Network timeout', onRetry: () {}),
                ],
              ),
            ),
          ),
        );
        await tester.pump();

        // English defaults from AppStrings
        expect(find.text('No items found'), findsOneWidget);
        expect(find.text('Nothing to display right now.'), findsOneWidget);
        expect(find.text('Loading...'), findsOneWidget);
        expect(find.text('Something went wrong'), findsOneWidget);
        expect(find.text('Try Again'), findsOneWidget);
      },
    );

    testWidgets(
      'AppEmptyState, AppLoadingView, and AppErrorView default dynamically to Hindi strings in Hindi locale',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            locale: const Locale('hi'),
            supportedLocales: AppLanguage.supportedLocales,
            localizationsDelegates: const [
              AppStrings.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            home: Scaffold(
              body: Column(
                children: [
                  const AppEmptyState(),
                  const AppLoadingView(),
                  AppErrorView(message: 'नेटवर्क समस्या', onRetry: () {}),
                ],
              ),
            ),
          ),
        );
        await tester.pump();

        // Hindi defaults dynamically resolved from AppStrings without hardcoded fallback
        expect(find.text('कोई जानकारी नहीं मिली'), findsOneWidget);
        expect(
          find.text('अभी प्रदर्शित करने के लिए कुछ नहीं है।'),
          findsOneWidget,
        );
        expect(find.text('लोड हो रहा है...'), findsOneWidget);
        expect(find.text('कुछ गड़बड़ हुई'), findsOneWidget);
        expect(find.text('पुनः प्रयास करें'), findsOneWidget);
      },
    );

    test('Static audit: app_state_views.dart must resolve defaults from AppStrings rather than raw literals', () {
      final file = File('lib/shared/presentation/widgets/app_state_views.dart');
      expect(file.existsSync(), isTrue);

      final content = file.readAsStringSync();

      // Verify that AppStrings.of(context) is used to resolve defaults
      expect(content.contains('AppStrings.of(context)'), isTrue);
      expect(content.contains('strings.emptyTitle'), isTrue);
      expect(content.contains('strings.emptyMessage'), isTrue);
      expect(content.contains('strings.loading'), isTrue);
      expect(content.contains('strings.errorTitle'), isTrue);
      expect(content.contains('strings.tryAgain'), isTrue);

      // Verify that old hardcoded defaults in constructor declarations are removed
      expect(content.contains("this.title = 'Something went wrong'"), isFalse);
      expect(content.contains("this.retryLabel = 'Try Again'"), isFalse);
    });
  });
}
