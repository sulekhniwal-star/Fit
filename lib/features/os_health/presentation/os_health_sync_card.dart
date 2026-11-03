import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../shared/theme/app_colors.dart';
import '../../../shared/theme/app_radii.dart';
import '../../../shared/theme/app_spacing.dart';
import '../../../shared/theme/app_typography.dart';
import '../../../shared/widgets/bento_card.dart';
import '../../health/domain/health_primitives.dart';
import '../data/health_integration_service.dart';
import '../domain/health_data_types.dart';

class OsHealthSyncCard extends ConsumerStatefulWidget {
  final String userId;
  final VoidCallback? onSyncCompleted;

  const OsHealthSyncCard({
    super.key,
    required this.userId,
    this.onSyncCompleted,
  });

  @override
  ConsumerState<OsHealthSyncCard> createState() => _OsHealthSyncCardState();
}

class _OsHealthSyncCardState extends ConsumerState<OsHealthSyncCard> {
  bool _isSyncing = false;
  HealthIntegrationStatus? _status;

  @override
  void initState() {
    super.initState();
    _loadStatus();
  }

  Future<void> _loadStatus() async {
    final service = ref.read(healthIntegrationServiceProvider);
    final status = await service.getStatus();
    if (mounted) {
      setState(() => _status = status);
    }
  }

  Future<void> _triggerSync() async {
    if (_isSyncing) return;
    setState(() => _isSyncing = true);

    try {
      final service = ref.read(healthIntegrationServiceProvider);
      await service.syncHealthData(userId: widget.userId);
      await _loadStatus();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('OS health data synced successfully.'),
            backgroundColor: AppColors.success,
            duration: Duration(seconds: 2),
          ),
        );
      }
      widget.onSyncCompleted?.call();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Health sync failed: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSyncing = false);
      }
    }
  }

  Future<void> _toggleConnection() async {
    final service = ref.read(healthIntegrationServiceProvider);
    if (_status?.isConnected == true) {
      await service.disconnect();
    } else {
      await service.requestPermissions(HealthDataType.values.toSet());
    }
    await _loadStatus();
  }

  String _formatLastSync(DateTime? time) {
    if (time == null) return 'Never synced';
    final diff = DateTime.now().difference(time);
    if (diff.inMinutes < 1) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    return '${diff.inDays}d ago';
  }

  @override
  Widget build(BuildContext context) {
    final isConnected = _status?.isConnected == true;
    final platformSource = _status?.platformSource ?? HealthSource.healthConnect;
    final platformName = platformSource == HealthSource.appleHealth ? 'Apple Health' : 'Google Health Connect';
    final platformIcon = platformSource == HealthSource.appleHealth ? Icons.favorite : Icons.link;

    return BentoCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header row with platform brand badge and connection status
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(platformIcon, color: AppColors.primary, size: 22),
                  const SizedBox(width: AppSpacing.xs),
                  Text(
                    platformName,
                    style: AppTypography.title.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: 4),
                decoration: BoxDecoration(
                  color: isConnected
                      ? AppColors.primary.withValues(alpha: 0.15)
                      : AppColors.warning.withValues(alpha: 0.15),
                  borderRadius: AppRadii.borderFull,
                  border: Border.all(
                    color: isConnected ? AppColors.primary : AppColors.warning,
                  ),
                ),
                child: Text(
                  isConnected ? 'Connected' : 'Disconnected',
                  style: TextStyle(
                    color: isConnected ? AppColors.primary : AppColors.warning,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: AppSpacing.sm),

          Text(
            'Bi-directional sync with $platformName for automated step, sleep, vital, and weight tracking.',
            style: const TextStyle(color: AppColors.textSecondary, fontSize: 13, height: 1.4),
          ),

          const SizedBox(height: AppSpacing.md),

          // Permissions / Telemetry chips
          Wrap(
            spacing: AppSpacing.xs,
            runSpacing: AppSpacing.xs,
            children: HealthDataType.values.map((type) {
              final isGranted = _status?.permissions[type]?.isAuthorized == true;
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: 4),
                decoration: BoxDecoration(
                  color: isGranted ? AppColors.surface : AppColors.surface.withValues(alpha: 0.5),
                  borderRadius: AppRadii.borderSm,
                  border: Border.all(
                    color: isGranted ? AppColors.primary.withValues(alpha: 0.5) : AppColors.glassBorder,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      isGranted ? Icons.check_circle : Icons.circle_outlined,
                      size: 14,
                      color: isGranted ? AppColors.primary : AppColors.textSecondary,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      type.displayName.split(' ').first,
                      style: TextStyle(
                        color: isGranted ? AppColors.textPrimary : AppColors.textSecondary,
                        fontSize: 11,
                        fontWeight: isGranted ? FontWeight.w600 : FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),

          const SizedBox(height: AppSpacing.md),
          const Divider(color: AppColors.glassBorder, height: 1),
          const SizedBox(height: AppSpacing.sm),

          // Actions row: Last sync timestamp + Manual Sync + Connect/Disconnect
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Last Synced', style: TextStyle(color: AppColors.textSecondary, fontSize: 11)),
                  Text(
                    _formatLastSync(_status?.lastSyncTime),
                    key: const Key('os_health_last_sync_text'),
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  TextButton(
                    key: const Key('os_health_toggle_btn'),
                    onPressed: _toggleConnection,
                    child: Text(
                      isConnected ? 'Disconnect' : 'Connect',
                      style: TextStyle(
                        color: isConnected ? AppColors.error : AppColors.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.xs),
                  ElevatedButton(
                    key: const Key('os_health_sync_now_btn'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: AppColors.background,
                      visualDensity: VisualDensity.compact,
                      shape: const RoundedRectangleBorder(borderRadius: AppRadii.borderFull),
                    ),
                    onPressed: isConnected && !_isSyncing ? _triggerSync : null,
                    child: _isSyncing
                        ? const SizedBox(
                            width: 14,
                            height: 14,
                            child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.background),
                          )
                        : const Text('Sync Now', style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: AppSpacing.sm),

          // Statutory privacy notice
          const Text(
            'Statutory notice: FitKarma syncs observations directly from your on-device health store with affirmative consent. All biometric data is encrypted locally and never transmitted to unauthorized third parties.',
            style: TextStyle(color: AppColors.textSecondary, fontSize: 10, fontStyle: FontStyle.italic),
          ),
        ],
      ),
    );
  }
}
