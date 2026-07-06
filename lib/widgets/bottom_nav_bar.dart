import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class BottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const BottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: isDarkMode ? AppTheme.darkBackground : AppTheme.lightSurface,
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryRed.withValues(alpha: 0.1),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: onTap,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.transparent,
        elevation: 0,
        selectedItemColor: AppTheme.primaryRed,
        unselectedItemColor: isDarkMode
            ? AppTheme.textSecondary
            : AppTheme.textSecondaryLight,
        selectedFontSize: 12,
        unselectedFontSize: 11,
        items: [
          BottomNavigationBarItem(
            icon: _buildIcon(
              icon: Icons.home_outlined,
              activeIcon: Icons.home,
              isActive: currentIndex == 0,
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: _buildIcon(
              icon: Icons.map_outlined,
              activeIcon: Icons.map,
              isActive: currentIndex == 1,
            ),
            label: 'Map',
          ),
          BottomNavigationBarItem(
            icon: _buildIcon(
              icon: Icons.people_outline,
              activeIcon: Icons.people,
              isActive: currentIndex == 2,
            ),
            label: 'Community',
          ),
          BottomNavigationBarItem(
            icon: _buildIcon(
              icon: Icons.report_outlined,
              activeIcon: Icons.report,
              isActive: currentIndex == 3,
            ),
            label: 'Report',
          ),
        ],
      ),
    );
  }

  Widget _buildIcon({
    required IconData icon,
    required IconData activeIcon,
    required bool isActive,
  }) {
    return AnimatedContainer(
      duration: AppTheme.fastDuration,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        gradient: isActive
            ? LinearGradient(
                colors: [
                  AppTheme.primaryRed.withValues(alpha: 0.2),
                  AppTheme.primaryRed.withValues(alpha: 0.1),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              )
            : null,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(
        isActive ? activeIcon : icon,
        size: 24,
      ),
    );
  }
}