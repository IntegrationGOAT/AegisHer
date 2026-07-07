enum SosStatus { idle, countdown, active, cancelled, completed }
class SosContact {
  final String id;
  final String name;
  final String phone;
  final String relationship;
  const SosContact({required this.id, required this.name, required this.phone, required this.relationship});
}
class SosEvidence {
  final String type; // location, audio, sensor
  final Map<String, dynamic> data;
  final DateTime capturedAt;
  const SosEvidence({required this.type, required this.data, required this.capturedAt});
}
class SosEvent {
  final String id;
  final SosStatus status;
  final DateTime startedAt;
  final double latitude;
  final double longitude;
  final List<SosEvidence> evidence;
  final List<String> contactsNotified;
  const SosEvent({required this.id, required this.status, required this.startedAt, required this.latitude, required this.longitude, this.evidence = const [], this.contactsNotified = const []});
}
