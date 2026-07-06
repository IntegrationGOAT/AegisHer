import 'package:flutter_test/flutter_test.dart';

import 'package:aegisher/main.dart';

void main() {
  testWidgets('App renders home screen', (WidgetTester tester) async {
    await tester.pumpWidget(const AegisHerApp());

    // Verify the app title is shown in the AppBar
    expect(find.text('AegisHer'), findsOneWidget);
  });
}