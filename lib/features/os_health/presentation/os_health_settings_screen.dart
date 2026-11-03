import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../shared/theme/app_colors.dart';
import '../../../shared/theme/app_radii.dart';
import '../../../shared/theme/app_spacing.dart';
import '../../../shared/theme/app_typography.dart';
import '../../../shared/widgets/app_scaffold.dart';
import '../../../shared/widgets/bento_card.dart';
import '../../../shared/widgets/sync_status_badge.dart';
import '../../auth/presentation/auth_state_notifier.dart';
import 'os_health_sync_card.dart';

class OsHealthSettingsScreen extends ConsumerWidget {
  final String? userId;

  const OsHealthSettingsScreen({super.key, this.userId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final effectiveUserId = userId ??
        () {
          final authState = ref.watch(authStateNotifierProvider);
          if (authState is AuthAuthenticated) {
            return authState.user.id;
          }
          return 'user_default';
        }();

    return AppScaffold(
      appBar: AppBar(
        title: const Text(
          'OS Health Integration',
          style: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold),
        ),
        backgroundColor: AppColors.surface,
        elevation: 0,
        actions: const [
          SyncStatusBadge(),
          SizedBox(width: AppSpacing.sm),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.md),
        children: [
          // 1. Interactive Connection & Sync Card
          OsHealthSyncCard(userId: effectiveUserId),

          const SizedBox(height: AppSpacing.md),

          // 2. Background Sync Cadence Bento Card
          BentoCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.battery_charging_full, color: AppColors.primary, size: 20),
                    const SizedBox(width: AppSpacing.xs),
                    Text(
                      'Battery-Conscious Sync',
                      style: AppTypography.title.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.xs),
                const Text(
                  'FitKarma automatically synchronizes biometric telemetry in the background every 15-30 minutes to preserve device battery life while keeping your step, sleep, and vitals history fresh.',
                  style: TextStyle(color: AppColors.textSecondary, fontSize: 13, height: 1.4),
                ),
                const SizedBox(height: AppSpacing.sm),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: AppRadii.borderSm,
                        border: Border.all(color: AppColors.glassBorder),
                      ),
                      child: const Text('Min Interval: 15 mins',
                          style: TextStyle(color: AppColors.primary, fontSize: 11, fontWeight: FontWeight.bold)),
                    ),
                    const SizedBox(width: AppSpacing.xs),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: AppRadii.borderSm,
                        border: Border.all(color: AppColors.glassBorder),
                      ),
                      child: const Text('Backoff: Exponential',
                          style: TextStyle(color: AppColors.textSecondary, fontSize: 11)),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: AppSpacing.md),

          // 3. DPDP Act Privacy Notice
          BentoCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.shield_outlined, color: AppColors.primary, size: 20),
                    const SizedBox(width: AppSpacing.xs),
                    Text(
                      'Data Sovereignty & DPDP 2023',
                      style: AppTypography.title.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.xs),
                const Text(
                  'Under the Digital Personal Data Protection Act 2023, your wearable health observations remain under your sole ownership. All imports are stored in local SQLCipher-encrypted tables. FitKarma never sells or shares your biometric telemetry with third parties.',
                  style: TextStyle(color: AppColors.textSecondary, fontSize: 13, height: 1.4),
                ),
              ],
            ),
          ),
          const SizedBox(height: 80),
        ],
      ),
    );
  }
}
