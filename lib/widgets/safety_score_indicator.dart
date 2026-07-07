// SafetyScoreIndicator — animated ring with the numeric score and a label.
// Uses AegisMotion for the tween, AegisGradients for the ring stroke, and
// the design tokens for sizing. The ring colour picks from the semantic
// safe/amber/danger palette based on the score band.

import 'package:flutter/material.dart';

import '../core/theme/design_tokens.dart';
import '../models/safety_score.dart';
import '../theme/app_theme.dart';

class SafetyScoreIndicator extends StatefulWidget {
  final SafetyScore safetyScore;
  final double size;

  const SafetyScoreIndicator({
    required this.safetyScore,
    this.size = 140,
    super.key,
  });

  @override
  State<SafetyScoreIndicator> createState() => _SafetyScoreIndicatorState();
}

class _SafetyScoreIndicatorState extends State<SafetyScoreIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: AegisMotion.slow,
      vsync: this,
    );
    _animation = Tween<double>(
      begin: 0,
      end: (widget.safetyScore.score / 100).clamp(0.0, 1.0),
    ).animate(CurvedAnimation(parent: _controller, curve: AegisMotion.decelerate));
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _controller.forward();
    });
  }

  @override
  void didUpdateWidget(covariant SafetyScoreIndicator old) {
    super.didUpdateWidget(old);
    if (old.safetyScore.score != widget.safetyScore.score) {
      _animation = Tween<double>(
        begin: _animation.value,
        end: (widget.safetyScore.score / 100).clamp(0.0, 1.0),
      ).animate(CurvedAnimation(parent: _controller, curve: AegisMotion.decelerate));
      _controller
        ..reset()
        ..forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final score = widget.safetyScore.score;
    final color = _scoreColor(score);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: widget.size,
          height: widget.size,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: widget.size,
                height: widget.size,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      color.withValues(alpha: 0.20),
                      color.withValues(alpha: 0.0),
                    ],
                  ),
                ),
              ),
              SizedBox(
                width: widget.size,
                height: widget.size,
                child: AnimatedBuilder(
                  animation: _animation,
                  builder: (context, _) {
                    return CircularProgressIndicator(
                      value: _animation.value,
                      strokeWidth: 8,
                      backgroundColor: AppTheme.cardBorder.withValues(alpha: 0.4),
                      valueColor: AlwaysStoppedAnimation<Color>(color),
                      strokeCap: StrokeCap.round,
                    );
                  },
                ),
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    score.toStringAsFixed(0),
                    style: TextStyle(
                      color: color,
                      fontSize: widget.size * 0.3,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.5,
                    ),
                  ),
                  Text(
                    'safety',
                    style: TextStyle(
                      color: AppTheme.textSecondary,
                      fontSize: widget.size * 0.10,
                      letterSpacing: 1.2,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: AegisSpacing.space3),
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AegisSpacing.space5,
            vertical: AegisSpacing.space1,
          ),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.18),
            borderRadius: BorderRadius.circular(AegisRadius.radiusFull),
            border: Border.all(color: color.withValues(alpha: 0.30)),
          ),
          child: Text(
            widget.safetyScore.level.label,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.w700,
              fontSize: 13,
              letterSpacing: 0.4,
            ),
          ),
        ),
      ],
    );
  }

  Color _scoreColor(double score) {
    if (score >= 70) return AppTheme.signalGreen;
    if (score >= 40) return AppTheme.signalAmber;
    return AppTheme.signalRed;
  }
}
