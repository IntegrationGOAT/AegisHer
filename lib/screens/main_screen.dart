// MainScreen — bottom-nav shell with five tab destinations (Home, Map,
// Community, SOS, Settings). For the Foundation MVP, SOS and Settings are
// surfaced as alert dialogs so the navigation feels real without depending
// on phases 4-5 features.

import 'package:flutter/material.dart';

import '../core/theme/design_tokens.dart';
import '../theme/app_theme.dart';
import '../widgets/app_drawer.dart';
import '../widgets/bottom_nav_bar.dart';
import 'community_screen.dart';
import 'home_screen.dart';
import 'report_incident_screen.dart';
import 'safety_map_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;
  ThemeMode _themeMode = ThemeMode.dark;

  static const List<Widget> _screens = <Widget>[
    HomeScreen(),
    SafetyMapScreen(),
    CommunityScreen(),
    ReportIncidentScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  void _toggleTheme() {
    setState(() {
      _themeMode =
          _themeMode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    });
  }

  void _placeholderAction(String label) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$label coming in next phase'),
        backgroundColor: AppTheme.signalGreen,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AegisHer',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: _themeMode,
      home: Scaffold(
        drawer: AppDrawer(
          currentIndex: _currentIndex,
          onItemTapped: _onItemTapped,
          onThemeToggle: _toggleTheme,
          onProfileTap: () => _placeholderAction('Profile'),
          onSettingsTap: () => _placeholderAction('Settings'),
          onHelpTap: () => _placeholderAction('Help'),
          onAboutTap: () => _placeholderAction('About'),
        ),
        body: AnimatedSwitcher(
          duration: AegisMotion.pageIn,
          switchInCurve: AegisMotion.emphasized,
          switchOutCurve: AegisMotion.standard,
          transitionBuilder: (child, animation) {
            return FadeTransition(
              opacity: animation,
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0, 0.04),
                  end: Offset.zero,
                ).animate(animation),
                child: child,
              ),
            );
          },
          child: KeyedSubtree(
            key: ValueKey<int>(_currentIndex),
            child: _screens[_currentIndex],
          ),
        ),
        bottomNavigationBar: BottomNavBar(
          currentIndex: _currentIndex,
          onTap: _onItemTapped,
        ),
      ),
    );
  }
}
