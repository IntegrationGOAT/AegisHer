import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/design_tokens.dart';
import '../../../../theme/app_theme.dart';
import '../../domain/entities/chat_message.dart';
import '../../data/repositories/chatbot_repository.dart';

class ChatbotController extends StateNotifier<List<ChatMessage>> {
  final Ref _ref;
  ChatbotController(this._ref)
      : super(<ChatMessage>[
          ChatMessage(
            id: 'welcome',
            text: "Hi! I'm Aegis, your safety companion. How can I help?",
            fromUser: false,
            timestamp: DateTime(2024),
            intent: ChatIntent.greeting,
          ),
        ]);

  Future<void> send(String text) async {
    final trimmed = text.trim();
    if (trimmed.isEmpty) return;
    final userMsg = ChatMessage(
      id: 'u_${DateTime.now().millisecondsSinceEpoch}',
      text: trimmed,
      fromUser: true,
      timestamp: DateTime.now(),
      intent: ChatIntent.smalltalk,
    );
    state = <ChatMessage>[...state, userMsg];
    final reply = await _ref.read(chatbotRepositoryProvider).sendMessage(trimmed);
    if (!mounted) return;
    state = <ChatMessage>[...state, reply];
  }
}

final chatbotControllerProvider =
    StateNotifierProvider<ChatbotController, List<ChatMessage>>(
        (ref) => ChatbotController(ref));

class ChatbotScreen extends ConsumerStatefulWidget {
  const ChatbotScreen({super.key});
  @override
  ConsumerState<ChatbotScreen> createState() => _CS();
}

class _CS extends ConsumerState<ChatbotScreen> {
  final _ctrl = TextEditingController();
  bool _sending = false;

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  Future<void> _send() async {
    final text = _ctrl.text;
    if (text.trim().isEmpty || _sending) return;
    setState(() => _sending = true);
    await ref.read(chatbotControllerProvider.notifier).send(text);
    if (!mounted) return;
    _ctrl.clear();
    setState(() => _sending = false);
  }

  Widget _bubble(ChatMessage m) {
    final isUser = m.fromUser;
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: AegisSpacing.space2),
        padding: const EdgeInsets.symmetric(
          horizontal: AegisSpacing.space5,
          vertical: AegisSpacing.space3,
        ),
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
        decoration: BoxDecoration(
          gradient: isUser ? AegisGradients.aegisCyanGradient : null,
          color: isUser ? null : AppTheme.charcoal,
          borderRadius: BorderRadius.circular(AegisRadius.radiusLg),
          border: isUser ? null : Border.all(color: AppTheme.darkCardBorder),
        ),
        child: Text(
          m.text,
          style: TextStyle(
            color: isUser ? AppTheme.obsidian : AppTheme.textPrimary,
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final messages = ref.watch(chatbotControllerProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Aegis Chatbot'),
        backgroundColor: AppTheme.obsidian,
        foregroundColor: AppTheme.textPrimary,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(AegisSpacing.space4),
              itemCount: messages.length,
              itemBuilder: (_, i) => _bubble(messages[i]),
            ),
          ),
          if (_sending)
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: AegisSpacing.space4),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text('Aegis is typing...',
                    style: TextStyle(color: AppTheme.textSecondary, fontSize: 12)),
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(AegisSpacing.space4),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _ctrl,
                    decoration: const InputDecoration(
                      hintText: 'Type a message...',
                      border: OutlineInputBorder(),
                    ),
                    onSubmitted: (_) => _send(),
                  ),
                ),
                const SizedBox(width: AegisSpacing.space3),
                IconButton(
                  onPressed: _sending ? null : _send,
                  icon: const Icon(Icons.send, color: AppTheme.electricCyan),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
