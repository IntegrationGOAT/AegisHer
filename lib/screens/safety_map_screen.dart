import 'package:flutter/material.dart';

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
    await Future.delayed(const Duration(seconds: 1));
    if (mounted) {
      setState(() => _isCalculating = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Safe route found! Map integration coming soon.'),
          backgroundColor: AppTheme.safeGreen,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Safe Route', showBackButton: false),
      body: Column(
        children: [
          // Map placeholder
          Expanded(
            flex: 3,
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppTheme.darkSurface, AppTheme.darkBackground],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppTheme.primaryRed.withValues(alpha: 0.3),
                          width: 2,
                        ),
                      ),
                      child: Icon(
                        Icons.map_outlined,
                        size: 48,
                        color: AppTheme.primaryRed.withValues(alpha: 0.6),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Map Integration',
                      style: TextStyle(
                        color: AppTheme.textSecondary,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Enter locations below to find a safe route',
                      style: TextStyle(
                        color: AppTheme.textSecondary.withValues(alpha: 0.7),
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Route input section
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: AppTheme.darkBackground,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Start location
                TextField(
                  controller: _startController,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(
                      Icons.circle,
                      color: AppTheme.safeGreen,
                      size: 12,
                    ),
                    hintText: 'Enter starting location',
                  ),
                ),
                const SizedBox(height: 12),

                // End location
                TextField(
                  controller: _endController,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(
                      Icons.flag,
                      color: AppTheme.dangerRed,
                      size: 12,
                    ),
                    hintText: 'Enter destination',
                  ),
                ),
                const SizedBox(height: 20),

                // Find route button
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
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryRed,
                      foregroundColor: Colors.white,
                      disabledBackgroundColor: AppTheme.primaryRed.withValues(
                        alpha: 0.4,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 4,
                      shadowColor: AppTheme.primaryRed.withValues(alpha: 0.4),
                    ),
                    child: _isCalculating
                        ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.white,
                              ),
                            ),
                          )
                        : const Text(
                            'Find Safest Route',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
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
