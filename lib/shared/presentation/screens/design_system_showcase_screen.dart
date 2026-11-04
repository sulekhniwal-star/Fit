import 'package:fitkarma/shared/presentation/accessibility/accessibility.dart';
import 'package:fitkarma/shared/presentation/theme/app_colors.dart';
import 'package:fitkarma/shared/presentation/theme/app_spacing.dart';
import 'package:fitkarma/shared/presentation/theme/app_typography.dart';
import 'package:fitkarma/shared/presentation/widgets/app_chip.dart';
import 'package:fitkarma/shared/presentation/widgets/app_progress_indicator.dart';
import 'package:fitkarma/shared/presentation/widgets/app_state_views.dart';
import 'package:fitkarma/shared/presentation/widgets/app_text_field.dart';
import 'package:fitkarma/shared/presentation/widgets/bento_card.dart';
import 'package:fitkarma/shared/presentation/widgets/primary_button.dart';
import 'package:flutter/material.dart';

/// Storybook-style Design System Showcase screen for previewing and verifying UI tokens.
class DesignSystemShowcaseScreen extends StatefulWidget {
  const DesignSystemShowcaseScreen({super.key});

  @override
  State<DesignSystemShowcaseScreen> createState() =>
      _DesignSystemShowcaseScreenState();
}

class _DesignSystemShowcaseScreenState
    extends State<DesignSystemShowcaseScreen> {
  bool _chipSelected = true;
  final TextEditingController _textController = TextEditingController(
    text: 'Dal Tadka',
  );

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('FitKarma Design System')),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        children: [
          // 1. Color Palette Tokens
          Text('Color Palette', style: AppTypography.titleLarge),
          const SizedBox(height: AppSpacing.md),
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: [
              _colorChip('Primary', AppColors.primary),
              _colorChip('Teal', AppColors.primaryAccent),
              _colorChip('Saffron', AppColors.saffron),
              _colorChip('Tech Blue', AppColors.techBlue),
              _colorChip('Surface', AppColors.surface),
              _colorChip('Elevated', AppColors.surfaceElevated),
              _colorChip('Error', AppColors.error),
            ],
          ),
          const SizedBox(height: AppSpacing.xl),

          // 2. Typography
          Text('Typography', style: AppTypography.titleLarge),
          const SizedBox(height: AppSpacing.sm),
          Text('Display Large 32sp', style: AppTypography.displayLarge),
          Text('Display Medium 24sp', style: AppTypography.displayMedium),
          Text('Title Large 20sp', style: AppTypography.titleLarge),
          Text('Title Medium 16sp', style: AppTypography.titleMedium),
          Text('Body Large 16sp text', style: AppTypography.bodyLarge),
          Text('Body Medium 14sp secondary', style: AppTypography.bodyMedium),
          const SizedBox(height: AppSpacing.xl),

          // 3. Bento Card
          Text('Bento Cards (Glassmorphism)', style: AppTypography.titleLarge),
          const SizedBox(height: AppSpacing.md),
          BentoCard(
            onTap: () {},
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Today Calories', style: AppTypography.titleMedium),
                    const Icon(
                      Icons.local_fire_department,
                      color: AppColors.saffron,
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.sm),
                Text('1,840 / 2,200 kcal', style: AppTypography.displayMedium),
                const SizedBox(height: AppSpacing.sm),
                const AppLinearProgressIndicator(value: 0.84),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.xl),

          // 4. Buttons
          Text(
            'Buttons (Min 48dp Touch Target)',
            style: AppTypography.titleLarge,
          ),
          const SizedBox(height: AppSpacing.md),
          PrimaryButton(label: 'Primary Action', onPressed: () {}),
          const SizedBox(height: AppSpacing.md),
          const PrimaryButton(label: 'Loading Button', isLoading: true),
          const SizedBox(height: AppSpacing.md),
          const PrimaryButton(label: 'Disabled Button', onPressed: null),
          const SizedBox(height: AppSpacing.xl),

          // 5. Inputs
          Text('Inputs', style: AppTypography.titleLarge),
          const SizedBox(height: AppSpacing.md),
          AppTextField(
            label: 'Meal Name',
            controller: _textController,
            hint: 'Search Indian food...',
            prefixIcon: const Icon(
              Icons.search,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          const AppTextField(
            label: 'Portion Count',
            hint: 'Enter quantity',
            errorText: 'Quantity must be greater than zero',
          ),
          const SizedBox(height: AppSpacing.xl),

          // 6. Chips
          Text('Chips & Tags', style: AppTypography.titleLarge),
          const SizedBox(height: AppSpacing.md),
          Wrap(
            spacing: AppSpacing.sm,
            children: [
              AppChip(
                label: 'Vegetarian',
                isSelected: _chipSelected,
                onSelected: (val) => setState(() => _chipSelected = val),
              ),
              AppChip(
                label: 'High Protein',
                isSelected: !_chipSelected,
                onSelected: (val) => setState(() => _chipSelected = !val),
              ),
              const AppChip(label: 'Ayurvedic', isSelected: false),
            ],
          ),
          const SizedBox(height: AppSpacing.xl),

          // 7. State Views
          Text('State Views', style: AppTypography.titleLarge),
          const SizedBox(height: AppSpacing.md),
          const BentoCard(
            child: AppLoadingView(message: 'Analyzing meal with Groq AI...'),
          ),
          const SizedBox(height: AppSpacing.md),
          const BentoCard(
            child: AppEmptyState(
              icon: Icons.restaurant_menu,
              title: 'No Meals Logged Today',
              message: 'Start logging via WhatsApp voice note or tap to add your breakfast.',
              actionLabel: 'Log First Meal',
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          BentoCard(
            child: AppErrorView(
              title: 'Sync Interrupted',
              message: 'Unable to sync observations with Supabase. Working in offline mode.',
              onRetry: () {},
            ),
          ),
          const SizedBox(height: AppSpacing.xl),

          // 8. Accessibility & Non-Color-Only Indicators
          Text(
            'Accessibility & Status Badges',
            style: AppTypography.titleLarge,
          ),
          const SizedBox(height: AppSpacing.md),
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: [
              AccessibleStatusBadge.optimal(label: 'Optimal Blood Glucose'),
              AccessibleStatusBadge.warning(label: 'Approaching Calorie Cap'),
              AccessibleStatusBadge.alert(label: 'Sync Connection Failed'),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          AccessibleFocus(
            onTap: () {},
            child: BentoCard(
              child: AccessibleSemantics.biomarker(
                metricName: 'Fasting Blood Sugar',
                value: '95',
                unit: 'mg/dL',
                status: 'Optimal',
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Fasting Sugar', style: AppTypography.titleMedium),
                    Text('95 mg/dL', style: AppTypography.displayMedium),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _colorChip(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(color: color, borderRadius: AppRadius.radiusSm),
      child: Text(
        label,
        style: TextStyle(
          color: color.computeLuminance() > 0.5 ? Colors.black : Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
    );
  }
}
