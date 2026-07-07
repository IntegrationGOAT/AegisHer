import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/chat_message.dart';

abstract class ChatbotRepository {
  Future<ChatMessage> sendMessage(String text);
  ChatIntent classify(String text);
}

class MockChatbotRepository implements ChatbotRepository {
  static const _d = Duration(milliseconds: 700);
  @override
  ChatIntent classify(String text) {
    final l = text.toLowerCase();
    if (l.contains('hello') || l.contains('hi ')) return ChatIntent.greeting;
    if (l.contains('sos') || l.contains('emergency')) return ChatIntent.sos;
    if (l.contains('safe') || l.contains('route')) return ChatIntent.route;
    if (l.contains('report') || l.contains('incident')) return ChatIntent.incident;
    if (l.contains('danger') || l.contains('unsafe')) return ChatIntent.safety;
    return ChatIntent.smalltalk;
  }

  @override
  Future<ChatMessage> sendMessage(String text) async {
    await Future<void>.delayed(_d);
    final intent = classify(text);
    String reply;
    switch (intent) {
      case ChatIntent.greeting: reply = "Hi! I'm Aegis, your safety companion. How can I help?"; break;
      case ChatIntent.sos: reply = "If you're in danger, tap the SOS button at the bottom of the screen. I can also guide you to nearby safe zones."; break;
      case ChatIntent.route: reply = "Open the Map tab to find a safer route from your current location."; break;
      case ChatIntent.incident: reply = "Use the Community tab to report an incident. Reports can be anonymous."; break;
      case ChatIntent.safety: reply = "Your current area safety score is shown on the Home tab with explainable AI breakdown."; break;
      case ChatIntent.smalltalk: reply = "I'm a stub chatbot for the AegisHer Foundation MVP. Real AI integration coming soon."; break;
      case ChatIntent.unknown: reply = "I didn't catch that — try asking about safety, routes, or reporting."; break;
    }
    return ChatMessage(id: 'm_${DateTime.now().millisecondsSinceEpoch}', text: reply, fromUser: false, timestamp: DateTime.now(), intent: intent);
  }
}

final chatbotRepositoryProvider = Provider<ChatbotRepository>((ref) => MockChatbotRepository());
