import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../shared/theme/app_colors.dart';
import '../../../shared/theme/app_radii.dart';
import '../../../shared/theme/app_spacing.dart';
import '../../../shared/theme/app_typography.dart';
import '../../../shared/widgets/bento_card.dart';
import '../data/drift_health_repositories.dart';
import '../domain/mood_log.dart';

class MoodSelectorCard extends ConsumerStatefulWidget {
  final String userId;

  const MoodSelectorCard({super.key, required this.userId});

  @override
  ConsumerState<MoodSelectorCard> createState() => _MoodSelectorCardState();
}

class _MoodSelectorCardState extends ConsumerState<MoodSelectorCard> {
  MoodState? _selectedMood;

  @override
  void initState() {
    super.initState();
    _loadLatestMood();
  }

  Future<void> _loadLatestMood() async {
    final repo = ref.read(moodRepositoryProvider);
    final result = await repo.getLatest(widget.userId);
    result.when(
      onSuccess: (log) {
        if (log != null && mounted) {
          setState(() => _selectedMood = log.mood);
        }
      },
      onFailure: (_) {},
    );
  }

  Future<void> _selectMood(MoodState mood) async {
    setState(() => _selectedMood = mood);

    final log = MoodLog(
      id: 'mood_${DateTime.now().millisecondsSinceEpoch}',
      userId: widget.userId,
      recordedAt: DateTime.now(),
      mood: mood,
    );

    final repo = ref.read(moodRepositoryProvider);
    await repo.saveLocal(log);
  }

  @override
  Widget build(BuildContext context) {
    return BentoCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(AppSpacing.xs),
                decoration: BoxDecoration(
                  color: AppColors.saffron.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.mood_rounded, color: AppColors.saffron, size: 20),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Text(
                  'Daily Mood',
                  style: AppTypography.title.copyWith(color: AppColors.textPrimary),
                ),
              ),
              if (_selectedMood != null)
                Text(
                  _selectedMood!.label,
                  style: AppTypography.caption.copyWith(
                    color: AppColors.saffron,
                    fontWeight: FontWeight.bold,
                  ),
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: MoodState.values.map((m) {
              final isSelected = _selectedMood == m;
              return GestureDetector(
                key: Key('mood_item_${m.score}'),
                onTap: () => _selectMood(m),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.sm,
                    vertical: AppSpacing.xs,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.saffron.withValues(alpha: 0.2) : AppColors.surface,
                    borderRadius: BorderRadius.circular(AppRadii.md),
                    border: Border.all(
                      color: isSelected ? AppColors.saffron : AppColors.glassBorder,
                      width: isSelected ? 1.5 : 1.0,
                    ),
                  ),
                  child: Column(
                    children: [
                      Text(m.emoji, style: const TextStyle(fontSize: 24)),
                      const SizedBox(height: 2),
                      Text(
                        m.label,
                        style: AppTypography.caption.copyWith(
                          fontSize: 10,
                          color: isSelected ? AppColors.textPrimary : AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
