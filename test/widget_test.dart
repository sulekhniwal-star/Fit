import 'package:fitkarma/core/config/app_config.dart';
import 'package:fitkarma/core/providers/app_providers.dart';
import 'package:fitkarma/main.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('FitKarma smoke test - boots cleanly with Riverpod', (WidgetTester tester) async {
    final testConfig = AppConfig.development();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          appConfigProvider.overrideWithValue(testConfig),
        ],
        child: const FitKarmaApp(),
      ),
    );

    expect(find.text('FitKarma Health OS'), findsOneWidget);
    expect(find.text('Env: development'), findsOneWidget);
  });
}
