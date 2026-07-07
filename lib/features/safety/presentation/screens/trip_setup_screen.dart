import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/design_tokens.dart';
import '../../../../theme/app_theme.dart';
import '../../../../core/widgets/glass_card.dart';
import '../../../../widgets/custom_app_bar.dart';
import '../../domain/entities/trip.dart';
import '../controllers/trip_controller.dart';

class TripSetupScreen extends ConsumerStatefulWidget {
  const TripSetupScreen({super.key});
  @override
  ConsumerState<TripSetupScreen> createState() => _TSS();
}

class _TSS extends ConsumerState<TripSetupScreen> {
  final _origin = TextEditingController(text: 'Home');
  final _destination = TextEditingController(text: 'Office');
  int _interval = 15;

  @override
  void dispose() {
    _origin.dispose();
    _destination.dispose();
    super.dispose();
  }

  void _start() {
    if (_origin.text.trim().isEmpty || _destination.text.trim().isEmpty) return;
    ref.read(tripControllerProvider.notifier).startTrip(
          origin: _origin.text.trim(),
          destination: _destination.text.trim(),
          intervalMinutes: _interval,
        );
  }

  String _formatTime(DateTime t) {
    final diff = DateTime.now().difference(t);
    if (diff.inMinutes < 1) return 'Just now';
    if (diff.inHours < 1) return '${diff.inMinutes}m ago';
    if (diff.inDays < 1) return '${diff.inHours}h ago';
    return '${diff.inDays}d ago';
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(tripControllerProvider);
    if (state.activeTrip != null) {
      return _ActiveTripView(
        state: state,
        onAcknowledge: () => ref.read(tripControllerProvider.notifier).acknowledgeCheckIn(),
        onCancel: () => ref.read(tripControllerProvider.notifier).cancelTrip(),
      );
    }
    return Scaffold(
      appBar: const CustomAppBar(title: 'Safety Pulse Trip', showBackButton: true),
      body: ListView(
        padding: const EdgeInsets.all(AegisSpacing.space5),
        children: [
          GlassCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: AegisGradients.aegisCyanGradient,
                      ),
                      alignment: Alignment.center,
                      child: const Icon(Icons.timeline, color: Colors.white, size: 20),
                    ),
                    const SizedBox(width: AegisSpacing.space4),
                    const Expanded(
                      child: Text(
                        'Travel safely with periodic check-ins',
                        style: TextStyle(
                          color: AppTheme.textPrimary,
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AegisSpacing.space3),
                const Text(
                  'We will text your emergency contacts if you miss a check-in.',
                  style: TextStyle(color: AppTheme.textSecondary, fontSize: 13),
                ),
              ],
            ),
          ),
          const SizedBox(height: AegisSpacing.space6),
          TextField(
            controller: _origin,
            decoration: const InputDecoration(
              labelText: 'Origin',
              prefixIcon: Icon(Icons.trip_origin),
            ),
          ),
          const SizedBox(height: AegisSpacing.space4),
          TextField(
            controller: _destination,
            decoration: const InputDecoration(
              labelText: 'Destination',
              prefixIcon: Icon(Icons.location_on_outlined),
            ),
          ),
          const SizedBox(height: AegisSpacing.space6),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: AegisSpacing.space2),
            child: Text(
              'Check-in interval',
              style: TextStyle(color: AppTheme.textPrimary, fontSize: 14, fontWeight: FontWeight.w600),
            ),
          ),
          const SizedBox(height: AegisSpacing.space3),
          Wrap(
            spacing: AegisSpacing.space3,
            children: [
              for (final m in const [10, 15, 30, 60])
                ChoiceChip(
                  label: Text('$m min'),
                  selected: _interval == m,
                  onSelected: (_) => setState(() => _interval = m),
                ),
            ],
          ),
          const SizedBox(height: AegisSpacing.space7),
          SizedBox(
            height: 52,
            child: ElevatedButton.icon(
              onPressed: _start,
              icon: const Icon(Icons.play_arrow),
              label: const Text(
                'Start Trip',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
              ),
            ),
          ),
          const SizedBox(height: AegisSpacing.space6),
          if (state.history.isNotEmpty) ...[
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: AegisSpacing.space2),
              child: Text(
                'Recent Trips',
                style: TextStyle(color: AppTheme.textPrimary, fontSize: 14, fontWeight: FontWeight.w700),
              ),
            ),
            const SizedBox(height: AegisSpacing.space3),
            ...state.history.reversed.take(5).map(
                  (t) => Card(
                    child: ListTile(
                      leading: Icon(
                        t.status == TripStatus.completed
                            ? Icons.check_circle
                            : t.status == TripStatus.cancelled
                                ? Icons.cancel
                                : t.status == TripStatus.triggered
                                    ? Icons.warning
                                    : Icons.directions_walk,
                        color: t.status == TripStatus.triggered
                            ? AppTheme.signalRed
                            : AppTheme.electricCyan,
                      ),
                      title: Text(
                        '${t.origin} -> ${t.destination}',
                        style: const TextStyle(color: AppTheme.textPrimary),
                      ),
                      subtitle: Text(
                        _formatTime(t.startedAt),
                        style: const TextStyle(color: AppTheme.textSecondary, fontSize: 12),
                      ),
                    ),
                  ),
                ),
          ],
        ],
      ),
    );
  }
}

