import 'package:fitkarma/main.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('FitKarma smoke test - boots cleanly', (WidgetTester tester) async {
    await tester.pumpWidget(const FitKarmaApp());
    expect(find.text('FitKarma Health OS'), findsOneWidget);
  });
}
