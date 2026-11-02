import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LocaleNotifier extends StateNotifier<Locale> {
  LocaleNotifier([Locale initialLocale = const Locale('en')]) : super(initialLocale);

  void setLocale(Locale newLocale) {
    if (newLocale.languageCode == 'en' || newLocale.languageCode == 'hi') {
      state = newLocale;
    }
  }

  void toggleLocale() {
    if (state.languageCode == 'en') {
      state = const Locale('hi');
    } else {
      state = const Locale('en');
    }
  }
}

final localeProvider = StateNotifierProvider<LocaleNotifier, Locale>((ref) {
  return LocaleNotifier();
});
