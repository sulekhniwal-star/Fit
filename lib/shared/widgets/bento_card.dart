import 'dart:ui';
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_motion.dart';
import '../theme/app_radii.dart';
import '../theme/app_spacing.dart';

class BentoCard extends StatefulWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final VoidCallback? onTap;
  final Color? backgroundColor;
  final Color? borderColor;

  const BentoCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(AppSpacing.lg),
    this.onTap,
    this.backgroundColor,
    this.borderColor,
  });

  @override
  State<BentoCard> createState() => _BentoCardState();
}

class _BentoCardState extends State<BentoCard> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    Widget card = ClipRRect(
      borderRadius: AppRadii.borderMd,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: widget.padding,
          decoration: BoxDecoration(
            color: widget.backgroundColor ?? AppColors.glassBackground,
            borderRadius: AppRadii.borderMd,
            border: Border.all(
              color: widget.borderColor ?? AppColors.glassBorder,
              width: 1,
            ),
          ),
          child: widget.child,
        ),
      ),
    );

    if (widget.onTap != null) {
      card = GestureDetector(
        onTapDown: (_) => setState(() => _isPressed = true),
        onTapUp: (_) => setState(() => _isPressed = false),
        onTapCancel: () => setState(() => _isPressed = false),
        onTap: widget.onTap,
        child: AnimatedScale(
          scale: _isPressed ? 0.98 : 1.0,
          duration: AppMotion.fast,
          curve: AppMotion.spring,
          child: card,
        ),
      );
    }

    return card;
  }
}

