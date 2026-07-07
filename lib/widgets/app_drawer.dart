// AppDrawer — futuristic side drawer with a gradient header, glass-style
// rows, and a bottom theme toggle. Reads brightness from Theme.of(context)
// and uses design tokens for spacing/radii.

import 'package:flutter/material.dart';

import '../core/theme/design_tokens.dart';
import '../theme/app_theme.dart';

class AppDrawer extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onItemTapped;
  final VoidCallback? onThemeToggle;
  final VoidCallback? onProfileTap;
  final VoidCallback? onSettingsTap;
  final VoidCallback? onHelpTap;
  final VoidCallback? onAboutTap;

  const AppDrawer({
    required this.currentIndex,
    required this.onItemTapped,
    this.onThemeToggle,
    this.onProfileTap,
    this.onSettingsTap,
    this.onHelpTap,
    this.onAboutTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? AppTheme.obsidian : AppTheme.lightSurface;
    final fgPrimary =
        isDark ? AppTheme.textPrimary : AppTheme.textPrimaryLight;
    final fgSecondary =
        isDark ? AppTheme.textSecondary : AppTheme.textSecondaryLight;
    final border = isDark
        ? AppTheme.darkCardBorder
        : AppTheme.lightCardBorder;

    return Drawer(
      backgroundColor: bg,
      child: Column(
        children: <Widget>[
          // Header with gradient + profile summary
          Container(
            padding: const EdgeInsets.only(
              top: 60,
              bottom: AegisSpacing.space7,
              left: AegisSpacing.space5,
              right: AegisSpacing.space5,
            ),
            decoration: const BoxDecoration(
              gradient: AegisGradients.aegisAuroraGradient,
            ),
            child: InkWell(
              onTap: onProfileTap,
              borderRadius: BorderRadius.circular(AegisRadius.radiusLg),
              child: Row(
                children: <Widget>[
                  Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius:
                          BorderRadius.circular(AegisRadius.radiusLg),
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
                  const SizedBox(width: AegisSpacing.space5),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'Guest User',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.2,
                          ),
                        ),
                        const SizedBox(height: AegisSpacing.space1),
                        Text(
                          'Tap to view profile',
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.85),
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    Icons.chevron_right,
                    color: Colors.white.withValues(alpha: 0.85),
                  ),
                ],
              ),
            ),
          ),

          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: AegisSpacing.space5),
              children: <Widget>[
                _DrawerItem(
                  icon: Icons.home_outlined,
                  activeIcon: Icons.home_rounded,
                  label: 'Home',
                  isActive: currentIndex == 0,
                  onTap: () {
                    onItemTapped(0);
                    Navigator.pop(context);
                  },
                  isDark: isDark,
                ),
                _DrawerItem(
                  icon: Icons.map_outlined,
                  activeIcon: Icons.map_rounded,
                  label: 'Safe Route',
                  isActive: currentIndex == 1,
                  onTap: () {
                    onItemTapped(1);
                    Navigator.pop(context);
                  },
                  isDark: isDark,
                ),
                _DrawerItem(
                  icon: Icons.people_outline,
                  activeIcon: Icons.people_rounded,
                  label: 'Community',
                  isActive: currentIndex == 2,
                  onTap: () {
                    onItemTapped(2);
                    Navigator.pop(context);
                  },
                  isDark: isDark,
                ),
                _DrawerItem(
                  icon: Icons.report_outlined,
                  activeIcon: Icons.report_rounded,
                  label: 'Report Incident',
                  isActive: currentIndex == 3,
                  onTap: () {
                    onItemTapped(3);
                    Navigator.pop(context);
                  },
                  isDark: isDark,
                ),
                const SizedBox(height: AegisSpacing.space3),
                Divider(
                  color: border,
                  height: 1,
                  indent: AegisSpacing.space5,
                  endIndent: AegisSpacing.space5,
                ),
                const SizedBox(height: AegisSpacing.space3),
                _DrawerItem(
                  icon: Icons.settings_outlined,
                  activeIcon: Icons.settings_rounded,
                  label: 'Settings',
                  isActive: false,
                  onTap: () {
                    Navigator.pop(context);
                    onSettingsTap?.call();
                  },
                  isDark: isDark,
                ),
                _DrawerItem(
                  icon: Icons.help_outline,
                  activeIcon: Icons.help_rounded,
                  label: 'Help & Support',
                  isActive: false,
                  onTap: () {
                    Navigator.pop(context);
                    onHelpTap?.call();
                  },
                  isDark: isDark,
                ),
                _DrawerItem(
                  icon: Icons.info_outline,
                  activeIcon: Icons.info_rounded,
                  label: 'About',
                  isActive: false,
                  onTap: () {
                    Navigator.pop(context);
                    onAboutTap?.call();
                  },
                  isDark: isDark,
                ),
              ],
            ),
          ),

          if (onThemeToggle != null)
            Container(
              padding: const EdgeInsets.all(AegisSpacing.space5),
              decoration: BoxDecoration(
                color: isDark ? AppTheme.charcoal : AppTheme.lightCard,
                border: Border(
                  top: BorderSide(color: border, width: 1),
                ),
              ),
              child: InkWell(
                onTap: () {
                  Navigator.pop(context);
                  onThemeToggle?.call();
                },
                borderRadius: BorderRadius.circular(AegisRadius.radiusMd),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AegisSpacing.space5,
                    vertical: AegisSpacing.space3,
                  ),
                  decoration: BoxDecoration(
                    color: AppTheme.electricCyan.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(AegisRadius.radiusMd),
                    border: Border.all(
                      color: AppTheme.electricCyan.withValues(alpha: 0.30),
                      width: 0.6,
                    ),
                  ),
                  child: Row(
                    children: <Widget>[
                      Icon(
                        isDark ? Icons.light_mode : Icons.dark_mode,
                        color: AppTheme.electricCyan,
                        size: 22,
                      ),
                      const SizedBox(width: AegisSpacing.space4),
                      Text(
                        isDark ? 'Light Mode' : 'Dark Mode',
                        style: TextStyle(
                          color: fgPrimary,
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const Spacer(),
                      Icon(
                        isDark
                            ? Icons.wb_sunny_outlined
                            : Icons.nightlight_outlined,
                        color: AppTheme.electricCyan,
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
  final bool isDark;

  const _DrawerItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.isActive,
    required this.onTap,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final fgSecondary =
        isDark ? AppTheme.textSecondary : AppTheme.textSecondaryLight;
    final fgPrimary =
        isDark ? AppTheme.textPrimary : AppTheme.textPrimaryLight;

    return InkWell(
      onTap: onTap,
      child: AnimatedContainer(
        duration: AegisMotion.fast,
        margin: const EdgeInsets.symmetric(
          horizontal: AegisSpacing.space3,
          vertical: AegisSpacing.space1,
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: AegisSpacing.space5,
          vertical: AegisSpacing.space3,
        ),
        decoration: BoxDecoration(
          gradient: isActive ? AegisGradients.aegisCyanGradient : null,
          color: isActive
              ? null
              : AppTheme.electricCyan.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(AegisRadius.radiusMd),
          border: Border.all(
            color: isActive
                ? Colors.transparent
                : AppTheme.electricCyan.withValues(alpha: 0.12),
            width: 0.6,
          ),
        ),
        child: Row(
          children: <Widget>[
            Icon(
              isActive ? activeIcon : icon,
              color: isActive
                  ? AppTheme.obsidian
                  : AppTheme.electricCyan,
              size: 22,
            ),
            const SizedBox(width: AegisSpacing.space5),
            Text(
              label,
              style: TextStyle(
                color: isActive ? AppTheme.obsidian : fgPrimary,
                fontSize: 15,
                fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
                letterSpacing: 0.2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
