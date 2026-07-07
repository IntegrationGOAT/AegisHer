// AegisHer design tokens — spacing, radii, elevation, blur, motion, gradients,
// and the GlassNeumorphicTokens ThemeExtension used by glass/neumorphic widgets.
//
// Everything here is a single source of truth: the legacy `lib/theme/app_theme.dart`
// keeps the colour/typography/theme-data surface, and these tokens are the
// non-color design language that any widget can read from `Theme.of(context)
// .extension<GlassNeumorphicTokens>()`.

import 'package:flutter/material.dart';

/// Spacing scale in logical pixels. Use these for padding, margins, and gaps
/// rather than hard-coded numbers.
class AegisSpacing {
  AegisSpacing._();

  static const double space0 = 0;
  static const double space1 = 2;
  static const double space2 = 4;
  static const double space3 = 8;
  static const double space4 = 12;
  static const double space5 = 16;
  static const double space6 = 20;
  static const double space7 = 24;
  static const double space8 = 32;
  static const double space9 = 40;
  static const double space10 = 48;
  static const double space11 = 64;
  static const double space12 = 80;
}

/// Corner radius scale.
class AegisRadius {
  AegisRadius._();

  static const double none = 0;
  static const double radiusXs = 4;
  static const double radiusSm = 8;
  static const double radiusMd = 12;
  static const double radiusLg = 16;
  static const double radiusXl = 24;
  static const double radius2xl = 32;
  static const double radiusFull = 999;
}

/// Elevation scale (Material 3 surfaces).
class AegisElevation {
  AegisElevation._();

  static const double level0 = 0;
  static const double level1 = 1;
  static const double level2 = 3;
  static const double level3 = 6;
  static const double level4 = 8;
  static const double level5 = 12;

  // Common aliases used in legacy code.
  static const double low = level2;
  static const double medium = level3;
  static const double high = level5;
}

/// Blur radius scale used by glassmorphism widgets (`BackdropFilter` sigma).
class AegisBlur {
  AegisBlur._();

  static const double blurNone = 0;
  static const double blurSm = 8;
  static const double blurMd = 16;
  static const double blurLg = 24;
  static const double blurXl = 36;
  static const double blurXxl = 48;
}

/// Motion durations and curves.
class AegisMotion {
  AegisMotion._();

  // Durations.
  static const Duration instant = Duration(milliseconds: 80);
  static const Duration fast = Duration(milliseconds: 200);
  static const Duration medium = Duration(milliseconds: 350);
  static const Duration slow = Duration(milliseconds: 500);
  static const Duration pageIn = Duration(milliseconds: 320);
  static const Duration pageOut = Duration(milliseconds: 240);

  // Curves — picked from Material 3 motion guidelines plus spring.
  static const Curve standard = Curves.easeInOutCubic;
  static const Curve emphasized = Cubic(0.2, 0, 0, 1);
  static const Curve decelerate = Curves.easeOutCubic;
  static const Curve accelerate = Curves.easeInCubic;
  static const Curve overshoot = Curves.easeOutBack;

  // New additions specifically requested by this step.
  static const Curve easeOutExpo = Curves.easeOutExpo;
  static const Curve easeInExpo = Curves.easeInExpo;
  static const Curve spring = Curves.elasticOut;
  static const Curve bounceOut = Curves.bounceOut;
}

/// Reusable gradient presets. Stops are picked to feel Apple/Tesla —
/// saturated cyan fading into deep violet, with an aurora multicolor band.
class AegisGradients {
  AegisGradients._();

  static const LinearGradient aegisCyanGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: <Color>[
      Color(0xFF00E5FF),
      Color(0xFF00B8D4),
    ],
  );

  static const LinearGradient aegisVioletGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: <Color>[
      Color(0xFF7C4DFF),
      Color(0xFF5E35B1),
    ],
  );

  static const LinearGradient aegisAuroraGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: <Color>[
      Color(0xFF00E5FF),
      Color(0xFF7C4DFF),
      Color(0xFFFF4081),
    ],
    stops: <double>[0.0, 0.55, 1.0],
  );

  static const LinearGradient aegisObsidianGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: <Color>[
      Color(0xFF0A0A0F),
      Color(0xFF14141A),
      Color(0xFF1E1E26),
    ],
    stops: <double>[0.0, 0.5, 1.0],
  );

  static const LinearGradient aegisSosGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: <Color>[
      Color(0xFFFF3D5A),
      Color(0xFFFF6B6B),
    ],
  );
}

/// ThemeExtension carrying the non-color design language.
///
/// Read with:
///   final tokens = Theme.of(context).extension<GlassNeumorphicTokens>()!;
///
/// The constructor takes both light and dark variants so a single
/// ThemeData can carry the right pair.
@immutable
class GlassNeumorphicTokens extends ThemeExtension<GlassNeumorphicTokens> {
  const GlassNeumorphicTokens({
    required this.glassSurface,
    required this.glassSurfaceStrong,
    required this.glassBorder,
    required this.glassHighlight,
    required this.glassBlur,
    required this.neumorphicLightShadow,
    required this.neumorphicDarkShadow,
    required this.neumorphicSurface,
    required this.glowCyan,
    required this.glowViolet,
    required this.scrim,
  });

