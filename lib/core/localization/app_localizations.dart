import 'package:flutter/material.dart';

class AppLocalizations {
  final Locale locale;

  const AppLocalizations(this.locale);

  static const List<Locale> supportedLocales = [
    Locale('en'),
    Locale('hi'),
  ];

  static const Map<String, Map<String, String>> _localizedValues = {
    'en': {
      'app_title': 'FitKarma Health OS',
      'welcome': 'Welcome to FitKarma',
      'login': 'Sign In',
      'otp_login': 'Sign In with Phone OTP',
      'dashboard': 'Daily Intelligence',
      'nutrition': 'Nutrition',
      'workouts': 'Workouts',
      'profile': 'Health Profile',
      'data_vault': 'Data Vault & Privacy',
      'settings': 'Settings',
      'save': 'Save',
      'cancel': 'Cancel',
      'offline_mode': 'Offline Mode',
      'offline_queued': 'Saved locally. Will sync when reconnected.',
      'streak': 'Day Streak',
      'today_dip': "Today's Package",
    },
    'hi': {
      'app_title': 'फिटकर्मा हेल्थ ओएस',
      'welcome': 'फिटकर्मा में आपका स्वागत है',
      'login': 'साइन इन करें',
      'otp_login': 'फ़ोन ओटीपी से साइन इन करें',
      'dashboard': 'दैनिक स्वास्थ्य पैकेज',
      'nutrition': 'पोषण व आहार',
      'workouts': 'वर्कआउट व कसरत',
      'profile': 'स्वास्थ्य प्रोफ़ाइल',
      'data_vault': 'डेटा वॉल्ट व गोपनीयता',
      'settings': 'सेटिंग्स',
      'save': 'सहेजें',
      'cancel': 'रद्द करें',
      'offline_mode': 'ऑफ़लाइन मोड',
      'offline_queued': 'स्थानीय रूप से सहेजा गया। नेटवर्क मिलने पर सिंक होगा।',
      'streak': 'दिनों का क्रम',
      'today_dip': 'आज का पैकेज',
    },
  };

  String translate(String key) {
    final languageCode = locale.languageCode;
    final currentMap = _localizedValues[languageCode];
    if (currentMap != null && currentMap.containsKey(key)) {
      return currentMap[key]!;
    }
    // Fall back to English
    final fallbackMap = _localizedValues['en']!;
    return fallbackMap[key] ?? key;
  }

  // Convenient typed getters
  String get appTitle => translate('app_title');
  String get welcome => translate('welcome');
  String get login => translate('login');
  String get otpLogin => translate('otp_login');
  String get dashboard => translate('dashboard');
  String get nutrition => translate('nutrition');
  String get workouts => translate('workouts');
  String get profile => translate('profile');
  String get dataVault => translate('data_vault');
  String get settings => translate('settings');
  String get save => translate('save');
  String get cancel => translate('cancel');
  String get offlineMode => translate('offline_mode');
  String get offlineQueued => translate('offline_queued');
  String get streak => translate('streak');
  String get todayDip => translate('today_dip');
}

class AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => ['en', 'hi'].contains(locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) async {
    return AppLocalizations(locale);
  }

  @override
  bool shouldReload(AppLocalizationsDelegate old) => false;
}

