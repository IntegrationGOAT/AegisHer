import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class AppDrawer extends StatelessWidget {
  final int currentIndex;
  final Function(int) onItemTapped;
  final VoidCallback? onThemeToggle;
  final VoidCallback? onProfileTap;
  final VoidCallback? onSettingsTap;
  final VoidCallback? onHelpTap;
  final VoidCallback? onAboutTap;

  const AppDrawer({
    super.key,
    required this.currentIndex,
    required this.onItemTapped,
    this.onThemeToggle,
    this.onProfileTap,
    this.onSettingsTap,
    this.onHelpTap,
    this.onAboutTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Drawer(
      backgroundColor: isDarkMode
          ? AppTheme.darkBackground
          : AppTheme.lightSurface,
      child: Column(
        children: [
          // Header with profile
          Container(
            padding: const EdgeInsets.only(
              top: 60,
              bottom: 24,
              left: 20,
              right: 20,
            ),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [AppTheme.primaryRed, AppTheme.accentRed],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: onProfileTap ?? () {},
                  child: Row(
                    children: [
                      Container(
                        width: 64,
                        height: 64,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.3),
                            width: 2,
                          ),
                        ),
                        child: const Icon(
                          Icons.person,
                          color: Colors.white,
                          size: 32,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Guest User',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Tap to view profile',
                              style: TextStyle(
                                color: Colors.white.withValues(alpha: 0.8),
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Icon(
                        Icons.chevron_right,
                        color: Colors.white.withValues(alpha: 0.8),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Navigation items
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 16),
              children: [
                _DrawerItem(
                  icon: Icons.home_outlined,
                  activeIcon: Icons.home,
                  label: 'Home',
                  isActive: currentIndex == 0,
                  onTap: () {
                    onItemTapped(0);
                    Navigator.pop(context);
                  },
                ),
                _DrawerItem(
                  icon: Icons.map_outlined,
                  activeIcon: Icons.map,
                  label: 'Safe Route',
                  isActive: currentIndex == 1,
                  onTap: () {
                    onItemTapped(1);
                    Navigator.pop(context);
                  },
                ),
                _DrawerItem(
                  icon: Icons.people_outline,
                  activeIcon: Icons.people,
                  label: 'Community',
                  isActive: currentIndex == 2,
                  onTap: () {
                    onItemTapped(2);
                    Navigator.pop(context);
                  },
                ),
                _DrawerItem(
                  icon: Icons.report_outlined,
                  activeIcon: Icons.report,
                  label: 'Report Incident',
                  isActive: currentIndex == 3,
                  onTap: () {
                    onItemTapped(3);
                    Navigator.pop(context);
                  },
                ),

                const SizedBox(height: 8),
                const Divider(
                  color: AppTheme.darkCardBorder,
                  height: 1,
                  indent: 16,
                  endIndent: 16,
                ),
                const SizedBox(height: 8),

                _DrawerItem(
                  icon: Icons.settings_outlined,
                  activeIcon: Icons.settings,
                  label: 'Settings',
                  isActive: false,
                  onTap: () {
                    Navigator.pop(context);
                    onSettingsTap?.call();
                  },
                ),
                _DrawerItem(
                  icon: Icons.help_outline,
                  activeIcon: Icons.help,
                  label: 'Help & Support',
                  isActive: false,
                  onTap: () {
                    Navigator.pop(context);
                    onHelpTap?.call();
                  },
                ),
                _DrawerItem(
                  icon: Icons.info_outline,
                  activeIcon: Icons.info,
                  label: 'About',
                  isActive: false,
                  onTap: () {
                    Navigator.pop(context);
                    onAboutTap?.call();
                  },
                ),
              ],
            ),
          ),

          // Theme toggle at bottom
          if (onThemeToggle != null)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDarkMode
                    ? AppTheme.darkSurface
                    : AppTheme.lightSurface,
                border: Border(
                  top: BorderSide(
                    color: isDarkMode
                        ? AppTheme.darkCardBorder
                        : AppTheme.lightCardBorder,
                    width: 1,
                  ),
                ),
              ),
              child: InkWell(
                onTap: () {
                  Navigator.pop(context);
                  onThemeToggle?.call();
                },
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryRed.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        isDarkMode ? Icons.light_mode : Icons.dark_mode,
                        color: AppTheme.primaryRed,
                        size: 22,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        isDarkMode ? 'Light Mode' : 'Dark Mode',
                        style: TextStyle(
                          color: isDarkMode
                              ? AppTheme.textPrimary
                              : AppTheme.textPrimaryLight,
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const Spacer(),
                      Icon(
                        isDarkMode
                            ? Icons.wb_sunny_outlined
                            : Icons.nightlight_outlined,
                        color: AppTheme.primaryRed,
                        size: 20,
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _DrawerItem extends StatelessWidget {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _DrawerItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return InkWell(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isActive
              ? AppTheme.primaryRed.withValues(alpha: 0.15)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(
              isActive ? activeIcon : icon,
              color: isActive
                  ? AppTheme.primaryRed
                  : isDarkMode
                  ? AppTheme.textSecondary
                  : AppTheme.textSecondaryLight,
              size: 22,
            ),
            const SizedBox(width: 16),
            Text(
              label,
              style: TextStyle(
                color: isActive
                    ? AppTheme.primaryRed
                    : isDarkMode
                    ? AppTheme.textPrimary
                    : AppTheme.textPrimaryLight,
                fontSize: 15,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
