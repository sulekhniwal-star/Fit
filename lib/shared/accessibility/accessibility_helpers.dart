import 'package:flutter/material.dart';
import '../theme/app_spacing.dart';

/// Wraps any widget to guarantee a minimum 48x48dp interactive hit target
/// fulfilling WCAG 2.1 touch accessibility requirements.
class MinTouchTarget extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;
  final String? semanticLabel;

  const MinTouchTarget({
    super.key,
    required this.child,
    this.onTap,
    this.semanticLabel,
  });

  @override
  Widget build(BuildContext context) {
    Widget content = ConstrainedBox(
      constraints: const BoxConstraints(
        minWidth: AppSpacing.minTouchTarget,
        minHeight: AppSpacing.minTouchTarget,
      ),
      child: Center(
        child: child,
      ),
    );

    if (semanticLabel != null) {
      content = Semantics(
        label: semanticLabel,
        button: onTap != null,
        child: content,
      );
    }

    if (onTap != null) {
      content = InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: content,
      );
    }

    return content;
  }
}

/// Helper that bounds text scaling to prevent layout breaks on budget screens
class BoundedTextScale extends StatelessWidget {
  final Widget child;
  final double maxScale;

  const BoundedTextScale({
    super.key,
    required this.child,
    this.maxScale = 1.6,
  });

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final textScale = mediaQuery.textScaler.clamp(
      minScaleFactor: 0.8,
      maxScaleFactor: maxScale,
    );

    return MediaQuery(
      data: mediaQuery.copyWith(textScaler: textScale),
      child: child,
    );
  }
}
