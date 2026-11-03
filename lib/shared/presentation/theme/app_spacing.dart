import 'package:flutter/material.dart';

/// FitKarma Spacing Scale, Radii, and Sizing Conventions.
/// Conforms to Brain/ui_spec.md Section 13.
class AppSpacing {
  AppSpacing._();

  static const double xxs = 2.0;
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 12.0;
  static const double lg = 16.0;
  static const double xl = 24.0;
  static const double xxl = 32.0;
  static const double xxxl = 48.0;

  /// Minimum accessible touch target (WCAG 2.1 AA requirement).
  static const double minTouchTarget = 48.0;
}

/// FitKarma Standard Border Radius Tokens.
class AppRadius {
  AppRadius._();

  static const double xs = 6.0;
  static const double sm = 10.0;
  static const double md = 16.0; // Standard Bento card radius
  static const double lg = 24.0;
  static const double full = 999.0;

  static const BorderRadius radiusXs = BorderRadius.all(Radius.circular(xs));
  static const BorderRadius radiusSm = BorderRadius.all(Radius.circular(sm));
  static const BorderRadius radiusMd = BorderRadius.all(Radius.circular(md));
  static const BorderRadius radiusLg = BorderRadius.all(Radius.circular(lg));
  static const BorderRadius radiusFull = BorderRadius.all(
    Radius.circular(full),
  );
}

/// FitKarma Motion and Spring Physics Tokens.
class AppMotion {
  AppMotion._();

  static const Duration fast = Duration(milliseconds: 150);
  static const Duration normal = Duration(milliseconds: 250);
  static const Duration slow = Duration(milliseconds: 400);

  static const Curve springCurve = Curves.easeOutBack;
  static const Curve standardCurve = Curves.easeOutCubic;
}
