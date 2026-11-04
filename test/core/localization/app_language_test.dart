import 'package:fitkarma/core/localization/app_language.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AppLanguage Enum & Catalog Specification', () {
    test('contains all 8 required initial and expansion languages', () {
      expect(AppLanguage.values.length, 8);
      expect(AppLanguage.values, contains(AppLanguage.english));
      expect(AppLanguage.values, contains(AppLanguage.hindi));
      expect(AppLanguage.values, contains(AppLanguage.tamil));
      expect(AppLanguage.values, contains(AppLanguage.telugu));
      expect(AppLanguage.values, contains(AppLanguage.gujarati));
      expect(AppLanguage.values, contains(AppLanguage.bengali));
      expect(AppLanguage.values, contains(AppLanguage.marathi));
      expect(AppLanguage.values, contains(AppLanguage.punjabi));
    });

    test('verifies language metadata and ISO codes', () {
      expect(AppLanguage.english.code, 'en');
      expect(AppLanguage.english.englishName, 'English');
      expect(AppLanguage.english.nativeName, 'English');
      expect(AppLanguage.english.isSupported, isTrue);
      expect(AppLanguage.english.isPreparedExpansion, isFalse);

      expect(AppLanguage.hindi.code, 'hi');
      expect(AppLanguage.hindi.englishName, 'Hindi');
      expect(AppLanguage.hindi.nativeName, 'हिन्दी');
      expect(AppLanguage.hindi.isSupported, isTrue);
      expect(AppLanguage.hindi.isPreparedExpansion, isFalse);

      expect(AppLanguage.tamil.code, 'ta');
      expect(AppLanguage.tamil.nativeName, 'தமிழ்');
      expect(AppLanguage.tamil.isSupported, isFalse);
      expect(AppLanguage.tamil.isPreparedExpansion, isTrue);

      expect(AppLanguage.telugu.code, 'te');
      expect(AppLanguage.telugu.nativeName, 'తెలుగు');
      expect(AppLanguage.telugu.isSupported, isFalse);

      expect(AppLanguage.gujarati.code, 'gu');
      expect(AppLanguage.gujarati.nativeName, 'ગુજરાતી');
      expect(AppLanguage.gujarati.isSupported, isFalse);

      expect(AppLanguage.bengali.code, 'bn');
      expect(AppLanguage.bengali.nativeName, 'বাংলা');
      expect(AppLanguage.bengali.isSupported, isFalse);

      expect(AppLanguage.marathi.code, 'mr');
      expect(AppLanguage.marathi.nativeName, 'मराठी');
      expect(AppLanguage.marathi.isSupported, isFalse);

      expect(AppLanguage.punjabi.code, 'pa');
      expect(AppLanguage.punjabi.nativeName, 'ਪੰਜਾਬੀ');
      expect(AppLanguage.punjabi.isSupported, isFalse);
    });

    test('supportedLanguages contains only active Phase 1 languages', () {
      expect(AppLanguage.supportedLanguages, [
        AppLanguage.english,
        AppLanguage.hindi,
      ]);
    });

    test('preparedExpansionLanguages contains 6 regional languages', () {
      expect(AppLanguage.preparedExpansionLanguages, [
        AppLanguage.tamil,
        AppLanguage.telugu,
        AppLanguage.gujarati,
        AppLanguage.bengali,
        AppLanguage.marathi,
        AppLanguage.punjabi,
      ]);
    });

    test('supportedLocales returns matching Flutter Locales', () {
      expect(AppLanguage.supportedLocales, [
        const Locale('en'),
        const Locale('hi'),
      ]);
    });

    test('toLocale returns valid Flutter Locale', () {
      expect(AppLanguage.english.toLocale, const Locale('en'));
      expect(AppLanguage.hindi.toLocale, const Locale('hi'));
      expect(AppLanguage.tamil.toLocale, const Locale('ta'));
    });

    test('fromCode maps codes case-insensitively and handles whitespace', () {
      expect(AppLanguage.fromCode('en'), AppLanguage.english);
      expect(AppLanguage.fromCode('EN'), AppLanguage.english);
      expect(AppLanguage.fromCode(' hi '), AppLanguage.hindi);
      expect(AppLanguage.fromCode('ta'), AppLanguage.tamil);
      expect(AppLanguage.fromCode('te'), AppLanguage.telugu);
      expect(AppLanguage.fromCode('gu'), AppLanguage.gujarati);
      expect(AppLanguage.fromCode('bn'), AppLanguage.bengali);
      expect(AppLanguage.fromCode('mr'), AppLanguage.marathi);
      expect(AppLanguage.fromCode('pa'), AppLanguage.punjabi);
    });

    test(
      'fromCode falls back deterministically to English on unknown codes',
      () {
        expect(AppLanguage.fromCode(null), AppLanguage.english);
        expect(AppLanguage.fromCode(''), AppLanguage.english);
        expect(AppLanguage.fromCode('   '), AppLanguage.english);
        expect(AppLanguage.fromCode('fr'), AppLanguage.english);
        expect(AppLanguage.fromCode('es'), AppLanguage.english);
        expect(AppLanguage.fromCode('unknown_xyz'), AppLanguage.english);
      },
    );

    test('fromLocale maps Flutter Locale properly', () {
      expect(AppLanguage.fromLocale(const Locale('en')), AppLanguage.english);
      expect(AppLanguage.fromLocale(const Locale('hi')), AppLanguage.hindi);
      expect(AppLanguage.fromLocale(const Locale('de')), AppLanguage.english);
    });
  });
}
