// HomeScreen — DPSI gauge, quick actions, recent incidents.
// Reads theme tokens; light and dark variants are automatic.

import 'package:flutter/material.dart';

import '../core/theme/design_tokens.dart';
import '../core/widgets/glass_card.dart';
import '../features/chatbot/presentation/screens/chatbot_screen.dart';
import '../features/safe_zones/presentation/screens/safe_zones_screen.dart';
import '../features/safety/presentation/screens/trip_setup_screen.dart';
import '../models/incident_report.dart';
import '../models/safety_score.dart';
import '../services/location_service.dart';
import '../services/safety_service.dart';
import '../theme/app_theme.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/incident_card.dart';
import '../widgets/safety_score_indicator.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final SafetyService _safetyService = SafetyService();
  final LocationService _locationService = LocationService();

  SafetyScore _safetyScore = SafetyScore.initial();
  List<IncidentReport> _recentIncidents = <IncidentReport>[];
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
            backgroundColor: AppTheme.signalRed,
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
        color: AppTheme.electricCyan,
        onRefresh: _loadData,
        child: _isLoading
            ? const Center(
                child: CircularProgressIndicator(color: AppTheme.electricCyan),
              )
            : SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(AegisSpacing.space5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    _AnimatedSection(
                      delay: Duration.zero,
                      child: GlassCard(
                        padding: const EdgeInsets.all(AegisSpacing.space7),
                        child: Column(
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Container(
                                  width: 4,
                                  height: 24,
                                  decoration: BoxDecoration(
                                    gradient: AegisGradients.aegisCyanGradient,
                                    borderRadius: BorderRadius.circular(2),
                                  ),
                                ),
                                const SizedBox(width: AegisSpacing.space3),
                                Text(
                                  'Current Area Safety',
                                  style: TextStyle(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurface,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(width: AegisSpacing.space3),
                                Container(
                                  width: 4,
                                  height: 24,
                                  decoration: BoxDecoration(
                                    gradient: AegisGradients.aegisCyanGradient,
                                    borderRadius: BorderRadius.circular(2),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: AegisSpacing.space6),
                            SafetyScoreIndicator(
                              safetyScore: _safetyScore,
                              size: 140,
                            ),
                            const SizedBox(height: AegisSpacing.space6),
                            if (_safetyScore.factors.isNotEmpty) ...<Widget>[
                              Divider(
                                color: AppTheme.cardBorder.withValues(
                                  alpha: 0.4,
                                ),
                              ),
                              const SizedBox(height: AegisSpacing.space4),
                              Text(
                                'Safety Factors',
                                style: TextStyle(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onSurfaceVariant,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: AegisSpacing.space3),
                              ..._safetyScore.factors.map(
                                (factor) => Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: AegisSpacing.space1,
                                  ),
                                  child: Row(
                                    children: <Widget>[
                                      const Icon(
                                        Icons.check_circle,
                                        color: AppTheme.signalGreen,
                                        size: 18,
                                      ),
                                      const SizedBox(
                                          width: AegisSpacing.space3),
                                      Expanded(
                                        child: Text(
                                          factor,
                                          style: TextStyle(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onSurface,
                                            fontSize: 14,
                                          ),
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
                    const SizedBox(height: AegisSpacing.space7),
                    Text(
                      'Quick Actions',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurface,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: AegisSpacing.space4),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: _QuickActionCard(
                            icon: Icons.timeline,
                            label: 'Safety Pulse',
                            gradient: AegisGradients.aegisCyanGradient,
                            delay: const Duration(milliseconds: 100),
                            onTap: () => Navigator.of(context).push(MaterialPageRoute<void>(
                              builder: (_) => const TripSetupScreen(),
                            )),
                          ),
                        ),
                        const SizedBox(width: AegisSpacing.space4),
                        Expanded(
                          child: _QuickActionCard(
                            icon: Icons.smart_toy_outlined,
                            label: 'AI Chatbot',
                            gradient: AegisGradients.aegisVioletGradient,
                            delay: const Duration(milliseconds: 200),
                            onTap: () => Navigator.of(context).push(MaterialPageRoute<void>(
                              builder: (_) => const ChatbotScreen(),
                            )),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AegisSpacing.space4),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: _QuickActionCard(
                            icon: Icons.shield_outlined,
                            label: 'Safe Zones',
                            gradient: AegisGradients.aegisCyanGradient,
                            delay: const Duration(milliseconds: 300),
                            onTap: () => Navigator.of(context).push(MaterialPageRoute<void>(
                              builder: (_) => const SafeZonesScreen(),
                            )),
                          ),
                        ),
                        const SizedBox(width: AegisSpacing.space4),
                        Expanded(
                          child: _QuickActionCard(
                            icon: Icons.add_circle_outline,
                            label: 'Report Incident',
                            gradient: AegisGradients.aegisVioletGradient,
                            delay: const Duration(milliseconds: 400),
                            onTap: () => _snack('Use bottom navigation'),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AegisSpacing.space7),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          'Recent Incidents',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onSurface,
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        TextButton(
                          onPressed: () => _snack('Use bottom navigation'),
                          child: const Text('See All'),
                        ),
                      ],
                    ),
                    const SizedBox(height: AegisSpacing.space3),
                    if (_recentIncidents.isEmpty)
                      _AnimatedSection(
                        delay: const Duration(milliseconds: 300),
                        child: GlassCard(
                          child: Center(
                            child: Column(
                              children: <Widget>[
                                const Icon(
                                  Icons.shield_outlined,
                                  color: AppTheme.electricCyan,
                                  size: 48,
                                ),
                                const SizedBox(height: AegisSpacing.space4),
                                Text(
                                  'No recent incidents in your area',
                                  style: TextStyle(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurfaceVariant,
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
                            (entry) => _AnimatedSection(
                              delay: Duration(
                                  milliseconds: 100 * (entry.key + 1)),
                              child: IncidentCard(
                                incident: entry.value,
                                onUpvote: () {
                                  _safetyService
                                      .upvoteIncident(entry.value.id);
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

  void _snack(String text) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(text),
        backgroundColor: AppTheme.signalGreen,
      ),
    );
  }
}

class _AnimatedSection extends StatefulWidget {
  final Widget child;
  final Duration delay;

  const _AnimatedSection({required this.child, this.delay = Duration.zero});

  @override
  State<_AnimatedSection> createState() => _AnimatedSectionState();
}

class _AnimatedSectionState extends State<_AnimatedSection>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fade;
  late Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: AegisMotion.medium,
      vsync: this,
    );
    _fade = CurvedAnimation(parent: _controller, curve: AegisMotion.decelerate);
    _slide = Tween<Offset>(
      begin: const Offset(0, 0.08),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: AegisMotion.decelerate));
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _controller.forward();
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
      opacity: _fade,
      child: SlideTransition(position: _slide, child: widget.child),
    );
  }
}

class _QuickActionCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final LinearGradient gradient;
  final Duration delay;
  final VoidCallback onTap;

  const _QuickActionCard({
    required this.icon,
    required this.label,
    required this.gradient,
    required this.delay,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final fgPrimary =
        isDark ? AppTheme.textPrimary : AppTheme.textPrimaryLight;
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AegisRadius.radiusLg),
        child: Padding(
          padding: const EdgeInsets.all(AegisSpacing.space6),
          child: Column(
            children: <Widget>[
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  gradient: gradient,
                  borderRadius:
                      BorderRadius.circular(AegisRadius.radiusLg),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                      color: AppTheme.electricCyan.withValues(alpha: 0.35),
                      blurRadius: 18,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Icon(icon, color: AppTheme.obsidian, size: 28),
              ),
              const SizedBox(height: AegisSpacing.space4),
              Text(
                label,
                style: TextStyle(
                  color: fgPrimary,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
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
