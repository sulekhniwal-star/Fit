import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../shared/theme/app_colors.dart';
import '../../../shared/theme/app_radii.dart';
import '../../../shared/theme/app_spacing.dart';
import '../../../shared/theme/app_typography.dart';
import '../../../shared/widgets/action_button.dart';
import '../domain/ai_meal_analyzer_service.dart';
import '../domain/ai_models.dart';
import 'ai_meal_confirmation_card.dart';

class AiMealTextLoggerSheet extends ConsumerStatefulWidget {
  final VoidCallback? onManualFallback;
  final VoidCallback? onMealLogged;

  const AiMealTextLoggerSheet({
    super.key,
    this.onManualFallback,
    this.onMealLogged,
  });

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const AiMealTextLoggerSheet(),
    );
  }

  @override
  ConsumerState<AiMealTextLoggerSheet> createState() => _AiMealTextLoggerSheetState();
}

class _AiMealTextLoggerSheetState extends ConsumerState<AiMealTextLoggerSheet> {
  final TextEditingController _textController = TextEditingController();
  bool _isAnalyzing = false;
  String? _errorMessage;
  AiMealAnalysisResult? _analyzedResult;

  static const List<String> _quickSuggestions = [
    '2 Phulkas and 1 bowl Dal Tadka',
    'Plate of Poha and Chai',
    'Dal Chawal with Dahi',
    'Paneer Bhurji with 2 Rotis',
    'Idli with Sambhar and Chutney',
  ];

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  Future<void> _analyzeInput() async {
    final text = _textController.text.trim();
    if (text.isEmpty) {
      setState(() => _errorMessage = 'Please describe what you had to eat.');
      return;
    }

    setState(() {
      _isAnalyzing = true;
      _errorMessage = null;
    });

    final service = ref.read(aiMealAnalyzerServiceProvider);
    final res = await service.analyzeTextMeal(text);

    if (mounted) {
      if (res.isSuccess) {
        setState(() {
          _isAnalyzing = false;
          _analyzedResult = res.dataOrNull;
        });
      } else {
        setState(() {
          _isAnalyzing = false;
          _errorMessage = res.failureOrNull?.message ?? 'AI analysis failed';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Container(
      padding: EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.md,
        AppSpacing.lg,
        AppSpacing.lg + bottomInset,
      ),
      decoration: const BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadii.lg)),
      ),
      child: SingleChildScrollView(
        child: _analyzedResult != null
            ? Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton.icon(
                        onPressed: () {
                          setState(() => _analyzedResult = null);
                        },
                        icon: const Icon(Icons.arrow_back_rounded, size: 16),
                        label: const Text('Edit Description'),
                        style: TextButton.styleFrom(foregroundColor: AppColors.textSecondary),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close_rounded, color: AppColors.textSecondary),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  AiMealConfirmationCard(
                    initialResult: _analyzedResult!,
                    onManualFallback: () {
                      Navigator.of(context).pop();
                      widget.onManualFallback?.call();
                    },
                    onMealLogged: () {
                      Navigator.of(context).pop();
                      widget.onMealLogged?.call();
                    },
                  ),
                ],
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Drag handle
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: AppColors.glassBorder,
                        borderRadius: BorderRadius.circular(AppRadii.full),
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(AppSpacing.xs),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withValues(alpha: 0.15),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.chat_bubble_outline_rounded,
                                color: AppColors.primary, size: 20),
                          ),
                          const SizedBox(width: AppSpacing.sm),
                          Text(
                            'AI Meal Description',
                            style: AppTypography.headline.copyWith(color: AppColors.textPrimary),
                          ),
                        ],
                      ),
                      IconButton(
                        icon: const Icon(Icons.close_rounded, color: AppColors.textSecondary),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  const Text(
                    'Describe your meal in English or Hinglish (e.g., "2 rotis, 1 bowl dal tadka, aur thoda sa dahi").',
                    style: AppTypography.bodySecondary,
                  ),
                  const SizedBox(height: AppSpacing.md),

                  // Quick suggestions
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: _quickSuggestions.map((suggestion) {
                        return Padding(
                          padding: const EdgeInsets.only(right: AppSpacing.xs),
                          child: ActionChip(
                            label: Text(suggestion),
                            backgroundColor: AppColors.surfaceElevated,
                            labelStyle: AppTypography.caption.copyWith(
                              color: AppColors.textSecondary,
                              fontSize: 12,
                            ),
                            onPressed: () {
                              _textController.text = suggestion;
                            },
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),

                  // Text field
                  TextField(
                    controller: _textController,
                    maxLines: 3,
                    style: AppTypography.body.copyWith(color: AppColors.textPrimary),
                    decoration: InputDecoration(
                      hintText: 'What did you eat today?',
                      hintStyle: AppTypography.bodySecondary,
                      filled: true,
                      fillColor: AppColors.surface,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(AppRadii.md),
                        borderSide: const BorderSide(color: AppColors.glassBorder),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(AppRadii.md),
                        borderSide: const BorderSide(color: AppColors.glassBorder),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(AppRadii.md),
                        borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
                      ),
                    ),
                  ),

                  if (_errorMessage != null) ...[
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      _errorMessage!,
                      style: AppTypography.caption.copyWith(color: AppColors.error),
                    ),
                  ],

                  const SizedBox(height: AppSpacing.lg),

                  ActionButton(
                    label: _isAnalyzing ? 'Analyzing with AI Gateway...' : 'Analyze Meal',
                    icon: Icons.auto_awesome_rounded,
                    isLoading: _isAnalyzing,
                    onPressed: _isAnalyzing ? null : _analyzeInput,
                  ),
                ],
              ),
      ),
    );
  }
}
