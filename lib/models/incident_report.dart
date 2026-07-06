enum IncidentType {
  theft,
  harassment,
  assault,
  suspiciousActivity,
  poorLighting,
  roadHazard,
  other;

  String get label {
    switch (this) {
      case IncidentType.theft:
        return 'Theft';
      case IncidentType.harassment:
        return 'Harassment';
      case IncidentType.assault:
        return 'Assault';
      case IncidentType.suspiciousActivity:
        return 'Suspicious Activity';
      case IncidentType.poorLighting:
        return 'Poor Lighting';
      case IncidentType.roadHazard:
        return 'Road Hazard';
      case IncidentType.other:
        return 'Other';
    }
  }

  String get icon {
    switch (this) {
      case IncidentType.theft:
        return 'theft';
      case IncidentType.harassment:
        return 'harassment';
      case IncidentType.assault:
        return 'assault';
      case IncidentType.suspiciousActivity:
        return 'suspicious';
      case IncidentType.poorLighting:
        return 'lighting';
      case IncidentType.roadHazard:
        return 'hazard';
      case IncidentType.other:
        return 'other';
    }
  }
}

class IncidentReport {
  final String id;
  final IncidentType type;
  final double latitude;
  final double longitude;
  final String address;
  final String description;
  final DateTime reportedAt;
  final int upvotes;
  final bool verified;

  IncidentReport({
    required this.id,
    required this.type,
    required this.latitude,
    required this.longitude,
    required this.address,
    required this.description,
    required this.reportedAt,
    this.upvotes = 0,
    this.verified = false,
  });

  factory IncidentReport.fromJson(Map<String, dynamic> json) {
    return IncidentReport(
      id: json['id'] as String,
      type: IncidentType.values.firstWhere(
        (e) => e.name == json['type'],
        orElse: () => IncidentType.other,
      ),
      latitude: json['latitude'] as double,
      longitude: json['longitude'] as double,
      address: json['address'] as String,
      description: json['description'] as String,
      reportedAt: DateTime.parse(json['reported_at'] as String),
      upvotes: json['upvotes'] as int? ?? 0,
      verified: json['verified'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type.name,
      'latitude': latitude,
      'longitude': longitude,
      'address': address,
      'description': description,
      'reported_at': reportedAt.toIso8601String(),
      'upvotes': upvotes,
      'verified': verified,
    };
  }
}