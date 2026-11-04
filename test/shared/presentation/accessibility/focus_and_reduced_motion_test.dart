import 'package:fitkarma/shared/presentation/accessibility/accessible_focus.dart';
import 'package:fitkarma/shared/presentation/accessibility/reduced_motion_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Focus Management & Reduced Motion Preferences', () {
    testWidgets(
      'AccessibleFocus gains focus and responds to Enter and Space keys',
      (WidgetTester tester) async {
        var tapCount = 0;
        final focusNode = FocusNode();
        addTearDown(focusNode.dispose);

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: AccessibleFocus(
                focusNode: focusNode,
                onTap: () => tapCount++,
                child: const Text('Interactive Card'),
              ),
            ),
          ),
        );

        expect(focusNode.hasFocus, isFalse);

        // Request focus
        focusNode.requestFocus();
        await tester.pumpAndSettle();
        expect(focusNode.hasFocus, isTrue);

        // Send Enter key
        await tester.sendKeyEvent(LogicalKeyboardKey.enter);
        await tester.pumpAndSettle();
        expect(tapCount, 1);

        // Send Space key
        await tester.sendKeyEvent(LogicalKeyboardKey.space);
        await tester.pumpAndSettle();
        expect(tapCount, 2);
      },
    );

    testWidgets(
      'ReducedMotionHelper suppresses animations and adjusts duration when disableAnimations is active',
      (WidgetTester tester) async {
        bool? prefersReduced;
        Duration? activeDuration;
        Curve? activeCurve;

        await tester.pumpWidget(
          MaterialApp(
            home: MediaQuery(
              data: const MediaQueryData(disableAnimations: true),
              child: Builder(
                builder: (context) {
                  prefersReduced = ReducedMotionHelper.prefersReducedMotion(
                    context,
                  );
                  activeDuration = ReducedMotionHelper.duration(
                    context,
                    const Duration(milliseconds: 350),
                  );
                  activeCurve = ReducedMotionHelper.curve(
                    context,
                    Curves.easeOutCubic,
                  );
                  return const SizedBox();
                },
              ),
            ),
          ),
        );

        expect(prefersReduced, isTrue);
        expect(activeDuration, Duration.zero);
        expect(activeCurve, Curves.linear);
      },
    );

    testWidgets(
      'ReducedMotionHelper preserves standard animations when disableAnimations is false',
      (WidgetTester tester) async {
        bool? prefersReduced;
        Duration? activeDuration;
        Curve? activeCurve;

        await tester.pumpWidget(
          MaterialApp(
            home: MediaQuery(
              data: const MediaQueryData(disableAnimations: false),
              child: Builder(
                builder: (context) {
                  prefersReduced = ReducedMotionHelper.prefersReducedMotion(
                    context,
                  );
                  activeDuration = ReducedMotionHelper.duration(
                    context,
                    const Duration(milliseconds: 350),
                  );
                  activeCurve = ReducedMotionHelper.curve(
                    context,
                    Curves.easeOutCubic,
                  );
                  return const SizedBox();
                },
              ),
            ),
          ),
        );

        expect(prefersReduced, isFalse);
        expect(activeDuration, const Duration(milliseconds: 350));
        expect(activeCurve, Curves.easeOutCubic);
      },
    );
  });
}
