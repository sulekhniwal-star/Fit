import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/sync/sync_coordinator.dart';
import '../../core/sync/sync_state.dart';
import '../theme/app_colors.dart';
import '../theme/app_radii.dart';
import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';

class SyncStatusBadge extends ConsumerWidget {
  final VoidCallback? onTap;

  const SyncStatusBadge({super.key, this.onTap});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final syncState = ref.watch(syncCoordinatorProvider);

    Color badgeColor;
    Color textColor;
    IconData icon;
    String label;

    switch (syncState) {
      case SyncIdle():
        badgeColor = AppColors.surface;
        textColor = AppColors.textSecondary;
        icon = Icons.cloud_done_rounded;
        label = 'Synced';
        break;
      case SyncOffline(:final pendingCount):
        badgeColor = AppColors.warning.withValues(alpha: 0.15);
        textColor = AppColors.warning;
        icon = Icons.cloud_off_rounded;
        label = pendingCount > 0 ? 'Offline ($pendingCount)' : 'Offline';
        break;
      case Syncing(:final pendingCount):
        badgeColor = AppColors.techBlue.withValues(alpha: 0.15);
        textColor = AppColors.techBlue;
        icon = Icons.sync_rounded;
        label = 'Syncing ($pendingCount)';
        break;
      case Synced(:final itemsSynced):
        badgeColor = AppColors.primary.withValues(alpha: 0.15);
        textColor = AppColors.primary;
        icon = Icons.check_circle_outline_rounded;
        label = itemsSynced > 0 ? 'Synced ($itemsSynced)' : 'Synced';
        break;
      case SyncErrorState():
        badgeColor = AppColors.error.withValues(alpha: 0.15);
        textColor = AppColors.error;
        icon = Icons.error_outline_rounded;
        label = 'Sync error';
        break;
      case SyncConflictState():
        badgeColor = AppColors.saffron.withValues(alpha: 0.15);
        textColor = AppColors.saffron;
        icon = Icons.warning_amber_rounded;
        label = 'Conflict';
        break;
    }

    return GestureDetector(
      key: const Key('sync_status_badge'),
      onTap: onTap ??
          () {
            ref.read(syncCoordinatorProvider.notifier).triggerSync();
          },
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm,
          vertical: AppSpacing.xs,
        ),
        decoration: BoxDecoration(
          color: badgeColor,
          borderRadius: BorderRadius.circular(AppRadii.full),
          border: Border.all(
            color: textColor.withValues(alpha: 0.3),
            width: 1.0,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 14, color: textColor),
            const SizedBox(width: AppSpacing.xs),
            Text(
              label,
              style: AppTypography.caption.copyWith(
                color: textColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

