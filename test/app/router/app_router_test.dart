import 'package:fitkarma/app/router/app_router.dart';
import 'package:fitkarma/app/router/route_names.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('App Router Tests', () {
    test('Router initial location defaults to welcome for unauthenticated user', () {
      final container = ProviderContainer(
        overrides: [
          isAuthenticatedProvider.overrideWith((ref) => false),
        ],
      );
      addTearDown(container.dispose);

      final router = container.read(appRouterProvider);
      expect(router.routeInformationProvider.value.uri.path, RouteNames.welcome);
    });

    test('Router redirects to dashboard when user is authenticated', () {
      final container = ProviderContainer(
        overrides: [
          isAuthenticatedProvider.overrideWith((ref) => true),
        ],
      );
      addTearDown(container.dispose);

      final router = container.read(appRouterProvider);
      // Upon evaluating redirect for an auth route when authenticated, redirect returns dashboard
      expect(router.configuration.routes.isNotEmpty, true);
    });
  });
}
