import 'package:dio/dio.dart';
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
      case ChatIntent.greeting:
        reply = "Hi! I'm Aegis, your safety companion. How can I help?";
        break;
      case ChatIntent.sos:
        reply =
            "If you're in danger, tap the SOS button at the bottom of the screen. I can also guide you to nearby safe zones.";
        break;
      case ChatIntent.route:
        reply =
            "Open the Map tab to find a safer route from your current location.";
        break;
      case ChatIntent.incident:
        reply =
            "Use the Community tab to report an incident. Reports can be anonymous.";
        break;
      case ChatIntent.safety:
        reply =
            "Your current area safety score is shown on the Home tab with explainable AI breakdown.";
        break;
      case ChatIntent.smalltalk:
        reply =
            "I'm a stub chatbot for the AegisHer Foundation MVP. Real AI integration coming soon.";
        break;
      case ChatIntent.unknown:
        reply = "I didn't catch that — try asking about safety, routes, or reporting.";
        break;
    }
    return ChatMessage(
      id: 'm_${DateTime.now().millisecondsSinceEpoch}',
      text: reply,
      fromUser: false,
      timestamp: DateTime.now(),
      intent: intent,
    );
  }
}

class GeminiChatbotRepository implements ChatbotRepository {
  static const String _apiKey = String.fromEnvironment(
    'GEMINI_API_KEY',
    defaultValue: '',
  );
  static const String _model = String.fromEnvironment(
    'GEMINI_MODEL',
    defaultValue: 'gemini-2.0-flash',
  );

  final Dio _dio;

  GeminiChatbotRepository({Dio? dio})
      : _dio = dio ??
            Dio(BaseOptions(
              connectTimeout: const Duration(seconds: 15),
              receiveTimeout: const Duration(seconds: 30),
              sendTimeout: const Duration(seconds: 15),
            ));

  bool get isConfigured => _apiKey.isNotEmpty;

  String get _endpoint =>
      'https://generativelanguage.googleapis.com/v1beta/models/$_model:generateContent?key=$_apiKey';

  static const String _systemPrompt =
      "You are Aegis, a concise, supportive women's safety companion. "
      'Give short, actionable answers (max 80 words). '
      "Prioritize the user's physical safety. "
      'If they mention danger or SOS, immediately tell them to tap the SOS button. '
      'For safety scores, routes, or reports, point them to the relevant tab.';

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
    if (!isConfigured) {
      throw StateError(
          'GEMINI_API_KEY not configured at build time. Rebuild with --dart-define=GEMINI_API_KEY=...');
    }
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        _endpoint,
        options: Options(headers: {
          'Content-Type': 'application/json',
        }),
        data: <String, dynamic>{
          'system_instruction': {
            'parts': [
              {'text': _systemPrompt}
            ]
          },
          'contents': [
            {
              'role': 'user',
              'parts': [
                {'text': text}
              ]
            }
          ],
          'generationConfig': {
            'maxOutputTokens': 220,
            'temperature': 0.7,
          },
        },
      );
      final data = response.data;
      String content = '';
      if (data != null) {
        final candidates = data['candidates'];
        if (candidates is List && candidates.isNotEmpty) {
          final first = candidates.first;
          if (first is Map) {
            final c = first['content'];
            if (c is Map) {
              final parts = c['parts'];
              if (parts is List && parts.isNotEmpty) {
                final p0 = parts.first;
                if (p0 is Map) {
                  final t = p0['text'];
                  if (t is String) content = t.trim();
                }
              }
            }
          }
        }
      }
      final reply = content.isEmpty
          ? 'I could not generate a response. Please try again.'
          : content;
      return ChatMessage(
        id: 'm_${DateTime.now().millisecondsSinceEpoch}',
        text: reply,
        fromUser: false,
        timestamp: DateTime.now(),
        intent: classify(text),
      );
    } on DioException catch (e) {
      final msg = e.response?.data is Map &&
              (e.response!.data as Map)['error'] is Map
          ? ((e.response!.data as Map)['error'] as Map)['message']?.toString()
          : null;
      throw Exception(
          'Gemini API error (${e.response?.statusCode ?? 'no status'}): ${msg ?? e.message ?? 'unknown'}');
    }
  }
}

final geminiChatbotRepositoryProvider = Provider<GeminiChatbotRepository>(
  (ref) => GeminiChatbotRepository(),
);

final chatbotRepositoryProvider = Provider<ChatbotRepository>((ref) {
  final gemini = ref.read(geminiChatbotRepositoryProvider);
  if (gemini.isConfigured) return gemini;
  return MockChatbotRepository();
});
