import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/design_tokens.dart';
import '../../../../theme/app_theme.dart';
import '../../../../core/widgets/glass_card.dart';
import '../../../../widgets/custom_app_bar.dart';
import '../../domain/entities/sos_event.dart';
import '../controllers/sos_controller.dart';

class SosScreen extends ConsumerWidget {
  const SosScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(sosControllerProvider);
    final c = ref.read(sosControllerProvider.notifier);
    Widget body;
    switch (state.status) {
      case SosStatus.idle:
      case SosStatus.cancelled:
      case SosStatus.completed:
        body = _Idle(onHold: c.startCountdown);
        break;
      case SosStatus.countdown:
        body = _Countdown(value: state.countdown, onCancel: c.cancel);
        break;
      case SosStatus.active:
        body = _Active(state: state, onCancel: c.cancel);
        break;
    }
    return Scaffold(
      appBar: const CustomAppBar(title: 'SOS Emergency', showBackButton: false),
      body: SafeArea(child: Padding(
        padding: const EdgeInsets.all(AegisSpacing.space5),
        child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          Expanded(child: Center(child: SingleChildScrollView(child: body))),
        ]),
      )),
    );
  }
}

class _Idle extends StatefulWidget {
  final VoidCallback onHold;
  const _Idle({required this.onHold});
  @override State<_Idle> createState() => _IdleS();
}
class _IdleS extends State<_Idle> with SingleTickerProviderStateMixin {
  late AnimationController _ac;
  bool _holding = false;
  @override void initState() { super.initState(); _ac = AnimationController(vsync: this, duration: const Duration(seconds: 3))..addStatusListener((s) { if (s == AnimationStatus.completed) widget.onHold(); }); }
  void _start() { setState(() => _holding = true); _ac.forward(from: 0); }
  void _stop() { setState(() => _holding = false); _ac.stop(); _ac.value = 0; }
  @override void dispose() { _ac.dispose(); super.dispose(); }
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _start(),
      onTapUp: (_) => _stop(),
      onTapCancel: _stop,
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        SizedBox(width: 220, height: 220, child: Stack(alignment: Alignment.center, children: [
          Container(decoration: BoxDecoration(shape: BoxShape.circle, gradient: RadialGradient(colors: [AppTheme.signalRed.withValues(alpha: 0.35), AppTheme.signalRed.withValues(alpha: 0.0)]))),
          SizedBox(width: 200, height: 200, child: AnimatedBuilder(animation: _ac, builder: (_, __) => CircularProgressIndicator(value: _ac.value, strokeWidth: 6, backgroundColor: AppTheme.darkCardBorder.withValues(alpha: 0.5), valueColor: const AlwaysStoppedAnimation<Color>(AppTheme.signalRed)))),
          Container(width: 160, height: 160, decoration: BoxDecoration(shape: BoxShape.circle, gradient: AegisGradients.aegisSosGradient, boxShadow: [BoxShadow(color: AppTheme.signalRed.withValues(alpha: _holding ? 0.7 : 0.4), blurRadius: _holding ? 40 : 24, offset: const Offset(0, 8))]), alignment: Alignment.center, child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Text(_holding ? '${((1 - _ac.value) * 3).ceil().clamp(1, 3)}' : 'SOS', style: const TextStyle(color: Colors.white, fontSize: 44, fontWeight: FontWeight.w900, letterSpacing: 2)),
            Text(_holding ? 'HOLD' : 'TAP & HOLD', style: const TextStyle(color: Colors.white70, fontSize: 11, letterSpacing: 1.5)),
          ])),
        ])),
        const SizedBox(height: AegisSpacing.space5),
        const Text('Tap and HOLD for 3 seconds to activate SOS', style: TextStyle(color: AppTheme.textSecondary, fontSize: 13), textAlign: TextAlign.center),
      ]),
    );
  }
}

