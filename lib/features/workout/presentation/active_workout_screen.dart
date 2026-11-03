import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../shared/theme/app_colors.dart';
import '../../../shared/theme/app_radii.dart';
import '../../../shared/theme/app_spacing.dart';
import '../../../shared/widgets/bento_card.dart';
import '../data/drift_exercise_repository.dart';
import '../data/drift_workout_repository.dart';
import '../domain/exercise.dart';
import '../domain/workout_session.dart';
import '../domain/workout_set.dart';
import 'rest_timer_widget.dart';

class ActiveWorkoutScreen extends ConsumerStatefulWidget {
  final WorkoutSession? initialSession;

  const ActiveWorkoutScreen({super.key, this.initialSession});

  @override
  ConsumerState<ActiveWorkoutScreen> createState() => _ActiveWorkoutScreenState();
}

class _ActiveWorkoutScreenState extends ConsumerState<ActiveWorkoutScreen> {
  late WorkoutSession _session;
  Timer? _elapsedTimer;
  int _elapsedSeconds = 0;
  bool _showRestTimer = false;
  final int _restDuration = 60;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _session = widget.initialSession ??
        WorkoutSession(
          id: 'ws_${now.millisecondsSinceEpoch}',
          userId: 'user_active',
          title: 'Full Body Power & Strength',
          workoutType: WorkoutType.strength,
          startedAt: now,
          status: WorkoutSessionStatus.inProgress,
        );

    _elapsedSeconds = _session.computeDurationSeconds(now);
    _startElapsedTimer();

