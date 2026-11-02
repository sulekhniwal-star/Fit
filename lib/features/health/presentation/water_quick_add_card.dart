import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../shared/theme/app_colors.dart';
import '../../../shared/theme/app_radii.dart';
import '../../../shared/theme/app_spacing.dart';
import '../../../shared/theme/app_typography.dart';
import '../../../shared/widgets/bento_card.dart';
import '../data/drift_health_repositories.dart';
import '../domain/water_log.dart';

class WaterQuickAddCard extends ConsumerStatefulWidget {
  final String userId;

  const WaterQuickAddCard({super.key, required this.userId});

  @override
  ConsumerState<WaterQuickAddCard> createState() => _WaterQuickAddCardState();
}

class _WaterQuickAddCardState extends ConsumerState<WaterQuickAddCard> {
  int _currentTotalMl = 0;
  static const int _goalMl = 2500;

  @override
  void initState() {
    super.initState();
    _loadTodayTotal();
  }

  Future<void> _loadTodayTotal() async {
    final repo = ref.read(waterRepositoryProvider);
    final result = await repo.getDailyTotalMl(widget.userId, DateTime.now());
    result.when(
      onSuccess: (total) => setState(() => _currentTotalMl = total),
      onFailure: (_) {},
    );
  }

  Future<void> _addWater(int amountMl) async {
    final log = WaterLog(
      id: 'water_${DateTime.now().millisecondsSinceEpoch}',
      userId: widget.userId,
      recordedAt: DateTime.now(),
      amountMl: amountMl,
      dailyGoalMl: _goalMl,
    );

    final repo = ref.read(waterRepositoryProvider);
    await repo.saveLocal(log);
    setState(() => _currentTotalMl += amountMl);
  }

  @override
  Widget build(BuildContext context) {
    final progress = (_currentTotalMl / _goalMl).clamp(0.0, 1.0);

    return BentoCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(AppSpacing.xs),
                decoration: BoxDecoration(
                  color: AppColors.techBlue.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.water_drop_rounded, color: AppColors.techBlue, size: 20),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Text(
                  'Hydration',
                  style: AppTypography.title.copyWith(color: AppColors.textPrimary),
                ),
              ),
              Text(
                '$_currentTotalMl / $_goalMl ml',
                style: AppTypography.caption.copyWith(color: AppColors.techBlue, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          ClipRRect(
            borderRadius: BorderRadius.circular(AppRadii.full),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: AppColors.surface,
              valueColor: const AlwaysStoppedAnimation<Color>(AppColors.techBlue),
              minHeight: 8,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  key: const Key('add_water_250_btn'),
                  onPressed: () => _addWater(250),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.textPrimary,
                    side: const BorderSide(color: AppColors.glassBorder),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadii.md)),
                  ),
                  child: const Text('+250 ml (Glass)'),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: OutlinedButton(
                  key: const Key('add_water_500_btn'),
                  onPressed: () => _addWater(500),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.textPrimary,
                    side: const BorderSide(color: AppColors.glassBorder),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadii.md)),
                  ),
                  child: const Text('+500 ml (Bottle)'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

