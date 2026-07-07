// BottomNavBar — futuristic tab bar styled with cyan glow on the active icon.
// Reads brightness from Theme.of(context) and uses design tokens for spacing.

import 'package:flutter/material.dart';

import '../core/theme/design_tokens.dart';
import '../theme/app_theme.dart';

class BottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const BottomNavBar({
    required this.currentIndex,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? AppTheme.darkBackground : AppTheme.lightSurface;

    return Container(
      decoration: BoxDecoration(
        color: bg,
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: AppTheme.electricCyan.withValues(alpha: isDark ? 0.10 : 0.05),
            blurRadius: 24,
            offset: const Offset(0, -5),
          ),
        ],
        border: Border(
          top: BorderSide(
            color: (isDark
                    ? AppTheme.darkCardBorder
                    : AppTheme.lightCardBorder)
                .withValues(alpha: 0.4),
          ),
        ),
      ),
      child: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: onTap,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.transparent,
        elevation: 0,
        selectedItemColor: AppTheme.electricCyan,
        unselectedItemColor: isDark
            ? AppTheme.textSecondary
            : AppTheme.textSecondaryLight,
        selectedFontSize: 12,
        unselectedFontSize: 11,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: _IconBubble(
              icon: Icons.home_outlined,
              activeIcon: Icons.home_rounded,
              isActive: currentIndex == 0,
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: _IconBubble(
              icon: Icons.map_outlined,
              activeIcon: Icons.map_rounded,
              isActive: currentIndex == 1,
            ),
            label: 'Map',
          ),
          BottomNavigationBarItem(
            icon: _IconBubble(
              icon: Icons.people_outline,
              activeIcon: Icons.people_rounded,
              isActive: currentIndex == 2,
            ),
            label: 'Community',
          ),
          BottomNavigationBarItem(
            icon: _IconBubble(
              icon: Icons.report_outlined,
              activeIcon: Icons.report_rounded,
              isActive: currentIndex == 3,
            ),
            label: 'Report',
          ),
        ],
      ),
    );
  }
}

class _IconBubble extends StatelessWidget {
  final IconData icon;
  final IconData activeIcon;
  final bool isActive;

  const _IconBubble({
    required this.icon,
    required this.activeIcon,
    required this.isActive,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: AegisMotion.fast,
      curve: AegisMotion.standard,
      padding: const EdgeInsets.symmetric(
        horizontal: AegisSpacing.space4,
        vertical: AegisSpacing.space1,
      ),
      decoration: BoxDecoration(
        gradient: isActive ? AegisGradients.aegisCyanGradient : null,
        borderRadius: BorderRadius.circular(AegisRadius.radiusFull),
        boxShadow: isActive
            ? <BoxShadow>[
                BoxShadow(
                  color: AppTheme.electricCyan.withValues(alpha: 0.45),
                  blurRadius: 14,
                  offset: const Offset(0, 4),
                ),
              ]
            : null,
      ),
      child: Icon(
        isActive ? activeIcon : icon,
        size: 22,
        color: isActive
            ? AppTheme.obsidian
            : IconTheme.of(context).color,
      ),
    );
  }
}
