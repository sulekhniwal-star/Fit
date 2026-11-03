import 'package:fitkarma/shared/presentation/theme/app_colors.dart';
import 'package:flutter/material.dart';

/// Reusable Glassmorphism Bento Card container for dashboard and metrics surfaces.
class BentoCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final VoidCallback? onTap;

  const BentoCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16.0),
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16.0),
      child: Container(
        padding: padding,
        decoration: BoxDecoration(
          color: AppColors.surfaceGlass,
          borderRadius: BorderRadius.circular(16.0),
          border: Border.all(color: Colors.white.withAlpha(20), width: 1.0),
        ),
        child: child,
      ),
    );
  }
}
