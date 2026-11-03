import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../shared/theme/app_colors.dart';
import '../../../shared/theme/app_radii.dart';
import '../../../shared/theme/app_spacing.dart';
import '../../../shared/theme/app_typography.dart';
import '../../../shared/widgets/app_scaffold.dart';
import '../../../shared/widgets/bento_card.dart';
import '../../../shared/widgets/sync_status_badge.dart';
import '../../auth/presentation/auth_state_notifier.dart';
import '../data/drift_workout_repository.dart';
import '../domain/exercise.dart';
import '../domain/recovery_readiness_calculator.dart';
import '../domain/volume_progression_calculator.dart';
import '../domain/workout_session.dart';
import '../domain/workout_set.dart';
import 'active_workout_screen.dart';

class WorkoutDashboardScreen extends ConsumerStatefulWidget {
  final String? userId;

  const WorkoutDashboardScreen({super.key, this.userId});

  @override
  ConsumerState<WorkoutDashboardScreen> createState() => _WorkoutDashboardScreenState();
}

class _WorkoutDashboardScreenState extends ConsumerState<WorkoutDashboardScreen> {
  bool _isLoading = true;
  List<WorkoutSession> _sessions = [];
  double _weeklyVolume = 0.0;
  double _previousWeeklyVolume = 0.0;
  late ReadinessScore _readiness;

  final VolumeProgressionCalculator _volumeCalculator = const VolumeProgressionCalculator();
  final RecoveryReadinessCalculator _readinessCalculator = const RecoveryReadinessCalculator();

  String get _effectiveUserId {
    if (widget.userId != null) return widget.userId!;
    final authState = ref.watch(authStateNotifierProvider);
    if (authState is AuthAuthenticated) {
      return authState.user.id;
    }
    return 'user_default';
  }

  @override
  void initState() {
    super.initState();
    _loadDashboardData();
  }

  Future<void> _loadDashboardData() async {
    setState(() => _isLoading = true);

    final repo = ref.read(workoutRepositoryProvider);
    final res = await repo.getRecentSessions(_effectiveUserId, limit: 30);
    final sessions = res.dataOrNull ?? [];

    final now = DateTime.now();
    final todayMidnight = DateTime(now.year, now.month, now.day);
    final startOfCurrentWeek = todayMidnight.subtract(Duration(days: now.weekday - 1));
    final startOfPreviousWeek = startOfCurrentWeek.subtract(const Duration(days: 7));

    final currentVol = _volumeCalculator.calculateWeeklyTotalVolume(sessions, startOfCurrentWeek);
    final prevVol = _volumeCalculator.calculateWeeklyTotalVolume(sessions, startOfPreviousWeek);

    // Compute recovery readiness (using baseline 420 mins sleep, acute volume, chronic volume)
    final acuteWorkload = currentVol;
    final chronicWorkload = prevVol > 0.0 ? prevVol : currentVol;
    final readiness = _readinessCalculator.calculateReadiness(
      sleepMinutes: 450,
      acuteWorkloadKg: acuteWorkload,
      chronicWorkloadKg: chronicWorkload,
    );

    if (mounted) {
      setState(() {
        _sessions = sessions;
        _weeklyVolume = currentVol;
        _previousWeeklyVolume = prevVol;
        _readiness = readiness;
        _isLoading = false;
      });
    }
  }

  void _startRoutine({
    required String title,
    required WorkoutType type,
    List<WorkoutSet>? defaultSets,
  }) {
    final now = DateTime.now();
    final session = WorkoutSession(
      id: 'ws_${now.millisecondsSinceEpoch}',
      userId: _effectiveUserId,
      title: title,
      workoutType: type,
      startedAt: now,
      sets: defaultSets ?? const [],
      status: WorkoutSessionStatus.inProgress,
    );

    Navigator.of(context)
        .push(
      MaterialPageRoute<void>(
        builder: (_) => ActiveWorkoutScreen(initialSession: session),
        settings: const RouteSettings(name: '/active-workout'),
      ),
    )
        .then((_) {
      _loadDashboardData();
    });
  }

