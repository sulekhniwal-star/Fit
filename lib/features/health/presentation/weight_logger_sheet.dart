import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../shared/theme/app_colors.dart';
import '../../../shared/theme/app_radii.dart';
import '../../../shared/theme/app_spacing.dart';
import '../../../shared/theme/app_typography.dart';
import '../../../shared/widgets/action_button.dart';
import '../../../shared/widgets/bento_card.dart';
import '../data/drift_body_metrics_repository.dart';
import '../domain/body_metric.dart';
import '../domain/health_primitives.dart';

class WeightLoggerSheet extends ConsumerStatefulWidget {
  final String userId;
  final double? initialWeightKg;
  final VoidCallback? onSaved;

  const WeightLoggerSheet({
    super.key,
    required this.userId,
    this.initialWeightKg,
    this.onSaved,
  });

  @override
  ConsumerState<WeightLoggerSheet> createState() => _WeightLoggerSheetState();
}

class _WeightLoggerSheetState extends ConsumerState<WeightLoggerSheet> {
  late TextEditingController _weightController;
  HealthUnit _selectedUnit = HealthUnit.kg;
  final DateTime _selectedDate = DateTime.now();
  bool _isSaving = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    final initial = widget.initialWeightKg ?? 70.0;
    _weightController = TextEditingController(text: initial.toStringAsFixed(1));
  }

  @override
  void dispose() {
    _weightController.dispose();
    super.dispose();
  }

  void _toggleUnit(HealthUnit unit) {
    if (_selectedUnit == unit) return;
    final currentVal = double.tryParse(_weightController.text) ?? 70.0;
    double newVal;
    if (unit == HealthUnit.lbs) {
      newVal = HealthUnit.kgToLbs(currentVal);
    } else {
      newVal = HealthUnit.lbsToKg(currentVal);
    }
    setState(() {
      _selectedUnit = unit;
      _weightController.text = newVal.toStringAsFixed(1);
    });
  }

  Future<void> _handleSave() async {
    final value = double.tryParse(_weightController.text.trim());
    if (value == null) {
      setState(() => _errorMessage = 'Please enter a valid weight');
      return;
    }

    final entry = BodyMetricEntry(
      id: 'weight_${DateTime.now().millisecondsSinceEpoch}',
      userId: widget.userId,
      metricType: BodyMetricType.weight,
      value: value,
      unit: _selectedUnit,
      recordedAt: _selectedDate,
      source: HealthSource.manual,
    );

    if (!entry.isValid) {
      setState(() => _errorMessage = 'Weight is outside physiological limits (20-400 kg)');
      return;
    }

    setState(() {
      _isSaving = true;
      _errorMessage = null;
    });

    final repository = ref.read(bodyMetricsRepositoryProvider);
    final result = await repository.saveLocal(entry);

    setState(() => _isSaving = false);

    result.when(
      onSuccess: (_) {
        if (widget.onSaved != null) widget.onSaved!();
        if (Navigator.of(context).canPop()) {
          Navigator.of(context).pop();
        }
      },
      onFailure: (failure) {
        setState(() => _errorMessage = failure.message);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: AppSpacing.md,
        right: AppSpacing.md,
        top: AppSpacing.md,
      ),
      child: BentoCard(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(AppSpacing.xs),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.15),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.scale_rounded, color: AppColors.primary, size: 24),
                ),
                const SizedBox(width: AppSpacing.sm),
                Text(
                  'Log Body Weight',
                  style: AppTypography.title.copyWith(color: AppColors.textPrimary),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),

            // kg / lbs Toggle
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ChoiceChip(
                  key: const Key('unit_chip_kg'),
                  label: const Text('KG'),
                  selected: _selectedUnit == HealthUnit.kg,
                  selectedColor: AppColors.primary,
                  backgroundColor: AppColors.surface,
                  labelStyle: TextStyle(
                    color: _selectedUnit == HealthUnit.kg
                        ? AppColors.background
                        : AppColors.textPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                  onSelected: (_) => _toggleUnit(HealthUnit.kg),
                ),
                const SizedBox(width: AppSpacing.sm),
                ChoiceChip(
                  key: const Key('unit_chip_lbs'),
                  label: const Text('LBS'),
                  selected: _selectedUnit == HealthUnit.lbs,
                  selectedColor: AppColors.primary,
                  backgroundColor: AppColors.surface,
                  labelStyle: TextStyle(
                    color: _selectedUnit == HealthUnit.lbs
                        ? AppColors.background
                        : AppColors.textPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                  onSelected: (_) => _toggleUnit(HealthUnit.lbs),
                ),
              ],
            ),

            const SizedBox(height: AppSpacing.md),

            // Value Input
            Container(
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(AppRadii.md),
                border: Border.all(color: AppColors.glassBorder),
              ),
              child: TextField(
                key: const Key('weight_input_field'),
                controller: _weightController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                textAlign: TextAlign.center,
                style: AppTypography.display.copyWith(color: AppColors.textPrimary),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
                ],
                decoration: InputDecoration(
                  border: InputBorder.none,
                  suffixText: _selectedUnit.symbol,
                  suffixStyle: AppTypography.title.copyWith(color: AppColors.textSecondary),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md,
                    vertical: AppSpacing.md,
                  ),
                ),
              ),
            ),

            if (_errorMessage != null) ...[
              const SizedBox(height: AppSpacing.xs),
              Text(
                _errorMessage!,
                key: const Key('weight_error_text'),
                style: AppTypography.caption.copyWith(color: AppColors.error),
                textAlign: TextAlign.center,
              ),
            ],

            const SizedBox(height: AppSpacing.lg),

            ActionButton(
              key: const Key('save_weight_button'),
              label: 'Save Weight Entry',
              isLoading: _isSaving,
              onPressed: _handleSave,
            ),
            const SizedBox(height: AppSpacing.sm),
          ],
        ),
      ),
    );
  }
}
