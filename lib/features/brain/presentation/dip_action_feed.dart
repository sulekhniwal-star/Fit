import 'package:flutter/material.dart';
import '../../../shared/theme/app_colors.dart';
import '../../../shared/theme/app_radii.dart';
import '../../../shared/theme/app_spacing.dart';
import '../../../shared/theme/app_typography.dart';
import '../../../shared/widgets/bento_card.dart';
import '../domain/dip_models.dart';

class DipActionFeed extends StatelessWidget {
  final List<DipMicroAction> actions;
  final ValueChanged<DipMicroAction>? onActionTap;
  final ValueChanged<DipMicroAction>? onDismiss;

  const DipActionFeed({
    super.key,
    required this.actions,
    this.onActionTap,
    this.onDismiss,
  });

  IconData _getCategoryIcon(DipActionCategory category) {
    switch (category) {
      case DipActionCategory.hydration:
        return Icons.water_drop;
      case DipActionCategory.nutrition:
        return Icons.restaurant;
      case DipActionCategory.movement:
        return Icons.directions_walk;
      case DipActionCategory.recovery:
        return Icons.self_improvement;
      case DipActionCategory.mindset:
        return Icons.lightbulb_outline;
    }
  }

  Color _getCategoryColor(DipActionCategory category) {
    switch (category) {
      case DipActionCategory.hydration:
        return AppColors.techBlue;
      case DipActionCategory.nutrition:
        return AppColors.saffron;
      case DipActionCategory.movement:
        return AppColors.primary;
      case DipActionCategory.recovery:
        return AppColors.primaryAccent;
      case DipActionCategory.mindset:
        return AppColors.warning;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (actions.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'TODAY\'S PRIORITIES',
              style: AppTypography.caption.copyWith(
                letterSpacing: 1.2,
                fontWeight: FontWeight.bold,
                color: AppColors.textSecondary,
              ),
            ),
            Text(
              '${actions.length} Recommended',
              style: TextStyle(
                color: AppColors.textSecondary.withAlpha(160),
                fontSize: 11,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        ...actions.map((action) => _buildActionCard(context, action)),
      ],
    );
  }

  Widget _buildActionCard(BuildContext context, DipMicroAction action) {
    final categoryColor = _getCategoryColor(action.category);

    return Padding(
      key: ValueKey(action.id),
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: BentoCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Meta Row
            Row(
              children: [
                Icon(
                  _getCategoryIcon(action.category),
                  size: 16,
                  color: categoryColor,
                ),
                const SizedBox(width: AppSpacing.xs),
                Text(
                  action.category.name.toUpperCase(),
                  style: TextStyle(
                    color: categoryColor,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.8,
                  ),
                ),
                if (action.culturalContext != null) ...[
                  const SizedBox(width: AppSpacing.xs),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: AppColors.saffron.withAlpha(30),
                      borderRadius: BorderRadius.circular(AppRadii.sm),
                    ),
                    child: const Text(
                      'Traditional',
                      style: TextStyle(
                        color: AppColors.saffron,
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
                const Spacer(),
                if (action.isDismissible && onDismiss != null)
                  InkWell(
                    key: Key('dismiss_${action.id}'),
                    onTap: () => onDismiss!(action),
                    borderRadius: BorderRadius.circular(AppRadii.full),
                    child: Padding(
                      padding: const EdgeInsets.all(4),
                      child: Icon(
                        Icons.close,
                        size: 16,
                        color: AppColors.textSecondary.withAlpha(160),
                      ),
                    ),
                  ),
              ],
            ),

            const SizedBox(height: AppSpacing.xs),

            // Title & Description
            Text(
              action.title,
              style: AppTypography.title.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              action.description,
              style: AppTypography.bodySecondary.copyWith(
                height: 1.35,
              ),
            ),

            const SizedBox(height: AppSpacing.md),

            // Action Button
            SizedBox(
              width: double.infinity,
              height: 40,
              child: ElevatedButton(
                key: Key('btn_${action.id}'),
                onPressed: () => onActionTap?.call(action),
                style: ElevatedButton.styleFrom(
                  backgroundColor: categoryColor.withAlpha(40),
                  foregroundColor: categoryColor,
                  elevation: 0,
                  side: BorderSide(color: categoryColor.withAlpha(120), width: 1),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppRadii.md),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      action.actionLabel,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                    ),
                    const SizedBox(width: 4),
                    const Icon(Icons.arrow_forward, size: 14),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
