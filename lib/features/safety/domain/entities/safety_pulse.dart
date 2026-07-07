enum SafetyPulseSeverity { info, warning, critical }
class SafetyPulseAlert {
  final String id;
  final String title;
  final String body;
  final SafetyPulseSeverity severity;
  final DateTime timestamp;
  final double latitude;
  final double longitude;
  const SafetyPulseAlert({required this.id, required this.title, required this.body, required this.severity, required this.timestamp, required this.latitude, required this.longitude});
}
