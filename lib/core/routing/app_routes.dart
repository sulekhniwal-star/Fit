/// Centralized route definitions for FitKarma.
class AppRoutes {
  AppRoutes._();

  // Unauthenticated routes
  static const String onboarding = '/onboarding';
  static const String login = '/auth/login';
  static const String otp = '/auth/otp';

  // Authenticated top-level product areas
  static const String dashboard = '/dashboard';
  static const String nutrition = '/nutrition';
  static const String nutritionLog = '/nutrition/log';
  static const String workouts = '/workouts';
  static const String sleep = '/sleep';
  static const String recovery = '/recovery';
  static const String mealAnalyze = '/ai/meal-analyze';
  static const String family = '/family';
  static const String subscriptions = '/subscriptions';
  static const String settings = '/settings';
  static const String dataVault = '/data-vault';

  /// List of public / unauthenticated routes
  static const Set<String> publicRoutes = {onboarding, login, otp};

  /// Checks if a route path is considered public / unauthenticated
  static bool isPublicRoute(String path) {
    return publicRoutes.contains(path);
  }
}
