import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';

class OfflineBanner extends StatelessWidget {
  final String message;

  const OfflineBanner({
    super.key,
    this.message = 'Offline mode active — changes will sync automatically',
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.sm,
      ),
      color: AppColors.saffron.withValues(alpha: 0.15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.wifi_off_rounded,
            size: 16,
            color: AppColors.saffron,
          ),
          const SizedBox(width: AppSpacing.sm),
          Flexible(
            child: Text(
              message,
              style: AppTypography.caption.copyWith(
                color: AppColors.saffron,
                fontWeight: FontWeight.w600,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

