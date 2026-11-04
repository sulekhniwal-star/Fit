library;

import 'package:fitkarma/core/localization/app_language.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// Delegate for Flutter localization infrastructure integration.
class AppLocalizationsDelegate extends LocalizationsDelegate<AppStrings> {
  const AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => true;

  @override
  Future<AppStrings> load(Locale locale) {
    return SynchronousFuture<AppStrings>(AppStrings.forLocale(locale));
  }

  @override
  bool shouldReload(AppLocalizationsDelegate old) => false;
}

/// Base contract and canonical English implementation of typed UI strings.
///
/// All strings are statically typed to guarantee zero untyped string-key lookup failures.
/// Any un-translated keys in regional language catalogs fall back cleanly to English.
abstract class AppStrings {
  const AppStrings();

  /// Localization delegate instance for MaterialApp registration.
  static const LocalizationsDelegate<AppStrings> delegate =
      AppLocalizationsDelegate();

  /// Resolves the nearest [AppStrings] in the widget tree.
  ///
  /// Falls back deterministically to [EnglishStrings] if no ancestor localization is found.
  static AppStrings of(BuildContext context) {
    return Localizations.of<AppStrings>(context, AppStrings) ??
        const EnglishStrings();
  }

  // --- Buttons & Actions ---
  String get save;
  String get cancel;
  String get continueText;
  String get retry;
  String get tryAgain;
  String get delete;
  String get done;
  String get edit;
  String get back;
  String get next;
  String get close;
  String get confirm;
  String get dismiss;
  String get apply;
  String get search;
  String get refresh;

  // --- Navigation & Core Modules ---
  String get appTitle;
  String get dashboard;
  String get nutrition;
  String get healthTracking;
  String get family;
  String get dataVault;
  String get profile;
  String get settings;

  // --- Greetings & Dashboard ---
  String get greetingMorning;
  String get greetingAfternoon;
  String get greetingEvening;
  String get dailyScore;
  String get streakCount;
  String get healthStatus;
  String get recentActivity;
  String streakDays(int count);

  // --- Nutrition & Diet ---
  String get logMeal;
  String get fastingActive;
  String get calories;
  String get macros;
  String get protein;
  String get carbs;
  String get fats;
  String get waterIntake;
  String get breakfast;
  String get lunch;
  String get dinner;
  String get snacks;
  String caloriesValue(int amount);
  String waterGlasses(int count);

  // --- Vitals & Biomarkers ---
  String get steps;
  String get heartRate;
  String get sleep;
  String get bloodGlucose;
  String get bloodPressure;
  String get hba1c;
  String get weight;
  String stepsValue(int count);

  // --- UI States & Errors ---
  String get loading;
  String get errorTitle;
  String get errorMessage;
  String get emptyTitle;
  String get emptyMessage;
  String get offlineMode;
  String get syncPending;
  String get syncSuccess;
  String get noInternet;

  // --- Auth & Account ---
  String get login;
  String get logout;
  String get phoneNumber;
  String get verifyOtp;
  String get enterOtp;
  String get resendOtp;
  String get welcomeTitle;
  String get welcomeSubtitle;

  // --- AI Coaching ---
  String get aiCoach;
  String get aiCoachHint;
  String get aiDisclaimer;

  /// Resolves the appropriate [AppStrings] catalog for given [AppLanguage].
  ///
  /// Falls back deterministically to [EnglishStrings] for unreleased or unsupported languages.
  static AppStrings forLanguage(AppLanguage language) {
    switch (language) {
      case AppLanguage.hindi:
        return const HindiStrings();
      case AppLanguage.english:
      case AppLanguage.tamil:
      case AppLanguage.telugu:
      case AppLanguage.gujarati:
      case AppLanguage.bengali:
      case AppLanguage.marathi:
      case AppLanguage.punjabi:
        return const EnglishStrings();
    }
  }

  /// Resolves the appropriate [AppStrings] catalog for given Flutter [Locale].
  static AppStrings forLocale(Locale locale) {
    return forLanguage(AppLanguage.fromLocale(locale));
  }
}

/// Canonical, complete English UI strings catalog for FitKarma.
class EnglishStrings extends AppStrings {
  const EnglishStrings();

  @override
  String get save => 'Save';

  @override
  String get cancel => 'Cancel';

  @override
  String get continueText => 'Continue';

  @override
  String get retry => 'Retry';

  @override
  String get tryAgain => 'Try Again';

  @override
  String get delete => 'Delete';

  @override
  String get done => 'Done';

  @override
  String get edit => 'Edit';

