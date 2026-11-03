import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fitkarma/features/cultural/data/aqi_service.dart';
import 'package:fitkarma/features/cultural/presentation/aqi_badge.dart';
import 'package:fitkarma/features/cultural/presentation/aqi_context_card.dart';
import 'package:fitkarma/features/cultural/presentation/aqi_details_sheet.dart';
import 'package:fitkarma/features/cultural/presentation/aqi_state_notifier.dart';

void main() {
  group('AQI Widgets & Presentation Tests', () {
    late AqiService service;

    setUp(() {
      service = AqiService(MockCpcbAqiProvider());
    });

    Widget createTestApp(Widget child) {
      return ProviderScope(
        overrides: [
          aqiServiceProvider.overrideWithValue(service),
        ],
        child: MaterialApp(home: Scaffold(body: child)),
      );
    }

    testWidgets('AqiBadge renders numeric AQI and CPCB color label', (tester) async {
      await tester.pumpWidget(const MaterialApp(
        home: Scaffold(
          body: AqiBadge(aqi: 285),
        ),
      ));

      expect(find.text('285 AQI'), findsOneWidget);
      expect(find.text('(Poor)'), findsOneWidget);
    });

    testWidgets('AqiContextCard renders city name, CPCB badge and opens details sheet', (tester) async {
      await tester.pumpWidget(createTestApp(const AqiContextCard()));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.text('Air Quality: Delhi NCR'), findsOneWidget);
      expect(find.text('285 AQI'), findsOneWidget);
      expect(find.text('View Indoor Alternatives'), findsOneWidget);

      // Tap to open sheet
      await tester.tap(find.text('View Indoor Alternatives'));
      await tester.pumpAndSettle();

      expect(find.byType(AqiDetailsSheet), findsOneWidget);
      expect(find.text('Air Quality Index'), findsOneWidget);
      expect(find.text('Indoor Workout Advised'), findsOneWidget);
      expect(find.textContaining('PM2.5 (Fine)'), findsOneWidget);
    });

    testWidgets('AqiDetailsSheet switches city and recomputes advisory', (tester) async {
      final notifier = AqiStateNotifier(service);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            aqiStateNotifierProvider.overrideWith((ref) => notifier),
          ],
          child: const MaterialApp(
            home: Scaffold(body: AqiDetailsSheet()),
          ),
        ),
      );

      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      // Initial Delhi NCR
      expect(find.text('285 AQI'), findsOneWidget);

      // Select Bengaluru chip
      final bengaluruChip = find.text('Bengaluru');
      expect(bengaluruChip, findsOneWidget);
      await tester.tap(bengaluruChip);
      await tester.pumpAndSettle();

      // Now reflects Bengaluru's satisfactory 68 AQI
      expect(find.text('68 AQI'), findsOneWidget);
      expect(find.text('Outdoor Exercise Safe'), findsOneWidget);
    });
  });
}
