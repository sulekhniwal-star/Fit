import 'package:flutter/material.dart';
import '../../../shared/theme/app_colors.dart';
import '../../../shared/theme/app_radii.dart';
import '../../../shared/theme/app_spacing.dart';
import '../../../shared/theme/app_typography.dart';
import '../../../shared/widgets/bento_card.dart';
import '../domain/dip_models.dart';

class DailyReadinessCard extends StatelessWidget {
  final DailyReadinessScore score;
  final VoidCallback? onTap;

  const DailyReadinessCard({
    super.key,
    required this.score,
    this.onTap,
  });

  Color _getTierColor(ReadinessTier tier) {
    switch (tier) {
      case ReadinessTier.peak:
        return AppColors.primary; // Neon Mint
      case ReadinessTier.optimal:
        return AppColors.primaryAccent; // Teal
      case ReadinessTier.moderate:
        return AppColors.saffron; // Saffron Gold
      case ReadinessTier.recovery:
        return AppColors.warning; // Alert / Amber
    }
  }

  IconData _getFactorIcon(String name) {
    if (name.contains('Sleep')) return Icons.bedtime_outlined;
    if (name.contains('Vitals')) return Icons.favorite_outline;
    if (name.contains('Strain')) return Icons.fitness_center_outlined;
    return Icons.water_drop_outlined;
  }

  @override
  Widget build(BuildContext context) {
    final tierColor = _getTierColor(score.tier);

    return BentoCard(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row: Title & Tier Badge
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(Icons.bolt, color: tierColor, size: 20),
                  const SizedBox(width: AppSpacing.xs),
                  Text(
                    'DAILY READINESS',
                    style: AppTypography.caption.copyWith(
                      letterSpacing: 1.2,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.sm,
                  vertical: 3,
                ),
                decoration: BoxDecoration(
                  color: tierColor.withAlpha(35),
                  borderRadius: BorderRadius.circular(AppRadii.full),
                  border: Border.all(color: tierColor.withAlpha(120), width: 1),
                ),
                child: Text(
                  score.tier.name.toUpperCase(),
                  style: TextStyle(
                    color: tierColor,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: AppSpacing.md),

          // Middle Row: Score Gauge & Narrative
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Score Ring
              Container(
                width: 76,
                height: 76,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: tierColor.withAlpha(20),
                  border: Border.all(color: tierColor, width: 3),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '${score.score}',
                        style: TextStyle(
                          color: tierColor,
                          fontSize: 26,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      Text(
                        '/100',
                        style: TextStyle(
                          color: AppColors.textSecondary.withAlpha(160),
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(width: AppSpacing.md),

              // Headline & Explanation
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      score.headline,
                      style: AppTypography.title.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      score.explanation,
                      style: AppTypography.bodySecondary.copyWith(
                        height: 1.35,
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: AppSpacing.md),

          // Contributing Factors Row
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: score.factors.map((f) {
                return Container(
                  margin: const EdgeInsets.only(right: AppSpacing.xs),
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.sm,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceElevated,
                    borderRadius: BorderRadius.circular(AppRadii.sm),
                    border: Border.all(
                      color: f.isMissing
                          ? AppColors.textSecondary.withAlpha(40)
                          : AppColors.glassBorder,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        _getFactorIcon(f.name),
                        size: 13,
                        color: f.isMissing
                            ? AppColors.textSecondary
                            : AppColors.primary,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        f.isMissing ? '${f.name} (est)' : '${f.name} ${f.score}%',
                        style: TextStyle(
                          color: f.isMissing
                              ? AppColors.textSecondary
                              : AppColors.textPrimary,
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),

          const SizedBox(height: AppSpacing.sm),

          // Statutory Non-Medical Disclaimer
          Text(
            score.statutoryDisclaimer,
            style: TextStyle(
              color: AppColors.textSecondary.withAlpha(130),
              fontSize: 10,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }
}