  @override
  String get back => 'Back';

  @override
  String get next => 'Next';

  @override
  String get close => 'Close';

  @override
  String get confirm => 'Confirm';

  @override
  String get dismiss => 'Dismiss';

  @override
  String get apply => 'Apply';

  @override
  String get search => 'Search';

  @override
  String get refresh => 'Refresh';

  @override
  String get appTitle => 'FitKarma';

  @override
  String get dashboard => 'Dashboard';

  @override
  String get nutrition => 'Nutrition';

  @override
  String get healthTracking => 'Health Tracking';

  @override
  String get family => 'Family';

  @override
  String get dataVault => 'Data Vault';

  @override
  String get profile => 'Profile';

  @override
  String get settings => 'Settings';

  @override
  String get greetingMorning => 'Good morning';

  @override
  String get greetingAfternoon => 'Good afternoon';

  @override
  String get greetingEvening => 'Good evening';

  @override
  String get dailyScore => 'Daily Score';

  @override
  String get streakCount => 'Day Streak';

  @override
  String get healthStatus => 'Health Status';

  @override
  String get recentActivity => 'Recent Activity';

  @override
  String streakDays(int count) => '$count day${count == 1 ? '' : 's'} streak';

  @override
  String get logMeal => 'Log Meal';

  @override
  String get fastingActive => 'Fasting Active';

  @override
  String get calories => 'Calories';

  @override
  String get macros => 'Macros';

  @override
  String get protein => 'Protein';

  @override
  String get carbs => 'Carbs';

  @override
  String get fats => 'Fats';

  @override
  String get waterIntake => 'Water Intake';

  @override
  String get breakfast => 'Breakfast';

  @override
  String get lunch => 'Lunch';

  @override
  String get dinner => 'Dinner';

  @override
  String get snacks => 'Snacks';

  @override
  String caloriesValue(int amount) => '$amount kcal';

  @override
  String waterGlasses(int count) => '$count glass${count == 1 ? '' : 'es'}';

  @override
  String get steps => 'Steps';

  @override
  String get heartRate => 'Heart Rate';

  @override
  String get sleep => 'Sleep';

  @override
  String get bloodGlucose => 'Blood Glucose';

  @override
  String get bloodPressure => 'Blood Pressure';

  @override
  String get hba1c => 'HbA1c';

  @override
  String get weight => 'Weight';

  @override
  String stepsValue(int count) => '$count steps';

  @override
  String get loading => 'Loading...';

  @override
  String get errorTitle => 'Something went wrong';

  @override
  String get errorMessage => 'An unexpected error occurred. Please try again.';

  @override
  String get emptyTitle => 'No items found';

  @override
  String get emptyMessage => 'Nothing to display right now.';

  @override
  String get offlineMode => 'Offline Mode';

  @override
  String get syncPending => 'Changes pending sync';

  @override
  String get syncSuccess => 'Synced successfully';

  @override
  String get noInternet => 'No internet connection';

  @override
  String get login => 'Log In';

  @override
  String get logout => 'Log Out';

  @override
  String get phoneNumber => 'Phone Number';

  @override
  String get verifyOtp => 'Verify OTP';

  @override
  String get enterOtp => 'Enter OTP';

  @override
  String get resendOtp => 'Resend OTP';

  @override
  String get welcomeTitle => 'Welcome to FitKarma';

  @override
  String get welcomeSubtitle =>
      'Your holistic, India-first intelligent health operating system.';

  @override
  String get aiCoach => 'FitKarma AI Coach';

  @override
  String get aiCoachHint => 'Ask about meals, workouts, or health stats...';

  @override
  String get aiDisclaimer =>
      'FitKarma provides lifestyle and wellness guidance, not medical diagnosis.';
}

/// Hindi (हिन्दी) UI strings catalog for FitKarma.
///
/// Extends [EnglishStrings] directly so that any un-translated key automatically
/// and deterministically falls back to English without missing string errors.
class HindiStrings extends EnglishStrings {
  const HindiStrings();

  @override
  String get save => 'सहेजें';

  @override
  String get cancel => 'रद्द करें';

  @override
  String get continueText => 'आगे बढ़ें';

  @override
  String get retry => 'पुनः प्रयास करें';

  @override
  String get tryAgain => 'पुनः प्रयास करें';

  @override
  String get delete => 'हटाएं';

  @override
  String get done => 'पूर्ण';

  @override
  String get edit => 'संपादित करें';

  @override
  String get back => 'पीछे';

  @override
  String get next => 'आगे';

