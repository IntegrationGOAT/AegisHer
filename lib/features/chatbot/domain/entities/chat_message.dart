enum ChatIntent { greeting, safety, route, sos, incident, smalltalk, unknown }
class ChatMessage {
  final String id;
  final String text;
  final bool fromUser;
  final DateTime timestamp;
  final ChatIntent intent;
  const ChatMessage({required this.id, required this.text, required this.fromUser, required this.timestamp, required this.intent});
}
