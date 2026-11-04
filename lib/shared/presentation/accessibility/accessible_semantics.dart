import 'package:fitkarma/shared/presentation/theme/app_colors.dart';
import 'package:fitkarma/shared/presentation/theme/app_spacing.dart';
import 'package:fitkarma/shared/presentation/theme/app_typography.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

/// Semantic helpers and components for assistive technology and screen readers.
class AccessibleSemantics {
  const AccessibleSemantics._();

  /// Wraps a widget with an explicit [OrdinalSortKey] to control screen-reader traversal order.
  static Widget ordered({
    required Widget child,
    required double order,
    String? label,
    String? hint,
  }) {
    return Semantics(
      sortKey: OrdinalSortKey(order),
      label: label,
      hint: hint,
      child: child,
    );
  }

  /// Announces a dynamic message to assistive screen readers (TalkBack / VoiceOver).
  static Future<void> announce(
    BuildContext context,
    String message, {
    TextDirection textDirection = TextDirection.ltr,
  }) async {
    final view = View.of(context);
    await SemanticsService.sendAnnouncement(view, message, textDirection);
  }

  /// Wraps a health biomarker (e.g. Heart Rate, Blood Glucose, Steps) with
  /// an accessible semantic node describing the full measurement and health status.
  static Widget biomarker({
    required Widget child,
    required String metricName,
    required String value,
    String? unit,
    String? status,
  }) {
    final semanticBuffer = StringBuffer('$metricName: $value');
    if (unit != null && unit.isNotEmpty) {
      semanticBuffer.write(' $unit');
    }
    if (status != null && status.isNotEmpty) {
      semanticBuffer.write(', status: $status');
    }

    return Semantics(
      container: true,
      label: semanticBuffer.toString(),
      excludeSemantics: true,
      child: child,
    );
  }
}

/// Status badge that conveys state through BOTH color, an icon, and text,
/// adhering to WCAG 2.1 Success Criterion 1.4.1 (Use of Color).
class AccessibleStatusBadge extends StatelessWidget {
  const AccessibleStatusBadge({
    super.key,
    required this.label,
    required this.icon,
    required this.color,
    this.backgroundColor,
  });

  /// Factory for normal / optimal state (e.g. In Range, Completed).
  factory AccessibleStatusBadge.optimal({
    required String label,
    IconData icon = Icons.check_circle_outline,
  }) {
    return AccessibleStatusBadge(
      label: label,
      icon: icon,
      color: AppColors.primary,
    );
  }

  /// Factory for warning / cautionary state (e.g. Approaching Limit, Fasting Window).
  factory AccessibleStatusBadge.warning({
    required String label,
    IconData icon = Icons.warning_amber_rounded,
  }) {
    return AccessibleStatusBadge(
      label: label,
      icon: icon,
      color: AppColors.saffron,
    );
  }

  /// Factory for alert / error state (e.g. Out of Range, Sync Failed).
  factory AccessibleStatusBadge.alert({
    required String label,
    IconData icon = Icons.error_outline,
  }) {
    return AccessibleStatusBadge(
      label: label,
      icon: icon,
      color: AppColors.error,
    );
  }

  final String label;
  final IconData icon;
  final Color color;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    final effectiveBg = backgroundColor ?? color.withAlpha(35);

    return Semantics(
      container: true,
      label: 'Status: $label',
      excludeSemantics: true,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm,
          vertical: AppSpacing.xs,
        ),
        decoration: BoxDecoration(
          color: effectiveBg,
          borderRadius: AppRadius.radiusSm,
          border: Border.all(color: color.withAlpha(90), width: 1.0),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 14, color: color),
            const SizedBox(width: AppSpacing.xs),
            Text(
              label,
              style: AppTypography.labelSmall.copyWith(
                color: color,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
