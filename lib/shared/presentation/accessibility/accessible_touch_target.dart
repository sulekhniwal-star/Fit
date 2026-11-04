import 'package:fitkarma/shared/presentation/theme/app_spacing.dart';
import 'package:flutter/material.dart';

/// Ensures any interactive child widget meets or exceeds the WCAG 2.1 touch target
/// standard of at least 48.0dp x 48.0dp (per [AppSpacing.minTouchTarget]).
///
/// Automatically centers or aligns the visual child within the enlarged touchable area.
class AccessibleTouchTarget extends StatelessWidget {
  const AccessibleTouchTarget({
    super.key,
    required this.child,
    this.minWidth = AppSpacing.minTouchTarget,
    this.minHeight = AppSpacing.minTouchTarget,
    this.alignment = Alignment.center,
  });

  /// The interactive or visual child widget.
  final Widget child;

  /// Minimum horizontal touch target extent. Defaults to 48.0dp.
  final double minWidth;

  /// Minimum vertical touch target extent. Defaults to 48.0dp.
  final double minHeight;

  /// How the child is aligned within the padded touch boundary.
  final Alignment alignment;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(minWidth: minWidth, minHeight: minHeight),
      child: Align(
        alignment: alignment,
        widthFactor: 1.0,
        heightFactor: 1.0,
        child: child,
      ),
    );
  }
}
