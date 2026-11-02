import 'package:flutter/material.dart';
import '../../../shared/theme/app_colors.dart';
import '../../../shared/theme/app_radii.dart';
import '../../../shared/theme/app_spacing.dart';
import '../../../shared/theme/app_typography.dart';
import '../../../shared/widgets/action_button.dart';
import '../../../shared/widgets/bento_card.dart';
import '../conflict/conflict_resolution.dart';

class ConflictResolutionDialog<T> extends StatelessWidget {
  final ConflictData<T> conflict;
  final String Function(T item)? summaryBuilder;
  final ValueChanged<ConflictResolutionChoice> onResolved;

  const ConflictResolutionDialog({
    super.key,
    required this.conflict,
    this.summaryBuilder,
    required this.onResolved,
  });

  @override
  Widget build(BuildContext context) {
    final clientSummary = summaryBuilder != null
        ? summaryBuilder!(conflict.clientVersion)
        : conflict.clientVersion.toString();

    final serverSummary = summaryBuilder != null
        ? summaryBuilder!(conflict.serverVersion)
        : conflict.serverVersion.toString();

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(AppSpacing.md),
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
                    color: AppColors.saffron.withValues(alpha: 0.15),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.sync_problem_rounded, color: AppColors.saffron, size: 24),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Text(
                    'Data Conflict Detected',
                    style: AppTypography.title.copyWith(color: AppColors.textPrimary),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'This record was updated both locally on this device and on the cloud. '
              'Please choose which version to preserve.',
              style: AppTypography.bodySecondary.copyWith(color: AppColors.textSecondary),
            ),
            const SizedBox(height: AppSpacing.md),

            // Local Device Version
            Container(
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(AppRadii.md),
                border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.phone_android_rounded, size: 16, color: AppColors.primary),
                      const SizedBox(width: AppSpacing.xs),
                      Text(
                        'This Device (Local)',
                        style: AppTypography.caption.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    clientSummary,
                    style: AppTypography.body.copyWith(color: AppColors.textPrimary),
                  ),
                ],
              ),
            ),

            const SizedBox(height: AppSpacing.sm),

            // Remote Server Version
            Container(
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(AppRadii.md),
                border: Border.all(color: AppColors.techBlue.withValues(alpha: 0.3)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.cloud_outlined, size: 16, color: AppColors.techBlue),
                      const SizedBox(width: AppSpacing.xs),
                      Text(
                        'Cloud (Server)',
                        style: AppTypography.caption.copyWith(
                          color: AppColors.techBlue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    serverSummary,
                    style: AppTypography.body.copyWith(color: AppColors.textPrimary),
                  ),
                ],
              ),
            ),

            const SizedBox(height: AppSpacing.lg),

            // Actions
            ActionButton(
              key: const Key('keep_client_button'),
              label: 'Keep My Local Changes',
              onPressed: () {
                Navigator.of(context).pop();
                onResolved(ConflictResolutionChoice.keepClient);
              },
            ),
            const SizedBox(height: AppSpacing.sm),
            ActionButton(
              key: const Key('keep_server_button'),
              label: 'Keep Cloud Version',
              variant: ActionButtonVariant.outline,
              onPressed: () {
                Navigator.of(context).pop();
                onResolved(ConflictResolutionChoice.keepServer);
              },
            ),
          ],
        ),
      ),
    );
  }
}