class _ActiveTripView extends StatelessWidget {
  final TripState state;
  final VoidCallback onAcknowledge;
  final VoidCallback onCancel;
  const _ActiveTripView({
    required this.state,
    required this.onAcknowledge,
    required this.onCancel,
  });

  String _formatDuration(Duration d) {
    if (d.isNegative) return '00:00';
    final mm = d.inMinutes.toString().padLeft(2, '0');
    final ss = (d.inSeconds % 60).toString().padLeft(2, '0');
    return '$mm:$ss';
  }

  Widget _stat(String label, String value, {Color? color}) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            color: color ?? AppTheme.textPrimary,
            fontSize: 22,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: const TextStyle(color: AppTheme.textSecondary, fontSize: 11),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final trip = state.activeTrip!;
    final countdownStr = _formatDuration(state.countdown);
    final acked = trip.checkIns.where((c) => c.acknowledgedAt != null).length;
    final missed = trip.checkIns.where((c) => c.triggered).length;
    final isAlert = trip.status == TripStatus.triggered;
    return Scaffold(
      appBar: CustomAppBar(
        title: isAlert ? 'TRIP ALERT' : 'Active Trip',
        showBackButton: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(AegisSpacing.space5),
        children: [
          GlassCard(
            child: Column(
              children: [
                Row(
                  children: [
                    const Icon(Icons.trip_origin, color: AppTheme.electricCyan),
                    const SizedBox(width: AegisSpacing.space3),
                    Expanded(
                      child: Text(
                        trip.origin,
                        style: const TextStyle(
                          color: AppTheme.textPrimary,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: AegisSpacing.space2),
                  child: Icon(Icons.arrow_downward, color: AppTheme.textSecondary, size: 18),
                ),
                Row(
                  children: [
                    const Icon(Icons.location_on, color: AppTheme.violet),
                    const SizedBox(width: AegisSpacing.space3),
                    Expanded(
                      child: Text(
                        trip.destination,
                        style: const TextStyle(
                          color: AppTheme.textPrimary,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AegisSpacing.space5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _stat('Check-ins', '$acked'),
                    _stat(
                      'Missed',
                      '$missed',
                      color: missed > 0 ? AppTheme.signalRed : AppTheme.textSecondary,
                    ),
                    _stat('Interval', '${trip.checkInIntervalMinutes}m'),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: AegisSpacing.space5),
          if (isAlert) ...[
            GlassCard(
              child: Column(
                children: [
                  const Icon(Icons.warning_amber_rounded, color: AppTheme.signalRed, size: 56),
                  const SizedBox(height: AegisSpacing.space3),
                  const Text(
                    'ALERT SENT',
                    style: TextStyle(color: AppTheme.signalRed, fontSize: 20, fontWeight: FontWeight.w900),
                  ),
                  const SizedBox(height: AegisSpacing.space2),
                  Text(
                    'Notified: ${trip.contactsNotified.join(", ")}',
                    style: const TextStyle(color: AppTheme.textSecondary, fontSize: 13),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            const SizedBox(height: AegisSpacing.space5),
          ] else ...[
            GlassCard(
              child: Column(
                children: [
                  const Text(
                    'Next check-in in',
                    style: TextStyle(color: AppTheme.textSecondary, fontSize: 13),
                  ),
                  const SizedBox(height: AegisSpacing.space2),
                  Text(
                    countdownStr,
                    style: TextStyle(
                      color: countdownStr == '00:00'
                          ? AppTheme.signalRed
                          : AppTheme.electricCyan,
                      fontSize: 44,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AegisSpacing.space5),
            SizedBox(
              height: 56,
              child: ElevatedButton.icon(
                onPressed: onAcknowledge,
                icon: const Icon(Icons.check),
                label: const Text(
                    "I'M SAFE",
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800)),
              ),
            ),
            const SizedBox(height: AegisSpacing.space3),
          ],
          SizedBox(
            height: 50,
            child: OutlinedButton.icon(
              onPressed: onCancel,
              icon: const Icon(Icons.stop_circle_outlined, color: AppTheme.signalRed),
              label: const Text(
                'End Trip',
                style: TextStyle(color: AppTheme.signalRed, fontWeight: FontWeight.w700),
              ),
              style: OutlinedButton.styleFrom(side: const BorderSide(color: AppTheme.signalRed)),
            ),
          ),
        ],
      ),
    );
  }
}
