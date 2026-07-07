import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/design_tokens.dart';
import '../../../../theme/app_theme.dart';
import '../../../../core/widgets/glass_card.dart';
import '../../../../widgets/custom_app_bar.dart';
import '../../../auth/presentation/controllers/auth_controller.dart';
import '../../domain/entities/app_settings.dart';
import '../controllers/settings_controller.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = ref.watch(settingsControllerProvider);
    final auth = ref.watch(authControllerProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final fg = isDark ? AppTheme.textPrimary : AppTheme.textPrimaryLight;
    return Scaffold(
      appBar: const CustomAppBar(title: 'Settings', showBackButton: false),
      body: ListView(padding: const EdgeInsets.all(AegisSpacing.space5), children: [
        if (auth.user != null) GlassCard(child: Row(children: [
          Container(width: 48, height: 48, decoration: const BoxDecoration(shape: BoxShape.circle, gradient: AegisGradients.aegisCyanGradient), child: const Icon(Icons.person, color: Colors.white)),
          const SizedBox(width: AegisSpacing.space4),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(auth.user!.name, style: TextStyle(color: fg, fontSize: 16, fontWeight: FontWeight.w700)), Text(auth.user!.email, style: const TextStyle(color: AppTheme.textSecondary, fontSize: 12))])),
        ])),
        const SizedBox(height: AegisSpacing.space6),
        _section('Appearance'),
        GlassCard(child: Column(children: [
          const ListTile(title: Text('Theme', style: TextStyle(color: AppTheme.textPrimary))),
          Padding(padding: const EdgeInsets.symmetric(horizontal: AegisSpacing.space3, vertical: AegisSpacing.space3), child: SegmentedButton<AppThemeModeChoice>(segments: const [
            ButtonSegment(value: AppThemeModeChoice.system, label: Text('System'), icon: Icon(Icons.brightness_auto)),
            ButtonSegment(value: AppThemeModeChoice.light, label: Text('Light'), icon: Icon(Icons.light_mode)),
            ButtonSegment(value: AppThemeModeChoice.dark, label: Text('Dark'), icon: Icon(Icons.dark_mode)),
          ], selected: {s.themeMode}, onSelectionChanged: (set) => ref.read(settingsControllerProvider.notifier).setThemeMode(set.first))),
        ])),
        const SizedBox(height: AegisSpacing.space6),
        _section('Accessibility'),
        GlassCard(child: Column(children: [
          SwitchListTile(title: const Text('Reduce motion', style: TextStyle(color: AppTheme.textPrimary)), value: s.reduceMotion, onChanged: (v) => ref.read(settingsControllerProvider.notifier).toggleReduceMotion(v)),
          SwitchListTile(title: const Text('High contrast', style: TextStyle(color: AppTheme.textPrimary)), value: s.highContrast, onChanged: (v) => ref.read(settingsControllerProvider.notifier).toggleHighContrast(v)),
          ListTile(title: const Text('Text size', style: TextStyle(color: AppTheme.textPrimary)), subtitle: Slider(value: s.textScale, min: 0.8, max: 1.4, divisions: 6, label: '${(s.textScale * 100).round()}%', onChanged: (v) => ref.read(settingsControllerProvider.notifier).setTextScale(v))),
        ])),
        const SizedBox(height: AegisSpacing.space6),
        _section('Notifications & Security'),
        GlassCard(child: Column(children: [
          SwitchListTile(title: const Text('Push notifications', style: TextStyle(color: AppTheme.textPrimary)), value: s.notificationsEnabled, onChanged: (v) => ref.read(settingsControllerProvider.notifier).toggleNotifications(v)),
          SwitchListTile(title: const Text('Biometric unlock', style: TextStyle(color: AppTheme.textPrimary)), subtitle: const Text('Use device biometric on second launch', style: TextStyle(color: AppTheme.textSecondary)), value: s.biometricEnabled, onChanged: (v) => ref.read(settingsControllerProvider.notifier).toggleBiometric(v)),
        ])),
        const SizedBox(height: AegisSpacing.space7),
        SizedBox(height: 50, child: OutlinedButton.icon(onPressed: () async { await ref.read(authControllerProvider.notifier).signOut(); }, icon: const Icon(Icons.logout, color: AppTheme.signalRed), label: const Text('Sign out', style: TextStyle(color: AppTheme.signalRed, fontWeight: FontWeight.w700)), style: OutlinedButton.styleFrom(side: const BorderSide(color: AppTheme.signalRed)))),
      ]),
    );
  }
  Widget _section(String t) => Padding(padding: const EdgeInsets.only(left: AegisSpacing.space2, bottom: AegisSpacing.space3), child: Text(t.toUpperCase(), style: const TextStyle(color: AppTheme.electricCyan, fontSize: 12, fontWeight: FontWeight.w700, letterSpacing: 1.5)));
}
