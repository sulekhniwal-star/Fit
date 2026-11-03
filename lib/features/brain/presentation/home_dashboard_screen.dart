import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/database/app_database.dart';
import '../../../core/sync/outbox_queue.dart';
import '../../../shared/theme/app_colors.dart';
import '../../../shared/theme/app_radii.dart';
import '../../../shared/theme/app_spacing.dart';
import '../../../shared/theme/app_typography.dart';
import '../../../shared/widgets/app_scaffold.dart';
import '../../../shared/widgets/bento_card.dart';
import '../../../shared/widgets/sync_status_badge.dart';
import '../../auth/presentation/auth_state_notifier.dart';
import '../../health/data/drift_health_repositories.dart';
import '../../health/domain/water_log.dart';
import '../../health/presentation/weight_logger_sheet.dart';
import '../data/dip_repository.dart';
import '../domain/dip_models.dart';
import 'daily_readiness_card.dart';
import 'dip_action_feed.dart';
import 'quick_log_action_bar.dart';

class HomeDashboardScreen extends ConsumerStatefulWidget {
  final String? initialUserId;

  const HomeDashboardScreen({super.key, this.initialUserId});

  @override
  ConsumerState<HomeDashboardScreen> createState() => _HomeDashboardScreenState();
}

class _HomeDashboardScreenState extends ConsumerState<HomeDashboardScreen> {
  final Set<String> _dismissedActionIds = {};

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good Morning';
    if (hour < 17) return 'Good Afternoon';
    return 'Good Evening';
  }

  Future<void> _handleQuickWater(String userId) async {
    final db = ref.read(appDatabaseProvider);
    final outbox = OutboxQueue(db);
    final waterRepo = DriftWaterRepository(db, outbox);

    final now = DateTime.now();
    await waterRepo.saveLocal(
      WaterLog(
        id: 'water_${now.millisecondsSinceEpoch}',
        userId: userId,
        recordedAt: now,
        amountMl: 250,
      ),
    );

    // Invalidate DIP to trigger recalculation
    ref.invalidate(dailyIntelligencePackageProvider);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Added 250ml water'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  void _handleLogWeight(String userId) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => WeightLoggerSheet(
        userId: userId,
        onSaved: () {
          ref.invalidate(dailyIntelligencePackageProvider);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authStateNotifierProvider);
    final userId = widget.initialUserId ??
        (authState is AuthAuthenticated ? authState.user.id : 'user_default');
    final userName = authState is AuthAuthenticated
        ? (authState.user.phone ?? 'Friend')
        : 'Friend';

    final dipAsync = ref.watch(dailyIntelligencePackageProvider);

    return AppScaffold(
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.primary.withAlpha(30),
                borderRadius: BorderRadius.circular(AppRadii.sm),
              ),
              child: const Text(
                'FITKARMA',
                style: TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w900,
                  fontSize: 12,
                  letterSpacing: 1.5,
                ),
              ),
            ),
          ],
        ),
        actions: [
          const SyncStatusBadge(),
          const SizedBox(width: AppSpacing.xs),
          IconButton(
            key: const Key('home_settings_btn'),
            icon: const Icon(Icons.settings_outlined, color: AppColors.textSecondary),
            onPressed: () => context.push('/settings'),
          ),
          const SizedBox(width: AppSpacing.xs),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(dailyIntelligencePackageProvider);
        },
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.md),
          children: [
            // 1. Greeting & Date Pill
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Namaste, $userName 🙏',
                      style: AppTypography.headline.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      _getGreeting(),
                      style: AppTypography.bodySecondary,
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.sm,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceElevated,
                    borderRadius: BorderRadius.circular(AppRadii.full),
                    border: Border.all(color: AppColors.glassBorder),
                  ),
                  child: const Text(
                    'Today',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: AppSpacing.md),

            // 2. Main DIP State
            dipAsync.when(
              loading: () => const Center(
                child: Padding(
                  padding: EdgeInsets.all(AppSpacing.xl),
                  child: CircularProgressIndicator(color: AppColors.primary),
                ),
              ),
              error: (err, stack) => BentoCard(
                child: Column(
                  children: [
                    const Icon(Icons.error_outline, color: AppColors.error, size: 36),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      'Unable to assemble Daily Intelligence',
                      style: AppTypography.title.copyWith(color: AppColors.textPrimary),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      '$err',
                      style: AppTypography.bodySecondary,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    ElevatedButton(
                      onPressed: () => ref.invalidate(dailyIntelligencePackageProvider),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
              data: (dip) {
                final visibleActions = dip.topActions
                    .where((a) => !_dismissedActionIds.contains(a.id))
                    .toList();

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Daily Readiness Card
                    DailyReadinessCard(score: dip.readinessScore),

                    const SizedBox(height: AppSpacing.md),

                    // Contextual Micro-Action Feed (Max 3)
                    if (visibleActions.isNotEmpty) ...[
                      DipActionFeed(
                        actions: visibleActions,
                        onActionTap: (action) {
                          if (action.actionRoute != null && action.actionRoute!.isNotEmpty) {
                            if (action.actionRoute == '/dashboard') {
                              _handleQuickWater(userId);
                            } else {
                              context.push(action.actionRoute!);
                            }
                          }
                        },
                        onDismiss: (action) {
                          setState(() {
                            _dismissedActionIds.add(action.id);
                          });
                        },
                      ),
                      const SizedBox(height: AppSpacing.md),
                    ],

                    // Quick Log Action Bar
                    QuickLogActionBar(
                      onQuickWaterTap: () => _handleQuickWater(userId),
                      onLogMealTap: () => context.push('/nutrition'),
                      onWorkoutTap: () => context.push('/workouts'),
                      onLogWeightTap: () => _handleLogWeight(userId),
                    ),

                    const SizedBox(height: AppSpacing.md),

                    // Daily Metrics Summary Row
                    _buildSummaryMetricsGrid(context, dip.summaryMetrics),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryMetricsGrid(BuildContext context, DipSummaryMetrics metrics) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'DAILY VITALS & SUMMARY',
          style: AppTypography.caption.copyWith(
            letterSpacing: 1.2,
            fontWeight: FontWeight.bold,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        Row(
          children: [
            Expanded(
              child: _buildMetricTile(
                icon: Icons.directions_walk,
                color: AppColors.primary,
                title: 'Steps',
                value: '${metrics.todaySteps}',
                target: '${metrics.stepGoal}',
                onTap: () => context.push('/workouts'),
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: _buildMetricTile(
                icon: Icons.local_fire_department,
                color: AppColors.saffron,
                title: 'Calories',
                value: '${metrics.consumedCalories.round()}',
                target: '${metrics.targetCalories.round()} kcal',
                onTap: () => context.push('/nutrition'),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        Row(
          children: [
            Expanded(
              child: _buildMetricTile(
                icon: Icons.water_drop,
                color: AppColors.techBlue,
                title: 'Water',
                value: '${metrics.consumedWaterMl}ml',
                target: '${metrics.targetWaterMl}ml',
                onTap: () {},
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: _buildMetricTile(
                icon: Icons.bedtime,
                color: AppColors.primaryAccent,
                title: 'Sleep',
                value: metrics.sleepMinutes != null
                    ? '${(metrics.sleepMinutes! / 60.0).toStringAsFixed(1)}h'
                    : '--',
                target: '8.0h goal',
                onTap: () {},
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildMetricTile({
    required IconData icon,
    required Color color,
    required String title,
    required String value,
    required String target,
    VoidCallback? onTap,
  }) {
    return BentoCard(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: color),
              const SizedBox(width: 4),
              Text(
                title,
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            value,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            target,
            style: TextStyle(
              color: AppColors.textSecondary.withAlpha(150),
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }
}
