// Responsive layout helpers.
//
// AegisHer is mobile-first but the Flutter skeleton must also render cleanly
// on tablet/foldable form factors (e.g. Samsung Galaxy Z Fold, iPad mini).
// These helpers let any widget pick a value based on the largest side of the
// available constraints without re-implementing breakpoint logic everywhere.

import 'package:flutter/widgets.dart';

/// Standard Material breakpoints expressed in dp (logical pixels).
///
///   * compact  — phones in portrait (< 600 dp)
///   * medium   — small tablets, large phones in landscape (600 – 1024 dp)
///   * expanded — tablets, foldables open, desktop (>= 1024 dp)
class Breakpoints {
  Breakpoints._();

  static const double compact = 600;
  static const double medium = 1024;

  /// Aspect ratio above which a foldable is considered "book mode" rather
  /// than "tablet mode". Galaxy Z Fold inner display hovers around 0.6,
  /// iPad mini sits around 0.75 — so 0.65 is a sane cut-off.
  static const double foldableAspectMax = 0.65;
}

enum DeviceClass { compact, medium, expanded }

/// Static helpers for picking a value based on the active layout.
class Responsive {
  Responsive._();

  /// Classify the available width into a [DeviceClass].
  static DeviceClass classify(double width) {
    if (width < Breakpoints.compact) return DeviceClass.compact;
    if (width < Breakpoints.medium) return DeviceClass.medium;
    return DeviceClass.expanded;
  }

  /// Pick one of three values based on the current layout.
  ///
  ///   final columns = Responsive.value(
  ///     context,
  ///     compact: 1,
  ///     medium: 2,
  ///     expanded: 3,
  ///   );
  static T value<T>(
    BuildContext context, {
    required T compact,
    T? medium,
    T? expanded,
  }) {
    final size = MediaQuery.sizeOf(context);
    switch (classify(size.width)) {
      case DeviceClass.compact:
        return compact;
      case DeviceClass.medium:
        return medium ?? compact;
      case DeviceClass.expanded:
        return expanded ?? medium ?? compact;
    }
  }

  /// True when the available space looks like a foldable book mode:
  /// one dimension is in the expanded range while the other is roughly
  /// tablet portrait, producing an aspect ratio below the threshold.
  static bool isFoldable(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final longest = size.width > size.height ? size.width : size.height;
    final shortest = size.width > size.height ? size.height : size.width;
    final ratio = shortest / longest;
    return longest >= Breakpoints.compact && ratio < Breakpoints.foldableAspectMax;
  }

  /// True when the platform is currently in a tablet-or-larger window.
  static bool isTabletOrLarger(BuildContext context) =>
      classify(MediaQuery.sizeOf(context).width) != DeviceClass.compact;

  /// Padding inset for the current device class — used by `Scaffold.body` to
  /// keep content off the very edge of large screens.
  static EdgeInsets pagePadding(BuildContext context) {
    final w = MediaQuery.sizeOf(context).width;
    if (w >= Breakpoints.medium) {
      return const EdgeInsets.symmetric(horizontal: 48, vertical: 24);
    }
    if (w >= Breakpoints.compact) {
      return const EdgeInsets.symmetric(horizontal: 24, vertical: 16);
    }
    return const EdgeInsets.symmetric(horizontal: 16, vertical: 12);
  }

  /// Maximum content width on large screens — prevents lines of text from
  /// stretching across the entire viewport.
  static double maxContentWidth(BuildContext context) {
    final w = MediaQuery.sizeOf(context).width;
    if (w >= 1280) return 1080;
    if (w >= Breakpoints.medium) return 720;
    return double.infinity;
  }
}

/// A `LayoutBuilder` wrapper that exposes the active [DeviceClass] to its
/// `builder` callback so callers don't have to recompute it.
///
///   AegisLayout(
///     builder: (context, cls, constraints) {
///       return cls == DeviceClass.compact ? MobileNav() : TabletNav();
///     },
///   )
class AegisLayout extends StatelessWidget {
  const AegisLayout({required this.builder, super.key});

  final Widget Function(
    BuildContext context,
    DeviceClass deviceClass,
    BoxConstraints constraints,
  ) builder;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return builder(
          context,
          Responsive.classify(constraints.maxWidth),
          constraints,
        );
      },
    );
  }
}
