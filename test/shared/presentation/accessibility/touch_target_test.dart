import 'package:fitkarma/shared/presentation/accessibility/accessible_touch_target.dart';
import 'package:fitkarma/shared/presentation/theme/app_spacing.dart';
import 'package:fitkarma/shared/presentation/theme/app_theme.dart';
import 'package:fitkarma/shared/presentation/widgets/app_text_field.dart';
import 'package:fitkarma/shared/presentation/widgets/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Accessible Touch Target Sizing (Min 48dp WCAG 2.1)', () {
    testWidgets(
      'AccessibleTouchTarget expands small visual elements to at least 48x48dp',
      (WidgetTester tester) async {
        var tapped = false;

        await tester.pumpWidget(
          MaterialApp(
            theme: AppTheme.darkTheme,
            home: Scaffold(
              body: Center(
                child: AccessibleTouchTarget(
                  child: GestureDetector(
                    onTap: () => tapped = true,
                    child: const Icon(Icons.close, size: 16.0),
                  ),
                ),
              ),
            ),
          ),
        );

        final targetFinder = find.byType(AccessibleTouchTarget);
        expect(targetFinder, findsOneWidget);

        final renderBox = tester.renderObject<RenderBox>(targetFinder);
        expect(
          renderBox.size.width,
          greaterThanOrEqualTo(AppSpacing.minTouchTarget),
        );
        expect(
          renderBox.size.height,
          greaterThanOrEqualTo(AppSpacing.minTouchTarget),
        );

        // Tapping anywhere in the 48x48 bounds triggers gesture
        await tester.tap(targetFinder);
        expect(tapped, isTrue);
      },
    );

    testWidgets('PrimaryButton enforces minimum 48dp height', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.darkTheme,
          home: Scaffold(
            body: Center(
              child: PrimaryButton(label: 'Log Meal', onPressed: () {}),
            ),
          ),
        ),
      );

      final buttonFinder = find.byType(PrimaryButton);
      final renderBox = tester.renderObject<RenderBox>(buttonFinder);

      expect(
        renderBox.size.height,
        greaterThanOrEqualTo(AppSpacing.minTouchTarget),
      );
    });

    testWidgets(
      'AppTextField provides touch target area conforming to accessibility norms',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            theme: AppTheme.darkTheme,
            home: const Scaffold(
              body: Center(
                child: AppTextField(label: 'Meal Name', hint: 'Search...'),
              ),
            ),
          ),
        );

        final textFieldFinder = find.byType(TextField);
        final renderBox = tester.renderObject<RenderBox>(textFieldFinder);

        expect(
          renderBox.size.height,
          greaterThanOrEqualTo(AppSpacing.minTouchTarget),
        );
      },
    );
  });
}
