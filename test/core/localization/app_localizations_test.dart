import 'package:fitkarma/core/localization/app_localizations.dart';
import 'package:fitkarma/core/localization/locale_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Localization Architecture Tests (TASK 010)', () {
    test('AppLocalizations renders English and Hindi translations', () {
      const en = AppLocalizations(Locale('en'));
      expect(en.dashboard, 'Daily Intelligence');
      expect(en.nutrition, 'Nutrition');
      expect(en.offlineMode, 'Offline Mode');

      const hi = AppLocalizations(Locale('hi'));
      expect(hi.dashboard, 'दैनिक स्वास्थ्य पैकेज');
      expect(hi.nutrition, 'पोषण व आहार');
      expect(hi.offlineMode, 'ऑफ़लाइन मोड');
    });

    test('AppLocalizations falls back to English for missing keys', () {
      const hi = AppLocalizations(Locale('hi'));
      // Translating a key that exists only in English or is unknown
      final fallback = hi.translate('non_existent_hi_key');
      expect(fallback, 'non_existent_hi_key');
    });

    test('LocaleNotifier toggles between English and Hindi', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      expect(container.read(localeProvider), const Locale('en'));

      container.read(localeProvider.notifier).toggleLocale();
      expect(container.read(localeProvider), const Locale('hi'));

      container.read(localeProvider.notifier).toggleLocale();
      expect(container.read(localeProvider), const Locale('en'));
    });
  });
}

