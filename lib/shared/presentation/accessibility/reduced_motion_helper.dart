import 'package:flutter/material.dart';

/// Utilities for respecting vestibular and accessibility preferences for reduced motion.
///
/// In accordance with WCAG 2.1 Success Criterion 2.3.3 (Animation from Interactions),
/// motion effects can be suppressed or replaced with instantaneous transitions.
class ReducedMotionHelper {
  const ReducedMotionHelper._();

  /// Whether the user has system-level reduced motion or animation disabling active.
  static bool prefersReducedMotion(BuildContext context) {
    return MediaQuery.disableAnimationsOf(context) ||
        MediaQuery.accessibleNavigationOf(context);
  }

  /// Returns [Duration.zero] if the user prefers reduced motion, or [defaultDuration] otherwise.
  static Duration duration(BuildContext context, Duration defaultDuration) {
    if (prefersReducedMotion(context)) {
      return Duration.zero;
    }
    return defaultDuration;
  }

  /// Returns [Curves.linear] if reduced motion is active, or [defaultCurve] otherwise.
  static Curve curve(BuildContext context, Curve defaultCurve) {
    if (prefersReducedMotion(context)) {
      return Curves.linear;
    }
    return defaultCurve;
  }
}
