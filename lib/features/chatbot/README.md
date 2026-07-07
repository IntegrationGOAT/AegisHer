# Chatbot Feature

Polished chat UI with typing indicator, message bubbles, quick-reply chips, and stubbed AI responses keyed on intent classification.

## Folder Layout

- **`data/`** — `ChatbotRepository`, `IntentClassifier` (heuristic / on-device), mock response table.
- **`domain/`** — `ChatMessage`, `ChatIntent` enum, `SendMessageUseCase`, `ClassifyIntentUseCase`.
- **`presentation/`** — `ChatbotScreen`, `MessageBubble`, `TypingIndicator`, `QuickReplyChips`, `chatbotControllerProvider`.

## Public Surface

- **Screens:** `presentation/screens/chatbot_screen.dart`
- **Riverpod controllers:** `chatbotControllerProvider`, `chatHistoryProvider`
- **Use cases:** `SendMessageUseCase`, `ClassifyIntentUseCase`

## Stubbing

By default the repository returns canned responses per `ChatIntent` (safety, route, incident, small-talk). When `--dart-define=USE_MOCKS=false`, switch the repository implementation to call a real provider (OpenAI, Anthropic, etc.) — the interface stays stable.

## Related

- See [safety](../safety/) for the safety-intent handoff (e.g., "is this area safe?" → DPSI summary card).
- See [sos](../sos/) for the emergency-intent handoff (e.g., "I don't feel safe" → SOS CTA).
