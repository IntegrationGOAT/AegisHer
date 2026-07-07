class RouteSegment {
  final double latitude;
  final double longitude;
  final double safetyScore;
  final List<String> warnings;
  const RouteSegment({required this.latitude, required this.longitude, required this.safetyScore, this.warnings = const []});
}
class Hazard {
  final String id;
  final String type; // lighting, crowd, construction
  final double latitude;
  final double longitude;
  final String description;
  const Hazard({required this.id, required this.type, required this.latitude, required this.longitude, required this.description});
}
class Route {
  final String id;
  final List<RouteSegment> segments;
  final double overallSafetyScore;
  final double distanceKm;
  final int estimatedMinutes;
  final List<Hazard> hazards;
  const Route({required this.id, required this.segments, required this.overallSafetyScore, required this.distanceKm, required this.estimatedMinutes, this.hazards = const []});
}
