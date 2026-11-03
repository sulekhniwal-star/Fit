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
import '../../ai/presentation/ai_meal_text_logger_sheet.dart';
import '../../ai/presentation/photo_food_logger_screen.dart';
import '../../auth/presentation/auth_state_notifier.dart';
import '../../cultural/presentation/fasting_tracker_card.dart';
import '../../cultural/presentation/festival_banner_card.dart';
import '../data/drift_meal_log_repository.dart';
import '../domain/dynamic_tdee_calculator.dart';
import '../domain/food_log_entry.dart';
import '../domain/portion_unit.dart';
import 'recipe_splitter_sheet.dart';

class NutritionDashboardScreen extends ConsumerStatefulWidget {
  final String? userId;

  const NutritionDashboardScreen({super.key, this.userId});

  @override
  ConsumerState<NutritionDashboardScreen> createState() => _NutritionDashboardScreenState();
}

class _NutritionDashboardScreenState extends ConsumerState<NutritionDashboardScreen> {
  bool _isLoading = true;
  List<FoodLogEntry> _todayLogs = [];
  NutritionValues _dailyTotals = const NutritionValues(
    calories: 0.0,
    proteinGrams: 0.0,
    carbsGrams: 0.0,
    fatGrams: 0.0,
    fiberGrams: 0.0,
  );
  late DynamicTdeeResult _tdeeResult;

  static const double _targetCalories = 2000.0;
  static const double _targetProtein = 100.0;
  static const double _targetCarbs = 250.0;
  static const double _targetFat = 65.0;

  String get _effectiveUserId {
    if (widget.userId != null) return widget.userId!;
    final authState = ref.read(authStateNotifierProvider);
    if (authState is AuthAuthenticated) {
      return authState.user.id;
    }
    return 'default_user';
  }

