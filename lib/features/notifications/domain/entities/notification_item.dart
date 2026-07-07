enum NotificationCategory { sos, safetyPulse, community, system, chat }
class NotificationItem {
  final String id;
  final String title;
  final String body;
  final NotificationCategory category;
  final DateTime timestamp;
  final bool read;
  const NotificationItem({required this.id, required this.title, required this.body, required this.category, required this.timestamp, this.read = false});
}
