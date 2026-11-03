import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/config/app_config.dart';
import '../../core/providers/app_providers.dart';
import '../../features/ai/presentation/ai_meal_text_logger_sheet.dart';
import '../../features/ai/presentation/photo_food_logger_screen.dart';
import '../../features/auth/presentation/otp_verification_screen.dart';
import '../../features/auth/presentation/phone_login_screen.dart';
import '../../features/brain/presentation/home_dashboard_screen.dart';
import '../../features/cultural/presentation/fasting_screen.dart';
import '../../features/health/presentation/health_dashboard_screen.dart';
import '../../features/nutrition/presentation/nutrition_dashboard_screen.dart';
import '../../features/onboarding/presentation/onboarding_wizard_screen.dart';
import '../../features/os_health/presentation/os_health_settings_screen.dart';
import '../../features/workout/presentation/active_workout_screen.dart';
import '../../features/workout/presentation/workout_dashboard_screen.dart';
import 'route_names.dart';

final isAuthenticatedProvider = StateProvider<bool>((ref) {
  final config = ref.watch(appConfigProvider);
  // Default to authenticated in development mode so developers land directly on the main dashboard
  return config.isDevelopment;
});

final appRouterProvider = Provider<GoRouter>((ref) {
  final isAuthenticated = ref.watch(isAuthenticatedProvider);

  return GoRouter(
    initialLocation: isAuthenticated ? RouteNames.dashboard : RouteNames.welcome,
    redirect: (context, state) {
      final isAuthRoute = state.matchedLocation == RouteNames.welcome ||
          state.matchedLocation == RouteNames.otpLogin ||
          state.matchedLocation == RouteNames.splash;

      if (!isAuthenticated && !isAuthRoute) {
        return RouteNames.welcome;
      }

      if (isAuthenticated && isAuthRoute) {
        return RouteNames.dashboard;
      }

      return null;
    },
    routes: [
      GoRoute(
        path: RouteNames.welcome,
        builder: (context, state) => const PhoneLoginScreen(),
      ),
      GoRoute(
        path: RouteNames.otpLogin,
        builder: (context, state) {
          final phone = state.extra as String? ?? '9876543210';
          return OtpVerificationScreen(phoneNumber: phone);
        },
      ),
      GoRoute(
        path: RouteNames.onboarding,
        builder: (context, state) => OnboardingWizardScreen(
          onCompleted: () => context.go(RouteNames.dashboard),
        ),
      ),
      GoRoute(
        path: RouteNames.dashboard,
        builder: (context, state) => const HomeDashboardScreen(),
      ),
      GoRoute(
        path: RouteNames.nutrition,
        builder: (context, state) => const NutritionDashboardScreen(),
      ),
      GoRoute(
        path: RouteNames.aiTextMeal,
        builder: (context, state) => Scaffold(
          appBar: AppBar(
            title: const Text('AI Meal Description'),
            backgroundColor: const Color(0xFF16191E),
          ),
          backgroundColor: const Color(0xFF0D0F12),
          body: const SafeArea(child: AiMealTextLoggerSheet()),
        ),
      ),
      GoRoute(
        path: RouteNames.aiPhotoMeal,
        builder: (context, state) => const PhotoFoodLoggerScreen(),
      ),
      GoRoute(
        path: RouteNames.workouts,
        builder: (context, state) => const WorkoutDashboardScreen(),
      ),
      GoRoute(
        path: RouteNames.activeWorkout,
        builder: (context, state) => const ActiveWorkoutScreen(),
      ),
      GoRoute(
        path: RouteNames.fasting,
        builder: (context, state) => const FastingScreen(),
      ),
      GoRoute(
        path: RouteNames.health,
        builder: (context, state) => const HealthDashboardScreen(),
      ),
      GoRoute(
        path: RouteNames.profile,
        builder: (context, state) => OnboardingWizardScreen(
          onCompleted: () => context.go(RouteNames.dashboard),
        ),
      ),
      GoRoute(
        path: RouteNames.dataVault,
        builder: (context, state) => const OsHealthSettingsScreen(),
      ),
      GoRoute(
        path: RouteNames.settings,
        builder: (context, state) => const OsHealthSettingsScreen(),
      ),
    ],
  );
});
