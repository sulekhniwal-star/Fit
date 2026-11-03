import 'package:fitkarma/app/fitkarma_app.dart';
import 'package:fitkarma/core/config/app_config.dart';
import 'package:fitkarma/core/providers/app_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('FitKarma smoke test - application starts', (
    WidgetTester tester,
  ) async {
    const config = AppConfig(
      environment: AppEnvironment.development,
      supabaseUrl: 'https://placeholder.supabase.co',
      supabaseAnonKey: 'placeholder-anon-key',
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [appConfigProvider.overrideWithValue(config)],
        child: const FitKarmaApp(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Onboarding'), findsOneWidget);
  });
}
