import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../core/theme/design_tokens.dart';

/// AegisHer futuristic design system.
///
/// The visual language is **Apple/Tesla-inspired**: charcoal + obsidian neutrals
/// with electric cyan and violet accents, generous dark surfaces, soft glows,
/// glassmorphism-friendly card tokens, and Material 3 motion. The previous red
/// brand palette has been retired in favour of a cooler, more "instrumented
/// cockpit" aesthetic.
///
/// The public API is **backwards compatible** with the original red theme:
///
/// * [`primaryRed`] and [`accentRed`] are kept as aliases of [`electricCyan`]
///   and [`violet`] so legacy widgets continue to compile while automatically
///   adopting the new palette.
/// * [`darkBackground`], [`darkSurface`], [`darkCardBorder`],
///   [`lightSurface`], [`lightCardBorder`], [`cardBorder`], [`textPrimary`],
///   [`textPrimaryLight`], [`textSecondary`], [`textSecondaryLight`],
///   [`fastDuration`], [`mediumDuration`], [`slowDuration`], [`darkTheme`],
///   [`lightTheme`], and [`getTheme`] keep the same names and types.
/// * [`dangerRed`] is retained as a **semantic** colour (signal red) for
///   danger states; it is **not** the brand colour any more.
///
/// New tokens (preferred for new code):
///
/// * [`electricCyan`], [`electricCyanDim`], [`violet`], [`violetDeep`],
///   [`signalGreen`], [`signalAmber`], [`signalRed`],
///   [`obsidian`], [`charcoal`], [`slate`], [`carbon`], [`silver`].
/// * [`getThemeFromController`] for wiring to a Riverpod `ThemeMode` notifier.
/// * [`aegisCyanGradient`], [`aegisVioletGradient`], [`aegisAuroraGradient`]
///   for hero sections and animated backgrounds.
class AppTheme {
  // ---------------------------------------------------------------------------
  // Brand & accent palette
  // ---------------------------------------------------------------------------

  /// Primary brand colour — electric cyan. Cool, instrumented, futuristic.
  static const Color electricCyan = Color(0xFF00E5FF);

  /// Hover/pressed variant of the primary cyan.
  static const Color electricCyanDim = Color(0xFF00B8D4);

  /// Secondary brand colour — violet, used for emphasis and gradients.
  static const Color violet = Color(0xFF7C4DFF);

  /// Deeper violet for shadows and gradients.
  static const Color violetDeep = Color(0xFF5E35B1);

  /// Glow / halo around cyan surfaces.
  static const Color cyanGlow = Color(0xFF66F2FF);

  /// Glow / halo around violet surfaces.
  static const Color violetGlow = Color(0xFFB39DDB);

  /// Backwards-compat alias used by legacy widgets. Maps to the brand cyan.
  static const Color primaryRed = electricCyan;
  static const Color primaryLight = cyanGlow;
  static const Color primaryDark = electricCyanDim;
  static const Color accentRed = violet;
  static const Color glowRed = cyanGlow;

  // ---------------------------------------------------------------------------
  // Semantic colours
  // ---------------------------------------------------------------------------

  /// Safe / "all clear" — green.
  static const Color signalGreen = Color(0xFF00E676);

  /// Caution / "be careful" — amber.
  static const Color signalAmber = Color(0xFFFFB300);

  /// Danger / "act now" — signal red. Used **only** for danger semantics,
  /// never as the brand colour.
  static const Color signalRed = Color(0xFFFF3D5A);

  /// Backwards-compat aliases (semantic meaning preserved).
  static const Color safeGreen = signalGreen;
  static const Color warningOrange = signalAmber;
  static const Color dangerRed = signalRed;

  // ---------------------------------------------------------------------------
  // Surface palette — dark (Apple/Tesla obsidian)
  // ---------------------------------------------------------------------------

  /// App background in dark mode. Near-black with a subtle blue undertone.
  static const Color obsidian = Color(0xFF0A0A0F);

  /// Slightly raised surface in dark mode.
  static const Color charcoal = Color(0xFF14141A);

  /// Card surface in dark mode.
  static const Color slate = Color(0xFF1E1E26);

