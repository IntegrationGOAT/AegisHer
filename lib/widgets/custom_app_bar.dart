// CustomAppBar — futuristic app bar with cyan-tinted icon bubbles and
// proper semantics. Reads colour from the theme so light and dark both work.

import 'package:flutter/material.dart';

import '../core/theme/design_tokens.dart';
import '../theme/app_theme.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final bool showBackButton;
  final VoidCallback? onBackPressed;
  final VoidCallback? onThemeToggle;
  final VoidCallback? onProfileTap;

  const CustomAppBar({
    required this.title,
    this.actions,
    this.showBackButton = false,
    this.onBackPressed,
    this.onThemeToggle,
    this.onProfileTap,
    super.key,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final fgPrimary =
        isDark ? AppTheme.textPrimary : AppTheme.textPrimaryLight;

    return AppBar(
      backgroundColor: isDark ? AppTheme.obsidian : AppTheme.lightSurface,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: true,
      leading: showBackButton
          ? IconButton(
              icon: _IconBubble(
                icon: Icons.arrow_back_ios_new,
                onTap:
                    onBackPressed ?? () => Navigator.maybePop(context),
              ),
              onPressed:
                  onBackPressed ?? () => Navigator.maybePop(context),
            )
          : Builder(
              builder: (innerContext) => IconButton(
                icon: _IconBubble(
                  icon: Icons.menu_rounded,
                  onTap: () => Scaffold.of(innerContext).openDrawer(),
                ),
                onPressed: () => Scaffold.of(innerContext).openDrawer(),
              ),
            ),
      title: Text(
        title,
        style: TextStyle(
          color: fgPrimary,
          fontWeight: FontWeight.w700,
          fontSize: 18,
          letterSpacing: 0.3,
        ),
      ),
      actions: <Widget>[
        if (onThemeToggle != null)
          IconButton(
            icon: _IconBubble(
              icon: isDark ? Icons.light_mode : Icons.dark_mode,
              onTap: onThemeToggle!,
            ),
            onPressed: onThemeToggle,
          ),
        if (onProfileTap != null)
          IconButton(
            icon: Container(
              padding: const EdgeInsets.all(AegisSpacing.space2),
              decoration: BoxDecoration(
                gradient: AegisGradients.aegisCyanGradient,
                borderRadius: BorderRadius.circular(AegisRadius.radiusMd),
              ),
              child: const Icon(Icons.person, color: AppTheme.obsidian, size: 20),
            ),
            onPressed: onProfileTap,
          ),
        ...?actions,
      ],
    );
  }
}

class _IconBubble extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _IconBubble({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkResponse(
      onTap: onTap,
      radius: 24,
      child: Container(
        padding: const EdgeInsets.all(AegisSpacing.space2),
        decoration: BoxDecoration(
          color: AppTheme.electricCyan.withValues(alpha: 0.10),
          borderRadius: BorderRadius.circular(AegisRadius.radiusMd),
          border: Border.all(
            color: AppTheme.electricCyan.withValues(alpha: 0.18),
            width: 0.6,
          ),
        ),
        child: Icon(icon, color: AppTheme.electricCyan, size: 20),
      ),
    );
  }
}
