library;

import 'package:flutter/material.dart';

/// Supported and prepared regional languages for FitKarma.
///
/// Phase 1 MVP active languages are English (`en`) and Hindi (`hi`, हिन्दी).
/// Prepared expansion languages include Tamil (`ta`), Telugu (`te`),
/// Gujarati (`gu`), Bengali (`bn`), Marathi (`mr`), and Punjabi (`pa`).
enum AppLanguage {
  english(
    code: 'en',
    englishName: 'English',
    nativeName: 'English',
    isSupported: true,
  ),
  hindi(
    code: 'hi',
    englishName: 'Hindi',
    nativeName: 'हिन्दी',
    isSupported: true,
  ),
  tamil(
    code: 'ta',
    englishName: 'Tamil',
    nativeName: 'தமிழ்',
    isSupported: false,
  ),
  telugu(
    code: 'te',
    englishName: 'Telugu',
    nativeName: 'తెలుగు',
    isSupported: false,
  ),
  gujarati(
    code: 'gu',
    englishName: 'Gujarati',
    nativeName: 'ગુજરાતી',
    isSupported: false,
  ),
  bengali(
    code: 'bn',
    englishName: 'Bengali',
    nativeName: 'বাংলা',
    isSupported: false,
  ),
  marathi(
    code: 'mr',
    englishName: 'Marathi',
    nativeName: 'मराठी',
    isSupported: false,
  ),
  punjabi(
    code: 'pa',
    englishName: 'Punjabi',
    nativeName: 'ਪੰਜਾਬੀ',
    isSupported: false,
  );

  const AppLanguage({
    required this.code,
    required this.englishName,
    required this.nativeName,
    required this.isSupported,
  });

  /// ISO 639-1 language code.
  final String code;

  /// Display name in English.
  final String englishName;

  /// Native display name in vernacular script.
  final String nativeName;

  /// Whether full UI string translations are bundled and active in the current release.
  final bool isSupported;

  /// Whether this language is in the prepared regional expansion roadmap.
  bool get isPreparedExpansion => !isSupported;

  /// Flutter [Locale] representation for this language.
  Locale get toLocale => Locale(code);

  /// Active supported languages for FitKarma Phase 1.
  static const List<AppLanguage> supportedLanguages = [
    AppLanguage.english,
    AppLanguage.hindi,
  ];

  /// Prepared regional expansion languages.
  static const List<AppLanguage> preparedExpansionLanguages = [
    AppLanguage.tamil,
    AppLanguage.telugu,
    AppLanguage.gujarati,
    AppLanguage.bengali,
    AppLanguage.marathi,
    AppLanguage.punjabi,
  ];

  /// Flutter [Locale] list matching active supported languages.
  static const List<Locale> supportedLocales = [Locale('en'), Locale('hi')];

  /// Resolves an [AppLanguage] from an ISO code string.
  ///
  /// Falls back deterministically to [AppLanguage.english] if the code is unrecognized.
  static AppLanguage fromCode(String? code) {
    if (code == null || code.trim().isEmpty) {
      return AppLanguage.english;
    }
    final normalized = code.trim().toLowerCase();
    for (final lang in AppLanguage.values) {
      if (lang.code == normalized) {
        return lang;
      }
    }
    return AppLanguage.english;
  }

  /// Resolves an [AppLanguage] from a Flutter [Locale].
  static AppLanguage fromLocale(Locale locale) {
    return fromCode(locale.languageCode);
  }
}