  @override
  String get close => 'बंद करें';

  @override
  String get confirm => 'पुष्टि करें';

  @override
  String get dismiss => 'खारिज करें';

  @override
  String get apply => 'लागू करें';

  @override
  String get search => 'खोजें';

  @override
  String get refresh => 'ताज़ा करें';

  @override
  String get appTitle => 'फिटकर्मा';

  @override
  String get dashboard => 'डैशबोर्ड';

  @override
  String get nutrition => 'पोषण';

  @override
  String get healthTracking => 'स्वास्थ्य ट्रैकिंग';

  @override
  String get family => 'परिवार';

  @override
  String get dataVault => 'डेटा वॉल्ट';

  @override
  String get profile => 'प्रोफ़ाइल';

  @override
  String get settings => 'सेटिंग्स';

  @override
  String get greetingMorning => 'शुभ प्रभात';

  @override
  String get greetingAfternoon => 'शुभ दोपहर';

  @override
  String get greetingEvening => 'शुभ संध्या';

  @override
  String get dailyScore => 'दैनिक स्कोर';

  @override
  String get streakCount => 'दिनों का सिलसिला';

  @override
  String get healthStatus => 'स्वास्थ्य स्थिति';

  @override
  String get recentActivity => 'हाल की गतिविधि';

  @override
  String streakDays(int count) => '$count दिनों का सिलसिला';

  @override
  String get logMeal => 'भोजन दर्ज करें';

  @override
  String get fastingActive => 'उपवास सक्रिय';

  @override
  String get calories => 'कैलोरी';

  @override
  String get macros => 'मैक्रोज़';

  @override
  String get protein => 'प्रोटीन';

  @override
  String get carbs => 'कार्ब्स';

  @override
  String get fats => 'वसा';

  @override
  String get waterIntake => 'पानी का सेवन';

  @override
  String get breakfast => 'नाश्ता';

  @override
  String get lunch => 'दोपहर का भोजन';

  @override
  String get dinner => 'रात का भोजन';

  @override
  String get snacks => 'हल्का नाश्ता';

  @override
  String caloriesValue(int amount) => '$amount किलोकैलोरी';

  @override
  String waterGlasses(int count) => '$count गिलास';

  @override
  String get steps => 'कदम';

  @override
  String get heartRate => 'हृदय गति';

  @override
  String get sleep => 'नींद';

  @override
  String get bloodGlucose => 'रक्त शर्करा';

  @override
  String get bloodPressure => 'रक्तचाप';

  @override
  String get hba1c => 'एचबीए1सी';

  @override
  String get weight => 'वजन';

  @override
  String stepsValue(int count) => '$count कदम';

  @override
  String get loading => 'लोड हो रहा है...';

  @override
  String get errorTitle => 'कुछ गड़बड़ हुई';

  @override
  String get errorMessage => 'एक अनपेक्षित त्रुटि हुई। कृपया पुनः प्रयास करें।';

  @override
  String get emptyTitle => 'कोई जानकारी नहीं मिली';

  @override
  String get emptyMessage => 'अभी प्रदर्शित करने के लिए कुछ नहीं है।';

  @override
  String get offlineMode => 'ऑफ़लाइन मोड';

  @override
  String get syncPending => 'सिंक होना बाकी है';

  @override
  String get syncSuccess => 'सफलतापूर्वक सिंक हुआ';

  @override
  String get noInternet => 'इंटरनेट कनेक्शन नहीं है';

  @override
  String get login => 'लॉग इन करें';

  @override
  String get logout => 'लॉग आउट करें';

  @override
  String get phoneNumber => 'फ़ोन नंबर';

  @override
  String get verifyOtp => 'ओटीपी सत्यापित करें';

  @override
  String get enterOtp => 'ओटीपी दर्ज करें';

  @override
  String get resendOtp => 'ओटीपी पुनः भेजें';

  @override
  String get welcomeTitle => 'फिटकर्मा में आपका स्वागत है';

  @override
  String get welcomeSubtitle =>
      'आपका समग्र, भारत-प्रथम बुद्धिमान स्वास्थ्य ऑपरेटिंग सिस्टम।';

  @override
  String get aiCoach => 'फिटकर्मा एआई कोच';

  @override
  String get aiCoachHint =>
      'भोजन, व्यायाम या स्वास्थ्य आंकड़ों के बारे में पूछें...';

  @override
  String get aiDisclaimer =>
      'फिटकर्मा जीवनशैली और कल्याण मार्गदर्शन प्रदान करता है, चिकित्सीय निदान नहीं।';
}
