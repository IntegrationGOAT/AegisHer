// Foundation MVP smoke test.
//
// Pumps the real MainScreen, drains all pending timers (Future.delayed
// in SafetyService.getSafetyScore + post-frame animation controllers),
// then asserts the home tab + bottom nav rendered.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:aegisher/main.dart';

void main() {
  testWidgets('App renders home screen', (tester) async {
    await tester.pumpWidget(const AegisHerApp());

    // Drain everything in real-time so Future.delayed timers resolve.
    // HomeScreen.initState kicks off a 300 ms location fetch + 500 ms safety
    // score + 500 ms nearby incidents = 1300 ms total.
    await tester.runAsync(() async {
      await Future<void>.delayed(const Duration(milliseconds: 1800));
    });
    // Settle the post-frame animation controllers.
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 200));

    // App title in the app bar
    expect(find.text('AegisHer'), findsOneWidget);
    // Bottom navigation has all 4 tabs.
    expect(find.text('Home'), findsOneWidget);
    expect(find.text('Map'), findsOneWidget);
    expect(find.text('Community'), findsOneWidget);
    expect(find.text('Report'), findsOneWidget);
  });
}
