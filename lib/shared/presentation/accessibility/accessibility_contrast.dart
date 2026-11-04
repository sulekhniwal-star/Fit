import 'dart:math' as math;

import 'package:flutter/material.dart';

/// Utilities for validating WCAG 2.1 color contrast compliance.
///
/// WCAG Level AA:
/// - Normal text (< 18pt or < 14pt bold): minimum 4.5:1
/// - Large text (>= 18pt or >= 14pt bold): minimum 3.0:1
/// - UI components and graphical objects: minimum 3.0:1
///
/// WCAG Level AAA:
/// - Normal text: minimum 7.0:1
/// - Large text: minimum 4.5:1
class AccessibilityContrast {
  const AccessibilityContrast._();

  /// Calculates the relative luminance of a color according to W3C WCAG 2.1.
  ///
  /// L = 0.2126 * R + 0.7152 * G + 0.0722 * B
  /// where R, G, and B are linear sRGB values.
  static double relativeLuminance(Color color) {
    return color.computeLuminance();
  }

  /// Calculates the WCAG contrast ratio between two colors.
  ///
  /// The returned value is between 1.0 (identical colors) and 21.0 (black and white).
  static double contrastRatio(Color foreground, Color background) {
    final l1 = relativeLuminance(foreground);
    final l2 = relativeLuminance(background);

    final lighter = math.max(l1, l2);
    final darker = math.min(l1, l2);

    return (lighter + 0.05) / (darker + 0.05);
  }

  /// Verifies whether the contrast between [foreground] and [background]
  /// meets WCAG standards for normal body text (< 18pt or < 14pt bold).
  static bool isNormalTextCompliant(
    Color foreground,
    Color background, {
    bool isEnhancedAaa = false,
  }) {
    final ratio = contrastRatio(foreground, background);
    final requiredRatio = isEnhancedAaa ? 7.0 : 4.5;
    return ratio >= requiredRatio;
  }

  /// Verifies whether the contrast between [foreground] and [background]
  /// meets WCAG standards for large text (>= 18pt or >= 14pt bold).
  static bool isLargeTextCompliant(
    Color foreground,
    Color background, {
    bool isEnhancedAaa = false,
  }) {
    final ratio = contrastRatio(foreground, background);
    final requiredRatio = isEnhancedAaa ? 4.5 : 3.0;
    return ratio >= requiredRatio;
  }

  /// Verifies whether the contrast for UI components and borders meets WCAG 2.1 (3.0:1).
  static bool isUiComponentCompliant(Color component, Color background) {
    final ratio = contrastRatio(component, background);
    return ratio >= 3.0;
  }
}
