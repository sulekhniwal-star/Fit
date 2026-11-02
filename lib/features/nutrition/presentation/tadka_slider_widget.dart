import 'package:flutter/material.dart';
import '../../../shared/theme/app_colors.dart';
import '../../../shared/theme/app_radii.dart';
import '../../../shared/theme/app_spacing.dart';
import '../../../shared/theme/app_typography.dart';
import '../../../shared/widgets/bento_card.dart';
import '../domain/tadka_model.dart';

class TadkaSliderWidget extends StatefulWidget {
  final TadkaModel initialTadka;
  final ValueChanged<TadkaModel>? onChanged;

  const TadkaSliderWidget({
    super.key,
    this.initialTadka = const TadkaModel(),
    this.onChanged,
  });

  @override
  State<TadkaSliderWidget> createState() => _TadkaSliderWidgetState();
}

class _TadkaSliderWidgetState extends State<TadkaSliderWidget> {
  late TadkaModel _tadka;

  @override
  void initState() {
    super.initState();
    _tadka = widget.initialTadka;
  }

  void _updateLevel(TadkaLevel level) {
    setState(() {
      _tadka = _tadka.copyWith(level: level);
    });
    widget.onChanged?.call(_tadka);
  }

  void _updateFatSource(TadkaFatSource source) {
    setState(() {
      _tadka = _tadka.copyWith(fatSource: source);
    });
    widget.onChanged?.call(_tadka);
  }

  @override
  Widget build(BuildContext context) {
    final calories = _tadka.additionalCalories;
    final fat = _tadka.additionalFatGrams;

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
                child: const Icon(Icons.local_fire_department_rounded, color: AppColors.saffron, size: 20),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Text(
                  'Tadka / Tempering Fat',
                  style: AppTypography.title.copyWith(color: AppColors.textPrimary),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.surfaceElevated,
                  borderRadius: AppRadii.borderSm,
                  border: Border.all(color: AppColors.glassBorder),
                ),
                child: Text(
                  'Estimate',
                  style: AppTypography.caption.copyWith(
                    color: AppColors.saffron,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),

          // Fat Source Selector
          Row(
            children: TadkaFatSource.values.map((source) {
              final isSelected = _tadka.fatSource == source;
              return Padding(
                padding: const EdgeInsets.only(right: AppSpacing.sm),
                child: ChoiceChip(
                  label: Text(source.label),
                  selected: isSelected,
                  selectedColor: AppColors.saffron.withValues(alpha: 0.25),
                  backgroundColor: AppColors.surfaceElevated,
                  labelStyle: AppTypography.caption.copyWith(
                    color: isSelected ? AppColors.saffron : AppColors.textSecondary,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                  ),
                  onSelected: (_) => _updateFatSource(source),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: AppSpacing.md),

          // Tadka Level Selector Buttons
          Row(
            children: TadkaLevel.values.map((level) {
              final isSelected = _tadka.level == level;
              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 2),
                  child: InkWell(
                    key: Key('tadka_level_${level.name}'),
                    onTap: () => _updateLevel(level),
                    borderRadius: AppRadii.borderSm,
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
                      decoration: BoxDecoration(
                        color: isSelected ? AppColors.saffron : AppColors.surfaceElevated,
                        borderRadius: AppRadii.borderSm,
                        border: Border.all(
                          color: isSelected ? AppColors.saffron : AppColors.glassBorder,
                        ),
                      ),
                      child: Column(
                        children: [
                          Text(
                            level.shortLabel,
                            style: AppTypography.caption.copyWith(
                              color: isSelected ? AppColors.background : AppColors.textPrimary,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            level == TadkaLevel.none
                                ? '0g'
                                : level == TadkaLevel.low
                                    ? '1 tsp'
                                    : level == TadkaLevel.medium
                                        ? '2 tsp'
                                        : '1 tbsp',
                            style: AppTypography.caption.copyWith(
                              fontSize: 10,
                              color: isSelected ? AppColors.background : AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: AppSpacing.md),

          // Caloric Impact feedback
          Container(
            padding: const EdgeInsets.all(AppSpacing.sm),
            decoration: const BoxDecoration(
              color: AppColors.surfaceElevated,
              borderRadius: AppRadii.borderSm,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _tadka.level == TadkaLevel.none
                      ? 'No added tempering fat'
                      : '+${calories.toStringAsFixed(0)} kcal (+${fat.toStringAsFixed(0)}g fat)',
                  style: AppTypography.caption.copyWith(
                    color: _tadka.level == TadkaLevel.none ? AppColors.textSecondary : AppColors.saffron,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  _tadka.fatSource.label,
                  style: AppTypography.caption.copyWith(color: AppColors.textSecondary),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.xs),

          // Statutory notice
          Text(
            TadkaModel.estimateNotice,
            style: AppTypography.caption.copyWith(
              fontSize: 10,
              color: AppColors.textSecondary.withValues(alpha: 0.8),
            ),
          ),
        ],
      ),
    );
  }
}
