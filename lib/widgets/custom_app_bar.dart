import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final bool showBackButton;
  final VoidCallback? onBackPressed;
  final VoidCallback? onThemeToggle;
  final VoidCallback? onProfileTap;

  const CustomAppBar({
    super.key,
    required this.title,
    this.actions,
    this.showBackButton = false,
    this.onBackPressed,
    this.onThemeToggle,
    this.onProfileTap,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return AppBar(
      leading: showBackButton
          ? IconButton(
              icon: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppTheme.primaryRed.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.arrow_back_ios_new,
                  color: AppTheme.primaryRed,
                  size: 20,
                ),
              ),
              onPressed: onBackPressed ?? () => Navigator.pop(context),
            )
          : Builder(
              builder: (context) => IconButton(
                icon: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryRed.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(Icons.menu, color: AppTheme.primaryRed, size: 24),
                ),
                onPressed: () => Scaffold.of(context).openDrawer(),
              ),
            ),
      title: Text(
        title,
        style: TextStyle(
          color: isDarkMode ? AppTheme.textPrimary : AppTheme.textPrimaryLight,
          fontWeight: FontWeight.w600,
          fontSize: 20,
        ),
      ),
      actions: [
        if (onThemeToggle != null)
          IconButton(
            icon: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppTheme.primaryRed.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                isDarkMode ? Icons.light_mode : Icons.dark_mode,
                color: AppTheme.primaryRed,
                size: 22,
              ),
            ),
            onPressed: onThemeToggle,
          ),
        if (onProfileTap != null)
          IconButton(
            icon: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppTheme.primaryRed, AppTheme.accentRed],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.person, color: Colors.white, size: 20),
            ),
            onPressed: onProfileTap,
          ),
        ...?actions,
      ],
    );
  }
}
