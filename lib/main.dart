import 'package:flutter/material.dart';

import 'screens/main_screen.dart';

void main() {
  runApp(const AegisHerApp());
}

class AegisHerApp extends StatelessWidget {
  const AegisHerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'AegisHer',
      debugShowCheckedModeBanner: false,
      home: MainScreen(),
    );
  }
}
