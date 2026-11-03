import 'package:fitkarma/shared/presentation/screens/design_system_showcase_screen.dart';
import 'package:fitkarma/shared/presentation/theme/app_colors.dart';
import 'package:fitkarma/shared/presentation/theme/app_spacing.dart';
import 'package:fitkarma/shared/presentation/theme/app_theme.dart';
import 'package:fitkarma/shared/presentation/widgets/app_chip.dart';
import 'package:fitkarma/shared/presentation/widgets/app_progress_indicator.dart';
import 'package:fitkarma/shared/presentation/widgets/app_state_views.dart';
import 'package:fitkarma/shared/presentation/widgets/app_text_field.dart';
import 'package:fitkarma/shared/presentation/widgets/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Design Tokens Verification', () {
    test('AppColors matches Brain/ui_spec.md color values', () {
      expect(AppColors.background.toARGB32(), 0xFF0D0F12);
      expect(AppColors.surface.toARGB32(), 0xFF161A22);
      expect(AppColors.surfaceElevated.toARGB32(), 0xFF1F2430);
      expect(AppColors.primary.toARGB32(), 0xFF00E599);
      expect(AppColors.primaryAccent.toARGB32(), 0xFF00BFA5);
      expect(AppColors.saffron.toARGB32(), 0xFFFF9933);
      expect(AppColors.techBlue.toARGB32(), 0xFF38BDF8);
      expect(AppColors.textPrimary.toARGB32(), 0xFFF8FAFC);
      expect(AppColors.textSecondary.toARGB32(), 0xFF94A3B8);
      expect(AppColors.error.toARGB32(), 0xFFEF4444);
    });

    test('AppSpacing and AppRadius match design spec', () {
      expect(AppSpacing.minTouchTarget, 48.0);
      expect(AppSpacing.xxs, 2.0);
      expect(AppSpacing.sm, 8.0);
      expect(AppSpacing.lg, 16.0);
      expect(AppSpacing.xxxl, 48.0);

      expect(AppRadius.md, 16.0); // Standard Bento card radius
      expect(AppRadius.full, 999.0);
    });

    test('AppTheme creates compliant dark ThemeData', () {
      final theme = AppTheme.darkTheme;

      expect(theme.brightness, Brightness.dark);
      expect(theme.scaffoldBackgroundColor, AppColors.background);
      expect(theme.useMaterial3, isTrue);
      expect(theme.textTheme.displayLarge, isNotNull);
      expect(theme.colorScheme.primary, AppColors.primary);
      expect(theme.colorScheme.error, AppColors.error);
    });
  });

  group('Design System Component Widget Tests', () {
    testWidgets('PrimaryButton renders with min 48dp height and handles tap', (
      WidgetTester tester,
    ) async {
      var tapped = false;

      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.darkTheme,
          home: Scaffold(
            body: PrimaryButton(
              label: 'Log Food',
              onPressed: () => tapped = true,
            ),
          ),
        ),
      );

      final buttonFinder = find.byType(ElevatedButton);
      expect(buttonFinder, findsOneWidget);

      final size = tester.getSize(buttonFinder);
      expect(size.height, greaterThanOrEqualTo(48.0));

      await tester.tap(buttonFinder);
      await tester.pump();
      expect(tapped, isTrue);
    });

    testWidgets('PrimaryButton shows loading spinner when isLoading is true', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.darkTheme,
          home: const Scaffold(
            body: PrimaryButton(label: 'Analyzing', isLoading: true),
          ),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text('Analyzing'), findsNothing);
    });

    testWidgets('AppTextField renders label, hint, and error state', (
      WidgetTester tester,
    ) async {
      String? entered;

      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.darkTheme,
          home: Scaffold(
            body: AppTextField(
              label: 'Portion Count',
              hint: 'e.g. 2 Rotis',
              errorText: 'Invalid portion',
              onChanged: (val) => entered = val,
            ),
          ),
        ),
      );

      expect(find.text('Portion Count'), findsOneWidget);
      expect(find.text('Invalid portion'), findsOneWidget);

      await tester.enterText(find.byType(TextField), '3');
      expect(entered, '3');
    });

    testWidgets('AppChip toggles selection and updates styling', (
      WidgetTester tester,
    ) async {
      var selected = false;

      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.darkTheme,
          home: Scaffold(
            body: StatefulBuilder(
              builder: (context, setState) {
                return AppChip(
                  label: 'Vegetarian',
                  isSelected: selected,
                  onSelected: (val) => setState(() => selected = val),
                );
              },
            ),
          ),
        ),
      );

      expect(find.text('Vegetarian'), findsOneWidget);
      await tester.tap(find.byType(FilterChip));
      await tester.pump();

      expect(selected, isTrue);
    });

    testWidgets('Progress indicators render linear and circular values', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.darkTheme,
          home: const Scaffold(
            body: Column(
              children: [
                AppProgressIndicator(value: 0.5),
                AppLinearProgressIndicator(value: 0.75),
              ],
            ),
          ),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.byType(LinearProgressIndicator), findsOneWidget);
    });

    testWidgets(
      'AppEmptyState, AppLoadingView, and AppErrorView render cleanly',
      (WidgetTester tester) async {
        var retryTapped = false;

        await tester.pumpWidget(
          MaterialApp(
            theme: AppTheme.darkTheme,
            home: Scaffold(
              body: SingleChildScrollView(
                child: Column(
                  children: [
                    const AppEmptyState(
                      title: 'No Workouts',
                      message: 'Get started today',
                    ),
                    const AppLoadingView(message: 'Syncing...'),
                    AppErrorView(
                      message: 'Connection timed out',
                      onRetry: () => retryTapped = true,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );

        expect(find.text('No Workouts'), findsOneWidget);
        expect(find.text('Syncing...'), findsOneWidget);
        expect(find.text('Connection timed out'), findsOneWidget);

        await tester.tap(find.text('Try Again'));
        expect(retryTapped, isTrue);
      },
    );

    testWidgets(
      'DesignSystemShowcaseScreen mounts and renders without errors',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            theme: AppTheme.darkTheme,
            home: const DesignSystemShowcaseScreen(),
          ),
        );
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 100));

        expect(find.text('FitKarma Design System'), findsOneWidget);
        expect(find.text('Color Palette'), findsOneWidget);
        expect(find.text('Typography'), findsOneWidget);
        expect(find.text('Bento Cards (Glassmorphism)'), findsOneWidget);
      },
    );
  });
}
