import 'package:flutter_test/flutter_test.dart';
import 'package:camino_sanctus/main.dart';

void main() {
  testWidgets('Camino Sanctus app smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const CaminoSanctusApp());

    // Verify that we have our app title
    expect(find.text('Camino Sanctus'), findsOneWidget);
  });
}
