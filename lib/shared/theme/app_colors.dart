import 'package:flutter/material.dart';

/// Authoritative color palette for FitKarma per Brain/ui_spec.md §13.
abstract class AppColors {
  // Primary dark background
  static const Color background = Color(0xFF0D0F12);

  // Surface levels
  static const Color surface = Color(0xFF161A22);
  static const Color surfaceElevated = Color(0xFF1F2430);

  // Primary brand accents
  static const Color primary = Color(0xFF00E599); // Neon Mint
  static const Color primaryAccent = Color(0xFF00BFA5); // Teal Accent

  // Cultural & System Accents
  static const Color saffron = Color(0xFFFF9933); // Ayurveda / Fasting Gold
  static const Color techBlue = Color(0xFF38BDF8); // AI Signals

  // Typography
  static const Color textPrimary = Color(0xFFF8FAFC);
  static const Color textSecondary = Color(0xFF94A3B8);

  // Status
  static const Color error = Color(0xFFEF4444);
  static const Color warning = Color(0xFFF59E0B);
  static const Color success = Color(0xFF10B981);

  // Glassmorphism overlays
  static const Color glassBackground = Color(0xB31F2430); // 70% opacity
  static const Color glassBorder = Color(0x14FFFFFF); // 8% white
}