  /// Default glass surface — translucent charcoal.
  final Color glassSurface;

  /// Stronger glass surface — for elevated glass (modals, sheets).
  final Color glassSurfaceStrong;

  /// Subtle hairline border that sits on top of glass.
  final Color glassBorder;

  /// Inner top-edge highlight on glass cards.
  final Color glassHighlight;

  /// Backdrop blur sigma.
  final double glassBlur;

  /// Light shadow colour for neumorphic raised surfaces.
  final Color neumorphicLightShadow;

  /// Dark shadow colour for neumorphic raised surfaces.
  final Color neumorphicDarkShadow;

  /// Surface colour for neumorphic surfaces.
  final Color neumorphicSurface;

  /// Cyan glow used for focused/active controls.
  final Color glowCyan;

  /// Violet glow used for secondary highlights.
  final Color glowViolet;

  /// Modal/sheet scrim colour.
  final Color scrim;

  static const GlassNeumorphicTokens dark = GlassNeumorphicTokens(
    glassSurface: Color(0x14141A66),
    glassSurfaceStrong: Color(0x1E1E26AA),
    glassBorder: Color(0xFFFFFFFF),
    glassHighlight: Color(0x1AFFFFFF),
    glassBlur: AegisBlur.blurLg,
    neumorphicLightShadow: Color(0x33FFFFFF),
    neumorphicDarkShadow: Color(0xCC000000),
    neumorphicSurface: Color(0xFF14141A),
    glowCyan: Color(0x6600E5FF),
    glowViolet: Color(0x667C4DFF),
    scrim: Color(0xCC000000),
  );

  static const GlassNeumorphicTokens light = GlassNeumorphicTokens(
    glassSurface: Color(0x80FFFFFF),
    glassSurfaceStrong: Color(0xCCFFFFFF),
    glassBorder: Color(0x14000000),
    glassHighlight: Color(0x14FFFFFF),
    glassBlur: AegisBlur.blurLg,
    neumorphicLightShadow: Color(0xFFFFFFFF),
    neumorphicDarkShadow: Color(0x1A0A0A0F),
    neumorphicSurface: Color(0xFFF5F5F7),
    glowCyan: Color(0x6600B8D4),
    glowViolet: Color(0x665E35B1),
    scrim: Color(0x66000000),
  );

  @override
  GlassNeumorphicTokens copyWith({
    Color? glassSurface,
    Color? glassSurfaceStrong,
    Color? glassBorder,
    Color? glassHighlight,
    double? glassBlur,
    Color? neumorphicLightShadow,
    Color? neumorphicDarkShadow,
    Color? neumorphicSurface,
    Color? glowCyan,
    Color? glowViolet,
    Color? scrim,
  }) {
    return GlassNeumorphicTokens(
      glassSurface: glassSurface ?? this.glassSurface,
      glassSurfaceStrong: glassSurfaceStrong ?? this.glassSurfaceStrong,
      glassBorder: glassBorder ?? this.glassBorder,
      glassHighlight: glassHighlight ?? this.glassHighlight,
      glassBlur: glassBlur ?? this.glassBlur,
      neumorphicLightShadow:
          neumorphicLightShadow ?? this.neumorphicLightShadow,
      neumorphicDarkShadow: neumorphicDarkShadow ?? this.neumorphicDarkShadow,
      neumorphicSurface: neumorphicSurface ?? this.neumorphicSurface,
      glowCyan: glowCyan ?? this.glowCyan,
      glowViolet: glowViolet ?? this.glowViolet,
      scrim: scrim ?? this.scrim,
    );
  }

  @override
  GlassNeumorphicTokens lerp(
    ThemeExtension<GlassNeumorphicTokens>? other,
    double t,
  ) {
    if (other is! GlassNeumorphicTokens) return this;
    return GlassNeumorphicTokens(
      glassSurface: Color.lerp(glassSurface, other.glassSurface, t)!,
      glassSurfaceStrong:
          Color.lerp(glassSurfaceStrong, other.glassSurfaceStrong, t)!,
      glassBorder: Color.lerp(glassBorder, other.glassBorder, t)!,
      glassHighlight: Color.lerp(glassHighlight, other.glassHighlight, t)!,
      glassBlur: glassBlur + (other.glassBlur - glassBlur) * t,
      neumorphicLightShadow:
          Color.lerp(neumorphicLightShadow, other.neumorphicLightShadow, t)!,
      neumorphicDarkShadow:
          Color.lerp(neumorphicDarkShadow, other.neumorphicDarkShadow, t)!,
      neumorphicSurface:
          Color.lerp(neumorphicSurface, other.neumorphicSurface, t)!,
      glowCyan: Color.lerp(glowCyan, other.glowCyan, t)!,
      glowViolet: Color.lerp(glowViolet, other.glowViolet, t)!,
      scrim: Color.lerp(scrim, other.scrim, t)!,
    );
  }
}

/// Convenience selector matching AppTheme.darkTheme / AppTheme.lightTheme so the
/// `ThemeData.extensions` list always includes the correct variant.
GlassNeumorphicTokens glassTokensFor(Brightness brightness) =>
    brightness == Brightness.dark
        ? GlassNeumorphicTokens.dark
        : GlassNeumorphicTokens.light;
