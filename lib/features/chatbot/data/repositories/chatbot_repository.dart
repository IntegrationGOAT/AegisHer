import 'dart:developer' as developer;

import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
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

/// Resolves the Gemini API key from (in order):
///   1. `GEMINI_API_KEY` env var loaded from .env (preferred — never baked into APK)
///   2. `GEMINI_API_KEY` dart-define (escape hatch for CI / release builds)
String _resolveApiKey() {
  final fromEnv = dotenv.env['GEMINI_API_KEY']?.trim() ?? '';
  if (fromEnv.isNotEmpty) return fromEnv;
  const fromDefine = String.fromEnvironment('GEMINI_API_KEY', defaultValue: '');
  return fromDefine.trim();
}

String _resolveModel() {
  final fromEnv = dotenv.env['GEMINI_MODEL']?.trim();
  if (fromEnv != null && fromEnv.isNotEmpty) return fromEnv;
  const fromDefine = String.fromEnvironment('GEMINI_MODEL', defaultValue: '');
  return fromDefine.trim().isEmpty ? 'gemini-flash-latest' : fromDefine.trim();
}

class GeminiChatbotRepository implements ChatbotRepository {
  GeminiChatbotRepository({Dio? dio})
      : _dio = dio ??
            Dio(BaseOptions(
              connectTimeout: const Duration(seconds: 15),
              receiveTimeout: const Duration(seconds: 30),
              sendTimeout: const Duration(seconds: 15),
            )) {
    _apiKey = _resolveApiKey();
    _model = _resolveModel();
    _logKeyPresence();
  }

  final Dio _dio;
  late final String _apiKey;
  late final String _model;

  bool get isConfigured => _apiKey.isNotEmpty;

  String get _endpoint =>
      'https://generativelanguage.googleapis.com/v1beta/models/$_model:generateContent';

  void _logKeyPresence() {
    if (_apiKey.isEmpty) {
      developer.log(
        '[Gemini] GEMINI_API_KEY is EMPTY — chatbot will fall back to mock.',
        name: 'AegisHer.Chatbot',
      );
      return;
    }
    final masked = _apiKey.length <= 8
        ? '***'
        : '${_apiKey.substring(0, 4)}...${_apiKey.substring(_apiKey.length - 4)} (len=${_apiKey.length})';
    developer.log(
      '[Gemini] Key loaded: $masked | model=$_model | endpoint=$_endpoint',
      name: 'AegisHer.Chatbot',
    );
  }

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
          'GEMINI_API_KEY not configured. Set it in .env or via --dart-define.');
    }

    developer.log('[Gemini] POST $_endpoint', name: 'AegisHer.Chatbot');

    try {
      final response = await _dio.post<Map<String, dynamic>>(
        _endpoint,
        options: Options(headers: {
          'Content-Type': 'application/json',
          'X-goog-api-key': _apiKey,
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

      developer.log(
        '[Gemini] Response status: ${response.statusCode}',
        name: 'AegisHer.Chatbot',
      );

      if (response.statusCode == null || response.statusCode! >= 400) {
        final body = response.data;
        developer.log(
          '[Gemini] Error body: ${body.toString()}',
          name: 'AegisHer.Chatbot',
        );
        throw Exception(
            'Gemini API error ${response.statusCode}: ${body.toString()}');
      }

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
      final status = e.response?.statusCode;
      final body = e.response?.data;
      developer.log(
        '[Gemini] DioException status=$status body=${body.toString()} message=${e.message}',
        name: 'AegisHer.Chatbot',
      );
      final msg = body is Map && body['error'] is Map
          ? (body['error'] as Map)['message']?.toString()
          : null;
      throw Exception(
          'Gemini API error ${status ?? "no status"}: ${msg ?? body?.toString() ?? e.message ?? "unknown"}');
    } catch (e, st) {
      developer.log(
        '[Gemini] Unexpected error: $e\n$st',
        name: 'AegisHer.Chatbot',
      );
      rethrow;
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
