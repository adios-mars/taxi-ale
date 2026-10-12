import 'package:flutter_test/flutter_test.dart';
import 'package:my_aoo/main.dart';

void main() {
  testWidgets('App initializes cleanly and renders splash screen', (WidgetTester tester) async {
    await tester.pumpWidget(const TaxiAleApp());
    expect(find.text('Taxi Ale'), findsOneWidget);
  });
}
