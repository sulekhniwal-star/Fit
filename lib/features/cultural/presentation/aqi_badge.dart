// ============================================================================
// CPCB AQI BADGE COMPONENT
// ============================================================================

import 'package:flutter/material.dart';
import '../../../shared/theme/app_radii.dart';
import '../domain/aqi_models.dart';

class AqiBadge extends StatelessWidget {
  final int aqi;
  final bool showCategory;
  final bool compact;

  const AqiBadge({
    super.key,
    required this.aqi,
    this.showCategory = true,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    final band = CpcbAqiBand.fromAqi(aqi);

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: compact ? 6 : 10,
        vertical: compact ? 2 : 4,
      ),
      decoration: BoxDecoration(
        color: band.color.withValues(alpha: 0.15),
        borderRadius: AppRadii.borderFull,
        border: Border.all(color: band.color.withValues(alpha: 0.4), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: band.color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            '$aqi AQI',
            style: TextStyle(
              fontSize: compact ? 11 : 12,
              fontWeight: FontWeight.w700,
              color: band.color,
            ),
          ),
          if (showCategory && !compact) ...[
            const SizedBox(width: 4),
            Text(
              '(${band.label})',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: band.color.withValues(alpha: 0.9),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
