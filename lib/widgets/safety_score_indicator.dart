import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../models/safety_score.dart';

class SafetyScoreIndicator extends StatelessWidget {
  final SafetyScore safetyScore;
  final double size;

  const SafetyScoreIndicator({
    super.key,
    required this.safetyScore,
    this.size = 120,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: size,
          height: size,
          child: Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: size,
                height: size,
                child: CircularProgressIndicator(
                  value: safetyScore.score / 100,
                  strokeWidth: 8,
                  backgroundColor: AppTheme.cardBorder,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    _getScoreColor(),
                  ),
                ),
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    safetyScore.score.toStringAsFixed(0),
                    style: TextStyle(
                      color: _getScoreColor(),
                      fontSize: size * 0.3,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'safety',
                    style: TextStyle(
                      color: AppTheme.textSecondary,
                      fontSize: size * 0.1,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          decoration: BoxDecoration(
            color: _getScoreColor().withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: _getScoreColor().withValues(alpha: 0.3),
            ),
          ),
          child: Text(
            safetyScore.level.label,
            style: TextStyle(
              color: _getScoreColor(),
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
        ),
      ],
    );
  }

  Color _getScoreColor() {
    if (safetyScore.score >= 70) return AppTheme.safeGreen;
    if (safetyScore.score >= 40) return AppTheme.warningOrange;
    return AppTheme.dangerRed;
  }
}