import 'package:flutter/material.dart';

abstract class AppMotion {
  static const Duration fast = Duration(milliseconds: 150);
  static const Duration normal = Duration(milliseconds: 250);
  static const Duration slow = Duration(milliseconds: 400);

  /// Spring physics curve for tactile micro-interactions
  static const Curve spring = Curves.easeOutBack;

  /// Smooth deceleration curve for layout transitions
  static const Curve smooth = Curves.easeOutCubic;
}

