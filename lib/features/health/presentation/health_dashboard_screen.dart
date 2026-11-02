import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../shared/theme/app_colors.dart';
import '../../../shared/theme/app_radii.dart';
import '../../../shared/theme/app_spacing.dart';
import '../../../shared/theme/app_typography.dart';
import '../../../shared/widgets/action_button.dart';
import '../../../shared/widgets/app_scaffold.dart';
import '../../../shared/widgets/bento_card.dart';
import '../../../shared/widgets/metric_card.dart';
import '../../../shared/widgets/sync_status_badge.dart';
import '../../auth/presentation/auth_state_notifier.dart';
import '../data/drift_body_metrics_repository.dart';
import '../data/drift_health_repositories.dart';
import '../data/drift_vitals_repositories.dart';
import '../domain/body_metric.dart';
import '../domain/habit_entry.dart';
import '../domain/medication_entry.dart';
import '../domain/vital_record.dart';
import '../domain/weight_trend_calculator.dart';
import 'mood_selector_card.dart';
import 'water_quick_add_card.dart';
import 'weight_logger_sheet.dart';

class HealthDashboardScreen extends ConsumerStatefulWidget {
  final String? userId;

  const HealthDashboardScreen({super.key, this.userId});

  @override
  ConsumerState<HealthDashboardScreen> createState() => _HealthDashboardScreenState();
}

class _HealthDashboardScreenState extends ConsumerState<HealthDashboardScreen> {
  bool _isLoading = true;
  double? _latestWeight;
  double? _movingAverageWeight;
  int _todaySteps = 0;
  int? _sleepMinutes;
  VitalRecord? _latestVital;
  List<MedicationEntry> _todayMeds = [];
  List<HabitEntry> _habits = [];

