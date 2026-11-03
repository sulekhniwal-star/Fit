import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../shared/theme/app_colors.dart';
import '../../../shared/theme/app_radii.dart';
import '../../../shared/theme/app_spacing.dart';
import '../../../shared/theme/app_typography.dart';
import '../../../shared/widgets/action_button.dart';
import '../../../shared/widgets/bento_card.dart';
import '../data/drift_meal_log_repository.dart';
import '../domain/family_recipe.dart';
import '../domain/food_log_entry.dart';
import '../domain/portion_unit.dart';

class RecipeSplitterSheet extends ConsumerStatefulWidget {
  final String userId;
  final FamilyRecipe? initialRecipe;
  final VoidCallback? onLogged;

  const RecipeSplitterSheet({
    super.key,
    required this.userId,
    this.initialRecipe,
    this.onLogged,
  });

  @override
  ConsumerState<RecipeSplitterSheet> createState() => _RecipeSplitterSheetState();
}

class _RecipeSplitterSheetState extends ConsumerState<RecipeSplitterSheet> {
  late FamilyRecipe _recipe;
  double _selectedPercentage = 25.0;
  MealSlot _selectedSlot = MealSlot.lunch;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _recipe = widget.initialRecipe ??
        FamilyRecipe(
          id: 'fam_rec_default',
          userId: widget.userId,
          name: 'Home-style Dal Tadka Pot',
          totalYieldGramsOrKatoris: 4.0,
          createdAt: DateTime.now(),
          ingredients: const [
            RecipeIngredient(
              foodName: 'Toor Dal (Cooked)',
              quantity: 400.0,
              unit: PortionUnit.gram,
              nutrition: NutritionValues(
                calories: 420.0,
                proteinGrams: 23.2,
                carbsGrams: 58.0,
                fatGrams: 11.2,
                fiberGrams: 14.0,
              ),
            ),
            RecipeIngredient(
              foodName: 'Desi Ghee Tadka',
              quantity: 2.0,
              unit: PortionUnit.tablespoon,
              nutrition: NutritionValues(
                calories: 180.0,
                proteinGrams: 0.0,
                carbsGrams: 0.0,
                fatGrams: 20.0,
                fiberGrams: 0.0,
              ),
            ),
          ],
        );
  }

  Future<void> _logSplitPortion() async {
    setState(() => _isSaving = true);
    final splitNutrition = _recipe.splitByPercentage(_selectedPercentage);

    final log = FoodLogEntry(
      id: 'log_split_${DateTime.now().millisecondsSinceEpoch}',
      userId: widget.userId,
      loggedAt: DateTime.now(),
      mealSlot: _selectedSlot,
      foodName: '${_recipe.name} (${_selectedPercentage.toInt()}% pot)',
      portionQuantity: _selectedPercentage,
      portionUnit: PortionUnit.serving,
      calories: splitNutrition.calories,
      proteinGrams: splitNutrition.proteinGrams,
      carbsGrams: splitNutrition.carbsGrams,
      fatGrams: splitNutrition.fatGrams,
      fiberGrams: splitNutrition.fiberGrams,
    );

    final repo = ref.read(mealLogRepositoryProvider);
    await repo.saveLocal(log);

    if (mounted) {
      setState(() => _isSaving = false);
      widget.onLogged?.call();
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final split = _recipe.splitByPercentage(_selectedPercentage);

    return Container(
      padding: EdgeInsets.only(
        top: AppSpacing.lg,
        left: AppSpacing.lg,
        right: AppSpacing.lg,
        bottom: MediaQuery.of(context).viewInsets.bottom + AppSpacing.xl,
      ),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadii.lg)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Family Recipe Splitter',
                style: AppTypography.title.copyWith(fontWeight: FontWeight.w700),
              ),
              IconButton(
                icon: const Icon(Icons.close, color: AppColors.textSecondary),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Batch Pot: ${_recipe.name} (${_recipe.totalYieldGramsOrKatoris.toInt()} ${_recipe.yieldUnitLabel})',
            style: AppTypography.bodySecondary,
          ),
          const SizedBox(height: AppSpacing.md),

          // Percentage Preset Selection Chips
          Text(
            'How much of the pot did you eat?',
            style: AppTypography.caption.copyWith(
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Row(
            children: [25.0, 33.3, 50.0, 100.0].map((pct) {
              final isSelected = (_selectedPercentage - pct).abs() < 0.5;
              final label = pct == 33.3 ? '⅓ pot (33%)' : '${pct.toInt()}% pot';
              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 2),
                  child: ChoiceChip(
                    label: Text(label, style: const TextStyle(fontSize: 11)),
                    selected: isSelected,
                    selectedColor: AppColors.saffron.withValues(alpha: 0.25),
                    backgroundColor: AppColors.surfaceElevated,
                    labelStyle: AppTypography.caption.copyWith(
                      color: isSelected ? AppColors.saffron : AppColors.textSecondary,
                      fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                    ),
                    onSelected: (_) => setState(() => _selectedPercentage = pct),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: AppSpacing.md),

          // Computed Personal Macros Card
          BentoCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Your Personal Share (${_selectedPercentage.toInt()}%)',
                  style: AppTypography.caption.copyWith(
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Text(
                      split.calories.toStringAsFixed(0),
                      style: AppTypography.metricLarge.copyWith(color: AppColors.primary),
                    ),
                    const SizedBox(width: AppSpacing.xs),
                    const Text('kcal', style: AppTypography.bodySecondary),
                    const Spacer(),
                    Text('P: ${split.proteinGrams}g', style: AppTypography.caption),
                    const SizedBox(width: AppSpacing.sm),
                    Text('C: ${split.carbsGrams}g', style: AppTypography.caption),
                    const SizedBox(width: AppSpacing.sm),
                    Text('F: ${split.fatGrams}g', style: AppTypography.caption),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.md),

          // Meal Slot Selection
          Text(
            'Log into Meal Slot',
            style: AppTypography.caption.copyWith(
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.xs,
            children: MealSlot.values.map((slot) {
              final isSelected = _selectedSlot == slot;
              return FilterChip(
                label: Text(slot.label),
                selected: isSelected,
                selectedColor: AppColors.primary.withValues(alpha: 0.2),
                backgroundColor: AppColors.surfaceElevated,
                labelStyle: AppTypography.caption.copyWith(
                  color: isSelected ? AppColors.primary : AppColors.textSecondary,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                ),
                onSelected: (_) => setState(() => _selectedSlot = slot),
              );
            }).toList(),
          ),
          const SizedBox(height: AppSpacing.lg),

          ActionButton(
            label: 'Log Split Portion',
            isLoading: _isSaving,
            onPressed: _logSplitPortion,
          ),
        ],
      ),
    );
  }
}