  /// Pressed/elevated surface in dark mode.
  static const Color carbon = Color(0xFF262630);

  /// Hairline border on dark cards.
  static const Color darkCardBorder = Color(0xFF2C2C38);

  /// Backwards-compat aliases.
  static const Color darkBackground = obsidian;
  static const Color darkSurface = charcoal;
  static const Color darkCard = slate;

  // ---------------------------------------------------------------------------
  // Surface palette — light (Apple "Tertiary System Background")
  // ---------------------------------------------------------------------------

  /// Page background in light mode.
  static const Color lightBackground = Color(0xFFF5F5F7);

  /// Standard surface in light mode.
  static const Color lightSurface = Color(0xFFFFFFFF);

  /// Card surface in light mode.
  static const Color lightCard = Color(0xFFFFFFFF);

  /// Hairline border on light cards.
  static const Color lightCardBorder = Color(0xFFD8D8E0);

  /// Default card border (backwards-compat). Maps to dark mode border.
  static const Color cardBorder = darkCardBorder;

  // ---------------------------------------------------------------------------
  // Text colours
  // ---------------------------------------------------------------------------

  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFFA0A0B0);
  static const Color textPrimaryLight = Color(0xFF0A0A0F);
  static const Color textSecondaryLight = Color(0xFF5C5C68);

  /// Dimmed text on dark (placeholders, captions).
  static const Color silver = Color(0xFF6E6E80);

  // ---------------------------------------------------------------------------
  // Gradients (for hero / animated backgrounds)
  // ---------------------------------------------------------------------------

  static const LinearGradient aegisCyanGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [electricCyan, electricCyanDim],
  );

  static const LinearGradient aegisVioletGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [violet, violetDeep],
  );

  static const LinearGradient aegisAuroraGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [electricCyan, violet, violetDeep],
    stops: [0.0, 0.55, 1.0],
  );

  static const LinearGradient aegisObsidianGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [obsidian, charcoal, slate],
  );

  // ---------------------------------------------------------------------------
  // Motion durations
  // ---------------------------------------------------------------------------

  static const Duration fastDuration = Duration(milliseconds: 200);
  static const Duration mediumDuration = Duration(milliseconds: 350);
  static const Duration slowDuration = Duration(milliseconds: 500);

  /// Page-transition durations.
  static const Duration pageTransitionIn = Duration(milliseconds: 320);
  static const Duration pageTransitionOut = Duration(milliseconds: 240);

  // ---------------------------------------------------------------------------
  // Curves
  // ---------------------------------------------------------------------------

  static const Curve standardCurve = Curves.easeInOutCubic;
  static const Curve emphasizedCurve = Cubic(0.2, 0.0, 0.0, 1.0);
  static const Curve decelCurve = Curves.easeOutCubic;

  // ---------------------------------------------------------------------------
  // Spacing & radii (mirrors design_tokens.dart for direct use)
  // ---------------------------------------------------------------------------

  static const double space2 = 4;
  static const double space3 = 8;
  static const double space4 = 12;
  static const double space5 = 16;
  static const double space6 = 24;
  static const double space7 = 32;
  static const double space8 = 48;

  static const double radiusSm = 8;
  static const double radiusMd = 12;
  static const double radiusLg = 16;
  static const double radiusXl = 24;
  static const double radiusFull = 999;

  static const double elevationLow = 2;
  static const double elevationMed = 6;
  static const double elevationHigh = 12;

  // ---------------------------------------------------------------------------
  // Theme builders
  // ---------------------------------------------------------------------------

  /// Material 3 dark theme.
  static ThemeData get darkTheme => _buildTheme(Brightness.dark);

  /// Material 3 light theme.
  static ThemeData get lightTheme => _buildTheme(Brightness.light);

  /// Convenience selector that matches the original API.
  ///
  /// Returns the dark theme when [isDarkMode] is `true`, otherwise the light
  /// theme. Prefer [`getThemeFromController`] for new code so callers can
  /// pass the system `ThemeMode` directly.
  static ThemeData getTheme(bool isDarkMode) =>
      isDarkMode ? darkTheme : lightTheme;

  /// Maps a [ThemeMode] (the value exposed by a Riverpod theme controller)
  /// to a concrete [ThemeData].
  static ThemeData getThemeFromController(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.dark:
        return darkTheme;
      case ThemeMode.light:
        return lightTheme;
      case ThemeMode.system:
        // Resolve system brightness at build time. Falls back to dark when
        // the platform dispatcher is unavailable (e.g. early in app start).
        final dispatcher = WidgetsBinding.instance.platformDispatcher;
        final brightness = dispatcher.platformBrightness;
        return brightness == Brightness.dark ? darkTheme : lightTheme;
    }
  }

  // ---------------------------------------------------------------------------
  // Internals
  // ---------------------------------------------------------------------------

  static ThemeData _buildTheme(Brightness brightness) {
    final isDark = brightness == Brightness.dark;
    final seed = electricCyan;
    final base = ColorScheme.fromSeed(
      seedColor: seed,
      brightness: brightness,
    );

    // Override surface/background with the custom obsidian palette so we get
    // M3 component theming for free, while the page chrome still feels
    // distinctly Tesla/Apple.
    final colorScheme = base.copyWith(
      primary: electricCyan,
      onPrimary: isDark ? obsidian : Colors.white,
      secondary: violet,
      onSecondary: Colors.white,
      tertiary: violetGlow,
      onTertiary: obsidian,
      surface: isDark ? charcoal : lightSurface,
      onSurface: isDark ? textPrimary : textPrimaryLight,
      surfaceContainerLowest: isDark ? obsidian : lightSurface,
      surfaceContainerLow: isDark ? obsidian : lightBackground,
      surfaceContainer: isDark ? charcoal : lightSurface,
      surfaceContainerHigh: isDark ? slate : lightBackground,
      surfaceContainerHighest: isDark ? carbon : lightCardBorder,
      outline: isDark ? darkCardBorder : lightCardBorder,
      outlineVariant: isDark ? carbon : lightCardBorder,
      error: signalRed,
      onError: Colors.white,
    );

    final textTheme = _buildTextTheme(isDark);

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: colorScheme,
      extensions: <ThemeExtension<dynamic>>[glassTokensFor(brightness)],
      scaffoldBackgroundColor: isDark ? obsidian : lightBackground,
      canvasColor: isDark ? obsidian : lightBackground,
      primaryColor: electricCyan,
      splashFactory: InkSparkle.splashFactory,
      visualDensity: VisualDensity.adaptivePlatformDensity,
      textTheme: textTheme,
      primaryTextTheme: textTheme,
      iconTheme: IconThemeData(
        color: isDark ? textPrimary : textPrimaryLight,
        size: 24,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: isDark ? obsidian : lightSurface,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(
          color: isDark ? textPrimary : textPrimaryLight,
        ),
        titleTextStyle: textTheme.titleLarge?.copyWith(
          color: isDark ? textPrimary : textPrimaryLight,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.2,
        ),
      ),
      cardTheme: CardThemeData(
        color: isDark ? slate : lightCard,
        surfaceTintColor: Colors.transparent,
        elevation: elevationMed,
        shadowColor: electricCyan.withValues(alpha: isDark ? 0.18 : 0.08),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusLg),
          side: BorderSide(
            color: (isDark ? darkCardBorder : lightCardBorder)
                .withValues(alpha: 0.6),
            width: 1,
          ),
        ),
        margin: EdgeInsets.zero,
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: electricCyan,
        foregroundColor: obsidian,
        elevation: elevationHigh,
        focusElevation: elevationHigh,
        hoverElevation: elevationHigh,
        highlightElevation: elevationHigh,
        extendedTextStyle: textTheme.labelLarge?.copyWith(
          color: obsidian,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.4,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: electricCyan,
          foregroundColor: obsidian,
          elevation: elevationLow,
          padding: const EdgeInsets.symmetric(
            horizontal: space6,
            vertical: space4,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radiusMd),
          ),
          textStyle: textTheme.labelLarge?.copyWith(
            fontWeight: FontWeight.w700,
            letterSpacing: 0.4,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: electricCyan,
          side: const BorderSide(color: electricCyan, width: 1.5),
          padding: const EdgeInsets.symmetric(
            horizontal: space6,
            vertical: space4,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radiusMd),
          ),
          textStyle: textTheme.labelLarge?.copyWith(
            fontWeight: FontWeight.w600,
            letterSpacing: 0.4,
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: electricCyan,
          textStyle: textTheme.labelLarge?.copyWith(
            fontWeight: FontWeight.w600,
            letterSpacing: 0.4,
          ),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: violet,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(
            horizontal: space6,
            vertical: space4,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radiusMd),
          ),
          textStyle: textTheme.labelLarge?.copyWith(
            fontWeight: FontWeight.w700,
            letterSpacing: 0.4,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: isDark ? charcoal : lightSurface,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: space5,
          vertical: space4,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMd),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMd),
          borderSide: BorderSide(
            color: (isDark ? darkCardBorder : lightCardBorder)
                .withValues(alpha: 0.6),
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMd),
          borderSide: const BorderSide(color: electricCyan, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMd),
          borderSide: const BorderSide(color: signalRed, width: 1.5),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMd),
          borderSide: const BorderSide(color: signalRed, width: 2),
        ),
        hintStyle: textTheme.bodyMedium?.copyWith(
          color: isDark ? silver : textSecondaryLight,
        ),
        labelStyle: textTheme.bodyMedium?.copyWith(
          color: isDark ? textSecondary : textSecondaryLight,
        ),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: isDark ? obsidian : lightSurface,
        selectedItemColor: electricCyan,
        unselectedItemColor: isDark ? textSecondary : textSecondaryLight,
        type: BottomNavigationBarType.fixed,
        elevation: elevationHigh,
        showUnselectedLabels: true,
        selectedLabelStyle: textTheme.labelSmall?.copyWith(
          fontWeight: FontWeight.w700,
          letterSpacing: 0.4,
        ),
        unselectedLabelStyle: textTheme.labelSmall,
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: isDark ? obsidian : lightSurface,
        indicatorColor: electricCyan.withValues(alpha: 0.18),
        elevation: elevationHigh,
        height: 72,
        labelTextStyle: WidgetStatePropertyAll(
          textTheme.labelMedium?.copyWith(fontWeight: FontWeight.w600),
        ),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const IconThemeData(color: electricCyan, size: 26);
          }
          return IconThemeData(
            color: isDark ? textSecondary : textSecondaryLight,
            size: 24,
          );
        }),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: isDark ? slate : lightBackground,
        selectedColor: electricCyan.withValues(alpha: 0.22),
        disabledColor: (isDark ? carbon : lightCardBorder)
            .withValues(alpha: 0.5),
        labelStyle: textTheme.labelMedium?.copyWith(
          color: isDark ? textPrimary : textPrimaryLight,
        ),
        secondaryLabelStyle: textTheme.labelMedium?.copyWith(
          color: electricCyan,
          fontWeight: FontWeight.w700,
        ),
        side: BorderSide(
          color: (isDark ? darkCardBorder : lightCardBorder)
              .withValues(alpha: 0.6),
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: space4,
          vertical: space3,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusFull),
        ),
      ),
      dividerTheme: DividerThemeData(
        color: (isDark ? darkCardBorder : lightCardBorder)
            .withValues(alpha: 0.6),
        thickness: 1,
        space: 1,
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: electricCyan,
        linearTrackColor: isDark ? slate : lightBackground,
        circularTrackColor: isDark ? slate : lightBackground,
      ),
      sliderTheme: SliderThemeData(
        activeTrackColor: electricCyan,
        inactiveTrackColor: (isDark ? darkCardBorder : lightCardBorder),
        thumbColor: electricCyan,
        overlayColor: electricCyan.withValues(alpha: 0.16),
        valueIndicatorColor: violet,
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return electricCyan;
          return isDark ? silver : lightCardBorder;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return electricCyan.withValues(alpha: 0.4);
          }
          return (isDark ? carbon : lightCardBorder).withValues(alpha: 0.6);
        }),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: isDark ? carbon : textPrimaryLight,
        contentTextStyle: textTheme.bodyMedium?.copyWith(
          color: isDark ? textPrimary : lightSurface,
        ),
        actionTextColor: electricCyan,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusMd),
        ),
        elevation: elevationHigh,
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: isDark ? charcoal : lightSurface,
        surfaceTintColor: Colors.transparent,
        elevation: elevationHigh,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusLg),
          side: BorderSide(
            color: (isDark ? darkCardBorder : lightCardBorder)
                .withValues(alpha: 0.6),
          ),
        ),
        titleTextStyle: textTheme.titleLarge?.copyWith(
          color: isDark ? textPrimary : textPrimaryLight,
          fontWeight: FontWeight.w700,
        ),
        contentTextStyle: textTheme.bodyMedium?.copyWith(
          color: isDark ? textSecondary : textSecondaryLight,
        ),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: isDark ? charcoal : lightSurface,
        surfaceTintColor: Colors.transparent,
        elevation: elevationHigh,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(radiusXl)),
        ),
      ),
      tabBarTheme: TabBarThemeData(
        labelColor: electricCyan,
        unselectedLabelColor: isDark ? textSecondary : textSecondaryLight,
        indicator: const UnderlineTabIndicator(
          borderSide: BorderSide(color: electricCyan, width: 2.5),
        ),
        indicatorSize: TabBarIndicatorSize.label,
        labelStyle: textTheme.labelLarge?.copyWith(
          fontWeight: FontWeight.w700,
          letterSpacing: 0.4,
        ),
        unselectedLabelStyle: textTheme.labelLarge,
      ),
      tooltipTheme: TooltipThemeData(
        decoration: BoxDecoration(
          color: isDark ? carbon : textPrimaryLight,
          borderRadius: BorderRadius.circular(radiusSm),
        ),
        textStyle: textTheme.bodySmall?.copyWith(
          color: isDark ? textPrimary : lightSurface,
        ),
      ),
      pageTransitionsTheme: PageTransitionsTheme(
        builders: <TargetPlatform, PageTransitionsBuilder>{
          TargetPlatform.android: const ZoomPageTransitionsBuilder(),
          TargetPlatform.iOS: const CupertinoPageTransitionsBuilder(),
          TargetPlatform.macOS: const CupertinoPageTransitionsBuilder(),
        },
      ),
    );
  }

  static TextTheme _buildTextTheme(bool isDark) {
    final onSurface = isDark ? textPrimary : textPrimaryLight;
    final secondary = isDark ? textSecondary : textSecondaryLight;
    return TextTheme(
      displayLarge: TextStyle(
        color: onSurface,
        fontSize: 48,
        fontWeight: FontWeight.w800,
        letterSpacing: -0.5,
        height: 1.05,
      ),
      displayMedium: TextStyle(
        color: onSurface,
        fontSize: 36,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.3,
        height: 1.1,
      ),
      displaySmall: TextStyle(
        color: onSurface,
        fontSize: 28,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.2,
        height: 1.15,
      ),
      headlineLarge: TextStyle(
        color: onSurface,
        fontSize: 26,
        fontWeight: FontWeight.w700,
        letterSpacing: 0,
      ),
      headlineMedium: TextStyle(
        color: onSurface,
        fontSize: 22,
        fontWeight: FontWeight.w600,
      ),
      headlineSmall: TextStyle(
        color: onSurface,
        fontSize: 20,
        fontWeight: FontWeight.w600,
      ),
      titleLarge: TextStyle(
        color: onSurface,
        fontSize: 18,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.2,
      ),
      titleMedium: TextStyle(
        color: onSurface,
        fontSize: 16,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.15,
      ),
      titleSmall: TextStyle(
        color: onSurface,
        fontSize: 14,
        fontWeight: FontWeight.w600,
      ),
      bodyLarge: TextStyle(
        color: onSurface,
        fontSize: 16,
        height: 1.45,
      ),
      bodyMedium: TextStyle(
        color: secondary,
        fontSize: 14,
        height: 1.45,
      ),
      bodySmall: TextStyle(
        color: secondary,
        fontSize: 12,
        height: 1.4,
      ),
      labelLarge: TextStyle(
        color: onSurface,
        fontSize: 14,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.4,
      ),
      labelMedium: TextStyle(
        color: secondary,
        fontSize: 12,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.4,
      ),
      labelSmall: TextStyle(
        color: secondary,
        fontSize: 11,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.5,
      ),
    );
  }
}
