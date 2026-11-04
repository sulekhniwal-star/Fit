import 'package:fitkarma/core/localization/app_language.dart';
import 'package:fitkarma/core/localization/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

// Partial test catalog demonstrating fallback behavior
class _TestPartialRegionalStrings extends EnglishStrings {
  const _TestPartialRegionalStrings();

  @override
  String get dashboard => 'रीजनल डैशबोर्ड';
  // All other strings omitted to test fallback to English
}

void main() {
  group('AppStrings Typed Catalogs & Deterministic Fallback', () {
    test('EnglishStrings contains non-empty strings across all categories', () {
      const en = EnglishStrings();

      // Buttons & Actions
      expect(en.save, 'Save');
      expect(en.cancel, 'Cancel');
      expect(en.continueText, 'Continue');
      expect(en.retry, 'Retry');
      expect(en.tryAgain, 'Try Again');
      expect(en.delete, 'Delete');
      expect(en.done, 'Done');
      expect(en.edit, 'Edit');
      expect(en.back, 'Back');
      expect(en.next, 'Next');
      expect(en.close, 'Close');
      expect(en.confirm, 'Confirm');
      expect(en.dismiss, 'Dismiss');
      expect(en.apply, 'Apply');
      expect(en.search, 'Search');
      expect(en.refresh, 'Refresh');

      // Navigation & Core Modules
      expect(en.appTitle, 'FitKarma');
      expect(en.dashboard, 'Dashboard');
      expect(en.nutrition, 'Nutrition');
      expect(en.healthTracking, 'Health Tracking');
      expect(en.family, 'Family');
      expect(en.dataVault, 'Data Vault');
      expect(en.profile, 'Profile');
      expect(en.settings, 'Settings');

      // Greetings & Dashboard
      expect(en.greetingMorning, 'Good morning');
      expect(en.greetingAfternoon, 'Good afternoon');
      expect(en.greetingEvening, 'Good evening');
      expect(en.dailyScore, 'Daily Score');
      expect(en.streakCount, 'Day Streak');
      expect(en.healthStatus, 'Health Status');
      expect(en.recentActivity, 'Recent Activity');
      expect(en.streakDays(1), '1 day streak');
      expect(en.streakDays(7), '7 days streak');

      // Nutrition & Diet
      expect(en.logMeal, 'Log Meal');
      expect(en.fastingActive, 'Fasting Active');
      expect(en.calories, 'Calories');
      expect(en.macros, 'Macros');
      expect(en.protein, 'Protein');
      expect(en.carbs, 'Carbs');
      expect(en.fats, 'Fats');
      expect(en.waterIntake, 'Water Intake');
      expect(en.breakfast, 'Breakfast');
      expect(en.lunch, 'Lunch');
      expect(en.dinner, 'Dinner');
      expect(en.snacks, 'Snacks');
      expect(en.caloriesValue(1850), '1850 kcal');
      expect(en.waterGlasses(1), '1 glass');
      expect(en.waterGlasses(8), '8 glasses');

      // Vitals & Biomarkers
      expect(en.steps, 'Steps');
      expect(en.heartRate, 'Heart Rate');
      expect(en.sleep, 'Sleep');
      expect(en.bloodGlucose, 'Blood Glucose');
      expect(en.bloodPressure, 'Blood Pressure');
      expect(en.hba1c, 'HbA1c');
      expect(en.weight, 'Weight');
      expect(en.stepsValue(10000), '10000 steps');

      // UI States & Errors
      expect(en.loading, 'Loading...');
      expect(en.errorTitle, 'Something went wrong');
      expect(en.errorMessage, contains('Please try again'));
      expect(en.emptyTitle, 'No items found');
      expect(en.emptyMessage, 'Nothing to display right now.');
      expect(en.offlineMode, 'Offline Mode');
      expect(en.syncPending, 'Changes pending sync');
      expect(en.syncSuccess, 'Synced successfully');
      expect(en.noInternet, 'No internet connection');

      // Auth & Account
      expect(en.login, 'Log In');
      expect(en.logout, 'Log Out');
      expect(en.phoneNumber, 'Phone Number');
      expect(en.verifyOtp, 'Verify OTP');
      expect(en.enterOtp, 'Enter OTP');
      expect(en.resendOtp, 'Resend OTP');
      expect(en.welcomeTitle, 'Welcome to FitKarma');
      expect(en.welcomeSubtitle, contains('India-first'));

      // AI Coaching
      expect(en.aiCoach, 'FitKarma AI Coach');
      expect(en.aiCoachHint, contains('meals, workouts'));
      expect(en.aiDisclaimer, contains('not medical diagnosis'));
    });

    test('HindiStrings overrides catalog with vernacular translations', () {
      const hi = HindiStrings();

      // Buttons & Actions
      expect(hi.save, 'सहेजें');
      expect(hi.cancel, 'रद्द करें');
      expect(hi.continueText, 'आगे बढ़ें');
      expect(hi.retry, 'पुनः प्रयास करें');
      expect(hi.tryAgain, 'पुनः प्रयास करें');
      expect(hi.delete, 'हटाएं');
      expect(hi.done, 'पूर्ण');
      expect(hi.edit, 'संपादित करें');
      expect(hi.back, 'पीछे');
      expect(hi.next, 'आगे');
      expect(hi.close, 'बंद करें');
      expect(hi.confirm, 'पुष्टि करें');
      expect(hi.dismiss, 'खारिज करें');
      expect(hi.apply, 'लागू करें');
      expect(hi.search, 'खोजें');
      expect(hi.refresh, 'ताज़ा करें');

      // Navigation & Core Modules
      expect(hi.appTitle, 'फिटकर्मा');
      expect(hi.dashboard, 'डैशबोर्ड');
      expect(hi.nutrition, 'पोषण');
      expect(hi.healthTracking, 'स्वास्थ्य ट्रैकिंग');
      expect(hi.family, 'परिवार');
      expect(hi.dataVault, 'डेटा वॉल्ट');
      expect(hi.profile, 'प्रोफ़ाइल');
      expect(hi.settings, 'सेटिंग्स');

      // Greetings & Dashboard
      expect(hi.greetingMorning, 'शुभ प्रभात');
      expect(hi.greetingAfternoon, 'शुभ दोपहर');
      expect(hi.greetingEvening, 'शुभ संध्या');
      expect(hi.dailyScore, 'दैनिक स्कोर');
      expect(hi.streakCount, 'दिनों का सिलसिला');
      expect(hi.healthStatus, 'स्वास्थ्य स्थिति');
      expect(hi.recentActivity, 'हाल की गतिविधि');
      expect(hi.streakDays(5), '5 दिनों का सिलसिला');

      // Nutrition
      expect(hi.logMeal, 'भोजन दर्ज करें');
      expect(hi.fastingActive, 'उपवास सक्रिय');
      expect(hi.calories, 'कैलोरी');
      expect(hi.macros, 'मैक्रोज़');
      expect(hi.protein, 'प्रोटीन');
      expect(hi.carbs, 'कार्ब्स');
      expect(hi.fats, 'वसा');
      expect(hi.waterIntake, 'पानी का सेवन');
      expect(hi.caloriesValue(2000), '2000 किलोकैलोरी');
      expect(hi.waterGlasses(5), '5 गिलास');

      // Vitals
      expect(hi.steps, 'कदम');
      expect(hi.heartRate, 'हृदय गति');
      expect(hi.sleep, 'नींद');
      expect(hi.bloodGlucose, 'रक्त शर्करा');
      expect(hi.bloodPressure, 'रक्तचाप');
      expect(hi.hba1c, 'एचबीए1सी');
      expect(hi.weight, 'वजन');
      expect(hi.stepsValue(8000), '8000 कदम');

      // UI States
      expect(hi.loading, 'लोड हो रहा है...');
      expect(hi.errorTitle, 'कुछ गड़बड़ हुई');
      expect(hi.emptyTitle, 'कोई जानकारी नहीं मिली');
      expect(hi.offlineMode, 'ऑफ़लाइन मोड');
      expect(hi.syncPending, 'सिंक होना बाकी है');
      expect(hi.syncSuccess, 'सफलतापूर्वक सिंक हुआ');
      expect(hi.noInternet, 'इंटरनेट कनेक्शन नहीं है');

      // Auth
      expect(hi.login, 'लॉग इन करें');
      expect(hi.logout, 'लॉग आउट करें');
      expect(hi.phoneNumber, 'फ़ोन नंबर');
      expect(hi.verifyOtp, 'ओटीपी सत्यापित करें');
      expect(hi.welcomeTitle, 'फिटकर्मा में आपका स्वागत है');

      // AI Coach
      expect(hi.aiCoach, 'फिटकर्मा एआई कोच');
    });

    test('Missing translation keys fall back deterministically to English', () {
      const partial = _TestPartialRegionalStrings();

      // Custom overridden key returns regional translation
      expect(partial.dashboard, 'रीजनल डैशबोर्ड');

      // Unimplemented keys fall back to EnglishStrings cleanly
      expect(partial.save, 'Save');
      expect(partial.cancel, 'Cancel');
      expect(partial.nutrition, 'Nutrition');
      expect(partial.dailyScore, 'Daily Score');
      expect(partial.loading, 'Loading...');
      expect(partial.errorTitle, 'Something went wrong');
    });

    test(
      'AppStrings.forLanguage returns Hindi for hindi, English for all else',
      () {
        expect(
          AppStrings.forLanguage(AppLanguage.english),
          isA<EnglishStrings>(),
        );
        expect(AppStrings.forLanguage(AppLanguage.hindi), isA<HindiStrings>());

        // Expansion languages fall back to English
        expect(
          AppStrings.forLanguage(AppLanguage.tamil),
          isA<EnglishStrings>(),
        );
        expect(
          AppStrings.forLanguage(AppLanguage.telugu),
          isA<EnglishStrings>(),
        );
        expect(
          AppStrings.forLanguage(AppLanguage.gujarati),
          isA<EnglishStrings>(),
        );
        expect(
          AppStrings.forLanguage(AppLanguage.bengali),
          isA<EnglishStrings>(),
        );
        expect(
          AppStrings.forLanguage(AppLanguage.marathi),
          isA<EnglishStrings>(),
        );
        expect(
          AppStrings.forLanguage(AppLanguage.punjabi),
          isA<EnglishStrings>(),
        );
      },
    );

    test('AppStrings.forLocale resolves appropriately with fallback', () {
      expect(AppStrings.forLocale(const Locale('en')), isA<EnglishStrings>());
      expect(AppStrings.forLocale(const Locale('hi')), isA<HindiStrings>());
      expect(AppStrings.forLocale(const Locale('ta')), isA<EnglishStrings>());
      expect(AppStrings.forLocale(const Locale('fr')), isA<EnglishStrings>());
    });

    test(
      'AppLocalizationsDelegate loads catalogs and reports support',
      () async {
        const delegate = AppStrings.delegate;

        expect(delegate.isSupported(const Locale('en')), isTrue);
        expect(delegate.isSupported(const Locale('hi')), isTrue);
        expect(delegate.isSupported(const Locale('unknown')), isTrue);

        final hiStrings = await delegate.load(const Locale('hi'));
        expect(hiStrings, isA<HindiStrings>());

        final enStrings = await delegate.load(const Locale('en'));
        expect(enStrings, isA<EnglishStrings>());

        final frStrings = await delegate.load(const Locale('fr'));
        expect(frStrings, isA<EnglishStrings>());

        expect(delegate.shouldReload(delegate), isFalse);
      },
    );
  });
}
