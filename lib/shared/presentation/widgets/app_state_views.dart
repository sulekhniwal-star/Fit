import 'package:fitkarma/core/localization/app_strings.dart';
import 'package:fitkarma/shared/presentation/theme/app_colors.dart';
import 'package:fitkarma/shared/presentation/theme/app_spacing.dart';
import 'package:fitkarma/shared/presentation/theme/app_typography.dart';
import 'package:fitkarma/shared/presentation/widgets/app_progress_indicator.dart';
import 'package:fitkarma/shared/presentation/widgets/primary_button.dart';
import 'package:flutter/material.dart';

/// Reusable Empty State view for food logs, workouts, or family members.
///
/// Automatically pulls localized strings from [AppStrings.of(context)] when defaults are omitted.
class AppEmptyState extends StatelessWidget {
  final IconData icon;
  final String? title;
  final String? message;
  final String? actionLabel;
  final VoidCallback? onAction;

  const AppEmptyState({
    super.key,
    this.icon = Icons.inbox_outlined,
    this.title,
    this.message,
    this.actionLabel,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    final strings = AppStrings.of(context);
    final effectiveTitle = title ?? strings.emptyTitle;
    final effectiveMessage = message ?? strings.emptyMessage;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(AppSpacing.lg),
              decoration: const BoxDecoration(
                color: AppColors.surface,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 48, color: AppColors.textSecondary),
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              effectiveTitle,
              style: AppTypography.titleLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              effectiveMessage,
              style: AppTypography.bodyMedium,
              textAlign: TextAlign.center,
            ),
            if (actionLabel != null && onAction != null) ...[
              const SizedBox(height: AppSpacing.xl),
              PrimaryButton(label: actionLabel!, onPressed: onAction),
            ],
          ],
        ),
      ),
    );
  }
}

/// Reusable Loading State view with optional localized status message.
class AppLoadingView extends StatelessWidget {
  final String? message;

  const AppLoadingView({super.key, this.message});

  @override
  Widget build(BuildContext context) {
    final strings = AppStrings.of(context);
    final effectiveMessage = message ?? strings.loading;

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const AppProgressIndicator(),
          const SizedBox(height: AppSpacing.lg),
          Text(effectiveMessage, style: AppTypography.bodyMedium),
        ],
      ),
    );
  }
}

/// Reusable Error State view with user-safe message and retry action.
class AppErrorView extends StatelessWidget {
  final String? title;
  final String message;
  final VoidCallback? onRetry;
  final String? retryLabel;

  const AppErrorView({
    super.key,
    this.title,
    required this.message,
    this.onRetry,
    this.retryLabel,
  });

  @override
  Widget build(BuildContext context) {
    final strings = AppStrings.of(context);
    final effectiveTitle = title ?? strings.errorTitle;
    final effectiveRetryLabel = retryLabel ?? strings.tryAgain;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(AppSpacing.lg),
              decoration: BoxDecoration(
                color: AppColors.error.withAlpha(25),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.error_outline,
                size: 48,
                color: AppColors.error,
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              effectiveTitle,
              style: AppTypography.titleLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              message,
              style: AppTypography.bodyMedium,
              textAlign: TextAlign.center,
            ),
            if (onRetry != null) ...[
              const SizedBox(height: AppSpacing.xl),
              PrimaryButton(label: effectiveRetryLabel, onPressed: onRetry),
            ],
          ],
        ),
      ),
    );
  }
}
