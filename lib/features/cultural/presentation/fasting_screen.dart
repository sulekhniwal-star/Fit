// ============================================================================
// FASTING PROTOCOLS & TRACKING SCREEN
// ============================================================================

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../shared/theme/app_colors.dart';
import '../../../shared/theme/app_radii.dart';
import '../../../shared/theme/app_spacing.dart';
import '../../../shared/theme/app_typography.dart';
import '../../../shared/widgets/action_button.dart';
import '../../../shared/widgets/app_scaffold.dart';
import '../../../shared/widgets/bento_card.dart';
import '../domain/fasting_protocol.dart';
import '../domain/fasting_session.dart';
import 'fasting_state_notifier.dart';
import 'refeeding_guidance_sheet.dart';

class FastingScreen extends ConsumerStatefulWidget {
  const FastingScreen({super.key});

  @override
  ConsumerState<FastingScreen> createState() => _FastingScreenState();
}

class _FastingScreenState extends ConsumerState<FastingScreen> {
  FastingProtocolType _selectedProtocol = FastingProtocolType.if16_8;

  @override
  Widget build(BuildContext context) {
    final fastingState = ref.watch(fastingStateNotifierProvider);
    final activeSession = fastingState.activeSession;
    final isActive = activeSession != null && activeSession.isActive;

    return AppScaffold(
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: Text(
          'Fasting & Cultural Vrat',
          style: AppTypography.title.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 1. Clinical Disclaimer
            Container(
              padding: const EdgeInsets.all(AppSpacing.sm),
              decoration: BoxDecoration(
                color: AppColors.surfaceElevated,
                borderRadius: AppRadii.borderSm,
                border: Border.all(color: AppColors.glassBorder),
              ),
              child: Row(
                children: [
                  const Icon(Icons.shield_outlined, color: AppColors.saffron, size: 20),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Text(
                      'Fasting is voluntary. Never advised for pregnant/nursing mothers or type 1 diabetics without doctor guidance.',
                      style: AppTypography.caption.copyWith(fontSize: 11, color: AppColors.textSecondary),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.md),

            // 2. Active Fast Display OR Protocol Selector
            if (isActive) ...[
              _buildActiveFastSection(activeSession),
            ] else ...[
              _buildProtocolSelector(),
              const SizedBox(height: AppSpacing.md),
              _buildProtocolDetails(),
              const SizedBox(height: AppSpacing.lg),
              ActionButton(
                label: 'Begin Fasting Window',
                onPressed: () async {
                  await ref.read(fastingStateNotifierProvider.notifier).startFast(
                        protocolType: _selectedProtocol,
                      );
                },
              ),
            ],

            const SizedBox(height: AppSpacing.xl),
          ],
        ),
      ),
    );
  }

  Widget _buildActiveFastSection(FastingSession session) {
    final protocol = FastingProtocol.fromType(session.protocolType);
    final elapsed = session.elapsedDuration;
    final elapsedHours = elapsed.inHours;
    final elapsedMins = elapsed.inMinutes % 60;
    final progress = session.progressPercentage.clamp(0.0, 1.0);
    final stageInfo = session.currentStageInfo;

    return Column(
      children: [
        BentoCard(
          child: Column(
            children: [
              Text(
                protocol.displayName,
                style: AppTypography.title.copyWith(color: AppColors.saffron),
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                protocol.culturalContext,
                style: AppTypography.caption.copyWith(color: AppColors.textSecondary),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.lg),

              // Circular Progress
              Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: 180,
                    height: 180,
                    child: CircularProgressIndicator(
                      value: progress,
                      strokeWidth: 12,
                      backgroundColor: AppColors.surfaceElevated,
                      valueColor: const AlwaysStoppedAnimation<Color>(AppColors.saffron),
                    ),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '${elapsedHours}h ${elapsedMins}m',
                        style: AppTypography.metricLarge.copyWith(color: AppColors.textPrimary, fontSize: 32),
                      ),
                      Text(
                        'Target: ${session.plannedDuration.inHours}h',
                        style: AppTypography.caption.copyWith(color: AppColors.textSecondary),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.lg),

              // Metabolic Stage Details
              Container(
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  color: AppColors.surfaceElevated,
                  borderRadius: AppRadii.borderMd,
                  border: Border.all(color: AppColors.glassBorder),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.bolt, color: AppColors.saffron, size: 18),
                        const SizedBox(width: AppSpacing.xs),
                        Text(
                          stageInfo.title,
                          style: AppTypography.caption.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppColors.saffron,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      stageInfo.biologicalDescription,
                      style: AppTypography.caption.copyWith(fontSize: 11, color: AppColors.textSecondary),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.md),

              // Waterless note
              if (session.isWaterless)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.warning.withValues(alpha: 0.15),
                    borderRadius: AppRadii.borderFull,
                  ),
                  child: Text(
                    '💧 Nirjala / Dry Fast — Hydration alerts paused',
                    style: AppTypography.caption.copyWith(fontSize: 10, color: AppColors.warning, fontWeight: FontWeight.bold),
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.md),

        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () async {
                  await ref.read(fastingStateNotifierProvider.notifier).cancelFast();
                },
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.textSecondary,
                  side: const BorderSide(color: AppColors.glassBorder),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: const Text('Cancel Fast'),
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: ActionButton(
                label: 'End Fast',
                onPressed: () async {
                  await ref.read(fastingStateNotifierProvider.notifier).endFast();
                  if (!mounted) return;
                  await showModalBottomSheet<void>(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                    builder: (_) => const RefeedingGuidanceSheet(),
                  );
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildProtocolSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Select Fasting Protocol',
          style: AppTypography.caption.copyWith(
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: FastingProtocol.allProtocols.map((p) {
            final isSelected = p.type == _selectedProtocol;
            return ChoiceChip(
              label: Text(p.displayName),
              selected: isSelected,
              onSelected: (selected) {
                if (selected) {
                  setState(() => _selectedProtocol = p.type);
                }
              },
              selectedColor: AppColors.saffron,
              backgroundColor: AppColors.surfaceElevated,
              labelStyle: TextStyle(
                color: isSelected ? Colors.black : AppColors.textPrimary,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                fontSize: 12,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildProtocolDetails() {
    final p = FastingProtocol.fromType(_selectedProtocol);

    return BentoCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                p.displayName,
                style: AppTypography.caption.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              Text(
                p.hindiDisplayName,
                style: AppTypography.caption.copyWith(
                  color: AppColors.saffron,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            p.description,
            style: AppTypography.caption.copyWith(fontSize: 12, color: AppColors.textSecondary),
          ),
          const SizedBox(height: AppSpacing.sm),
          Row(
            children: [
              _buildMetaTag(Icons.timer_outlined, '${p.defaultFastHours}h Fast'),
              const SizedBox(width: AppSpacing.sm),
              _buildMetaTag(Icons.restaurant_outlined, '${p.eatingWindowHours}h Window'),
              if (p.isWaterless) ...[
                const SizedBox(width: AppSpacing.sm),
                _buildMetaTag(Icons.water_drop_outlined, 'Nirjala / Dry', color: AppColors.warning),
              ],
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          const Divider(color: AppColors.glassBorder),
          const SizedBox(height: AppSpacing.xs),
          Text(
            'Dietary Guidelines:',
            style: AppTypography.caption.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          ...p.dietaryGuidelines.map(
            (g) => Padding(
              padding: const EdgeInsets.only(bottom: 2),
              child: Text('• $g', style: AppTypography.caption.copyWith(fontSize: 11, color: AppColors.textSecondary)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetaTag(IconData icon, String text, {Color color = AppColors.primary}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: AppRadii.borderFull,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 4),
          Text(text, style: TextStyle(fontSize: 10, color: color, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
