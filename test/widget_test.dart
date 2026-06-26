import 'package:flutter_test/flutter_test.dart';
import 'package:catacutan_task7/main.dart';

void main() {
  testWidgets('E-Commerce Shop page renders', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify that the shop page title is rendered.
    expect(find.text('E-Commerce Shop'), findsOneWidget);
  });
}
