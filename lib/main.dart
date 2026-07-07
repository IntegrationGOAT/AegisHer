import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'screens/main_screen.dart';

void main() {
  runApp(const ProviderScope(child: AegisHerApp()));
}

class AegisHerApp extends StatelessWidget {
  const AegisHerApp({super.key});
  @override
  Widget build(BuildContext context) {
    return const MainScreen();
  }
}
