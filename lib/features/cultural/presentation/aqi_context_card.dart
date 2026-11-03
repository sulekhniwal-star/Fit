// ============================================================================
// AQI CONTEXT BENTO CARD (DASHBOARD WIDGET)
// ============================================================================

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../shared/theme/app_colors.dart';
import '../../../shared/theme/app_spacing.dart';
import '../../../shared/theme/app_typography.dart';
import '../../../shared/widgets/bento_card.dart';
import 'aqi_badge.dart';
import 'aqi_details_sheet.dart';
import 'aqi_state_notifier.dart';

class AqiContextCard extends ConsumerWidget {
  const AqiContextCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final aqiState = ref.watch(aqiStateNotifierProvider);
    final reading = aqiState.currentReading;
    final advisory = aqiState.currentAdvisory;

    if (reading == null || advisory == null) {
      return const SizedBox.shrink();
    }

    final band = reading.band;
    final isSafe = reading.isOutdoorSafe;

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
                  Icon(
                    isSafe ? Icons.air_rounded : Icons.masks_rounded,
                    color: band.color,
                    size: 20,
                  ),
                  const SizedBox(width: AppSpacing.xs),
                  Text(
                    'Air Quality: ${reading.city}',
                    style: AppTypography.caption.copyWith(
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
              AqiBadge(aqi: reading.aqi, compact: true),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),

          // Context message
          Text(
            isSafe
                ? 'Air quality is ${band.label.toLowerCase()}. Excellent conditions for outdoor exercise!'
                : '${band.label} AQI today. Consider switching outdoor cardio to an indoor alternative.',
            style: AppTypography.caption.copyWith(fontSize: 12, color: AppColors.textSecondary),
          ),
          const SizedBox(height: AppSpacing.sm),

          // Bottom Action
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () {
                  showModalBottomSheet<void>(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                    builder: (_) => const AqiDetailsSheet(),
                  );
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      isSafe ? 'View Details' : 'View Indoor Alternatives',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: band.color,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Icon(Icons.arrow_forward_ios_rounded, size: 10, color: band.color),
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