  @override
  Widget build(BuildContext context) {
    final volumeTrend = _volumeCalculator.calculateVolumeTrend(
      currentWeekVolume: _weeklyVolume,
      previousWeekVolume: _previousWeeklyVolume,
    );

    return AppScaffold(
      appBar: AppBar(
        title: const Text('Fitness & Workout', style: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold)),
        backgroundColor: AppColors.surface,
        elevation: 0,
        actions: const [
          SyncStatusBadge(),
          SizedBox(width: AppSpacing.sm),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        key: const Key('start_workout_fab'),
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.background,
        icon: const Icon(Icons.add),
        label: const Text('Start Workout', style: TextStyle(fontWeight: FontWeight.bold)),
        onPressed: () => _startRoutine(
          title: 'Custom Strength Session',
          type: WorkoutType.strength,
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
          : RefreshIndicator(
              onRefresh: _loadDashboardData,
              color: AppColors.primary,
              child: ListView(
                padding: const EdgeInsets.all(AppSpacing.md),
                children: [
                  // 1. Recovery Readiness Bento Card
                  BentoCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.favorite_outline, color: AppColors.primary, size: 20),
                                const SizedBox(width: AppSpacing.xs),
                                Text(
                                  'Recovery Readiness',
                                  style: AppTypography.title.copyWith(
                                    color: AppColors.textPrimary,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: 4),
                              decoration: BoxDecoration(
                                color: _getTierColor(_readiness.tier).withValues(alpha: 0.15),
                                borderRadius: AppRadii.borderFull,
                                border: Border.all(color: _getTierColor(_readiness.tier)),
                              ),
                              child: Text(
                                _readiness.tier.displayName,
                                style: TextStyle(
                                  color: _getTierColor(_readiness.tier),
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.md),
                        Row(
                          children: [
                            Text(
                              '${_readiness.score}',
                              key: const Key('readiness_score_text'),
                              style: const TextStyle(
                                color: AppColors.primary,
                                fontSize: 36,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const Text(
                              ' / 100',
                              style: TextStyle(color: AppColors.textSecondary, fontSize: 16),
                            ),
                            const Spacer(),
                            Expanded(
                              flex: 2,
                              child: Text(
                                _readiness.guidance,
                                style: const TextStyle(
                                  color: AppColors.textSecondary,
                                  fontSize: 12,
                                  height: 1.3,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        Text(
                          _readiness.disclaimer,
                          style: const TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 10,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: AppSpacing.md),

                  // 2. Weekly Volume Progression Bento Card
                  BentoCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.bar_chart, color: AppColors.primary, size: 20),
                                const SizedBox(width: AppSpacing.xs),
                                Text(
                                  'Weekly Volume Progress',
                                  style: AppTypography.title.copyWith(
                                    color: AppColors.textPrimary,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: 4),
                              decoration: BoxDecoration(
                                color: volumeTrend >= 0
                                    ? AppColors.success.withValues(alpha: 0.15)
                                    : AppColors.warning.withValues(alpha: 0.15),
                                borderRadius: AppRadii.borderFull,
                              ),
                              child: Text(
                                '${volumeTrend >= 0 ? '+' : ''}$volumeTrend% vs last week',
                                style: TextStyle(
                                  color: volumeTrend >= 0 ? AppColors.success : AppColors.warning,
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.md),
                        Text(
                          '${_weeklyVolume.toStringAsFixed(0)} kg',
                          key: const Key('weekly_volume_tonnage_text'),
                          style: const TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.xs),
                        const Text(
                          'Total accumulated working volume across completed sessions.',
                          style: TextStyle(color: AppColors.textSecondary, fontSize: 12),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: AppSpacing.md),

                  // 3. Quick Start Routines Bento Card
                  BentoCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Quick Start Routines',
                          style: AppTypography.title.copyWith(
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        Wrap(
                          spacing: AppSpacing.sm,
                          runSpacing: AppSpacing.sm,
                          children: [
                            ActionChip(
                              key: const Key('quick_start_empty'),
                              avatar: const Icon(Icons.add, size: 16, color: AppColors.primary),
                              label: const Text('Blank Workout'),
                              backgroundColor: AppColors.surface,
                              labelStyle: const TextStyle(color: AppColors.textPrimary, fontSize: 12),
                              onPressed: () => _startRoutine(
                                title: 'Blank Workout',
                                type: WorkoutType.strength,
                              ),
                            ),
                            ActionChip(
                              key: const Key('quick_start_surya'),
                              avatar: const Icon(Icons.self_improvement, size: 16, color: AppColors.saffron),
                              label: const Text('Surya Namaskar 12-Flow'),
                              backgroundColor: AppColors.surface,
                              labelStyle: const TextStyle(color: AppColors.textPrimary, fontSize: 12),
                              onPressed: () => _startRoutine(
                                title: 'Surya Namaskar Flow (सूर्य नमस्कार)',
                                type: WorkoutType.yoga,
                                defaultSets: const [
                                  WorkoutSet(
                                    id: 'set_surya_1',
                                    sessionId: '',
                                    exerciseId: 'ex_surya_namaskar_01',
                                    exerciseName: 'Surya Namaskar',
                                    setNumber: 1,
                                    weightKg: 0.0,
                                    reps: 12,
                                  ),
                                ],
                              ),
                            ),
                            ActionChip(
                              key: const Key('quick_start_akhada'),
                              avatar: const Icon(Icons.fitness_center, size: 16, color: AppColors.techBlue),
                              label: const Text('Akhada Dand & Baithak'),
                              backgroundColor: AppColors.surface,
                              labelStyle: const TextStyle(color: AppColors.textPrimary, fontSize: 12),
                              onPressed: () => _startRoutine(
                                title: 'Akhada Bodyweight Conditioning',
                                type: WorkoutType.strength,
                                defaultSets: const [
                                  WorkoutSet(
                                    id: 'set_dand_1',
                                    sessionId: '',
                                    exerciseId: 'ex_dand_01',
                                    exerciseName: 'Dand (Hindu Push-Up)',
                                    setNumber: 1,
                                    weightKg: 0.0,
                                    reps: 20,
                                  ),
                                  WorkoutSet(
                                    id: 'set_baithak_1',
                                    sessionId: '',
                                    exerciseId: 'ex_baithak_01',
                                    exerciseName: 'Baithak (Hindu Squat)',
                                    setNumber: 1,
                                    weightKg: 0.0,
                                    reps: 25,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: AppSpacing.md),

                  // 4. Recent Workouts History
                  Text(
                    'Recent Workouts',
                    style: AppTypography.title.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  if (_sessions.isEmpty)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: AppSpacing.lg),
                      child: Center(
                        child: Text(
                          'No workout sessions recorded yet.\nTap Start Workout to begin!',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
                        ),
                      ),
                    )
                  else
                    ..._sessions.take(10).map((session) {
                      final durationMins = (session.durationSeconds / 60).round();
                      return Container(
                        margin: const EdgeInsets.only(bottom: AppSpacing.sm),
                        padding: const EdgeInsets.all(AppSpacing.md),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceElevated,
                          borderRadius: AppRadii.borderMd,
                          border: Border.all(color: AppColors.glassBorder),
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(AppSpacing.sm),
                              decoration: const BoxDecoration(
                                color: AppColors.surface,
                                borderRadius: AppRadii.borderSm,
                              ),
                              child: Icon(
                                _getWorkoutIcon(session.workoutType),
                                color: AppColors.primary,
                                size: 20,
                              ),
                            ),
                            const SizedBox(width: AppSpacing.md),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    session.title,
                                    style: const TextStyle(
                                      color: AppColors.textPrimary,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    '${session.workoutType.displayName} • $durationMins min',
                                    style: const TextStyle(color: AppColors.textSecondary, fontSize: 12),
                                  ),
                                ],
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  '${session.totalVolumeKg.toStringAsFixed(0)} kg',
                                  style: const TextStyle(
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  session.status.displayName,
                                  style: TextStyle(
                                    color: session.status == WorkoutSessionStatus.completed
                                        ? AppColors.success
                                        : AppColors.warning,
                                    fontSize: 11,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    }),
                  const SizedBox(height: 80),
                ],
              ),
            ),
    );
  }

  Color _getTierColor(ReadinessTier tier) {
    switch (tier) {
      case ReadinessTier.high:
        return AppColors.primary;
      case ReadinessTier.moderate:
        return AppColors.warning;
      case ReadinessTier.recovery:
        return AppColors.primaryAccent;
    }
  }

  IconData _getWorkoutIcon(WorkoutType type) {
    switch (type) {
      case WorkoutType.strength:
        return Icons.fitness_center;
      case WorkoutType.yoga:
        return Icons.self_improvement;
      case WorkoutType.cardio:
        return Icons.directions_run;
      case WorkoutType.hiit:
        return Icons.flash_on;
      case WorkoutType.mobilityFlexibility:
        return Icons.accessibility_new;
      case WorkoutType.custom:
        return Icons.sports_gymnastics;
    }
  }
}
