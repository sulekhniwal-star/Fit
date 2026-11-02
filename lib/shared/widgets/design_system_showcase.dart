import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_radii.dart';
import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';
import 'action_button.dart';
import 'app_scaffold.dart';
import 'bento_card.dart';
import 'loading_skeleton.dart';
import 'metric_card.dart';

class DesignSystemShowcase extends StatelessWidget {
  const DesignSystemShowcase({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBar: AppBar(
        title: const Text('FitKarma Design System'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Color Palette', style: AppTypography.title),
            const SizedBox(height: AppSpacing.md),
            const Wrap(
              spacing: AppSpacing.sm,
              runSpacing: AppSpacing.sm,
              children: [
                _ColorChip(label: 'Background', color: AppColors.background),
                _ColorChip(label: 'Surface', color: AppColors.surface),
                _ColorChip(label: 'Elevated', color: AppColors.surfaceElevated),
                _ColorChip(label: 'Mint', color: AppColors.primary),
                _ColorChip(label: 'Teal', color: AppColors.primaryAccent),
                _ColorChip(label: 'Saffron', color: AppColors.saffron),
                _ColorChip(label: 'Tech Blue', color: AppColors.techBlue),
                _ColorChip(label: 'Error', color: AppColors.error),
              ],
            ),
            const SizedBox(height: AppSpacing.xl),
            const Text('Bento Grid & Metric Cards', style: AppTypography.title),
            const SizedBox(height: AppSpacing.md),
            const Row(
              children: [
                Expanded(
                  child: MetricCard(
                    title: 'Steps Today',
                    value: '10,240',
                    unit: 'steps',
                    icon: Icons.directions_walk,
                  ),
                ),
                SizedBox(width: AppSpacing.md),
                Expanded(
                  child: MetricCard(
                    title: 'Fasting Time',
                    value: '14.5',
                    unit: 'hrs',
                    accentColor: AppColors.saffron,
                    icon: Icons.timer_outlined,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            const BentoCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Daily Intelligence Package', style: AppTypography.title),
                  SizedBox(height: AppSpacing.xs),
                  Text(
                    'Indian food logging with Tadka slider and WhatsApp voice synchronization ready.',
                    style: AppTypography.bodySecondary,
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            const Text('Action Buttons', style: AppTypography.title),
            const SizedBox(height: AppSpacing.md),
            Row(
              children: [
                Expanded(
                  child: ActionButton(
                    label: 'Primary Action',
                    onPressed: () {},
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: ActionButton(
                    label: 'Secondary',
                    variant: ActionButtonVariant.secondary,
                    onPressed: () {},
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.xl),
            const Text('Loading Skeleton', style: AppTypography.title),
            const SizedBox(height: AppSpacing.md),
            const LoadingSkeleton(height: 60),
          ],
        ),
      ),
    );
  }
}

class _ColorChip extends StatelessWidget {
  final String label;
  final Color color;

  const _ColorChip({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color,
        borderRadius: AppRadii.borderXs,
        border: Border.all(color: AppColors.glassBorder),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color.computeLuminance() > 0.5 ? Colors.black : Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
