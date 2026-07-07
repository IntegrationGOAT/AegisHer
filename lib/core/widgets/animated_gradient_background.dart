// AnimatedGradientBackground — a 60 FPS shader-like animated gradient with
// subtle parallax drift. Used behind Home, Login, and Onboarding to give the
// app its futuristic Apple/Tesla atmosphere.
//
// The animation uses two layered AnimationControllers (drift + breathe) so the
// gradient moves continuously even when the user is idle. The base layer is
// drawn with two radial-gradient orbs whose centers trace a Lissajous curve.

import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../theme/design_tokens.dart';

class AnimatedGradientBackground extends StatefulWidget {
  const AnimatedGradientBackground({
    required this.child,
    super.key,
    this.seedColor1,
    this.seedColor2,
    this.seedColor3,
    this.intensity = 1.0,
    this.paused = false,
  });

  final Widget child;
  final Color? seedColor1;
  final Color? seedColor2;
  final Color? seedColor3;
  final double intensity;
  final bool paused;

  @override
  State<AnimatedGradientBackground> createState() =>
      _AnimatedGradientBackgroundState();
}

class _AnimatedGradientBackgroundState extends State<AnimatedGradientBackground>
    with TickerProviderStateMixin {
  late final AnimationController _drift = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 18),
  )..repeat();
  late final AnimationController _breathe = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 6),
  )..repeat(reverse: true);

  @override
  void didUpdateWidget(covariant AnimatedGradientBackground old) {
    super.didUpdateWidget(old);
    if (widget.paused && _drift.isAnimating) {
      _drift.stop();
      _breathe.stop();
    } else if (!widget.paused && !_drift.isAnimating) {
      _drift.repeat();
      _breathe.repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    _drift.dispose();
    _breathe.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final c2 = widget.seedColor2 ?? const Color(0xFF00E5FF);
    final c3 = widget.seedColor3 ?? const Color(0xFF7C4DFF);

    return AnimatedBuilder(
      animation: Listenable.merge(<Listenable>[_drift, _breathe]),
      builder: (context, child) {
        final t = _drift.value * math.pi * 2; // 0..2π
        final breathe = _breathe.value;
        final dx = (breathe - 0.5) * 0.18 * widget.intensity;
        final dy = (breathe - 0.5) * 0.12 * widget.intensity;
        final alignA = Alignment(
          -1 + 1.6 * (0.5 + 0.5 * math.sin(t)),
          -1 + 1.6 * (0.5 + 0.5 * math.cos(t)),
        );
        final alignB = Alignment(
          1 - 1.4 * (0.5 + 0.5 * (math.sin(t) + 1.4)),
          1 - 1.4 * (0.5 + 0.5 * (math.cos(t) + 0.6)),
        );

        final baseGradient = brightness == Brightness.dark
            ? AegisGradients.aegisObsidianGradient
            : const LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: <Color>[Color(0xFFF5F5F7), Color(0xFFE6E6EC)],
              );

        return Stack(
          fit: StackFit.expand,
          children: <Widget>[
            DecoratedBox(
              decoration: BoxDecoration(gradient: baseGradient),
              child: const SizedBox.expand(),
            ),
            Transform.translate(
              offset: Offset(dx * 30, dy * 30),
              child: _GlowOrb(
                color: c2.withValues(alpha: 0.30),
                alignment: alignA,
              ),
            ),
            Transform.translate(
              offset: Offset(-dx * 22, -dy * 22),
              child: _GlowOrb(
                color: c3.withValues(alpha: 0.26),
                alignment: alignB,
              ),
            ),
            DecoratedBox(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment.center,
                  radius: 1.4,
                  colors: <Color>[
                    Colors.transparent,
                    (brightness == Brightness.dark
                            ? Colors.black
                            : Colors.white)
                        .withValues(alpha: 0.20),
                  ],
                ),
              ),
              child: const SizedBox.expand(),
            ),
            child!,
          ],
        );
      },
      child: widget.child,
    );
  }
}

class _GlowOrb extends StatelessWidget {
  const _GlowOrb({required this.color, required this.alignment});

  final Color color;
  final Alignment alignment;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: alignment,
      child: FractionallySizedBox(
        widthFactor: 0.95,
        heightFactor: 0.95,
        child: DecoratedBox(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(
              colors: <Color>[
                color,
                color.withValues(alpha: 0),
              ],
              stops: const <double>[0.0, 1.0],
            ),
          ),
          child: const SizedBox.expand(),
        ),
      ),
    );
  }
}
