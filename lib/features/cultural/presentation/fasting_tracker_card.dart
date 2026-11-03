// ============================================================================
// FASTING TRACKER BENTO CARD (DASHBOARD WIDGET)
// ============================================================================

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../shared/theme/app_colors.dart';
import '../../../shared/theme/app_radii.dart';
import '../../../shared/theme/app_spacing.dart';
import '../../../shared/theme/app_typography.dart';
import '../../../shared/widgets/bento_card.dart';
import '../domain/fasting_protocol.dart';
import '../domain/fasting_session.dart';
import 'fasting_screen.dart';
import 'fasting_state_notifier.dart';
import 'refeeding_guidance_sheet.dart';

class FastingTrackerCard extends ConsumerWidget {
  const FastingTrackerCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final fastingState = ref.watch(fastingStateNotifierProvider);
    final activeSession = fastingState.activeSession;

    if (activeSession == null || !activeSession.isActive) {
      return _buildInactiveCard(context);
    }

    return _buildActiveCard(context, ref, activeSession);
  }

  Widget _buildInactiveCard(BuildContext context) {
    return BentoCard(
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(AppSpacing.xs),
            decoration: BoxDecoration(
              color: AppColors.saffron.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.timer_outlined, color: AppColors.saffron, size: 22),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Fasting & Cultural Vrat',
                  style: AppTypography.caption.copyWith(
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                Text(
                  '16:8, Navratri, Ekadashi, Karwa Chauth, Ramadan',
                  style: AppTypography.caption.copyWith(fontSize: 11, color: AppColors.textSecondary),
                ),
              ],
            ),
          ),
          OutlinedButton(
            onPressed: () => Navigator.of(context).push<void>(
              MaterialPageRoute<void>(builder: (_) => const FastingScreen()),
            ),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.saffron,
              side: const BorderSide(color: AppColors.saffron),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              minimumSize: const Size(0, 36),
            ),
            child: const Text('Start Fast', style: TextStyle(fontSize: 12)),
          ),
        ],
      ),
    );
  }

  Widget _buildActiveCard(BuildContext context, WidgetRef ref, FastingSession session) {
    final protocol = FastingProtocol.fromType(session.protocolType);
    final elapsed = session.elapsedDuration;
    final elapsedHours = elapsed.inHours;
    final elapsedMins = elapsed.inMinutes % 60;
    final plannedHours = session.plannedDuration.inHours;
    final progress = session.progressPercentage.clamp(0.0, 1.0);
    final stageInfo = session.currentStageInfo;

    return BentoCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.timer_rounded, color: AppColors.saffron, size: 18),
                  const SizedBox(width: AppSpacing.xs),
                  Text(
                    protocol.displayName,
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
                  stageInfo.title,
                  style: AppTypography.caption.copyWith(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: AppColors.saffron,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),

          // Elapsed and Planned Time
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                '${elapsedHours}h ${elapsedMins}m',
                style: AppTypography.metricLarge.copyWith(color: AppColors.saffron),
              ),
              const SizedBox(width: AppSpacing.xs),
              Text(
                '/ ${plannedHours}h target',
                style: AppTypography.bodySecondary,
              ),
              const Spacer(),
              Text(
                '${(progress * 100).toStringAsFixed(0)}%',
                style: AppTypography.caption.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),

          // Progress Bar
          ClipRRect(
            borderRadius: AppRadii.borderFull,
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 6,
              backgroundColor: AppColors.surfaceElevated,
              valueColor: const AlwaysStoppedAnimation<Color>(AppColors.saffron),
            ),
          ),
          const SizedBox(height: AppSpacing.sm),

          // Action buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () => Navigator.of(context).push<void>(
                  MaterialPageRoute<void>(builder: (_) => const FastingScreen()),
                ),
                child: const Text('Fast Details', style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
              ),
              const SizedBox(width: AppSpacing.xs),
              ElevatedButton(
                onPressed: () async {
                  await ref.read(fastingStateNotifierProvider.notifier).endFast();
                  if (!context.mounted) return;
                  await showModalBottomSheet<void>(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                    builder: (_) => const RefeedingGuidanceSheet(),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.saffron,
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  minimumSize: const Size(0, 34),
                ),
                child: const Text('End Fast', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
