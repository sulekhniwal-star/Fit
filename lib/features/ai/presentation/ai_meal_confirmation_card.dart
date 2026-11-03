import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../shared/theme/app_colors.dart';
import '../../../shared/theme/app_radii.dart';
import '../../../shared/theme/app_spacing.dart';
import '../../../shared/theme/app_typography.dart';
import '../../../shared/widgets/action_button.dart';
import '../../../shared/widgets/bento_card.dart';
import '../../nutrition/data/drift_meal_log_repository.dart';
import '../../nutrition/domain/food_log_entry.dart';
import '../domain/ai_models.dart';

class AiMealConfirmationCard extends ConsumerStatefulWidget {
  final AiMealAnalysisResult initialResult;
  final String userId;
  final MealSlot defaultMealSlot;
  final VoidCallback? onManualFallback;
  final VoidCallback? onMealLogged;

  const AiMealConfirmationCard({
    super.key,
    required this.initialResult,
    this.userId = 'user_default',
    this.defaultMealSlot = MealSlot.lunch,
    this.onManualFallback,
    this.onMealLogged,
  });

  @override
  ConsumerState<AiMealConfirmationCard> createState() => _AiMealConfirmationCardState();
}

class _AiMealConfirmationCardState extends ConsumerState<AiMealConfirmationCard> {
  late List<AiCandidateItem> _items;
  late MealSlot _selectedSlot;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _items = List.from(widget.initialResult.candidateItems);
    _selectedSlot = widget.defaultMealSlot;
  }

  double get _totalCalories => _items.fold(0.0, (s, i) => s + (i.estimatedCalories * i.quantity));
  double get _totalProtein => _items.fold(0.0, (s, i) => s + (i.proteinGrams * i.quantity));
  double get _totalCarbs => _items.fold(0.0, (s, i) => s + (i.carbsGrams * i.quantity));
  double get _totalFat => _items.fold(0.0, (s, i) => s + (i.fatGrams * i.quantity));

  void _updateQuantity(int index, double delta) {
    setState(() {
      final current = _items[index];
      final newQty = (current.quantity + delta).clamp(0.25, 20.0);
      _items[index] = current.copyWith(quantity: double.parse(newQty.toStringAsFixed(2)));
    });
  }

  void _removeItem(int index) {
    setState(() {
      _items.removeAt(index);
    });
  }

  Future<void> _confirmAndSave() async {
    if (_items.isEmpty) return;

    setState(() => _isSaving = true);
    final repo = ref.read(mealLogRepositoryProvider);
    final now = DateTime.now();

    for (var i = 0; i < _items.length; i++) {
      final item = _items[i];
      final entry = FoodLogEntry(
        id: 'ai_log_${now.millisecondsSinceEpoch}_$i',
        userId: widget.userId,
        loggedAt: now,
        mealSlot: _selectedSlot,
        foodName: item.foodName,
        portionQuantity: item.quantity,
        portionUnit: item.unit,
        cookingState: item.cookingState,
        tadkaLevel: item.tadkaLevel,
        calories: double.parse((item.estimatedCalories * item.quantity).toStringAsFixed(1)),
        proteinGrams: double.parse((item.proteinGrams * item.quantity).toStringAsFixed(1)),
        carbsGrams: double.parse((item.carbsGrams * item.quantity).toStringAsFixed(1)),
        fatGrams: double.parse((item.fatGrams * item.quantity).toStringAsFixed(1)),
        fiberGrams: 2.0 * item.quantity,
      );

      await repo.saveLocal(entry);
    }

    if (mounted) {
      setState(() => _isSaving = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${_items.length} dishes logged to ${_selectedSlot.label}!'),
          backgroundColor: AppColors.success,
        ),
      );
      widget.onMealLogged?.call();
    }
  }

  @override
  Widget build(BuildContext context) {
    final conf = widget.initialResult.overallConfidence;
    final confColor = conf == AiConfidenceLevel.high
        ? AppColors.success
        : conf == AiConfidenceLevel.medium
            ? AppColors.saffron
            : AppColors.error;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header & Confidence Indicator
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  'AI Meal Estimation',
                  style: AppTypography.headline.copyWith(color: AppColors.textPrimary),
                ),
              ),
              const SizedBox(width: AppSpacing.xs),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: 4),
                decoration: BoxDecoration(
                  color: confColor.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(AppRadii.full),
                  border: Border.all(color: confColor.withValues(alpha: 0.4)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.auto_awesome_rounded, size: 14, color: confColor),
                    const SizedBox(width: 4),
                    Text(
                      conf.label,
                      style: AppTypography.caption.copyWith(
                        color: confColor,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            widget.initialResult.summary,
            style: AppTypography.bodySecondary,
          ),

          // Uncertainty warnings (if any)
          if (widget.initialResult.uncertaintyReasons.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.sm),
            Container(
              padding: const EdgeInsets.all(AppSpacing.sm),
              decoration: BoxDecoration(
                color: AppColors.saffron.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(AppRadii.sm),
                border: Border.all(color: AppColors.saffron.withValues(alpha: 0.3)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.info_outline_rounded, size: 18, color: AppColors.saffron),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Text(
                      widget.initialResult.uncertaintyReasons.join('; '),
                      style: AppTypography.caption.copyWith(color: AppColors.saffron),
                    ),
                  ),
                ],
              ),
            ),
          ],

          const SizedBox(height: AppSpacing.md),

          // Meal Slot Selector Chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: MealSlot.values.map((slot) {
                final isSelected = _selectedSlot == slot;
                return Padding(
                  padding: const EdgeInsets.only(right: AppSpacing.xs),
                  child: FilterChip(
                    label: Text(slot.label),
                    selected: isSelected,
                    onSelected: (val) {
                      if (val) setState(() => _selectedSlot = slot);
                    },
                    selectedColor: AppColors.primary.withValues(alpha: 0.25),
                    checkmarkColor: AppColors.primary,
                    labelStyle: TextStyle(
                      color: isSelected ? AppColors.primary : AppColors.textSecondary,
                      fontWeight: isSelected ? FontWeight.w700 : FontWeight.w400,
                      fontSize: 12,
                    ),
                  ),
                );
              }).toList(),
            ),
          ),

          const SizedBox(height: AppSpacing.md),

          // Candidate Items List
          ..._items.asMap().entries.map((entry) {
            final idx = entry.key;
            final item = entry.value;

            return Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.sm),
              child: BentoCard(
                padding: const EdgeInsets.all(AppSpacing.sm),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.foodName,
                                style: AppTypography.body.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              if (item.isVerifiedInCatalog)
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.verified_rounded,
                                      size: 13,
                                      color: AppColors.primary,
                                    ),
                                    const SizedBox(width: 3),
                                    Text(
                                      'Verified Indian Catalog',
                                      style: AppTypography.caption.copyWith(
                                        color: AppColors.primary,
                                        fontSize: 10,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                            ],
                          ),
                        ),
                        // Portion Stepper
                        Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.remove_circle_outline_rounded, size: 20),
                              color: AppColors.textSecondary,
                              onPressed: () => _updateQuantity(idx, -0.5),
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
                              child: Text(
                                '${item.quantity} ${item.unit.label}',
                                style: AppTypography.caption.copyWith(
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.add_circle_outline_rounded, size: 20),
                              color: AppColors.primary,
                              onPressed: () => _updateQuantity(idx, 0.5),
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                            ),
                            const SizedBox(width: AppSpacing.xs),
                            IconButton(
                              icon: const Icon(Icons.close_rounded, size: 18),
                              color: AppColors.textSecondary,
                              onPressed: () => _removeItem(idx),
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    // Item Macro details
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${(item.estimatedCalories * item.quantity).toStringAsFixed(0)} kcal',
                          style: AppTypography.caption.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          'P: ${(item.proteinGrams * item.quantity).toStringAsFixed(1)}g',
                          style: AppTypography.caption.copyWith(fontSize: 11),
                        ),
                        Text(
                          'C: ${(item.carbsGrams * item.quantity).toStringAsFixed(1)}g',
                          style: AppTypography.caption.copyWith(fontSize: 11),
                        ),
                        Text(
                          'F: ${(item.fatGrams * item.quantity).toStringAsFixed(1)}g',
                          style: AppTypography.caption.copyWith(fontSize: 11),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          }),

          const SizedBox(height: AppSpacing.sm),

          // Real-time Macro Recalculation Bar
          BentoCard(
            backgroundColor: AppColors.surfaceElevated.withValues(alpha: 0.8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildMacroMetric('Calories', '${_totalCalories.toStringAsFixed(0)} kcal', AppColors.primary),
                _buildMacroMetric('Protein', '${_totalProtein.toStringAsFixed(1)}g', AppColors.techBlue),
                _buildMacroMetric('Carbs', '${_totalCarbs.toStringAsFixed(1)}g', AppColors.saffron),
                _buildMacroMetric('Fat', '${_totalFat.toStringAsFixed(1)}g', AppColors.textSecondary),
              ],
            ),
          ),

          const SizedBox(height: AppSpacing.md),

          // Hinglish Coaching Bento Card
          BentoCard(
            backgroundColor: AppColors.primary.withValues(alpha: 0.08),
            borderColor: AppColors.primary.withValues(alpha: 0.25),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(AppSpacing.xs),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.2),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.tips_and_updates_rounded, color: AppColors.primary, size: 18),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.initialResult.coaching.headline,
                        style: AppTypography.caption.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        widget.initialResult.coaching.hinglishText,
                        style: AppTypography.bodySecondary.copyWith(
                          color: AppColors.textPrimary,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: AppSpacing.md),

          // Statutory Non-Medical Disclaimer (TASK 063)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.surface.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(AppRadii.sm),
              border: Border.all(color: AppColors.glassBorder),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Icon(Icons.shield_outlined, size: 16, color: AppColors.textSecondary),
                const SizedBox(width: AppSpacing.xs),
                Expanded(
                  child: Text(
                    widget.initialResult.statutoryDisclaimer,
                    style: AppTypography.caption.copyWith(
                      color: AppColors.textSecondary,
                      fontSize: 11,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: AppSpacing.lg),

          // Action Buttons: Manual Fallback & Confirm & Log
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: widget.onManualFallback,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.textSecondary,
                    side: const BorderSide(color: AppColors.glassBorder),
                    minimumSize: const Size.fromHeight(48),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppRadii.md),
                    ),
                  ),
                  child: const Text('Search Manually'),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                flex: 2,
                child: ActionButton(
                  label: _isSaving ? 'Logging...' : 'Confirm & Log Meal',
                  icon: Icons.check_circle_rounded,
                  isLoading: _isSaving,
                  onPressed: _items.isEmpty ? null : _confirmAndSave,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMacroMetric(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          label,
          style: AppTypography.caption.copyWith(color: AppColors.textSecondary, fontSize: 11),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: AppTypography.body.copyWith(fontWeight: FontWeight.w700, color: color),
        ),
      ],
    );
  }
}
