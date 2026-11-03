// ============================================================================
// FESTIVAL CELEBRATION BENTO CARD (DASHBOARD WIDGET)
// ============================================================================

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../shared/theme/app_colors.dart';
import '../../../shared/theme/app_radii.dart';
import '../../../shared/theme/app_spacing.dart';
import '../../../shared/theme/app_typography.dart';
import '../../../shared/widgets/bento_card.dart';
import 'festival_detail_sheet.dart';
import 'festival_state_notifier.dart';

class FestivalBannerCard extends ConsumerWidget {
  const FestivalBannerCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final festivalState = ref.watch(festivalStateNotifierProvider);

    if (!festivalState.hasActiveFestival) {
      return const SizedBox.shrink();
    }

    final festival = festivalState.activeFestival!;

    return BentoCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(AppSpacing.xs),
                    decoration: BoxDecoration(
                      color: AppColors.saffron.withValues(alpha: 0.15),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.celebration_rounded, color: AppColors.saffron, size: 20),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Text(
                    festival.name,
                    style: AppTypography.caption.copyWith(
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.saffron.withValues(alpha: 0.15),
                  borderRadius: AppRadii.borderFull,
                ),
                child: Text(
                  'Festival Mode',
                  style: AppTypography.caption.copyWith(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: AppColors.saffron,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            festival.culturalGreeting,
            style: AppTypography.caption.copyWith(fontSize: 12, color: AppColors.textPrimary),
          ),
          Text(
            festival.hindiCulturalGreeting,
            style: AppTypography.caption.copyWith(fontSize: 11, color: AppColors.saffron),
          ),
          const SizedBox(height: AppSpacing.sm),

          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () {
                  showModalBottomSheet<void>(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                    builder: (_) => FestivalDetailSheet(festival: festival),
                  );
                },
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Feast Planner & Delicacies',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: AppColors.saffron,
                      ),
                    ),
                    SizedBox(width: 4),
                    Icon(Icons.arrow_forward_ios_rounded, size: 10, color: AppColors.saffron),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

