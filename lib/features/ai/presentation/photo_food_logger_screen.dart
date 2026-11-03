import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../shared/theme/app_colors.dart';
import '../../../shared/theme/app_radii.dart';
import '../../../shared/theme/app_spacing.dart';
import '../../../shared/theme/app_typography.dart';
import '../../../shared/widgets/action_button.dart';
import '../../../shared/widgets/app_scaffold.dart';
import '../../../shared/widgets/bento_card.dart';
import '../domain/ai_meal_analyzer_service.dart';
import '../domain/ai_models.dart';
import 'ai_meal_confirmation_card.dart';

class PhotoFoodLoggerScreen extends ConsumerStatefulWidget {
  final VoidCallback? onManualFallback;

  const PhotoFoodLoggerScreen({
    super.key,
    this.onManualFallback,
  });

  @override
  ConsumerState<PhotoFoodLoggerScreen> createState() => _PhotoFoodLoggerScreenState();
}

class _PhotoFoodLoggerScreenState extends ConsumerState<PhotoFoodLoggerScreen> {
  Uint8List? _selectedImageBytes;
  String? _selectedImageLabel;
  bool _isAnalyzing = false;
  String? _errorMessage;
  AiMealAnalysisResult? _analyzedResult;

  void _selectMockSample(String label, List<int> bytes) {
    setState(() {
      _selectedImageLabel = label;
      _selectedImageBytes = Uint8List.fromList(bytes);
      _errorMessage = null;
      _analyzedResult = null;
    });
  }

  Future<void> _analyzePhoto() async {
    if (_selectedImageBytes == null || _selectedImageBytes!.isEmpty) {
      setState(() => _errorMessage = 'Please take or choose a food photo first.');
      return;
    }

    setState(() {
      _isAnalyzing = true;
      _errorMessage = null;
    });

    final service = ref.read(aiMealAnalyzerServiceProvider);
    final res = await service.analyzePhotoMeal(_selectedImageBytes!);

    if (mounted) {
      if (res.isSuccess) {
        setState(() {
          _isAnalyzing = false;
          _analyzedResult = res.dataOrNull;
        });
      } else {
        setState(() {
          _isAnalyzing = false;
          _errorMessage = res.failureOrNull?.message ?? 'Vision analysis failed';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBar: AppBar(
        title: const Text('AI Photo Food Logger'),
        backgroundColor: AppColors.surface,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // DPDP Act 2023 Privacy Notice (TASK 063)
            Container(
              padding: const EdgeInsets.all(AppSpacing.sm),
              decoration: BoxDecoration(
                color: AppColors.techBlue.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(AppRadii.md),
                border: Border.all(color: AppColors.techBlue.withValues(alpha: 0.3)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.privacy_tip_outlined, color: AppColors.techBlue, size: 20),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Text(
                      'DPDP Act 2023 Compliant: Photos are processed ephemerally in-memory for meal analysis and immediately discarded. Zero permanent cloud image storage.',
                      style: AppTypography.caption.copyWith(color: AppColors.techBlue, fontSize: 11),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.md),

            if (_analyzedResult != null) ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton.icon(
                    onPressed: () {
                      setState(() => _analyzedResult = null);
                    },
                    icon: const Icon(Icons.refresh_rounded, size: 16),
                    label: const Text('Retake / Change Photo'),
                    style: TextButton.styleFrom(foregroundColor: AppColors.textSecondary),
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
                },
              ),
            ] else ...[
              // Camera / Photo Viewport Card
              BentoCard(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Column(
                  children: [
                    Container(
                      height: 180,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(AppRadii.md),
                        border: Border.all(color: AppColors.glassBorder),
                      ),
                      child: _selectedImageBytes != null
                          ? Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.check_circle_outline_rounded,
                                    size: 48, color: AppColors.primary),
                                const SizedBox(height: AppSpacing.xs),
                                Text(
                                  _selectedImageLabel ?? 'Photo Captured',
                                  style: AppTypography.body.copyWith(
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Ready for AI vision analysis',
                                  style: AppTypography.caption.copyWith(color: AppColors.textSecondary),
                                ),
                              ],
                            )
                          : const Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.camera_alt_outlined,
                                    size: 48, color: AppColors.textSecondary),
                                SizedBox(height: AppSpacing.sm),
                                Text(
                                  'Capture your Indian meal or plate',
                                  style: AppTypography.bodySecondary,
                                ),
                              ],
                            ),
                    ),
                    const SizedBox(height: AppSpacing.md),

                    // Photo trigger options / presets
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () => _selectMockSample(
                              'Standard Indian Thali',
                              [10, 20, 30, 40, 50, 60],
                            ),
                            icon: const Icon(Icons.camera_rounded, size: 18),
                            label: const Text('Capture Thali'),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: AppColors.textPrimary,
                              side: const BorderSide(color: AppColors.glassBorder),
                              minimumSize: const Size.fromHeight(44),
                            ),
                          ),
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () => _selectMockSample(
                              'South Indian Tiffin',
                              [70, 80, 90, 100, 110],
                            ),
                            icon: const Icon(Icons.photo_library_outlined, size: 18),
                            label: const Text('Pick Tiffin'),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: AppColors.textPrimary,
                              side: const BorderSide(color: AppColors.glassBorder),
                              minimumSize: const Size.fromHeight(44),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              if (_errorMessage != null) ...[
                const SizedBox(height: AppSpacing.sm),
                Text(
                  _errorMessage!,
                  style: AppTypography.caption.copyWith(color: AppColors.error),
                ),
              ],

              const SizedBox(height: AppSpacing.lg),

              ActionButton(
                label: _isAnalyzing
                    ? 'Analyzing Plate with Vision AI...'
                    : 'Analyze Photo with AI',
                icon: Icons.auto_awesome_rounded,
                isLoading: _isAnalyzing,
                onPressed: _isAnalyzing || _selectedImageBytes == null ? null : _analyzePhoto,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
