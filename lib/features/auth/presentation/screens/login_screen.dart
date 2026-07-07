import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/design_tokens.dart';
import '../../../../theme/app_theme.dart';
import '../../../../core/widgets/glass_card.dart';
import '../controllers/auth_controller.dart';

class LoginScreen extends ConsumerStatefulWidget { const LoginScreen({super.key}); @override ConsumerState<LoginScreen> createState() => _LS(); }
class _LS extends ConsumerState<LoginScreen> {
  final _email = TextEditingController(text: 'demo@aegisher.app');
  final _pw = TextEditingController(text: 'demo1234');
  final _formKey = GlobalKey<FormState>();
  @override void dispose() { _email.dispose(); _pw.dispose(); super.dispose(); }
  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    ref.read(authControllerProvider.notifier).signIn(_email.text.trim(), _pw.text);
  }
  @override
  Widget build(BuildContext context) {
    final auth = ref.watch(authControllerProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final fg = isDark ? AppTheme.textPrimary : AppTheme.textPrimaryLight;
    return Scaffold(
      body: SafeArea(child: SingleChildScrollView(
        padding: const EdgeInsets.all(AegisSpacing.space7),
        child: Form(key: _formKey, child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          const SizedBox(height: AegisSpacing.space9),
          Container(height: 96, decoration: const BoxDecoration(shape: BoxShape.circle, gradient: AegisGradients.aegisAuroraGradient), alignment: Alignment.center, child: const Icon(Icons.shield_outlined, size: 48, color: Colors.white)),
          const SizedBox(height: AegisSpacing.space6),
          Text('Welcome to AegisHer', style: TextStyle(color: fg, fontSize: 26, fontWeight: FontWeight.w800), textAlign: TextAlign.center),
          const SizedBox(height: AegisSpacing.space2),
          const Text('Sign in to continue', style: TextStyle(color: AppTheme.textSecondary, fontSize: 14), textAlign: TextAlign.center),
          const SizedBox(height: AegisSpacing.space8),
          GlassCard(child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            TextFormField(controller: _email, keyboardType: TextInputType.emailAddress, decoration: const InputDecoration(labelText: 'Email', prefixIcon: Icon(Icons.email_outlined)), validator: (v) => (v == null || !v.contains('@')) ? 'Invalid email' : null),
            const SizedBox(height: AegisSpacing.space5),
            TextFormField(controller: _pw, obscureText: true, decoration: const InputDecoration(labelText: 'Password', prefixIcon: Icon(Icons.lock_outline)), validator: (v) => (v == null || v.length < 4) ? 'Min 4 chars' : null),
            const SizedBox(height: AegisSpacing.space6),
            SizedBox(height: 50, child: ElevatedButton(onPressed: auth.loading ? null : _submit, child: auth.loading ? const SizedBox(width: 22, height: 22, child: CircularProgressIndicator(strokeWidth: 2, valueColor: AlwaysStoppedAnimation<Color>(Colors.white))) : const Text('Sign In'))),
            if (auth.error != null) ...[const SizedBox(height: AegisSpacing.space3), Text(auth.error!, style: const TextStyle(color: AppTheme.signalRed, fontSize: 12))],
          ])),
          const SizedBox(height: AegisSpacing.space5),
          TextButton(onPressed: () { ref.read(authControllerProvider.notifier).signUp(email: _email.text.trim(), password: _pw.text, name: _email.text.split('@').first); }, child: const Text("Don't have an account? Sign up")),
        ])),
      )),
    );
  }
}
