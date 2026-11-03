import 'package:flutter/material.dart';

/// FitKarma Shared Visual & Theme Color Tokens.
/// Conforms to Brain/ui_spec.md Section 13.
class AppColors {
  AppColors._();

  // Core Surfaces & Backgrounds
  static const Color background = Color(0xFF0D0F12);
  static const Color darkBackground = background; // Alias
  static const Color surface = Color(0xFF161A22);
  static const Color surfaceElevated = Color(0xFF1F2430);
  static const Color surfaceGlass = Color(0x1AFFFFFF);

  // Brand Accents
  static const Color primary = Color(0xFF00E599); // Neon Mint
  static const Color primaryAccent = Color(0xFF00BFA5); // Teal Accent
  static const Color saffron = Color(0xFFFF9933); // Ayurveda / Fasting gold
  static const Color techBlue = Color(0xFF38BDF8); // AI signal blue

  // Text Hierarchy
  static const Color textPrimary = Color(0xFFF8FAFC);
  static const Color textSecondary = Color(0xFF94A3B8);
  static const Color textTertiary = Color(0xFF64748B);

  // Status & Feedback
  static const Color success = Color(0xFF00E599);
  static const Color warning = Color(0xFFFBBF24);
  static const Color error = Color(0xFFEF4444);
  static const Color info = Color(0xFF38BDF8);

  // Border & Divider
  static const Color border = Color(0x1FFFFFFF);
  static const Color borderFocused = Color(0xFF00E599);
}
