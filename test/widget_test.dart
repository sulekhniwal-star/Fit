import 'package:fitkarma/main.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('FitKarma smoke test - application starts', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const FitKarmaApp());

    expect(find.text('FitKarma'), findsOneWidget);
  });
}
