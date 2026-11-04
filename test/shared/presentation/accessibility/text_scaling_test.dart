import 'package:fitkarma/shared/presentation/accessibility/text_scale_helper.dart';
import 'package:fitkarma/shared/presentation/screens/design_system_showcase_screen.dart';
import 'package:fitkarma/shared/presentation/theme/app_spacing.dart';
import 'package:fitkarma/shared/presentation/theme/app_theme.dart';
import 'package:fitkarma/shared/presentation/widgets/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Text Scaling & High Dynamic Font Scale Support', () {
    testWidgets('TextScaleHelper correctly reads and identifies scale factors',
        (WidgetTester tester) async {
      double? scaleFactor;
      bool? isLarge;

      await tester.pumpWidget(
        MaterialApp(
          home: MediaQuery(
            data: const MediaQueryData(
              textScaler: TextScaler.linear(1.5),
            ),
            child: Builder(
              builder: (context) {
                scaleFactor = TextScaleHelper.getScaleFactor(context);
                isLarge = TextScaleHelper.isLargeTextScale(context);
                return const SizedBox();
              },
            ),
          ),
        ),
      );

      expect(scaleFactor, 1.5);
      expect(isLarge, isTrue);
    });

    testWidgets(
      'PrimaryButton expands smoothly at 2.0x text scale without clipping',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            theme: AppTheme.darkTheme,
            home: MediaQuery(
              data: const MediaQueryData(
                textScaler: TextScaler.linear(2.0),
              ),
              child: Scaffold(
                body: Center(
                  child: PrimaryButton(
                    label: 'Complete Workout Session',
                    onPressed: () {},
                  ),
                ),
              ),
            ),
          ),
        );

        final buttonFinder = find.byType(PrimaryButton);
        final renderBox = tester.renderObject<RenderBox>(buttonFinder);

        // At 2.0x scale, height must exceed the 48dp baseline to avoid clipping
        expect(renderBox.size.height, greaterThan(AppSpacing.minTouchTarget));
        expect(tester.takeException(), isNull);
      },
    );

    testWidgets(
      'AccessibleScrollableColumn renders large content under 2.5x scale without overflow errors',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            theme: AppTheme.darkTheme,
            home: MediaQuery(
              data: const MediaQueryData(
                textScaler: TextScaler.linear(2.5),
                size: Size(360, 640),
              ),
              child: Scaffold(
                body: AccessibleScrollableColumn(
                  children: [
                    Text('FitKarma Daily Health Summary',
                        style: AppTheme.darkTheme.textTheme.displayMedium),
                    const SizedBox(height: AppSpacing.lg),
                    Text(
                      'Your heart rate variability indicates optimal parasympathetic recovery today. Keep up hydration during your fasting window.',
                      style: AppTheme.darkTheme.textTheme.bodyLarge,
                    ),
                    const SizedBox(height: AppSpacing.xl),
                    PrimaryButton(
                      label: 'Acknowledge Daily Coaching',
                      onPressed: () {},
                    ),
                  ],
                ),
              ),
            ),
          ),
        );

        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
        expect(find.text('FitKarma Daily Health Summary'), findsOneWidget);
      },
    );

    testWidgets(
      'DesignSystemShowcaseScreen mounts and renders cleanly under 1.5x accessibility text scale',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            theme: AppTheme.darkTheme,
            home: const MediaQuery(
              data: MediaQueryData(
                textScaler: TextScaler.linear(1.5),
                size: Size(400, 800),
              ),
              child: DesignSystemShowcaseScreen(),
            ),
          ),
        );

        await tester.pump();
        await tester.pump(const Duration(milliseconds: 100));

        expect(tester.takeException(), isNull);
        expect(find.text('FitKarma Design System'), findsOneWidget);

        // Progressively scroll down ListView until the accessibility section is visible
        for (var i = 0; i < 8; i++) {
          if (find.text('Accessibility & Status Badges').evaluate().isNotEmpty) {
            break;
          }
          await tester.drag(find.byType(ListView), const Offset(0, -600));
          await tester.pump(const Duration(milliseconds: 50));
        }

        expect(find.text('Accessibility & Status Badges'), findsOneWidget);
      },
    );
  });
}
