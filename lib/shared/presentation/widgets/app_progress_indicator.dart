import 'package:fitkarma/shared/presentation/theme/app_colors.dart';
import 'package:fitkarma/shared/presentation/theme/app_spacing.dart';
import 'package:flutter/material.dart';

/// Progress indicators adhering to FitKarma design tokens.
class AppProgressIndicator extends StatelessWidget {
  final double? value; // null for indeterminate
  final Color color;
  final double strokeWidth;

  const AppProgressIndicator({
    super.key,
    this.value,
    this.color = AppColors.primary,
    this.strokeWidth = 3.0,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Loading progress',
      value: value != null ? '${(value! * 100).toInt()}%' : 'In progress',
      child: CircularProgressIndicator(
        value: value,
        strokeWidth: strokeWidth,
        valueColor: AlwaysStoppedAnimation<Color>(color),
        backgroundColor: AppColors.surfaceElevated,
      ),
    );
  }
}

/// Linear progress bar for daily calorie / macro / step goals.
class AppLinearProgressIndicator extends StatelessWidget {
  final double value; // 0.0 to 1.0
  final Color color;
  final double height;

  const AppLinearProgressIndicator({
    super.key,
    required this.value,
    this.color = AppColors.primary,
    this.height = 8.0,
  });

  @override
  Widget build(BuildContext context) {
    final clampedValue = value.clamp(0.0, 1.0);

    return Semantics(
      label: 'Metric progress',
      value: '${(clampedValue * 100).toInt()}%',
      child: ClipRRect(
        borderRadius: AppRadius.radiusFull,
        child: LinearProgressIndicator(
          value: clampedValue,
          minHeight: height,
          valueColor: AlwaysStoppedAnimation<Color>(color),
          backgroundColor: AppColors.surfaceElevated,
        ),
      ),
    );
  }
}
