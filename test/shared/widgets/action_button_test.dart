import 'package:fitkarma/shared/theme/app_spacing.dart';
import 'package:fitkarma/shared/widgets/action_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ActionButton Widget Tests (TASK 012)', () {
    testWidgets('ActionButton satisfies minimum 48dp height requirement', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: ActionButton(
                label: 'Save Health Log',
                onPressed: () {},
              ),
            ),
          ),
        ),
      );

      final renderBox = tester.renderObject<RenderBox>(find.byType(ActionButton));
      expect(renderBox.size.height >= AppSpacing.minTouchTarget, true);
      expect(find.text('Save Health Log'), findsOneWidget);
    });

    testWidgets('ActionButton triggers callback when tapped', (WidgetTester tester) async {
      var wasTapped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: ActionButton(
                label: 'Tap Me',
                onPressed: () => wasTapped = true,
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.byType(ActionButton));
      await tester.pumpAndSettle();

      expect(wasTapped, true);
    });
  });
}

