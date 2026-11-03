import 'package:fitkarma/app/fitkarma_app.dart';
import 'package:fitkarma/core/config/app_config.dart';
import 'package:fitkarma/core/providers/app_providers.dart';
import 'package:fitkarma/core/routing/app_router.dart';
import 'package:fitkarma/core/routing/app_routes.dart';
import 'package:fitkarma/core/routing/auth_nav_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const testConfig = AppConfig(
    environment: AppEnvironment.development,
    supabaseUrl: 'https://dev.supabase.co',
    supabaseAnonKey: 'dev-anon-key',
  );

  group('Navigation & Route Architecture', () {
    testWidgets('Unauthenticated user lands on Onboarding by default', (
      WidgetTester tester,
    ) async {
      final authNotifier = AuthNavNotifier();

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            appConfigProvider.overrideWithValue(testConfig),
            authNavNotifierProvider.overrideWith((ref) => authNotifier),
          ],
          child: const FitKarmaApp(),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Onboarding'), findsOneWidget);
    });

    testWidgets(
      'Unauthenticated user redirected to Onboarding when trying to access Dashboard',
      (WidgetTester tester) async {
        final authNotifier = AuthNavNotifier();
        final router = createRouter(
          authNotifier: authNotifier,
          initialLocation: AppRoutes.dashboard,
        );

        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              appConfigProvider.overrideWithValue(testConfig),
              authNavNotifierProvider.overrideWith((ref) => authNotifier),
              appRouterProvider.overrideWithValue(router),
            ],
            child: const FitKarmaApp(),
          ),
        );
        await tester.pumpAndSettle();

        // Should be redirected back to Onboarding
        expect(find.text('Onboarding'), findsOneWidget);
        expect(find.text('Dashboard (DIP)'), findsNothing);
      },
    );

    testWidgets('Unauthenticated user can access Login and OTP public routes', (
      WidgetTester tester,
    ) async {
      final authNotifier = AuthNavNotifier();
      final router = createRouter(
        authNotifier: authNotifier,
        initialLocation: AppRoutes.login,
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            appConfigProvider.overrideWithValue(testConfig),
            authNavNotifierProvider.overrideWith((ref) => authNotifier),
            appRouterProvider.overrideWithValue(router),
          ],
          child: const FitKarmaApp(),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Login'), findsOneWidget);
    });

    testWidgets('Authenticated user redirected from Onboarding to Dashboard', (
      WidgetTester tester,
    ) async {
      final authNotifier = AuthNavNotifier()..setAuthenticated();
      final router = createRouter(
        authNotifier: authNotifier,
        initialLocation: AppRoutes.onboarding,
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            appConfigProvider.overrideWithValue(testConfig),
            authNavNotifierProvider.overrideWith((ref) => authNotifier),
            appRouterProvider.overrideWithValue(router),
          ],
          child: const FitKarmaApp(),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Dashboard (DIP)'), findsOneWidget);
      expect(find.text('Onboarding'), findsNothing);
    });

    final protectedRoutes = [
      {'route': AppRoutes.dashboard, 'title': 'Dashboard (DIP)'},
      {'route': AppRoutes.nutrition, 'title': 'Nutrition'},
      {'route': AppRoutes.nutritionLog, 'title': 'Food Log'},
      {'route': AppRoutes.workouts, 'title': 'Workouts'},
      {'route': AppRoutes.sleep, 'title': 'Sleep'},
      {'route': AppRoutes.recovery, 'title': 'Recovery'},
      {'route': AppRoutes.mealAnalyze, 'title': 'AI Meal Analysis'},
      {'route': AppRoutes.family, 'title': 'Family Care Dashboard'},
      {'route': AppRoutes.subscriptions, 'title': 'Subscriptions & UPI'},
      {'route': AppRoutes.settings, 'title': 'Settings'},
      {'route': AppRoutes.dataVault, 'title': 'Data Vault'},
    ];

    for (final entry in protectedRoutes) {
      testWidgets('Authenticated user can access ${entry['route']}', (
        WidgetTester tester,
      ) async {
        final authNotifier = AuthNavNotifier()..setAuthenticated();
        final router = createRouter(
          authNotifier: authNotifier,
          initialLocation: entry['route']!,
        );

        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              appConfigProvider.overrideWithValue(testConfig),
              authNavNotifierProvider.overrideWith((ref) => authNotifier),
              appRouterProvider.overrideWithValue(router),
            ],
            child: const FitKarmaApp(),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.text(entry['title']!), findsOneWidget);
      });
    }

    testWidgets('Dynamic auth transition reactively updates route location', (
      WidgetTester tester,
    ) async {
      final authNotifier = AuthNavNotifier();
      final router = createRouter(authNotifier: authNotifier);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            appConfigProvider.overrideWithValue(testConfig),
            authNavNotifierProvider.overrideWith((ref) => authNotifier),
            appRouterProvider.overrideWithValue(router),
          ],
          child: const FitKarmaApp(),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Onboarding'), findsOneWidget);

      // Transition to authenticated
      authNotifier.setAuthenticated();
      await tester.pumpAndSettle();

      expect(find.text('Dashboard (DIP)'), findsOneWidget);
    });
  });
}
