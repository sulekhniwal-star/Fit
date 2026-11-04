import 'package:fitkarma/shared/presentation/accessibility/accessible_semantics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Accessible Semantics, Screen-Reader Labels & Non-Color-Only Indicators',
      () {
    testWidgets(
        'AccessibleSemantics.ordered applies OrdinalSortKey for traversal',
        (WidgetTester tester) async {
      final handle = tester.ensureSemantics();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Column(
              children: [
                AccessibleSemantics.ordered(
                  order: 2.0,
                  child: const Text('Secondary Item'),
                ),
                AccessibleSemantics.ordered(
                  order: 1.0,
                  child: const Text('Primary Item'),
                ),
              ],
            ),
          ),
        ),
      );

      final semanticsFinder1 = find.byWidgetPredicate(
        (widget) =>
            widget is Semantics &&
            widget.properties.sortKey is OrdinalSortKey &&
            (widget.properties.sortKey! as OrdinalSortKey).order == 1.0,
      );
      final semanticsFinder2 = find.byWidgetPredicate(
        (widget) =>
            widget is Semantics &&
            widget.properties.sortKey is OrdinalSortKey &&
            (widget.properties.sortKey! as OrdinalSortKey).order == 2.0,
      );

      expect(semanticsFinder1, findsOneWidget);
      expect(semanticsFinder2, findsOneWidget);

      handle.dispose();
    });

    testWidgets(
      'AccessibleSemantics.biomarker synthesizes metric, unit, and health status label',
      (WidgetTester tester) async {
        final handle = tester.ensureSemantics();

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: AccessibleSemantics.biomarker(
                metricName: 'Blood Glucose',
                value: '95',
                unit: 'mg/dL',
                status: 'Optimal',
                child: const Text('95 mg/dL'),
              ),
            ),
          ),
        );

        final semantics = tester.getSemantics(find.text('95 mg/dL'));
        expect(
          semantics.label,
          'Blood Glucose: 95 mg/dL, status: Optimal',
        );

        handle.dispose();
      },
    );

    testWidgets(
      'AccessibleStatusBadge conveys state with text, icon, and semantics without relying on color alone',
      (WidgetTester tester) async {
        final handle = tester.ensureSemantics();

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Column(
                children: [
                  AccessibleStatusBadge.optimal(label: 'Optimal Zone'),
                  AccessibleStatusBadge.warning(label: 'Caution Window'),
                  AccessibleStatusBadge.alert(label: 'Sync Disconnected'),
                ],
              ),
            ),
          ),
        );

        // Optimal status
        expect(find.text('Optimal Zone'), findsOneWidget);
        expect(find.byIcon(Icons.check_circle_outline), findsOneWidget);
        expect(
          find.bySemanticsLabel('Status: Optimal Zone'),
          findsOneWidget,
        );

        // Warning status
        expect(find.text('Caution Window'), findsOneWidget);
        expect(find.byIcon(Icons.warning_amber_rounded), findsOneWidget);
        expect(
          find.bySemanticsLabel('Status: Caution Window'),
          findsOneWidget,
        );

        // Alert status
        expect(find.text('Sync Disconnected'), findsOneWidget);
        expect(find.byIcon(Icons.error_outline), findsOneWidget);
        expect(
          find.bySemanticsLabel('Status: Sync Disconnected'),
          findsOneWidget,
        );

        handle.dispose();
      },
    );
  });
}
