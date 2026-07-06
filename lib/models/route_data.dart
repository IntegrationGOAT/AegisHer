class RoutePoint {
  final double latitude;
  final double longitude;
  final double safetyScore;
  final List<String> warnings;

  RoutePoint({
    required this.latitude,
    required this.longitude,
    this.safetyScore = 0.0,
    this.warnings = const [],
  });

  factory RoutePoint.fromJson(Map<String, dynamic> json) {
    return RoutePoint(
      latitude: json['latitude'] as double,
      longitude: json['longitude'] as double,
      safetyScore: json['safety_score'] as double? ?? 0.0,
      warnings: List<String>.from(json['warnings'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'latitude': latitude,
      'longitude': longitude,
      'safety_score': safetyScore,
      'warnings': warnings,
    };
  }
}

class SafeRoute {
  final String id;
  final List<RoutePoint> points;
  final double overallSafetyScore;
  final double distance;
  final int estimatedDurationMinutes;
  final List<String> safetyHighlights;
  final List<String> warnings;

  SafeRoute({
    required this.id,
    required this.points,
    required this.overallSafetyScore,
    required this.distance,
    required this.estimatedDurationMinutes,
    this.safetyHighlights = const [],
    this.warnings = const [],
  });

  factory SafeRoute.fromJson(Map<String, dynamic> json) {
    return SafeRoute(
      id: json['id'] as String,
      points: (json['points'] as List)
          .map((p) => RoutePoint.fromJson(p as Map<String, dynamic>))
          .toList(),
      overallSafetyScore: json['overall_safety_score'] as double,
      distance: json['distance'] as double,
      estimatedDurationMinutes: json['estimated_duration_minutes'] as int,
      safetyHighlights: List<String>.from(json['safety_highlights'] ?? []),
      warnings: List<String>.from(json['warnings'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'points': points.map((p) => p.toJson()).toList(),
      'overall_safety_score': overallSafetyScore,
      'distance': distance,
      'estimated_duration_minutes': estimatedDurationMinutes,
      'safety_highlights': safetyHighlights,
      'warnings': warnings,
    };
  }
}