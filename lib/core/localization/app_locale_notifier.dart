library;

import 'package:fitkarma/core/localization/ai_phrasing_config.dart';
import 'package:fitkarma/core/localization/app_language.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// StateNotifier managing the active application locale and language in-memory.
///
/// Modifying the active language updates the UI immediately without requiring an app restart.
class AppLocaleNotifier extends StateNotifier<AppLanguage> {
  AppLocaleNotifier([super.state = AppLanguage.english]);

  /// Sets the active UI language.
  void setLanguage(AppLanguage language) {
    if (state != language) {
      state = language;
    }
  }

  /// Sets the active UI language from a Flutter [Locale].
  void setLocale(Locale locale) {
    final language = AppLanguage.fromLocale(locale);
    setLanguage(language);
  }

  /// Toggles between primary supported languages (English and Hindi).
  void toggleLanguage() {
    if (state == AppLanguage.english) {
      state = AppLanguage.hindi;
    } else {
      state = AppLanguage.english;
    }
  }
}

/// StateNotifier managing independent AI conversational phrasing and tone configuration.
class AiPhrasingConfigNotifier extends StateNotifier<AiPhrasingConfig> {
  AiPhrasingConfigNotifier([super.state = const AiPhrasingConfig()]);

  /// Updates the dialect for conversational LLM responses.
  void updateDialect(AppLanguage dialect) {
    state = state.copyWith(dialect: dialect);
  }

  /// Updates the Hinglish lexical mix ratio.
  void updateHinglishMixRatio(HinglishMixRatio ratio) {
    state = state.copyWith(hinglishMixRatio: ratio);
  }

  /// Updates the AI coaching tone persona.
  void updateCoachingTone(CoachingTone tone) {
    state = state.copyWith(coachingTone: tone);
  }

  /// Toggles fasting and religious calendar awareness for meal coaching.
  void setFastingAwareness({required bool enabled}) {
    state = state.copyWith(fastingAwareness: enabled);
  }

  /// Replaces the entire AI phrasing configuration.
  void updateConfig(AiPhrasingConfig config) {
    state = config;
  }
}
