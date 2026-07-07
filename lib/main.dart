import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'screens/main_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Load environment variables from the bundled .env asset BEFORE runApp so any
  // provider that reads GEMINI_API_KEY / GEMINI_MODEL at construction time gets it.
  await dotenv.load(fileName: '.env');
  runApp(const ProviderScope(child: AegisHerApp()));
}

class AegisHerApp extends StatelessWidget {
  const AegisHerApp({super.key});
  @override
  Widget build(BuildContext context) {
    return const MainScreen();
  }
}
