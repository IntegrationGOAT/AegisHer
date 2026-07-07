// CommunityScreen — filterable list of community-reported incidents.

import 'package:flutter/material.dart';

import '../core/theme/design_tokens.dart';
import '../models/incident_report.dart';
import '../services/safety_service.dart';
import '../theme/app_theme.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/incident_card.dart';

class CommunityScreen extends StatefulWidget {
  const CommunityScreen({super.key});

  @override
  State<CommunityScreen> createState() => _CommunityScreenState();
}

class _CommunityScreenState extends State<CommunityScreen> {
  final SafetyService _safetyService = SafetyService();
  List<IncidentReport> _incidents = <IncidentReport>[];
  bool _isLoading = true;
  IncidentType? _selectedFilter;

  @override
  void initState() {
    super.initState();
    _loadIncidents();
  }

  Future<void> _loadIncidents() async {
    setState(() => _isLoading = true);
    try {
      final incidents = await _safetyService.getNearbyIncidents(
        latitude: 19.0760,
        longitude: 72.8777,
        radiusKm: 5.0,
      );
      if (mounted) {
        setState(() {
          _incidents = incidents;
          _isLoading = false;
        });
      }
    } catch (_) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  List<IncidentReport> get _filteredIncidents {
    if (_selectedFilter == null) return _incidents;
    return _incidents.where((i) => i.type == _selectedFilter).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Community Reports',
        showBackButton: false,
      ),
      body: Column(
        children: <Widget>[
          Container(
            padding: const EdgeInsets.symmetric(vertical: AegisSpacing.space4),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding:
                  const EdgeInsets.symmetric(horizontal: AegisSpacing.space5),
              child: Row(
                children: <Widget>[
                  _FilterChip(
                    label: 'All',
                    selected: _selectedFilter == null,
                    onTap: () => setState(() => _selectedFilter = null),
                  ),
                  const SizedBox(width: AegisSpacing.space3),
                  ...IncidentType.values.map(
                    (type) => Padding(
                      padding:
                          const EdgeInsets.only(right: AegisSpacing.space3),
                      child: _FilterChip(
                        label: type.label,
                        selected: _selectedFilter == type,
                        onTap: () => setState(() => _selectedFilter = type),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          Expanded(
            child: RefreshIndicator(
              color: AppTheme.electricCyan,
              onRefresh: _loadIncidents,
              child: _isLoading
                  ? const Center(
                      child: CircularProgressIndicator(
                          color: AppTheme.electricCyan),
                    )
                  : _filteredIncidents.isEmpty
                      ? ListView(
                          children: <Widget>[
                            const SizedBox(height: 100),
                            Center(
                              child: Column(
                                children: <Widget>[
                                  const Icon(
                                    Icons.shield_outlined,
                                    color: AppTheme.electricCyan,
                                    size: 64,
                                  ),
                                  const SizedBox(
                                      height: AegisSpacing.space5),
                                  Text(
                                    'No incidents reported',
                                    style: TextStyle(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurface,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(
                                      height: AegisSpacing.space3),
                                  Text(
                                    'Your area looks safe!',
                                    style: TextStyle(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurfaceVariant,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.only(
                              bottom: AegisSpacing.space5),
                          itemCount: _filteredIncidents.length,
                          itemBuilder: (context, index) {
                            final incident = _filteredIncidents[index];
                            return IncidentCard(
                              incident: incident,
                              onUpvote: () {
                                _safetyService.upvoteIncident(incident.id);
                              },
                              onTap: () {
                                // TODO: Show incident details
                              },
                            );
                          },
                        ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: AegisMotion.fast,
        curve: AegisMotion.standard,
        padding: const EdgeInsets.symmetric(
          horizontal: AegisSpacing.space5,
          vertical: AegisSpacing.space3,
        ),
        decoration: BoxDecoration(
          gradient: selected ? AegisGradients.aegisCyanGradient : null,
          color: selected ? null : AppTheme.darkSurface,
          borderRadius: BorderRadius.circular(AegisRadius.radiusFull),
          border: Border.all(
            color: selected
                ? Colors.transparent
                : AppTheme.cardBorder.withValues(alpha: 0.6),
            width: 1,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: selected
                ? AppTheme.obsidian
                : AppTheme.textSecondary,
            fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
            fontSize: 13,
            letterSpacing: 0.3,
          ),
        ),
      ),
    );
  }
}
