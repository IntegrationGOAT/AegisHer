// FuturisticButton — primary/secondary/ghost variants with press feedback and
// optional shimmer-on-load. The primary variant uses the aegisCyanGradient,
// secondary uses aegisVioletGradient, ghost is a transparent outlined button
// with cyan border.

import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import '../theme/design_tokens.dart';

enum FuturisticButtonVariant { primary, secondary, ghost, danger }

class FuturisticButton extends StatefulWidget {
  const FuturisticButton({
    required this.label,
    required this.onPressed,
    super.key,
    this.variant = FuturisticButtonVariant.primary,
    this.icon,
    this.loading = false,
    this.expand = false,
    this.semanticLabel,
  });

  final String label;
  final VoidCallback? onPressed;
  final FuturisticButtonVariant variant;
  final IconData? icon;
  final bool loading;
  final bool expand;
  final String? semanticLabel;

  @override
  State<FuturisticButton> createState() => _FuturisticButtonState();
}

class _FuturisticButtonState extends State<FuturisticButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _press = AnimationController(
    vsync: this,
    duration: AegisMotion.fast,
    lowerBound: 0,
    upperBound: 0.04,
  );
  bool _hovered = false;

  @override
  void dispose() {
    _press.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final disabled = widget.onPressed == null || widget.loading;

    final (gradient, fg, border) = _styleFor(widget.variant);

    final child = AnimatedBuilder(
      animation: _press,
      builder: (context, c) {
        return Transform.scale(
          scale: 1 - _press.value,
          child: c,
        );
      },
      child: Container(
        height: 52,
        padding: const EdgeInsets.symmetric(horizontal: AegisSpacing.space6),
        decoration: BoxDecoration(
          gradient: gradient,
          color: gradient == null ? Colors.transparent : null,
          borderRadius: BorderRadius.circular(AegisRadius.radiusLg),
          border: gradient == null
              ? Border.all(color: border ?? AppTheme.electricCyan, width: 1.2)
              : null,
          boxShadow: gradient != null && !disabled
              ? <BoxShadow>[
                  BoxShadow(
                    color: (border ?? AppTheme.electricCyan)
                        .withValues(alpha: _hovered ? 0.45 : 0.25),
                    blurRadius: _hovered ? 22 : 14,
                    offset: const Offset(0, 6),
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisSize:
              widget.expand ? MainAxisSize.max : MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            if (widget.loading)
              SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(fg),
                ),
              )
            else if (widget.icon != null)
              Icon(widget.icon, size: 18, color: fg),
            if ((widget.icon != null || widget.loading) &&
                widget.label.isNotEmpty)
              const SizedBox(width: AegisSpacing.space3),
            Flexible(
              child: Text(
                widget.label,
                style: TextStyle(
                  color: fg,
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                  letterSpacing: 0.2,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );

    final wrapped = Stack(
      children: <Widget>[
        Positioned.fill(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(AegisRadius.radiusLg),
            child: widget.loading
                ? const _ShimmerLayer()
                : const SizedBox.shrink(),
          ),
        ),
        child,
      ],
    );

    return Semantics(
      button: true,
      enabled: !disabled,
      label: widget.semanticLabel ?? widget.label,
      child: MouseRegion(
        onEnter: (_) => setState(() => _hovered = true),
        onExit: (_) => setState(() => _hovered = false),
        child: GestureDetector(
          onTapDown: disabled ? null : (_) => _press.forward(),
          onTapUp: disabled ? null : (_) => _press.reverse(),
          onTapCancel: disabled ? null : () => _press.reverse(),
          onTap: disabled ? null : widget.onPressed,
          child: widget.expand
              ? SizedBox(width: double.infinity, child: wrapped)
              : wrapped,
        ),
      ),
    );
  }

  (LinearGradient?, Color, Color?) _styleFor(FuturisticButtonVariant v) {
    switch (v) {
      case FuturisticButtonVariant.primary:
        return (
          AegisGradients.aegisCyanGradient,
          Colors.black,
          AppTheme.electricCyan,
        );
      case FuturisticButtonVariant.secondary:
        return (
          AegisGradients.aegisVioletGradient,
          Colors.white,
          AppTheme.violet,
        );
      case FuturisticButtonVariant.ghost:
        return (null, AppTheme.electricCyan, AppTheme.electricCyan);
      case FuturisticButtonVariant.danger:
        return (
          AegisGradients.aegisSosGradient,
          Colors.white,
          AppTheme.signalRed,
        );
    }
  }
}

class _ShimmerLayer extends StatefulWidget {
  const _ShimmerLayer();

  @override
  State<_ShimmerLayer> createState() => _ShimmerLayerState();
}

class _ShimmerLayerState extends State<_ShimmerLayer>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1400),
  )..repeat();

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _ctrl,
      builder: (context, _) {
        final t = _ctrl.value;
        return DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment(-1 + 2 * t, 0),
              end: Alignment(1 + 2 * t, 0),
              colors: const <Color>[
                Color(0x10FFFFFF),
                Color(0x55FFFFFF),
                Color(0x10FFFFFF),
              ],
              stops: const <double>[0.0, 0.5, 1.0],
            ),
          ),
        );
      },
    );
  }
}
