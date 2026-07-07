// SafetyMapScreen — Map placeholder + route inputs (real Mapbox wired in
// the Phase-5 ferment; for now this stays a polished placeholder).

import 'package:flutter/material.dart';

import '../core/theme/design_tokens.dart';
import '../core/widgets/glass_card.dart';
import '../theme/app_theme.dart';
import '../widgets/custom_app_bar.dart';

class SafetyMapScreen extends StatefulWidget {
  const SafetyMapScreen({super.key});

  @override
  State<SafetyMapScreen> createState() => _SafetyMapScreenState();
}

class _SafetyMapScreenState extends State<SafetyMapScreen> {
  bool _isCalculating = false;

  final TextEditingController _startController = TextEditingController();
  final TextEditingController _endController = TextEditingController();

  @override
  void dispose() {
    _startController.dispose();
    _endController.dispose();
    super.dispose();
  }

  Future<void> _findSafeRoute() async {
    setState(() => _isCalculating = true);
    await Future<void>.delayed(const Duration(seconds: 1));
    if (mounted) {
      setState(() => _isCalculating = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Safe route found! Map integration coming soon.'),
          backgroundColor: AppTheme.signalGreen,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Safe Route', showBackButton: false),
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 3,
            child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                gradient: AegisGradients.aegisObsidianGradient,
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: <Color>[
                            AppTheme.electricCyan.withValues(alpha: 0.20),
                            AppTheme.electricCyan.withValues(alpha: 0.0),
                          ],
                        ),
                        border: Border.all(
                          color: AppTheme.electricCyan.withValues(alpha: 0.35),
                          width: 2,
                        ),
                      ),
                      child: const Icon(
                        Icons.map_outlined,
                        size: 48,
                        color: AppTheme.electricCyan,
                      ),
                    ),
                    const SizedBox(height: AegisSpacing.space5),
                    Text(
                      'Map Integration',
                      style: TextStyle(
                        color: AppTheme.textPrimary,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: AegisSpacing.space3),
                    Text(
                      'Enter locations below to find a safe route',
                      style: TextStyle(
                        color: AppTheme.textSecondary,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          GlassCard(
            padding: const EdgeInsets.all(AegisSpacing.space5),
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(AegisRadius.radiusXl),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                TextField(
                  controller: _startController,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(
                      Icons.circle,
                      color: AppTheme.signalGreen,
                      size: 12,
                    ),
                    hintText: 'Enter starting location',
                  ),
                ),
                const SizedBox(height: AegisSpacing.space4),
                TextField(
                  controller: _endController,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(
                      Icons.flag,
                      color: AppTheme.violet,
                      size: 12,
                    ),
                    hintText: 'Enter destination',
                  ),
                ),
                const SizedBox(height: AegisSpacing.space6),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed:
                        (_startController.text.isNotEmpty &&
                                _endController.text.isNotEmpty &&
                                !_isCalculating)
                            ? _findSafeRoute
                            : null,
                    child: _isCalculating
                        ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        : const Text('Find Safest Route'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
