import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/theme/design_tokens.dart';
import '../features/auth/presentation/controllers/auth_controller.dart';
import '../features/auth/presentation/screens/login_screen.dart';
import '../features/sos/presentation/screens/sos_screen.dart';
import '../features/settings/presentation/controllers/settings_controller.dart';
import '../features/settings/domain/entities/app_settings.dart';
import '../features/settings/presentation/screens/settings_screen.dart';
import '../theme/app_theme.dart';
import '../widgets/app_drawer.dart';
import '../widgets/bottom_nav_bar.dart';
import 'community_screen.dart';
import 'home_screen.dart';
import 'safety_map_screen.dart';

class MainScreen extends ConsumerStatefulWidget {
  const MainScreen({super.key});
  @override
  ConsumerState<MainScreen> createState() => _MS();
}

class _MS extends ConsumerState<MainScreen> {
  int _currentIndex = 0;
  static const List<Widget> _screens = <Widget>[HomeScreen(), SafetyMapScreen(), CommunityScreen(), SosScreen(), SettingsScreen()];
  void _onItemTapped(int i) => setState(() => _currentIndex = i);

  ThemeMode _resolveThemeMode(AppThemeModeChoice c) {
    switch (c) {
      case AppThemeModeChoice.system: return ThemeMode.system;
      case AppThemeModeChoice.light: return ThemeMode.light;
      case AppThemeModeChoice.dark: return ThemeMode.dark;
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = ref.watch(authControllerProvider);
    final settings = ref.watch(settingsControllerProvider);
    final isLoggedIn = auth.user != null;
    return MaterialApp(
      title: 'AegisHer',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: _resolveThemeMode(settings.themeMode),
      home: Scaffold(
        body: isLoggedIn
            ? AnimatedSwitcher(
                duration: AegisMotion.pageIn,
                switchInCurve: AegisMotion.emphasized,
                transitionBuilder: (child, animation) => FadeTransition(opacity: animation, child: SlideTransition(position: Tween<Offset>(begin: const Offset(0, 0.04), end: Offset.zero).animate(animation), child: child)),
                child: KeyedSubtree(key: ValueKey<int>(_currentIndex), child: _screens[_currentIndex]),
              )
            : const LoginScreen(),
        drawer: isLoggedIn
            ? AppDrawer(
                currentIndex: _currentIndex,
                onItemTapped: (i) { Navigator.pop(context); _onItemTapped(i); },
                onThemeToggle: () {
                  final next = settings.themeMode == AppThemeModeChoice.dark ? AppThemeModeChoice.light : AppThemeModeChoice.dark;
                  ref.read(settingsControllerProvider.notifier).setThemeMode(next);
                },
                onProfileTap: () { Navigator.pop(context); _onItemTapped(4); },
                onSettingsTap: () { Navigator.pop(context); _onItemTapped(4); },
                onHelpTap: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Help coming soon'))),
                onAboutTap: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('AegisHer Foundation MVP'))),
              )
            : null,
        bottomNavigationBar: isLoggedIn ? BottomNavBar(currentIndex: _currentIndex, onTap: _onItemTapped) : null,
      ),
    );
  }
}
