import 'package:fitkarma/core/routing/app_router_contract.dart';
import 'package:fitkarma/core/routing/app_routes.dart';
import 'package:fitkarma/core/routing/auth_nav_state.dart';
import 'package:fitkarma/core/routing/placeholder_screen.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>(
  debugLabel: 'root',
);

/// Builds the GoRouter instance configured with authentication boundaries and all placeholder routes.
GoRouter createRouter({
  required AuthNavNotifier authNotifier,
  String initialLocation = AppRoutes.onboarding,
}) {
  return GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: initialLocation,
    refreshListenable: authNotifier,
    redirect: (BuildContext context, GoRouterState state) {
      final isAuthenticated = authNotifier.isAuthenticated;
      final matchedLocation = state.matchedLocation;
      final isPublic = AppRoutes.isPublicRoute(matchedLocation);

      // Unauthenticated access to protected route redirects to onboarding
      if (!isAuthenticated && !isPublic) {
        return AppRoutes.onboarding;
      }

      // Authenticated user trying to access public auth/onboarding routes redirects to dashboard
      if (isAuthenticated && isPublic) {
        return AppRoutes.dashboard;
      }

      return null;
    },
    routes: [
      // 1. Unauthenticated routes
      GoRoute(
        path: AppRoutes.onboarding,
        name: 'onboarding',
        builder: (context, state) =>
            const PlaceholderScreen(title: 'Onboarding'),
      ),
      GoRoute(
        path: AppRoutes.login,
        name: 'login',
        builder: (context, state) => const PlaceholderScreen(title: 'Login'),
      ),
      GoRoute(
        path: AppRoutes.otp,
        name: 'otp',
        builder: (context, state) =>
            const PlaceholderScreen(title: 'Phone OTP'),
      ),

      // 2. Authenticated top-level product areas
      GoRoute(
        path: AppRoutes.dashboard,
        name: 'dashboard',
        builder: (context, state) =>
            const PlaceholderScreen(title: 'Dashboard (DIP)'),
      ),
      GoRoute(
        path: AppRoutes.nutrition,
        name: 'nutrition',
        builder: (context, state) =>
            const PlaceholderScreen(title: 'Nutrition'),
        routes: [
          GoRoute(
            path: 'log',
            name: 'nutritionLog',
            builder: (context, state) =>
                const PlaceholderScreen(title: 'Food Log'),
          ),
        ],
      ),
      GoRoute(
        path: AppRoutes.workouts,
        name: 'workouts',
        builder: (context, state) => const PlaceholderScreen(title: 'Workouts'),
      ),
      GoRoute(
        path: AppRoutes.sleep,
        name: 'sleep',
        builder: (context, state) => const PlaceholderScreen(title: 'Sleep'),
      ),
      GoRoute(
        path: AppRoutes.recovery,
        name: 'recovery',
        builder: (context, state) => const PlaceholderScreen(title: 'Recovery'),
      ),
      GoRoute(
        path: AppRoutes.mealAnalyze,
        name: 'mealAnalyze',
        builder: (context, state) =>
            const PlaceholderScreen(title: 'AI Meal Analysis'),
      ),
      GoRoute(
        path: AppRoutes.family,
        name: 'family',
        builder: (context, state) =>
            const PlaceholderScreen(title: 'Family Care Dashboard'),
      ),
      GoRoute(
        path: AppRoutes.subscriptions,
        name: 'subscriptions',
        builder: (context, state) =>
            const PlaceholderScreen(title: 'Subscriptions & UPI'),
      ),
      GoRoute(
        path: AppRoutes.settings,
        name: 'settings',
        builder: (context, state) => const PlaceholderScreen(title: 'Settings'),
      ),
      GoRoute(
        path: AppRoutes.dataVault,
        name: 'dataVault',
        builder: (context, state) =>
            const PlaceholderScreen(title: 'Data Vault'),
      ),
    ],
  );
}

/// Provider managing the active application GoRouter instance.
final appRouterProvider = Provider<GoRouter>((ref) {
  final authNotifier = ref.watch(authNavNotifierProvider);
  return createRouter(authNotifier: authNotifier);
});

/// Implementation of [AppRouterContract] using GoRouter.
class GoRouterAppRouter implements AppRouterContract {
  final GoRouter _router;

  GoRouterAppRouter(this._router);

  @override
  void navigateTo(String path, {Object? extra}) {
    _router.go(path, extra: extra);
  }

  @override
  void replaceWith(String path, {Object? extra}) {
    _router.replace(path, extra: extra);
  }

  @override
  void pop() {
    _router.pop();
  }

  @override
  String get currentRoute {
    final lastMatch = _router.routerDelegate.currentConfiguration.last;
    final matchList = lastMatch is RouteMatchList ? lastMatch : null;
    return matchList?.uri.toString() ?? '';
  }
}

/// Provider exposing [AppRouterContract] abstraction.
final appRouterContractProvider = Provider<AppRouterContract>((ref) {
  final router = ref.watch(appRouterProvider);
  return GoRouterAppRouter(router);
});
