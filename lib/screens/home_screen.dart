import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import '../models/safety_score.dart';
import '../models/incident_report.dart';
import '../services/safety_service.dart';
import '../services/location_service.dart';
import '../widgets/safety_score_indicator.dart';
import '../widgets/incident_card.dart';
import '../widgets/custom_app_bar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final SafetyService _safetyService = SafetyService();
  final LocationService _locationService = LocationService();

  SafetyScore _safetyScore = SafetyScore.initial();
  List<IncidentReport> _recentIncidents = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    try {
      final location = await _locationService.getCurrentLocation();
      final score = await _safetyService.getSafetyScore(
        location['latitude']!,
        location['longitude']!,
      );
      final incidents = await _safetyService.getNearbyIncidents(
        latitude: location['latitude']!,
        longitude: location['longitude']!,
      );

      if (mounted) {
        setState(() {
          _safetyScore = score;
          _recentIncidents = incidents;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error loading data: $e'),
            backgroundColor: AppTheme.dangerRed,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'AegisHer', showBackButton: false),
      body: RefreshIndicator(
        color: AppTheme.primaryRed,
        onRefresh: _loadData,
        child: _isLoading
            ? const Center(
                child: CircularProgressIndicator(color: AppTheme.primaryRed),
              )
            : SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Safety Score Section
                    _AnimatedCard(
                      delay: Duration.zero,
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  width: 4,
                                  height: 24,
                                  decoration: BoxDecoration(
                                    color: AppTheme.primaryRed,
                                    borderRadius: BorderRadius.circular(2),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                const Text(
                                  'Current Area Safety',
                                  style: TextStyle(
                                    color: AppTheme.textPrimary,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Container(
                                  width: 4,
                                  height: 24,
                                  decoration: BoxDecoration(
                                    color: AppTheme.primaryRed,
                                    borderRadius: BorderRadius.circular(2),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                            SafetyScoreIndicator(
                              safetyScore: _safetyScore,
                              size: 140,
                            ),
                            const SizedBox(height: 20),
                            if (_safetyScore.factors.isNotEmpty) ...[
                              const Divider(color: AppTheme.cardBorder),
                              const SizedBox(height: 12),
                              const Text(
                                'Safety Factors',
                                style: TextStyle(
                                  color: AppTheme.textSecondary,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 8),
                              ..._safetyScore.factors.map(
                                (factor) => Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 4,
                                  ),
                                  child: Row(
                                    children: [
                                      const Icon(
                                        Icons.check_circle,
                                        color: AppTheme.safeGreen,
                                        size: 18,
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        factor,
                                        style: const TextStyle(
                                          color: AppTheme.textPrimary,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Quick Actions
                    const Text(
                      'Quick Actions',
                      style: TextStyle(
                        color: AppTheme.textPrimary,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: _QuickActionCard(
                            icon: Icons.map_outlined,
                            label: 'Find Safe Route',
                            color: AppTheme.primaryRed,
                            delay: const Duration(milliseconds: 100),
                            onTap: () {
                              // Navigation handled by parent widget
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'Use bottom navigation to switch tabs',
                                  ),
                                  backgroundColor: AppTheme.safeGreen,
                                ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _QuickActionCard(
                            icon: Icons.add_circle_outline,
                            label: 'Report Incident',
                            color: AppTheme.accentRed,
                            delay: const Duration(milliseconds: 200),
                            onTap: () {
                              // Navigation handled by parent widget
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'Use bottom navigation to switch tabs',
                                  ),
                                  backgroundColor: AppTheme.safeGreen,
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Recent Incidents
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Recent Incidents',
                          style: TextStyle(
                            color: AppTheme.textPrimary,
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            // Navigation handled by parent widget
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Use bottom navigation to switch tabs',
                                ),
                                backgroundColor: AppTheme.safeGreen,
                              ),
                            );
                          },
                          child: const Text(
                            'See All',
                            style: TextStyle(color: AppTheme.primaryRed),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    if (_recentIncidents.isEmpty)
                      _AnimatedCard(
                        delay: const Duration(milliseconds: 300),
                        child: const Padding(
                          padding: EdgeInsets.all(24),
                          child: Center(
                            child: Column(
                              children: [
                                Icon(
                                  Icons.shield_outlined,
                                  color: AppTheme.primaryRed,
                                  size: 48,
                                ),
                                SizedBox(height: 12),
                                Text(
                                  'No recent incidents in your area',
                                  style: TextStyle(
                                    color: AppTheme.textSecondary,
                                    fontSize: 15,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                    else
                      ..._recentIncidents.asMap().entries.map(
                        (entry) => _AnimatedCard(
                          delay: Duration(milliseconds: 100 * (entry.key + 1)),
                          child: IncidentCard(
                            incident: entry.value,
                            onUpvote: () {
                              _safetyService.upvoteIncident(entry.value.id);
                            },
                          ),
                        ),
                      ),
                  ],
                ),
              ),
      ),
    );
  }
}

class _AnimatedCard extends StatefulWidget {
  final Widget child;
  final Duration delay;

  const _AnimatedCard({required this.child, this.delay = Duration.zero});

  @override
  State<_AnimatedCard> createState() => _AnimatedCardState();
}

class _AnimatedCardState extends State<_AnimatedCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: AppTheme.mediumDuration,
      vsync: this,
    );
    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.1),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));

    // Start animation after a frame to allow build to complete
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _controller.forward();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(position: _slideAnimation, child: widget.child),
    );
  }
}

class _QuickActionCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final Duration delay;
  final VoidCallback onTap;

  const _QuickActionCard({
    required this.icon,
    required this.label,
    required this.color,
    required this.delay,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      color.withValues(alpha: 0.3),
                      color.withValues(alpha: 0.1),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(icon, color: color, size: 28),
              ),
              const SizedBox(height: 12),
              Text(
                label,
                style: const TextStyle(
                  color: AppTheme.textPrimary,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
