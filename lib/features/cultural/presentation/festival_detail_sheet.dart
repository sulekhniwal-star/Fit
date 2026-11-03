// ============================================================================
// FESTIVAL DETAIL & FEAST PLANNER MODAL SHEET
// ============================================================================

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../shared/theme/app_colors.dart';
import '../../../shared/theme/app_radii.dart';
import '../../../shared/theme/app_spacing.dart';
import '../../../shared/theme/app_typography.dart';
import '../../../shared/widgets/bento_card.dart';
import '../domain/festival_models.dart';
import '../domain/festive_balance_calculator.dart';
import 'festival_state_notifier.dart';

class FestivalDetailSheet extends ConsumerWidget {
  final FestivalEvent festival;

  const FestivalDetailSheet({super.key, required this.festival});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final balancePlan = FestiveBalanceCalculator.calculatePlan(estimatedFeastCalories: 600);
    final notifier = ref.read(festivalStateNotifierProvider.notifier);
    final isMuted = ref.watch(festivalStateNotifierProvider).mutedFestivalIds.contains(festival.id);

    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadii.lg)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.md),
      child: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Handle bar
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: AppSpacing.md),
                  decoration: const BoxDecoration(
                    color: AppColors.glassBorder,
                    borderRadius: AppRadii.borderFull,
                  ),
                ),
              ),

              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          festival.name,
                          style: AppTypography.title.copyWith(fontSize: 18, color: AppColors.saffron),
                        ),
                        Text(
                          festival.hindiName,
                          style: AppTypography.caption.copyWith(color: AppColors.textSecondary),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      isMuted ? Icons.notifications_off_rounded : Icons.notifications_active_rounded,
                      color: isMuted ? AppColors.textSecondary : AppColors.saffron,
                    ),
                    tooltip: isMuted ? 'Muted (Tap to un-mute)' : 'Mute Festival Context',
                    onPressed: () {
                      notifier.toggleMuteFestival(festival.id);
                    },
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.sm),

              Text(
                festival.culturalGreeting,
                style: AppTypography.body.copyWith(fontWeight: FontWeight.w600, color: AppColors.textPrimary),
              ),
              const SizedBox(height: 2),
              Text(
                festival.hindiCulturalGreeting,
                style: AppTypography.caption.copyWith(color: AppColors.saffron),
              ),
              const SizedBox(height: AppSpacing.md),

              // Description Card
              BentoCard(
                padding: const EdgeInsets.all(AppSpacing.sm),
                child: Text(
                  festival.description,
                  style: AppTypography.caption.copyWith(fontSize: 12, color: AppColors.textSecondary),
                ),
              ),
              const SizedBox(height: AppSpacing.md),

              // Traditional Foods Section
              if (festival.traditionalFoods.isNotEmpty) ...[
                Text(
                  'Traditional Festive Delicacies:',
                  style: AppTypography.caption.copyWith(fontWeight: FontWeight.w700, color: AppColors.textPrimary),
                ),
                const SizedBox(height: AppSpacing.xs),
                ...festival.traditionalFoods.map(
                  (food) => Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.xs),
                    child: BentoCard(
                      padding: const EdgeInsets.all(AppSpacing.sm),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                food.name,
                                style: AppTypography.caption.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: AppColors.saffron.withValues(alpha: 0.15),
                                  borderRadius: AppRadii.borderFull,
                                ),
                                child: Text(
                                  '~${food.calories.toStringAsFixed(0)} kcal',
                                  style: AppTypography.caption.copyWith(fontSize: 10, color: AppColors.saffron, fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '${food.portionDescription} (${food.portionGrams.toStringAsFixed(0)}g) • P: ${food.proteinGrams}g | C: ${food.carbsGrams}g | F: ${food.fatGrams}g',
                            style: AppTypography.caption.copyWith(fontSize: 11, color: AppColors.textSecondary),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            food.culturalNote,
                            style: AppTypography.caption.copyWith(fontSize: 10, color: AppColors.textSecondary),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
              ],

              // Shame-Free Feast Planner
              Text(
                'Shame-Free Feast Balance Plan:',
                style: AppTypography.caption.copyWith(fontWeight: FontWeight.w700, color: AppColors.primary),
              ),
              const SizedBox(height: AppSpacing.xs),
              BentoCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      balancePlan.shameFreeAffirmation,
                      style: AppTypography.caption.copyWith(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      'Pre-Feast Preparation:',
                      style: AppTypography.caption.copyWith(fontWeight: FontWeight.bold, color: AppColors.saffron),
                    ),
                    ...balancePlan.preFeastGuidelines.map(
                      (g) => Text('• $g', style: AppTypography.caption.copyWith(fontSize: 11, color: AppColors.textSecondary)),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      'Post-Feast Shatapawali:',
                      style: AppTypography.caption.copyWith(fontWeight: FontWeight.bold, color: AppColors.techBlue),
                    ),
                    ...balancePlan.postFeastRecoveryTips.map(
                      (t) => Text('• $t', style: AppTypography.caption.copyWith(fontSize: 11, color: AppColors.textSecondary)),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.md),
            ],
          ),
        ),
      ),
    );
  }
}

