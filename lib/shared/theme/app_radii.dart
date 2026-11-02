import 'package:flutter/material.dart';

abstract class AppRadii {
  static const double xs = 6.0;
  static const double sm = 10.0;
  static const double md = 16.0; // Standard Bento card radius
  static const double lg = 24.0;
  static const double full = 999.0;

  static const BorderRadius borderXs = BorderRadius.all(Radius.circular(xs));
  static const BorderRadius borderSm = BorderRadius.all(Radius.circular(sm));
  static const BorderRadius borderMd = BorderRadius.all(Radius.circular(md));
  static const BorderRadius borderLg = BorderRadius.all(Radius.circular(lg));
  static const BorderRadius borderFull = BorderRadius.all(Radius.circular(full));
}

