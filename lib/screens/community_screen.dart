import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import '../models/incident_report.dart';
import '../services/safety_service.dart';
import '../widgets/incident_card.dart';
import '../widgets/custom_app_bar.dart';

class CommunityScreen extends StatefulWidget {
  const CommunityScreen({super.key});

  @override
  State<CommunityScreen> createState() => _CommunityScreenState();
}

class _CommunityScreenState extends State<CommunityScreen> {
  final SafetyService _safetyService = SafetyService();
  List<IncidentReport> _incidents = [];
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
      // Using default location for now
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
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
      }
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
        children: [
          // Filter chips
          Container(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  _FilterChip(
                    label: 'All',
                    selected: _selectedFilter == null,
                    onTap: () => setState(() => _selectedFilter = null),
                  ),
                  const SizedBox(width: 8),
                  ...IncidentType.values.map(
                    (type) => Padding(
                      padding: const EdgeInsets.only(right: 8),
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

          // Incident list
          Expanded(
            child: RefreshIndicator(
              color: AppTheme.primaryRed,
              onRefresh: _loadIncidents,
              child: _isLoading
                  ? const Center(
                      child: CircularProgressIndicator(
                        color: AppTheme.primaryRed,
                      ),
                    )
                  : _filteredIncidents.isEmpty
                  ? ListView(
                      children: const [
                        SizedBox(height: 100),
                        Center(
                          child: Column(
                            children: [
                              Icon(
                                Icons.shield_outlined,
                                color: AppTheme.primaryRed,
                                size: 64,
                              ),
                              SizedBox(height: 16),
                              Text(
                                'No incidents reported',
                                style: TextStyle(
                                  color: AppTheme.textPrimary,
                                  fontSize: 18,
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                'Your area looks safe!',
                                style: TextStyle(
                                  color: AppTheme.textSecondary,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.only(bottom: 16),
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
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // Navigation handled by parent widget
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Use bottom navigation to switch tabs'),
              backgroundColor: AppTheme.safeGreen,
            ),
          );
        },
        icon: const Icon(Icons.add),
        label: const Text('Report'),
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
        duration: AppTheme.fastDuration,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? AppTheme.primaryRed : AppTheme.darkSurface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: selected ? AppTheme.primaryRed : AppTheme.cardBorder,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: selected ? Colors.white : AppTheme.textSecondary,
            fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
            fontSize: 13,
          ),
        ),
      ),
    );
  }
}
