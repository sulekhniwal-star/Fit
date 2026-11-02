import 'package:fitkarma/shared/widgets/bento_card.dart';
import 'package:fitkarma/shared/widgets/metric_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Bento & Metric Card Tests (TASK 012)', () {
    testWidgets('BentoCard renders child content inside glassmorphic surface', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: BentoCard(
              child: Text('Bento Card Body'),
            ),
          ),
        ),
      );

      expect(find.text('Bento Card Body'), findsOneWidget);
      expect(find.byType(BackdropFilter), findsOneWidget);
    });

    testWidgets('MetricCard displays title, large value, and unit correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: MetricCard(
              title: 'Daily Steps',
              value: '8,450',
              unit: 'steps',
              subtitle: '84% of daily goal',
              icon: Icons.directions_walk,
            ),
          ),
        ),
      );

      expect(find.text('Daily Steps'), findsOneWidget);
      expect(find.text('8,450'), findsOneWidget);
      expect(find.text('steps'), findsOneWidget);
      expect(find.text('84% of daily goal'), findsOneWidget);
    });
  });
}
