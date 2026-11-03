import 'package:flutter/material.dart';
import '../../../shared/theme/app_colors.dart';
import '../../../shared/theme/app_radii.dart';
import '../../../shared/theme/app_spacing.dart';
import '../../../shared/theme/app_typography.dart';

class QuickLogActionBar extends StatelessWidget {
  final VoidCallback? onQuickWaterTap;
  final VoidCallback? onLogMealTap;
  final VoidCallback? onWorkoutTap;
  final VoidCallback? onLogWeightTap;

  const QuickLogActionBar({
    super.key,
    this.onQuickWaterTap,
    this.onLogMealTap,
    this.onWorkoutTap,
    this.onLogWeightTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'QUICK LOGGING',
          style: AppTypography.caption.copyWith(
            letterSpacing: 1.2,
            fontWeight: FontWeight.bold,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        Row(
          children: [
            Expanded(
              child: _buildButton(
                key: const Key('quick_log_water_btn'),
                icon: Icons.water_drop,
                label: '+250ml',
                color: AppColors.techBlue,
                onTap: onQuickWaterTap,
              ),
            ),
            const SizedBox(width: AppSpacing.xs),
            Expanded(
              child: _buildButton(
                key: const Key('quick_log_meal_btn'),
                icon: Icons.restaurant,
                label: 'Meal',
                color: AppColors.saffron,
                onTap: onLogMealTap,
              ),
            ),
            const SizedBox(width: AppSpacing.xs),
            Expanded(
              child: _buildButton(
                key: const Key('quick_log_workout_btn'),
                icon: Icons.fitness_center,
                label: 'Workout',
                color: AppColors.primary,
                onTap: onWorkoutTap,
              ),
            ),
            const SizedBox(width: AppSpacing.xs),
            Expanded(
              child: _buildButton(
                key: const Key('quick_log_weight_btn'),
                icon: Icons.monitor_weight_outlined,
                label: 'Weight',
                color: AppColors.primaryAccent,
                onTap: onLogWeightTap,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildButton({
    required Key key,
    required IconData icon,
    required String label,
    required Color color,
    VoidCallback? onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        key: key,
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadii.md),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: color.withAlpha(25),
            borderRadius: BorderRadius.circular(AppRadii.md),
            border: Border.all(color: color.withAlpha(90), width: 1),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: color, size: 20),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  color: color,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
