// NeumorphicButton — outset (raised) and inset (pressed) variants styled with
// soft dual-tone shadows for a tactile, soft-UI feel. Used for quiet controls
// that need to recede into the surface (theme toggle, accessibility toggles,
// secondary filters).
//
// Uses [GlassNeumorphicTokens] from the theme so light and dark both produce
// believable shadow pairs.

import 'package:flutter/material.dart';

import '../theme/design_tokens.dart';

enum NeumorphicVariant { outset, inset, flat }

class NeumorphicButton extends StatefulWidget {
  const NeumorphicButton({
    required this.child,
    required this.onPressed,
    super.key,
    this.variant = NeumorphicVariant.outset,
    this.padding = const EdgeInsets.symmetric(
      horizontal: AegisSpacing.space5,
      vertical: AegisSpacing.space4,
    ),
    this.borderRadius = const BorderRadius.all(Radius.circular(AegisRadius.radiusLg)),
    this.semanticLabel,
  });

  final Widget child;
  final VoidCallback? onPressed;
  final NeumorphicVariant variant;
  final EdgeInsetsGeometry padding;
  final BorderRadius borderRadius;
  final String? semanticLabel;

  @override
  State<NeumorphicButton> createState() => _NeumorphicButtonState();
}

class _NeumorphicButtonState extends State<NeumorphicButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl = AnimationController(
    vsync: this,
    duration: AegisMotion.fast,
    value: widget.variant == NeumorphicVariant.inset ? 1 : 0,
  );

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void _setPressed(bool pressed) {
    if (widget.onPressed == null) return;
    _ctrl.animateTo(
      pressed || widget.variant == NeumorphicVariant.inset ? 1 : 0,
      curve: AegisMotion.standard,
    );
  }

  @override
  Widget build(BuildContext context) {
    final tokens = Theme.of(context).extension<GlassNeumorphicTokens>()!;
    final radius = widget.borderRadius;

    return Semantics(
      button: true,
      enabled: widget.onPressed != null,
      label: widget.semanticLabel,
      child: GestureDetector(
        onTapDown: (_) => _setPressed(true),
        onTapUp: (_) => _setPressed(false),
        onTapCancel: () => _setPressed(false),
        onTap: widget.onPressed,
        child: AnimatedBuilder(
          animation: _ctrl,
          builder: (context, child) {
            final pressed = _ctrl.value;
            final outset = widget.variant == NeumorphicVariant.outset;
            final inset = widget.variant == NeumorphicVariant.inset;
            final blend = inset ? pressed : (outset ? 1 - pressed : 0);

            final outerDark = tokens.neumorphicDarkShadow.withValues(
              alpha: 0.55 * blend,
            );
            final innerLight = tokens.neumorphicLightShadow.withValues(
              alpha: 0.35 * blend,
            );

            return DecoratedBox(
              decoration: BoxDecoration(
                color: tokens.neumorphicSurface,
                borderRadius: radius,
                boxShadow: <BoxShadow>[
                  BoxShadow(
                    color: outerDark,
                    blurRadius: 18,
                    offset: Offset(6.0 * blend, 6.0 * blend),
                  ),
                  BoxShadow(
                    color: innerLight,
                    blurRadius: 18,
                    offset: Offset(-6.0 * blend, -6.0 * blend),
                  ),
                ],
                border: Border.all(
                  color: tokens.glassBorder.withValues(alpha: 0.08),
                  width: 0.6,
                ),
              ),
              child: Padding(padding: widget.padding, child: child),
            );
          },
          child: widget.child,
        ),
      ),
    );
  }
}