  @override
  void initState() {
    super.initState();
    const calc = DynamicTdeeCalculator();
    _tdeeResult = calc.calculate(
      weightKg: 70.0,
      heightCm: 175.0,
      age: 28,
      isMale: true,
      dailySteps: 7500,
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadNutritionData();
    });
  }

  Future<void> _loadNutritionData() async {
    final userId = _effectiveUserId;
    final repo = ref.read(mealLogRepositoryProvider);
    final today = DateTime.now();

    final logsResult = await repo.getForDay(userId, today);
    logsResult.when(
      onSuccess: (logs) => _todayLogs = logs,
      onFailure: (_) {},
    );

    final totalsResult = await repo.getDailyMacroTotals(userId, today);
    totalsResult.when(
      onSuccess: (totals) => _dailyTotals = totals,
      onFailure: (_) {},
    );

    if (mounted) {
      setState(() => _isLoading = false);
    }
  }

  void _openRecipeSplitter() {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => RecipeSplitterSheet(
        userId: _effectiveUserId,
        onLogged: () => _loadNutritionData(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: Text(
          'FitKarma Nutrition',
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
              onRefresh: _loadNutritionData,
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
                    // Calorie and Macro Goal Card
                    _buildMacroGoalCard(),
                    const SizedBox(height: AppSpacing.md),

                    // Dynamic TDEE summary
                    _buildDynamicTdeeCard(),
                    const SizedBox(height: AppSpacing.md),

                    // AI Food Recognition
                    _buildAiLoggingCard(),
                    const SizedBox(height: AppSpacing.sm),

                    // WhatsApp AI Logging Card
                    _buildWhatsAppAiBanner(),
                    const SizedBox(height: AppSpacing.sm),

                    // Cultural Festival Celebration
                    const FestivalBannerCard(),
                    const SizedBox(height: AppSpacing.sm),

                    // Cultural Fasting Tracker
                    const FastingTrackerCard(),
                    const SizedBox(height: AppSpacing.md),

                    // Quick Action: Family Recipe Splitter
                    _buildQuickActionRow(),
                    const SizedBox(height: AppSpacing.lg),

                    // Meal Slots
                    ...MealSlot.values.map(_buildMealSlotCard),
                    const SizedBox(height: AppSpacing.xl),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildMacroGoalCard() {
    final caloriePct = (_dailyTotals.calories / _targetCalories).clamp(0.0, 1.0);
    final proteinPct = (_dailyTotals.proteinGrams / _targetProtein).clamp(0.0, 1.0);
    final carbsPct = (_dailyTotals.carbsGrams / _targetCarbs).clamp(0.0, 1.0);
    final fatPct = (_dailyTotals.fatGrams / _targetFat).clamp(0.0, 1.0);

    return BentoCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Daily Energy & Macros',
                style: AppTypography.caption.copyWith(
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Icon(Icons.bolt_rounded, size: 18, color: AppColors.primary),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                _dailyTotals.calories.toStringAsFixed(0),
                style: AppTypography.metricLarge.copyWith(color: AppColors.primary),
              ),
              const SizedBox(width: AppSpacing.xs),
              Text(
                '/ ${_targetCalories.toStringAsFixed(0)} kcal',
                style: AppTypography.bodySecondary,
              ),
              const Spacer(),
              Text(
                '${(_targetCalories - _dailyTotals.calories).clamp(0, 9999).toStringAsFixed(0)} left',
                style: AppTypography.caption.copyWith(color: AppColors.textSecondary),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          ClipRRect(
            borderRadius: AppRadii.borderFull,
            child: LinearProgressIndicator(
              value: caloriePct,
              minHeight: 8,
              backgroundColor: AppColors.surfaceElevated,
              valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
            ),
          ),
          const SizedBox(height: AppSpacing.md),

          // Macro Breakdown bars
          Row(
            children: [
              Expanded(
                child: _buildMacroBar(
                  label: 'Protein',
                  current: _dailyTotals.proteinGrams,
                  target: _targetProtein,
                  color: AppColors.saffron,
                  pct: proteinPct,
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: _buildMacroBar(
                  label: 'Carbs',
                  current: _dailyTotals.carbsGrams,
                  target: _targetCarbs,
                  color: AppColors.techBlue,
                  pct: carbsPct,
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: _buildMacroBar(
                  label: 'Fat',
                  current: _dailyTotals.fatGrams,
                  target: _targetFat,
                  color: AppColors.warning,
                  pct: fatPct,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMacroBar({
    required String label,
    required double current,
    required double target,
    required Color color,
    required double pct,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: AppTypography.caption.copyWith(color: AppColors.textSecondary)),
            Text('${current.toStringAsFixed(0)}g', style: AppTypography.caption.copyWith(color: color)),
          ],
        ),
        const SizedBox(height: 4),
        ClipRRect(
          borderRadius: AppRadii.borderFull,
          child: LinearProgressIndicator(
            value: pct,
            minHeight: 4,
            backgroundColor: AppColors.surfaceElevated,
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),
        ),
      ],
    );
  }

  Widget _buildDynamicTdeeCard() {
    return Row(
      children: [
        Expanded(
          child: MetricCard(
            title: 'Dynamic TDEE',
            value: _tdeeResult.estimatedTdee.toStringAsFixed(0),
            unit: 'kcal',
            icon: Icons.local_fire_department_rounded,
            accentColor: AppColors.saffron,
            subtitle: _tdeeResult.confidenceLevel == 'high' ? 'Calibrated 7d' : 'Estimated',
          ),
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: MetricCard(
            title: 'Energy Balance',
            value: (_tdeeResult.estimatedTdee - _dailyTotals.calories).toStringAsFixed(0),
            unit: 'kcal deficit',
            icon: Icons.balance_rounded,
            accentColor: AppColors.techBlue,
            subtitle: 'Target: Maintenance',
          ),
        ),
      ],
    );
  }

  Widget _buildAiLoggingCard() {
    return BentoCard(
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(AppSpacing.xs),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.auto_awesome_rounded, color: AppColors.primary, size: 20),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'AI Meal Logging',
                  style: AppTypography.caption.copyWith(
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                Text(
                  'Describe in Hinglish or snap a photo of your plate.',
                  style: AppTypography.caption.copyWith(fontSize: 11),
                ),
              ],
            ),
          ),
          OutlinedButton(
            onPressed: () => showModalBottomSheet<void>(
              context: context,
              isScrollControlled: true,
              backgroundColor: Colors.transparent,
              builder: (ctx) => AiMealTextLoggerSheet(
                onMealLogged: _loadNutritionData,
              ),
            ),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.textPrimary,
              side: const BorderSide(color: AppColors.glassBorder),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              minimumSize: const Size(0, 36),
            ),
            child: const Text('Text AI', style: TextStyle(fontSize: 12)),
          ),
          const SizedBox(width: AppSpacing.xs),
          ActionButton(
            label: 'Photo AI',
            onPressed: () => Navigator.of(context).push<void>(
              MaterialPageRoute<void>(
                builder: (_) => const PhotoFoodLoggerScreen(),
              ),
            ).then((_) => _loadNutritionData()),
          ),
        ],
      ),
    );
  }

  Widget _buildWhatsAppAiBanner() {
    return BentoCard(
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(AppSpacing.xs),
            decoration: BoxDecoration(
              color: const Color(0xFF25D366).withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.chat_bubble_outline_rounded, color: Color(0xFF25D366), size: 20),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      'WhatsApp AI Logger',
                      style: AppTypography.caption.copyWith(
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: const Color(0xFF25D366).withValues(alpha: 0.2),
                        borderRadius: AppRadii.borderFull,
                      ),
                      child: Text(
                        'Active',
                        style: AppTypography.caption.copyWith(
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF25D366),
                        ),
                      ),
                    ),
                  ],
                ),
                Text(
                  'Send voice notes or text in Hindi/English to log in 5s.',
                  style: AppTypography.caption.copyWith(fontSize: 11),
                ),
              ],
            ),
          ),
          OutlinedButton(
            onPressed: _showWhatsAppInfoDialog,
            style: OutlinedButton.styleFrom(
              foregroundColor: const Color(0xFF25D366),
              side: const BorderSide(color: Color(0xFF25D366)),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              minimumSize: const Size(0, 36),
            ),
            child: const Text('Info', style: TextStyle(fontSize: 12)),
          ),
        ],
      ),
    );
  }

  void _showWhatsAppInfoDialog() {
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: Row(
          children: [
            const Icon(Icons.chat_bubble_rounded, color: Color(0xFF25D366)),
            const SizedBox(width: AppSpacing.sm),
            Text(
              'WhatsApp AI Logging',
              style: AppTypography.headline.copyWith(fontSize: 18),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Zero-friction nutrition logging directly from WhatsApp:',
              style: AppTypography.body,
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              '• Send voice notes in Hindi, English, or Hinglish\n'
              '• Type raw meal descriptions (e.g., "2 roti, 1 katori dal")\n'
              '• Receive instant interactive confirmation cards\n'
              '• Tap "Confirm & Log" to sync into your daily macros\n'
              '• DPDP Act 2023 compliant: audio is zeroed in-memory',
              style: AppTypography.caption.copyWith(fontSize: 12, height: 1.5),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Got it', style: TextStyle(color: AppColors.primary)),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionRow() {
    return BentoCard(
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(AppSpacing.xs),
            decoration: BoxDecoration(
              color: AppColors.saffron.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.pie_chart_outline_rounded, color: AppColors.saffron, size: 20),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Family Recipe Splitter',
                  style: AppTypography.caption.copyWith(
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                Text(
                  'Cook in large pots? Calculate your % portion share.',
                  style: AppTypography.caption.copyWith(fontSize: 11),
                ),
              ],
            ),
          ),
          ActionButton(
            label: 'Split Pot',
            onPressed: _openRecipeSplitter,
          ),
        ],
      ),
    );
  }

  Widget _buildMealSlotCard(MealSlot slot) {
    final slotEntries = _todayLogs.where((e) => e.mealSlot == slot).toList();
    final slotCalories = slotEntries.fold<double>(0.0, (sum, e) => sum + e.calories);

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: BentoCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  slot.label,
                  style: AppTypography.title.copyWith(
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                Text(
                  '${slotCalories.toStringAsFixed(0)} kcal',
                  style: AppTypography.caption.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            if (slotEntries.isEmpty)
              const Text(
                'No food items logged for this slot.',
                style: AppTypography.bodySecondary,
              )
            else
              ...slotEntries.map((e) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      children: [
                        const Icon(Icons.restaurant_rounded, size: 14, color: AppColors.textSecondary),
                        const SizedBox(width: AppSpacing.sm),
                        Expanded(
                          child: Text(
                            e.foodName,
                            style: AppTypography.body,
                          ),
                        ),
                        Text(
                          '${e.calories.toStringAsFixed(0)} kcal',
                          style: AppTypography.caption.copyWith(fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  )),
          ],
        ),
      ),
    );
  }
}
