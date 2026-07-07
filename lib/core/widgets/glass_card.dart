// GlassCard — translucent surface with BackdropFilter blur and a hairline
// border. Used throughout the futuristic UI for cards, sheets, and tiles.
//
// The card reads its tint/border from the [GlassNeumorphicTokens] theme
// extension but every value can be overridden via the constructor for
// per-screen theming (e.g. emergency red on SOS).

import 'dart:ui';

import 'package:flutter/material.dart';

import '../theme/design_tokens.dart';

class GlassCard extends StatelessWidget {
  const GlassCard({
    required this.child,
    super.key,
    this.padding = const EdgeInsets.all(AegisSpacing.space5),
    this.margin = EdgeInsets.zero,
    this.borderRadius = const BorderRadius.all(Radius.circular(AegisRadius.radiusLg)),
    this.tint,
    this.border,
    this.highlight,
    this.blur,
    this.width,
    this.height,
    this.onTap,
    this.elevated = true,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry margin;
  final BorderRadius borderRadius;
  final Color? tint;
  final Color? border;
  final Color? highlight;
  final double? blur;
  final double? width;
  final double? height;
  final VoidCallback? onTap;
  final bool elevated;

  @override
  Widget build(BuildContext context) {
    final tokens = Theme.of(context).extension<GlassNeumorphicTokens>()!;
    final effectiveTint = tint ?? tokens.glassSurface;
    final effectiveBorder = border ?? tokens.glassBorder;
    final effectiveHighlight = highlight ?? tokens.glassHighlight;
    final effectiveBlur = blur ?? tokens.glassBlur;

    final radius = borderRadius;

    final card = ClipRRect(
      borderRadius: radius,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: effectiveBlur, sigmaY: effectiveBlur),
        child: Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            color: effectiveTint,
            borderRadius: radius,
            border: Border.all(
              color: effectiveBorder.withValues(alpha: 0.18),
              width: 0.6,
            ),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: <Color>[
                effectiveHighlight.withValues(alpha: 0.10),
                effectiveTint,
              ],
            ),
            boxShadow: elevated
                ? <BoxShadow>[
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.20),
                      blurRadius: 18,
                      offset: const Offset(0, 8),
                    ),
                  ]
                : null,
          ),
          padding: padding,
          child: child,
        ),
      ),
    );

    final wrapped = margin == EdgeInsets.zero ? card : Padding(padding: margin, child: card);

    if (onTap == null) return wrapped;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: radius,
        child: wrapped,
      ),
    );
  }
}
