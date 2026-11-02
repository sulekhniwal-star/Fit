import 'package:fitkarma/shared/accessibility/accessibility_helpers.dart';
import 'package:fitkarma/shared/theme/app_spacing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Accessibility Helpers Tests (TASK 011)', () {
    testWidgets('MinTouchTarget enforces at least 48x48dp hit area', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: MinTouchTarget(
                semanticLabel: 'Small icon button',
                onTap: () {},
                child: const SizedBox(width: 16, height: 16),
              ),
            ),
          ),
        ),
      );

      final renderBox = tester.renderObject<RenderBox>(find.byType(MinTouchTarget));
      expect(renderBox.size.width >= AppSpacing.minTouchTarget, true);
      expect(renderBox.size.height >= AppSpacing.minTouchTarget, true);
    });

    testWidgets('Components render cleanly under 1.5x text scale factor', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: MediaQuery(
              data: MediaQueryData(
                textScaler: TextScaler.linear(1.5),
              ),
              child: BoundedTextScale(
                child: Column(
                  children: [
                    Text('FitKarma Large Text Title', style: TextStyle(fontSize: 24)),
                    Text('Health OS Telemetry Information Subtitle', style: TextStyle(fontSize: 16)),
                  ],
                ),
              ),
            ),
          ),
        ),
      );

      expect(tester.takeException(), isNull);
      expect(find.text('FitKarma Large Text Title'), findsOneWidget);
    });
  });
}
