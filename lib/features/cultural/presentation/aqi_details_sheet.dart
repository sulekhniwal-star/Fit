// ============================================================================
// AQI DETAILS & CITY SELECTOR MODAL SHEET
// ============================================================================

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../shared/theme/app_colors.dart';
import '../../../shared/theme/app_radii.dart';
import '../../../shared/theme/app_spacing.dart';
import '../../../shared/theme/app_typography.dart';
import '../../../shared/widgets/bento_card.dart';
import '../data/aqi_service.dart';
import 'aqi_badge.dart';
import 'aqi_state_notifier.dart';

class AqiDetailsSheet extends ConsumerWidget {
  const AqiDetailsSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final aqiState = ref.watch(aqiStateNotifierProvider);
    final reading = aqiState.currentReading;
    final advisory = aqiState.currentAdvisory;

    if (reading == null || advisory == null) {
      return const SizedBox(
        height: 200,
        child: Center(child: CircularProgressIndicator(color: AppColors.primary)),
      );
    }

    final band = reading.band;

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

              // Title and City Selector
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.air_rounded, color: AppColors.techBlue, size: 20),
                          const SizedBox(width: AppSpacing.xs),
                          Text(
                            'Air Quality Index',
                            style: AppTypography.title.copyWith(fontSize: 18),
                          ),
                        ],
                      ),
                      Text(
                        'CPCB NAQI Standards • Coarse Privacy',
                        style: AppTypography.caption.copyWith(color: AppColors.textSecondary, fontSize: 11),
                      ),
                    ],
                  ),
                  AqiBadge(aqi: reading.aqi),
                ],
              ),
              const SizedBox(height: AppSpacing.md),

              // City Chip Selector
              Text(
                'Change City (Privacy-Safe Coarse Selection):',
                style: AppTypography.caption.copyWith(fontWeight: FontWeight.w700, color: AppColors.textPrimary),
              ),
              const SizedBox(height: AppSpacing.xs),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: AqiService.supportedIndianCities.map((city) {
                    final isSelected = city == aqiState.selectedCity;
                    return Padding(
                      padding: const EdgeInsets.only(right: 6),
                      child: ChoiceChip(
                        label: Text(city),
                        selected: isSelected,
                        onSelected: (selected) {
                          if (selected) {
                            ref.read(aqiStateNotifierProvider.notifier).selectCity(city);
                          }
                        },
                        selectedColor: AppColors.primary,
                        backgroundColor: AppColors.surfaceElevated,
                        labelStyle: TextStyle(
                          color: isSelected ? Colors.black : AppColors.textPrimary,
                          fontSize: 11,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: AppSpacing.md),

              // Primary Workout Recommendation Card
              BentoCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          reading.isOutdoorSafe ? Icons.check_circle_outline_rounded : Icons.warning_amber_rounded,
                          color: band.color,
                          size: 20,
                        ),
                        const SizedBox(width: AppSpacing.xs),
                        Text(
                          reading.isOutdoorSafe ? 'Outdoor Exercise Safe' : 'Indoor Workout Advised',
                          style: AppTypography.caption.copyWith(
                            fontWeight: FontWeight.bold,
                            color: band.color,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      advisory.primaryRecommendation,
                      style: AppTypography.caption.copyWith(fontSize: 12, color: AppColors.textPrimary),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      advisory.hindiRecommendation,
                      style: AppTypography.caption.copyWith(fontSize: 11, color: AppColors.textSecondary),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.md),

              // Particulate breakdown
              Row(
                children: [
                  Expanded(
                    child: BentoCard(
                      padding: const EdgeInsets.all(AppSpacing.sm),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('PM2.5 (Fine)', style: AppTypography.caption.copyWith(color: AppColors.textSecondary)),
                          const SizedBox(height: 2),
                          Text(
                            reading.pm25 != null ? '${reading.pm25!.toStringAsFixed(1)} µg/m³' : '--',
                            style: AppTypography.title.copyWith(color: band.color, fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 2),
                          Text('Alveoli lung load', style: AppTypography.caption.copyWith(fontSize: 10)),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: BentoCard(
                      padding: const EdgeInsets.all(AppSpacing.sm),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('PM10 (Coarse)', style: AppTypography.caption.copyWith(color: AppColors.textSecondary)),
                          const SizedBox(height: 2),
                          Text(
                            reading.pm10 != null ? '${reading.pm10!.toStringAsFixed(1)} µg/m³' : '--',
                            style: AppTypography.title.copyWith(color: band.color, fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 2),
                          Text('Nasal / upper airway', style: AppTypography.caption.copyWith(fontSize: 10)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.md),

              // Recommended Indoor Alternatives (if outdoor is hazardous)
              if (advisory.indoorAlternatives.isNotEmpty) ...[
                Text(
                  'Recommended Indoor Alternatives Today:',
                  style: AppTypography.caption.copyWith(fontWeight: FontWeight.w700, color: AppColors.textPrimary),
                ),
                const SizedBox(height: AppSpacing.xs),
                ...advisory.indoorAlternatives.map(
                  (alt) => Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.xs),
                    child: BentoCard(
                      padding: const EdgeInsets.all(AppSpacing.sm),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  alt.title,
                                  style: AppTypography.caption.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                              ),
                              const SizedBox(width: AppSpacing.xs),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: AppColors.primary.withValues(alpha: 0.15),
                                  borderRadius: AppRadii.borderFull,
                                ),
                                child: Text(
                                  '${alt.estimatedDurationMinutes}m | ${alt.intensity}',
                                  style: AppTypography.caption.copyWith(fontSize: 10, color: AppColors.primary, fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 2),
                          Text(
                            alt.description,
                            style: AppTypography.caption.copyWith(fontSize: 11, color: AppColors.textSecondary),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
              ],

              // Respiratory health safety precautions
              Text(
                'Respiratory Precautions:',
                style: AppTypography.caption.copyWith(fontWeight: FontWeight.w700, color: AppColors.warning),
              ),
              const SizedBox(height: 4),
              ...advisory.respiratorySafetyTips.map(
                (tip) => Padding(
                  padding: const EdgeInsets.only(bottom: 2),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('• ', style: TextStyle(color: AppColors.warning)),
                      Expanded(
                        child: Text(
                          tip,
                          style: AppTypography.caption.copyWith(fontSize: 11, color: AppColors.textSecondary),
                        ),
                      ),
                    ],
                  ),
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