    // If starting with no exercises, auto-add a default exercise for convenience
    if (_session.sets.isEmpty) {
      _loadDefaultInitialExercise();
    }
  }

  void _loadDefaultInitialExercise() {
    final s1 = WorkoutSet(
      id: 'set_${DateTime.now().millisecondsSinceEpoch}_1',
      sessionId: _session.id,
      exerciseId: 'ex_bench_press_01',
      exerciseName: 'Barbell Bench Press',
      setNumber: 1,
      weightKg: 60.0,
      reps: 10,
    );
    final s2 = WorkoutSet(
      id: 'set_${DateTime.now().millisecondsSinceEpoch}_2',
      sessionId: _session.id,
      exerciseId: 'ex_bench_press_01',
      exerciseName: 'Barbell Bench Press',
      setNumber: 2,
      weightKg: 60.0,
      reps: 10,
    );
    setState(() {
      _session = _session.copyWith(sets: [s1, s2]);
    });
  }

  @override
  void dispose() {
    _elapsedTimer?.cancel();
    super.dispose();
  }

  void _startElapsedTimer() {
    _elapsedTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) {
        setState(() => _elapsedSeconds++);
      }
    });
  }

  String _formatElapsed(int seconds) {
    final h = (seconds ~/ 3600).toString().padLeft(2, '0');
    final m = ((seconds % 3600) ~/ 60).toString().padLeft(2, '0');
    final s = (seconds % 60).toString().padLeft(2, '0');
    return seconds >= 3600 ? '$h:$m:$s' : '$m:$s';
  }

  void _toggleSetCompletion(WorkoutSet targetSet) {
    final updatedSets = _session.sets.map((s) {
      if (s.id == targetSet.id) {
        final newCompleted = !s.isCompleted;
        return s.copyWith(
          isCompleted: newCompleted,
          completedAt: newCompleted ? DateTime.now() : null,
        );
      }
      return s;
    }).toList();

    final updatedSession = _session.copyWith(sets: updatedSets);
    setState(() {
      _session = updatedSession;
      if (!targetSet.isCompleted) {
        _showRestTimer = true;
      }
    });

    // Auto-save set update to Drift
    final changedSet = updatedSets.firstWhere((s) => s.id == targetSet.id);
    ref.read(workoutRepositoryProvider).saveSet(changedSet);
  }

  void _addSetForExercise(String exerciseId, String exerciseName) {
    final existingSets = _session.sets.where((s) => s.exerciseId == exerciseId).toList();
    final nextNumber = existingSets.length + 1;
    final lastWeight = existingSets.isNotEmpty ? existingSets.last.weightKg : 20.0;
    final lastReps = existingSets.isNotEmpty ? existingSets.last.reps : 10;

    final newSet = WorkoutSet(
      id: 'set_${DateTime.now().millisecondsSinceEpoch}_$nextNumber',
      sessionId: _session.id,
      exerciseId: exerciseId,
      exerciseName: exerciseName,
      setNumber: nextNumber,
      weightKg: lastWeight,
      reps: lastReps,
    );

    setState(() {
      _session = _session.copyWith(sets: [..._session.sets, newSet]);
    });

    ref.read(workoutRepositoryProvider).saveSet(newSet);
  }

  Future<void> _showAddExerciseModal() async {
    final repo = ref.read(exerciseRepositoryProvider);
    final exercisesRes = await repo.search(limit: 50);
    final exercises = exercisesRes.dataOrNull ?? [];

    if (!mounted) return;

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surfaceElevated,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadii.lg)),
      ),
      builder: (ctx) {
        return DraggableScrollableSheet(
          initialChildSize: 0.7,
          minChildSize: 0.4,
          maxChildSize: 0.9,
          expand: false,
          builder: (context, scrollController) {
            return Column(
              children: [
                Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
                  decoration: BoxDecoration(
                    color: AppColors.textSecondary.withValues(alpha: 0.4),
                    borderRadius: AppRadii.borderFull,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.xs),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Select Exercise',
                        style: TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close, color: AppColors.textSecondary),
                        onPressed: () => Navigator.pop(ctx),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.separated(
                    controller: scrollController,
                    itemCount: exercises.length,
                    separatorBuilder: (_, __) => const Divider(color: AppColors.glassBorder, height: 1),
                    itemBuilder: (context, index) {
                      final ex = exercises[index];
                      return ListTile(
                        title: Text(
                          ex.name,
                          style: const TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w600),
                        ),
                        subtitle: Text(
                          ex.hindiName.isNotEmpty
                              ? '${ex.hindiName} • ${ex.primaryMuscle.displayName}'
                              : ex.primaryMuscle.displayName,
                          style: const TextStyle(color: AppColors.textSecondary, fontSize: 12),
                        ),
                        trailing: const Icon(Icons.add_circle_outline, color: AppColors.primary),
                        onTap: () {
                          Navigator.pop(ctx);
                          _addSetForExercise(ex.id, ex.name);
                        },
                      );
                    },
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> _finishWorkout() async {
    final totalVol = _session.computeTotalVolume();
    final completedSets = _session.sets.where((s) => s.isCompleted).length;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surfaceElevated,
        shape: const RoundedRectangleBorder(borderRadius: AppRadii.borderMd),
        title: const Text(
          'Finish Workout?',
          style: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Elapsed Time: ${_formatElapsed(_elapsedSeconds)}',
                style: const TextStyle(color: AppColors.textSecondary)),
            const SizedBox(height: AppSpacing.xs),
            Text('Completed Sets: $completedSets',
                style: const TextStyle(color: AppColors.textSecondary)),
            const SizedBox(height: AppSpacing.xs),
            Text('Total Volume: ${totalVol.toStringAsFixed(1)} kg',
                style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)),
            const SizedBox(height: AppSpacing.md),
            const Text(
              'Statutory estimate based on standard MET values. Non-prescriptive.',
              style: TextStyle(color: AppColors.textSecondary, fontSize: 10),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Resume', style: TextStyle(color: AppColors.textSecondary)),
          ),
          ElevatedButton(
            key: const Key('finish_workout_confirm_btn'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: AppColors.background,
            ),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Finish & Save', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await ref.read(workoutRepositoryProvider).completeSession(
            _session.id,
            endedAt: DateTime.now(),
          );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Workout saved and synced to your history!'),
            backgroundColor: AppColors.success,
          ),
        );
        Navigator.maybePop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final totalVolume = _session.computeTotalVolume();
    final completedSetsCount = _session.sets.where((s) => s.isCompleted).length;

    // Group sets by exercise
    final Map<String, List<WorkoutSet>> exerciseGroups = {};
    for (final s in _session.sets) {
      exerciseGroups.putIfAbsent(s.exerciseId, () => []).add(s);
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _session.title,
              style: const TextStyle(color: AppColors.textPrimary, fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Text(
              _formatElapsed(_elapsedSeconds),
              key: const Key('active_workout_elapsed_time'),
              style: const TextStyle(color: AppColors.primary, fontSize: 12, fontWeight: FontWeight.w600),
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: AppSpacing.sm),
            child: ElevatedButton(
              key: const Key('finish_workout_btn'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.background,
                visualDensity: VisualDensity.compact,
                shape: const RoundedRectangleBorder(borderRadius: AppRadii.borderFull),
              ),
              onPressed: _finishWorkout,
              child: const Text('Finish', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
      bottomNavigationBar: _showRestTimer
          ? SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.sm),
                child: RestTimerWidget(
                  initialDurationSeconds: _restDuration,
                  onDismissed: () => setState(() => _showRestTimer = false),
                  onFinished: () {
                    // Optional cue
                  },
                ),
              ),
            )
          : null,
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.md),
        children: [
          // Metrics summary bar
          Row(
            children: [
              Expanded(
                child: BentoCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Total Volume', style: TextStyle(color: AppColors.textSecondary, fontSize: 11)),
                      const SizedBox(height: 4),
                      Text(
                        '${totalVolume.toStringAsFixed(0)} kg',
                        key: const Key('active_workout_volume_text'),
                        style: const TextStyle(color: AppColors.primary, fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: BentoCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Completed Sets', style: TextStyle(color: AppColors.textSecondary, fontSize: 11)),
                      const SizedBox(height: 4),
                      Text(
                        '$completedSetsCount / ${_session.sets.length}',
                        key: const Key('active_workout_sets_text'),
                        style: const TextStyle(color: AppColors.textPrimary, fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),

          // Exercise blocks
          ...exerciseGroups.entries.map((entry) {
            final sets = entry.value;
            final firstSet = sets.first;

            return Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.md),
              child: BentoCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          firstSet.exerciseName,
                          style: const TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.timer_outlined, color: AppColors.textSecondary, size: 20),
                        onPressed: () => setState(() => _showRestTimer = true),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.xs),

                  // Table header
                  const Row(
                    children: [
                      SizedBox(width: 32, child: Text('SET', style: TextStyle(color: AppColors.textSecondary, fontSize: 11, fontWeight: FontWeight.bold))),
                      SizedBox(width: AppSpacing.sm),
                      Expanded(flex: 3, child: Text('WEIGHT (KG)', style: TextStyle(color: AppColors.textSecondary, fontSize: 11, fontWeight: FontWeight.bold))),
                      SizedBox(width: AppSpacing.sm),
                      Expanded(flex: 3, child: Text('REPS', style: TextStyle(color: AppColors.textSecondary, fontSize: 11, fontWeight: FontWeight.bold))),
                      SizedBox(width: AppSpacing.sm),
                      SizedBox(width: 44, child: Center(child: Icon(Icons.check, size: 16, color: AppColors.textSecondary))),
                    ],
                  ),
                  const Divider(color: AppColors.glassBorder, height: AppSpacing.sm),

                  // Table rows
                  ...sets.map((s) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: Row(
                        children: [
                          SizedBox(
                            width: 32,
                            child: Text(
                              '${s.setNumber}',
                              style: TextStyle(
                                color: s.isCompleted ? AppColors.primary : AppColors.textSecondary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(width: AppSpacing.sm),
                          Expanded(
                            flex: 3,
                            child: Container(
                              height: 36,
                              decoration: BoxDecoration(
                                color: AppColors.surface,
                                borderRadius: AppRadii.borderSm,
                                border: Border.all(color: AppColors.glassBorder),
                              ),
                              child: Center(
                                child: Text(
                                  '${s.weightKg}',
                                  style: const TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: AppSpacing.sm),
                          Expanded(
                            flex: 3,
                            child: Container(
                              height: 36,
                              decoration: BoxDecoration(
                                color: AppColors.surface,
                                borderRadius: AppRadii.borderSm,
                                border: Border.all(color: AppColors.glassBorder),
                              ),
                              child: Center(
                                child: Text(
                                  '${s.reps}',
                                  style: const TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: AppSpacing.sm),
                          SizedBox(
                            width: 44,
                            child: Center(
                              child: IconButton(
                                key: Key('set_complete_btn_${s.id}'),
                                icon: Icon(
                                  s.isCompleted ? Icons.check_circle : Icons.radio_button_unchecked,
                                  color: s.isCompleted ? AppColors.primary : AppColors.textSecondary,
                                ),
                                onPressed: () => _toggleSetCompletion(s),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                  const SizedBox(height: AppSpacing.xs),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: TextButton.icon(
                      key: Key('add_set_btn_${entry.key}'),
                      icon: const Icon(Icons.add, size: 16, color: AppColors.primary),
                      label: const Text('Add Set', style: TextStyle(color: AppColors.primary, fontSize: 12)),
                      onPressed: () => _addSetForExercise(entry.key, firstSet.exerciseName),
                    ),
                  ),
                ],
              ),
            ),
          );
        }),

          const SizedBox(height: AppSpacing.sm),
          OutlinedButton.icon(
            key: const Key('add_exercise_main_btn'),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.primary,
              side: const BorderSide(color: AppColors.primary),
              padding: const EdgeInsets.all(AppSpacing.md),
              shape: const RoundedRectangleBorder(borderRadius: AppRadii.borderMd),
            ),
            icon: const Icon(Icons.fitness_center),
            label: const Text('Add Exercise', style: TextStyle(fontWeight: FontWeight.bold)),
            onPressed: _showAddExerciseModal,
          ),
          const SizedBox(height: 80),
        ],
      ),
    );
  }
}
