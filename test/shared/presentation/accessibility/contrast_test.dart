import 'package:fitkarma/shared/presentation/accessibility/accessibility_contrast.dart';
import 'package:fitkarma/shared/presentation/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('WCAG 2.1 Contrast Calculation & FitKarma Color Tokens', () {
    test('contrastRatio computes mathematically accurate bounds', () {
      // Pure black and white has maximum contrast 21:1
      final maxContrast = AccessibilityContrast.contrastRatio(
        Colors.white,
        Colors.black,
      );
      expect(maxContrast, closeTo(21.0, 0.1));

      // Identical colors have minimum contrast 1:1
      final minContrast = AccessibilityContrast.contrastRatio(
        Colors.white,
        Colors.white,
      );
      expect(minContrast, closeTo(1.0, 0.01));
    });

    test('FitKarma textPrimary on background exceeds WCAG AAA (>= 7.0:1)', () {
      final ratio = AccessibilityContrast.contrastRatio(
        AppColors.textPrimary,
        AppColors.background,
      );

      // #F8FAFC on #0D0F12 is exceptionally high contrast (~18:1)
      expect(ratio, greaterThan(15.0));
      expect(
        AccessibilityContrast.isNormalTextCompliant(
          AppColors.textPrimary,
          AppColors.background,
          isEnhancedAaa: true,
        ),
        isTrue,
      );
    });

    test('FitKarma textPrimary on surface meets WCAG AAA', () {
      final ratio = AccessibilityContrast.contrastRatio(
        AppColors.textPrimary,
        AppColors.surface,
      );

      expect(ratio, greaterThan(14.0));
      expect(
        AccessibilityContrast.isNormalTextCompliant(
          AppColors.textPrimary,
          AppColors.surface,
          isEnhancedAaa: true,
        ),
        isTrue,
      );
    });

    test('FitKarma textSecondary on background meets WCAG AA (>= 4.5:1)', () {
      final ratio = AccessibilityContrast.contrastRatio(
        AppColors.textSecondary,
        AppColors.background,
      );

      expect(ratio, greaterThan(6.0));
      expect(
        AccessibilityContrast.isNormalTextCompliant(
          AppColors.textSecondary,
          AppColors.background,
        ),
        isTrue,
      );
    });

    test('FitKarma Primary Button text (dark on mint) meets WCAG AAA', () {
      // Primary button uses AppColors.background text on AppColors.primary (neon mint)
      final ratio = AccessibilityContrast.contrastRatio(
        AppColors.background,
        AppColors.primary,
      );

      expect(ratio, greaterThan(11.0));
      expect(
        AccessibilityContrast.isNormalTextCompliant(
          AppColors.background,
          AppColors.primary,
          isEnhancedAaa: true,
        ),
        isTrue,
      );
    });

    test('FitKarma brand accents on dark background exceed WCAG AA', () {
      final mintRatio = AccessibilityContrast.contrastRatio(
        AppColors.primary,
        AppColors.background,
      );
      final saffronRatio = AccessibilityContrast.contrastRatio(
        AppColors.saffron,
        AppColors.background,
      );
      final techBlueRatio = AccessibilityContrast.contrastRatio(
        AppColors.techBlue,
        AppColors.background,
      );

      expect(mintRatio, greaterThan(10.0));
      expect(saffronRatio, greaterThan(7.0));
      expect(techBlueRatio, greaterThan(8.0));

      expect(
        AccessibilityContrast.isLargeTextCompliant(
          AppColors.saffron,
          AppColors.background,
        ),
        isTrue,
      );
      expect(
        AccessibilityContrast.isLargeTextCompliant(
          AppColors.techBlue,
          AppColors.background,
        ),
        isTrue,
      );
    });

    test('FitKarma Error Crimson meets WCAG AA on dark background', () {
      final ratio = AccessibilityContrast.contrastRatio(
        AppColors.error,
        AppColors.background,
      );

      expect(ratio, greaterThan(4.5));
      expect(
        AccessibilityContrast.isNormalTextCompliant(
          AppColors.error,
          AppColors.background,
        ),
        isTrue,
      );
    });
  });
}
