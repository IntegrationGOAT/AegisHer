// IncidentCard — used in Community list and Home feed.
// Reads colours from the theme so light and dark variants both work.

import 'package:flutter/material.dart';

import '../core/theme/design_tokens.dart';
import '../models/incident_report.dart';
import '../theme/app_theme.dart';

class IncidentCard extends StatelessWidget {
  final IncidentReport incident;
  final VoidCallback? onUpvote;
  final VoidCallback? onTap;

  const IncidentCard({
    required this.incident,
    this.onUpvote,
    this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final typeColor = _typeColor();
    final typeIcon = _typeIcon();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final fgPrimary =
        isDark ? AppTheme.textPrimary : AppTheme.textPrimaryLight;
    final fgSecondary =
        isDark ? AppTheme.textSecondary : AppTheme.textSecondaryLight;
    final cardColor = isDark ? AppTheme.darkCard : AppTheme.lightCard;

    return Card(
      color: cardColor,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AegisRadius.radiusLg),
        child: Padding(
          padding: const EdgeInsets.all(AegisSpacing.space5),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      typeColor.withValues(alpha: 0.32),
                      typeColor.withValues(alpha: 0.10),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(AegisRadius.radiusMd),
                ),
                child: Icon(typeIcon, color: typeColor, size: 24),
              ),
              const SizedBox(width: AegisSpacing.space4),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AegisSpacing.space3,
                            vertical: AegisSpacing.space1,
                          ),
                          decoration: BoxDecoration(
                            color: typeColor.withValues(alpha: 0.16),
                            borderRadius:
                                BorderRadius.circular(AegisRadius.radiusSm),
                          ),
                          child: Text(
                            incident.type.label,
                            style: TextStyle(
                              color: typeColor,
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.4,
                            ),
                          ),
                        ),
                        const Spacer(),
                        if (incident.verified)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AegisSpacing.space2,
                              vertical: AegisSpacing.space1,
                            ),
                            decoration: BoxDecoration(
                              color: AppTheme.signalGreen
                                  .withValues(alpha: 0.15),
                              borderRadius:
                                  BorderRadius.circular(AegisRadius.radiusSm),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.verified,
                                  color: AppTheme.signalGreen,
                                  size: 12,
                                ),
                                const SizedBox(width: 2),
                                Text(
                                  'Verified',
                                  style: TextStyle(
                                    color: AppTheme.signalGreen,
                                    fontSize: 10,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: AegisSpacing.space3),
                    Text(
                      incident.description,
                      style: TextStyle(
                        color: fgPrimary,
                        fontSize: 14,
                        height: 1.4,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: AegisSpacing.space2),
                    Row(
                      children: [
                        Icon(
                          Icons.location_on_outlined,
                          color: fgSecondary,
                          size: 14,
                        ),
                        const SizedBox(width: AegisSpacing.space1),
                        Expanded(
                          child: Text(
                            incident.address,
                            style: TextStyle(
                              color: fgSecondary,
                              fontSize: 12,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AegisSpacing.space1),
                    Text(
                      _formatTimeAgo(incident.reportedAt),
                      style: TextStyle(
                        color: fgSecondary,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AegisSpacing.space3),
              Column(
                children: [
                  InkWell(
                    onTap: onUpvote,
                    borderRadius:
                        BorderRadius.circular(AegisRadius.radiusFull),
                    child: Container(
                      padding: const EdgeInsets.all(AegisSpacing.space2),
                      decoration: BoxDecoration(
                        color: AppTheme.electricCyan.withValues(alpha: 0.16),
                        borderRadius:
                            BorderRadius.circular(AegisRadius.radiusFull),
                      ),
                      child: const Icon(
                        Icons.arrow_upward,
                        color: AppTheme.electricCyan,
                        size: 20,
                      ),
                    ),
                  ),
                  const SizedBox(height: AegisSpacing.space1),
                  Text(
                    '${incident.upvotes}',
                    style: TextStyle(
                      color: fgSecondary,
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _typeColor() {
    switch (incident.type) {
      case IncidentType.theft:
        return AppTheme.signalAmber;
      case IncidentType.harassment:
        return AppTheme.violet;
      case IncidentType.assault:
        return AppTheme.signalRed;
      case IncidentType.suspiciousActivity:
        return AppTheme.signalAmber;
      case IncidentType.poorLighting:
        return AppTheme.electricCyan;
      case IncidentType.roadHazard:
        return AppTheme.signalAmber;
      case IncidentType.other:
        return AppTheme.textSecondary;
    }
  }

  IconData _typeIcon() {
    switch (incident.type) {
      case IncidentType.theft:
        return Icons.shopping_bag_outlined;
      case IncidentType.harassment:
        return Icons.warning_amber_outlined;
      case IncidentType.assault:
        return Icons.gavel_outlined;
      case IncidentType.suspiciousActivity:
        return Icons.visibility_outlined;
      case IncidentType.poorLighting:
        return Icons.lightbulb_outline;
      case IncidentType.roadHazard:
        return Icons.construction_outlined;
      case IncidentType.other:
        return Icons.report_problem_outlined;
    }
  }

  String _formatTimeAgo(DateTime dateTime) {
    final difference = DateTime.now().difference(dateTime);
    if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else {
      return '${difference.inDays}d ago';
    }
  }
}
