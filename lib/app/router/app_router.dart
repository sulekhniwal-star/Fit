import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../features/health/presentation/health_dashboard_screen.dart';
import '../../features/nutrition/presentation/nutrition_dashboard_screen.dart';
import 'route_names.dart';

final isAuthenticatedProvider = StateProvider<bool>((ref) => false);

final appRouterProvider = Provider<GoRouter>((ref) {
  final isAuthenticated = ref.watch(isAuthenticatedProvider);

  return GoRouter(
    initialLocation: RouteNames.welcome,
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
        builder: (context, state) => const _PlaceholderScreen(title: 'Welcome to FitKarma'),
      ),
      GoRoute(
        path: RouteNames.otpLogin,
        builder: (context, state) => const _PlaceholderScreen(title: 'OTP Login'),
      ),
      GoRoute(
        path: RouteNames.onboarding,
        builder: (context, state) => const _PlaceholderScreen(title: 'Onboarding'),
      ),
      GoRoute(
        path: RouteNames.dashboard,
        builder: (context, state) => const HealthDashboardScreen(),
      ),
      GoRoute(
        path: RouteNames.nutrition,
        builder: (context, state) => const NutritionDashboardScreen(),
      ),
      GoRoute(
        path: RouteNames.workouts,
        builder: (context, state) => const _PlaceholderScreen(title: 'Workouts'),
      ),
      GoRoute(
        path: RouteNames.profile,
        builder: (context, state) => const _PlaceholderScreen(title: 'Profile'),
      ),
      GoRoute(
        path: RouteNames.dataVault,
        builder: (context, state) => const _PlaceholderScreen(title: 'DPDP Data Vault'),
      ),
      GoRoute(
        path: RouteNames.settings,
        builder: (context, state) => const _PlaceholderScreen(title: 'Settings'),
      ),
    ],
  );
});

class _PlaceholderScreen extends StatelessWidget {
  final String title;
  const _PlaceholderScreen({required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0F12),
      appBar: AppBar(
        title: Text(title),
        backgroundColor: const Color(0xFF16191E),
      ),
      body: Center(
        child: Text(
          title,
          style: const TextStyle(color: Colors.white, fontSize: 20),
        ),
      ),
    );
  }
}

