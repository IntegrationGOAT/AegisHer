// ReportIncidentScreen — typed form for submitting a community incident.

import 'package:flutter/material.dart';

import '../core/theme/design_tokens.dart';
import '../models/incident_report.dart';
import '../services/safety_service.dart';
import '../theme/app_theme.dart';
import '../widgets/custom_app_bar.dart';

class ReportIncidentScreen extends StatefulWidget {
  const ReportIncidentScreen({super.key});

  @override
  State<ReportIncidentScreen> createState() => _ReportIncidentScreenState();
}

class _ReportIncidentScreenState extends State<ReportIncidentScreen> {
  final SafetyService _safetyService = SafetyService();
  final _formKey = GlobalKey<FormState>();
  final _descriptionController = TextEditingController();
  final _addressController = TextEditingController();

  IncidentType _selectedType = IncidentType.other;
  bool _isSubmitting = false;

  @override
  void dispose() {
    _descriptionController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  Future<void> _submitReport() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isSubmitting = true);

    try {
      final report = IncidentReport(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        type: _selectedType,
        latitude: 19.0760,
        longitude: 72.8777,
        address: _addressController.text,
        description: _descriptionController.text,
        reportedAt: DateTime.now(),
      );

      final success = await _safetyService.reportIncident(report);

      if (mounted) {
        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Incident reported successfully!'),
              backgroundColor: AppTheme.signalGreen,
            ),
          );
          Navigator.pop(context);
        } else {
          setState(() => _isSubmitting = false);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Failed to report incident. Please try again.'),
              backgroundColor: AppTheme.signalRed,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isSubmitting = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: AppTheme.signalRed,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Report Incident',
        showBackButton: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AegisSpacing.space5),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Incident Type',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: AegisSpacing.space4),
              Wrap(
                spacing: AegisSpacing.space3,
                runSpacing: AegisSpacing.space3,
                children: IncidentType.values.map((type) {
                  final isSelected = _selectedType == type;
                  return GestureDetector(
                    onTap: () => setState(() => _selectedType = type),
                    child: AnimatedContainer(
                      duration: AegisMotion.fast,
                      padding: const EdgeInsets.symmetric(
                        horizontal: AegisSpacing.space5,
                        vertical: AegisSpacing.space3,
                      ),
                      decoration: BoxDecoration(
                        gradient: isSelected
                            ? AegisGradients.aegisCyanGradient
                            : null,
                        color: isSelected ? null : AppTheme.darkSurface,
                        borderRadius:
                            BorderRadius.circular(AegisRadius.radiusMd),
                        border: Border.all(
                          color: isSelected
                              ? Colors.transparent
                              : AppTheme.cardBorder.withValues(alpha: 0.6),
                        ),
                      ),
                      child: Text(
                        type.label,
                        style: TextStyle(
                          color: isSelected
                              ? AppTheme.obsidian
                              : AppTheme.textSecondary,
                          fontWeight: isSelected
                              ? FontWeight.w700
                              : FontWeight.w500,
                          letterSpacing: 0.3,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: AegisSpacing.space7),

              TextFormField(
                controller: _addressController,
                decoration: const InputDecoration(
                  labelText: 'Location / Address',
                  hintText: 'e.g., 123 Main St, near the park',
                  prefixIcon: Icon(Icons.location_on_outlined),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a location';
                  }
                  return null;
                },
              ),
              const SizedBox(height: AegisSpacing.space5),

              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  hintText: 'Describe what happened...',
                  prefixIcon: Icon(Icons.description_outlined),
                  alignLabelWithHint: true,
                ),
                maxLines: 4,
                maxLength: 500,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please provide a description';
                  }
                  return null;
                },
              ),
              const SizedBox(height: AegisSpacing.space7),

              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _isSubmitting ? null : _submitReport,
                  child: _isSubmitting
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : const Text('Submit Report'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