class _Countdown extends StatelessWidget {
  final int value;
  final VoidCallback onCancel;
  const _Countdown({required this.value, required this.onCancel});
  @override
  Widget build(BuildContext context) {
    return Column(mainAxisSize: MainAxisSize.min, children: [
      Container(width: 180, height: 180, decoration: BoxDecoration(shape: BoxShape.circle, gradient: RadialGradient(colors: [AppTheme.signalRed.withValues(alpha: 0.5), AppTheme.signalRed.withValues(alpha: 0.0)])), alignment: Alignment.center, child: Text('$value', style: const TextStyle(color: AppTheme.signalRed, fontSize: 96, fontWeight: FontWeight.w900))),
      const SizedBox(height: AegisSpacing.space6),
      const Text('Activating SOS...', style: TextStyle(color: AppTheme.textPrimary, fontSize: 18, fontWeight: FontWeight.w700)),
      const SizedBox(height: AegisSpacing.space5),
      OutlinedButton.icon(onPressed: onCancel, icon: const Icon(Icons.close), label: const Text('Cancel')),
    ]);
  }
}

class _Active extends StatelessWidget {
  final SosState state;
  final VoidCallback onCancel;
  const _Active({required this.state, required this.onCancel});
  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      GlassCard(child: Column(children: [
        Container(width: 72, height: 72, decoration: const BoxDecoration(shape: BoxShape.circle, gradient: AegisGradients.aegisSosGradient), alignment: Alignment.center, child: const Icon(Icons.emergency, color: Colors.white, size: 36)),
        const SizedBox(height: AegisSpacing.space4),
        const Text('SOS ACTIVE', style: TextStyle(color: AppTheme.signalRed, fontSize: 24, fontWeight: FontWeight.w900, letterSpacing: 1.5)),
        if (state.event != null) ...[const SizedBox(height: AegisSpacing.space2), Text('Started at ${state.event!.startedAt.toLocal().toString().substring(11, 19)}', style: const TextStyle(color: AppTheme.textSecondary, fontSize: 12))],
      ])),
      const SizedBox(height: AegisSpacing.space5),
      const Align(alignment: Alignment.centerLeft, child: Text('Emergency Contacts', style: TextStyle(color: AppTheme.textPrimary, fontSize: 14, fontWeight: FontWeight.w700))),
      const SizedBox(height: AegisSpacing.space3),
      ...state.contacts.map((c) => Card(child: ListTile(leading: const CircleAvatar(backgroundColor: AppTheme.signalRed, child: Icon(Icons.person, color: Colors.white)), title: Text(c.name, style: const TextStyle(color: AppTheme.textPrimary)), subtitle: Text('${c.relationship} • ${c.phone}', style: const TextStyle(color: AppTheme.textSecondary)), trailing: const Icon(Icons.check_circle, color: AppTheme.signalGreen)))),
      const SizedBox(height: AegisSpacing.space5),
      const Align(alignment: Alignment.centerLeft, child: Text('Evidence Log', style: TextStyle(color: AppTheme.textPrimary, fontSize: 14, fontWeight: FontWeight.w700))),
      const SizedBox(height: AegisSpacing.space3),
      GlassCard(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: state.evidenceLog.map((e) => Padding(padding: const EdgeInsets.symmetric(vertical: AegisSpacing.space2), child: Row(children: [const Icon(Icons.check_circle, color: AppTheme.signalGreen, size: 16), const SizedBox(width: AegisSpacing.space3), Expanded(child: Text(e, style: const TextStyle(color: AppTheme.textSecondary, fontSize: 13)))]))).toList())),
      const SizedBox(height: AegisSpacing.space7),
      SizedBox(height: 56, child: ElevatedButton.icon(style: ElevatedButton.styleFrom(backgroundColor: AppTheme.signalRed, foregroundColor: Colors.white), onPressed: onCancel, icon: const Icon(Icons.close), label: const Text('CANCEL SOS', style: TextStyle(fontWeight: FontWeight.w800)))),
    ]);
  }
}
