import 'package:flutter/material.dart';
import '../core/theme/design_tokens.dart';
import '../theme/app_theme.dart';

class BottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  const BottomNavBar({required this.currentIndex, required this.onTap, super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? AppTheme.darkBackground : AppTheme.lightSurface;
    return Container(
      decoration: BoxDecoration(
        color: bg,
        boxShadow: [BoxShadow(color: AppTheme.electricCyan.withValues(alpha: isDark ? 0.10 : 0.05), blurRadius: 24, offset: const Offset(0, -5))],
        border: Border(top: BorderSide(color: (isDark ? AppTheme.darkCardBorder : AppTheme.lightCardBorder).withValues(alpha: 0.4))),
      ),
      child: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: onTap,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.transparent,
        elevation: 0,
        selectedItemColor: AppTheme.electricCyan,
        unselectedItemColor: isDark ? AppTheme.textSecondary : AppTheme.textSecondaryLight,
        selectedFontSize: 11,
        unselectedFontSize: 10,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), activeIcon: Icon(Icons.home_rounded), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.map_outlined), activeIcon: Icon(Icons.map_rounded), label: 'Map'),
          BottomNavigationBarItem(icon: Icon(Icons.people_outline), activeIcon: Icon(Icons.people_rounded), label: 'Community'),
          BottomNavigationBarItem(icon: Icon(Icons.emergency_outlined), activeIcon: Icon(Icons.emergency), label: 'SOS'),
          BottomNavigationBarItem(icon: Icon(Icons.settings_outlined), activeIcon: Icon(Icons.settings_rounded), label: 'Settings'),
        ],
      ),
    );
  }
}