  String get _effectiveUserId {
    if (widget.userId != null) return widget.userId!;
    final authState = ref.watch(authStateNotifierProvider);
    if (authState is AuthAuthenticated) {
      return authState.user.id;
    }
    return 'default_user';
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadDashboardData();
    });
  }

  Future<void> _loadDashboardData() async {
    final userId = _effectiveUserId;

    // Load body metrics
    final bodyMetricsRepo = ref.read(bodyMetricsRepositoryProvider);
    final weightHistoryResult = await bodyMetricsRepo.getHistory(
      userId: userId,
      metricType: BodyMetricType.weight,
    );
    weightHistoryResult.when(
      onSuccess: (history) {
        if (history.isNotEmpty) {
          _latestWeight = history.last.value;
          const calc = WeightTrendCalculator();
          final trend = calc.calculate(history);
          _movingAverageWeight = trend?.movingAverage7DayKg;
        }
      },
      onFailure: (_) {},
    );

    // Load steps
    final stepsRepo = ref.read(stepRepositoryProvider);
    final stepsResult = await stepsRepo.getForDate(userId, DateTime.now());
    stepsResult.when(
      onSuccess: (record) {
        _todaySteps = record?.stepCount ?? 0;
      },
      onFailure: (_) {},
    );

    // Load sleep
    final sleepRepo = ref.read(sleepRepositoryProvider);
    final sleepResult = await sleepRepo.getHistory(userId, limit: 1);
    sleepResult.when(
      onSuccess: (records) {
        if (records.isNotEmpty) {
          _sleepMinutes = records.first.durationMinutes;
        }
      },
      onFailure: (_) {},
    );

    // Load vitals
    final vitalsRepo = ref.read(vitalsRepositoryProvider);
    final vitalsResult = await vitalsRepo.getRecent(userId, limit: 1);
    vitalsResult.when(
      onSuccess: (vitals) {
        if (vitals.isNotEmpty) {
          _latestVital = vitals.first;
        }
      },
      onFailure: (_) {},
    );

    // Load medications
    final medRepo = ref.read(medicationRepositoryProvider);
    final medResult = await medRepo.getForDay(userId, DateTime.now());
    medResult.when(
      onSuccess: (meds) {
        _todayMeds = meds;
      },
      onFailure: (_) {},
    );

    // Load habits
    final habitsRepo = ref.read(habitsRepositoryProvider);
    final habitsResult = await habitsRepo.getAll(userId);
    habitsResult.when(
      onSuccess: (habits) {
        _habits = habits;
      },
      onFailure: (_) {},
    );

    if (mounted) {
      setState(() => _isLoading = false);
    }
  }

  void _openWeightLogger() {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => WeightLoggerSheet(
        userId: _effectiveUserId,
        initialWeightKg: _latestWeight,
        onSaved: () => _loadDashboardData(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final effectiveId = _effectiveUserId;

    return AppScaffold(
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: Text(
          'FitKarma',
          style: AppTypography.title.copyWith(
            color: AppColors.primary,
            fontWeight: FontWeight.w700,
          ),
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: AppSpacing.md),
            child: SyncStatusBadge(),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
          : RefreshIndicator(
              onRefresh: _loadDashboardData,
              color: AppColors.primary,
              backgroundColor: AppColors.surface,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.lg,
                  vertical: AppSpacing.md,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Greeting Header
                    _buildGreetingHeader(),
                    const SizedBox(height: AppSpacing.lg),

                    // Weight summary card
                    _buildWeightCard(),
                    const SizedBox(height: AppSpacing.md),

                    // Steps and Sleep Row
                    Row(
                      children: [
                        Expanded(
                          child: MetricCard(
                            title: 'Steps Today',
                            value: '$_todaySteps',
                            unit: 'steps',
                            icon: Icons.directions_walk_rounded,
                            accentColor: AppColors.primary,
                            subtitle: 'Goal: 10,000',
                          ),
                        ),
                        const SizedBox(width: AppSpacing.md),
                        Expanded(
                          child: MetricCard(
                            title: 'Sleep',
                            value: _sleepMinutes != null
                                ? '${_sleepMinutes! ~/ 60}h ${_sleepMinutes! % 60}m'
                                : '--',
                            unit: _sleepMinutes != null ? '' : 'hrs',
                            icon: Icons.bedtime_rounded,
                            accentColor: AppColors.techBlue,
                            subtitle: 'Goal: 8h',
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.md),

                    // Hydration Card
                    WaterQuickAddCard(userId: effectiveId),
                    const SizedBox(height: AppSpacing.md),

                    // Mood Selector Card
                    MoodSelectorCard(userId: effectiveId),
                    const SizedBox(height: AppSpacing.md),

                    // Vitals & Medication Bento Cards
                    _buildVitalsCard(),
                    const SizedBox(height: AppSpacing.md),
                    _buildMedicationCard(),
                    const SizedBox(height: AppSpacing.md),

                    // Habit Streaks
                    _buildHabitsCard(),
                    const SizedBox(height: AppSpacing.xl),

                    // Statutory Non-Medical Disclaimer
                    _buildDisclaimerCard(),
                    const SizedBox(height: AppSpacing.xl),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildGreetingHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Namaste',
              style: AppTypography.headline.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(width: AppSpacing.xs),
            const Text('🙏', style: TextStyle(fontSize: 22)),
          ],
        ),
        const SizedBox(height: AppSpacing.xs),
        const Text(
          'Your intelligent holistic health overview',
          style: AppTypography.bodySecondary,
        ),
      ],
    );
  }

  Widget _buildWeightCard() {
    final weightDisplay = _latestWeight != null ? _latestWeight!.toStringAsFixed(1) : '--';
    final avgDisplay =
        _movingAverageWeight != null ? '${_movingAverageWeight!.toStringAsFixed(1)} kg 7d avg' : 'No trend yet';

    return BentoCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Weight & Trend',
                style: AppTypography.caption.copyWith(
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Icon(Icons.monitor_weight_outlined, size: 18, color: AppColors.saffron),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                weightDisplay,
                style: AppTypography.metricLarge.copyWith(color: AppColors.saffron),
              ),
              const SizedBox(width: AppSpacing.xs),
              const Text('kg', style: AppTypography.bodySecondary),
              const Spacer(),
              ActionButton(
                label: 'Log Weight',
                onPressed: _openWeightLogger,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            avgDisplay,
            style: AppTypography.caption.copyWith(color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }

  Widget _buildVitalsCard() {
    final vital = _latestVital;
    return BentoCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Vitals & Biometrics',
                style: AppTypography.caption.copyWith(
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              if (vital != null && vital.isElevatedReading)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppColors.warning.withValues(alpha: 0.2),
                    borderRadius: AppRadii.borderSm,
                    border: Border.all(color: AppColors.warning, width: 1),
                  ),
                  child: Text(
                    'Elevated Reading',
                    style: AppTypography.caption.copyWith(
                      color: AppColors.warning,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          if (vital == null)
            const Text(
              'No recent vital observations recorded.',
              style: AppTypography.bodySecondary,
            )
          else if (vital.vitalType == VitalType.bloodPressure)
            Row(
              children: [
                Text(
                  '${vital.systolic}/${vital.diastolic}',
                  style: AppTypography.metricLarge.copyWith(color: AppColors.textPrimary),
                ),
                const SizedBox(width: AppSpacing.xs),
                const Text('mmHg BP', style: AppTypography.bodySecondary),
                if (vital.pulse != null) ...[
                  const SizedBox(width: AppSpacing.md),
                  Text('${vital.pulse} bpm', style: AppTypography.bodySecondary),
                ],
              ],
            )
          else
            Row(
              children: [
                Text(
                  '${vital.glucoseMgDl?.toStringAsFixed(0)}',
                  style: AppTypography.metricLarge.copyWith(color: AppColors.textPrimary),
                ),
                const SizedBox(width: AppSpacing.xs),
                Text('mg/dL (${vital.contextTag ?? 'random'})', style: AppTypography.bodySecondary),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildMedicationCard() {
    return BentoCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Today\'s Medication Schedule',
                style: AppTypography.caption.copyWith(
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Icon(Icons.medication_outlined, size: 18, color: AppColors.techBlue),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          if (_todayMeds.isEmpty)
            const Text(
              'No medications scheduled for today.',
              style: AppTypography.bodySecondary,
            )
          else
            ..._todayMeds.map(
              (m) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  children: [
                    Icon(
                      m.status == MedicationStatus.taken
                          ? Icons.check_circle_rounded
                          : Icons.radio_button_unchecked,
                      size: 16,
                      color: m.status == MedicationStatus.taken ? AppColors.success : AppColors.textSecondary,
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Text('${m.name} (${m.dosage})', style: AppTypography.body),
                    const Spacer(),
                    Text(m.timeOfDay.name, style: AppTypography.caption),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildHabitsCard() {
    return BentoCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Daily Habits & Rituals',
                style: AppTypography.caption.copyWith(
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Icon(Icons.local_fire_department_rounded, size: 18, color: AppColors.saffron),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          if (_habits.isEmpty)
            const Text(
              'No habits tracked yet. Start your daily ritual today!',
              style: AppTypography.bodySecondary,
            )
          else
            ..._habits.map(
              (h) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  children: [
                    Text('🔥 ${h.currentStreak}d streak', style: AppTypography.caption),
                    const SizedBox(width: AppSpacing.sm),
                    Text(h.title, style: AppTypography.body),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildDisclaimerCard() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppRadii.borderMd,
        border: Border.all(color: AppColors.glassBorder),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.info_outline_rounded, size: 18, color: AppColors.textSecondary),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              VitalRecord.nonMedicalDisclaimer,
              style: AppTypography.caption.copyWith(
                color: AppColors.textSecondary,
                height: 1.3,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
