import 'package:fitkarma/shared/theme/app_colors.dart';
import 'package:fitkarma/shared/theme/app_motion.dart';
import 'package:fitkarma/shared/theme/app_radii.dart';
import 'package:fitkarma/shared/theme/app_spacing.dart';
import 'package:fitkarma/shared/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Design System Token Tests (TASK 009)', () {
    test('AppColors match Brain/ui_spec.md §13 values exactly', () {
      expect(AppColors.background, const Color(0xFF0D0F12));
      expect(AppColors.surface, const Color(0xFF161A22));
      expect(AppColors.surfaceElevated, const Color(0xFF1F2430));
      expect(AppColors.primary, const Color(0xFF00E599));
      expect(AppColors.primaryAccent, const Color(0xFF00BFA5));
      expect(AppColors.saffron, const Color(0xFFFF9933));
      expect(AppColors.techBlue, const Color(0xFF38BDF8));
      expect(AppColors.textPrimary, const Color(0xFFF8FAFC));
      expect(AppColors.textSecondary, const Color(0xFF94A3B8));
      expect(AppColors.error, const Color(0xFFEF4444));
    });

    test('AppSpacing and AppRadii define expected geometry', () {
      expect(AppSpacing.minTouchTarget, 48.0);
      expect(AppRadii.md, 16.0);
      expect(AppMotion.fast, const Duration(milliseconds: 150));
      expect(AppMotion.spring, Curves.easeOutBack);
    });

    test('AppTheme.darkTheme returns valid dark Material 3 ThemeData', () {
      final theme = AppTheme.darkTheme;
      expect(theme.brightness, Brightness.dark);
      expect(theme.scaffoldBackgroundColor, AppColors.background);
      expect(theme.colorScheme.primary, AppColors.primary);
      expect(theme.useMaterial3, true);
    });
  });
}

