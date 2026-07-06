import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/bottom_nav_bar.dart';
import '../widgets/app_drawer.dart';
import 'home_screen.dart';
import 'safety_map_screen.dart';
import 'community_screen.dart';
import 'report_incident_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;
  bool _isDarkMode = true;

  final List<Widget> _screens = [
    const HomeScreen(),
    const SafetyMapScreen(),
    const CommunityScreen(),
    const ReportIncidentScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  void _toggleTheme() {
    setState(() {
      _isDarkMode = !_isDarkMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: _isDarkMode ? ThemeMode.dark : ThemeMode.light,
      home: Scaffold(
        drawer: AppDrawer(
          currentIndex: _currentIndex,
          onItemTapped: _onItemTapped,
          onThemeToggle: _toggleTheme,
          onProfileTap: () {
            // TODO: Navigate to profile
          },
          onSettingsTap: () {
            // TODO: Navigate to settings
          },
          onHelpTap: () {
            // TODO: Navigate to help
          },
          onAboutTap: () {
            // TODO: Navigate to about
          },
        ),
        body: IndexedStack(
          index: _currentIndex,
          children: _screens,
        ),
        bottomNavigationBar: BottomNavBar(
          currentIndex: _currentIndex,
          onTap: _onItemTapped,
        ),
      ),
    );
  }
}