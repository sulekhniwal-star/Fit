import 'package:flutter/material.dart';

/// Utilities and widgets for handling dynamic system font scaling gracefully.
///
/// Ensures layouts remain readable and overflow-free across accessibility scale factors
/// up to 2.0x and beyond.
class TextScaleHelper {
  const TextScaleHelper._();

  /// Reads the current system text scale factor from [BuildContext].
  static double getScaleFactor(BuildContext context) {
    return MediaQuery.textScalerOf(context).scale(1.0);
  }

  /// Whether the user has enabled an enlarged accessibility text size (>= 1.3x).
  static bool isLargeTextScale(BuildContext context) {
    return getScaleFactor(context) >= 1.3;
  }

  /// Creates a [TextScaler] clamped between [minScale] and [maxScale].
  static TextScaler clampedTextScaler(
    BuildContext context, {
    double minScale = 0.85,
    double maxScale = 2.0,
  }) {
    return MediaQuery.textScalerOf(context)
        .clamp(minScaleFactor: minScale, maxScaleFactor: maxScale);
  }
}

/// A Column that automatically accommodates dynamic text scaling by making its
/// children vertically scrollable whenever spatial constraints or high text scales
/// would otherwise trigger RenderFlex overflows.
class AccessibleScrollableColumn extends StatelessWidget {
  const AccessibleScrollableColumn({
    super.key,
    required this.children,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.padding = EdgeInsets.zero,
    this.physics,
  });

  final List<Widget> children;
  final MainAxisAlignment mainAxisAlignment;
  final CrossAxisAlignment crossAxisAlignment;
  final EdgeInsetsGeometry padding;
  final ScrollPhysics? physics;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          padding: padding,
          physics: physics ?? const ClampingScrollPhysics(),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: constraints.maxHeight.isFinite
                  ? constraints.maxHeight
                  : 0,
              minWidth: constraints.maxWidth.isFinite
                  ? constraints.maxWidth
                  : 0,
            ),
            child: IntrinsicHeight(
              child: Column(
                mainAxisAlignment: mainAxisAlignment,
                crossAxisAlignment: crossAxisAlignment,
                children: children,
              ),
            ),
          ),
        );
      },
    );
  }
}
