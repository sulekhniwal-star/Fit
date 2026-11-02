import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_motion.dart';
import '../theme/app_radii.dart';
import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';

enum ActionButtonVariant {
  primary,
  secondary,
  outline,
}

class ActionButton extends StatefulWidget {
  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool isLoading;
  final ActionButtonVariant variant;

  const ActionButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.isLoading = false,
    this.variant = ActionButtonVariant.primary,
  });

  @override
  State<ActionButton> createState() => _ActionButtonState();
}

class _ActionButtonState extends State<ActionButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final isEnabled = widget.onPressed != null && !widget.isLoading;

    Color backgroundColor;
    Color textColor;
    Border? border;

    switch (widget.variant) {
      case ActionButtonVariant.primary:
        backgroundColor = isEnabled ? AppColors.primary : AppColors.surfaceElevated;
        textColor = isEnabled ? AppColors.background : AppColors.textSecondary;
        border = null;
        break;
      case ActionButtonVariant.secondary:
        backgroundColor = AppColors.surfaceElevated;
        textColor = AppColors.textPrimary;
        border = Border.all(color: AppColors.glassBorder);
        break;
      case ActionButtonVariant.outline:
        backgroundColor = Colors.transparent;
        textColor = AppColors.primary;
        border = Border.all(color: AppColors.primary, width: 1.5);
        break;
    }

    return GestureDetector(
      onTapDown: isEnabled ? (_) => setState(() => _isPressed = true) : null,
      onTapUp: isEnabled ? (_) => setState(() => _isPressed = false) : null,
      onTapCancel: isEnabled ? () => setState(() => _isPressed = false) : null,
      onTap: isEnabled ? widget.onPressed : null,
      child: AnimatedScale(
        scale: _isPressed ? 0.97 : 1.0,
        duration: AppMotion.fast,
        curve: AppMotion.spring,
        child: Container(
          constraints: const BoxConstraints(
            minHeight: AppSpacing.minTouchTarget,
            minWidth: AppSpacing.minTouchTarget,
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.xl,
            vertical: AppSpacing.md,
          ),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: AppRadii.borderSm,
            border: border,
          ),
          child: Center(
            child: widget.isLoading
                ? SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(textColor),
                    ),
                  )
                : Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (widget.icon != null) ...[
                        Icon(widget.icon, size: 18, color: textColor),
                        const SizedBox(width: AppSpacing.sm),
                      ],
                      Text(
                        widget.label,
                        style: AppTypography.button.copyWith(color: textColor),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}

