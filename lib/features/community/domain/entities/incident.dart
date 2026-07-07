enum IncidentCategory { theft, harassment, assault, suspiciousActivity, poorLighting, roadHazard, other }
enum IncidentSeverity { low, medium, high, critical }
class IncidentMedia {
  final String url;
  final bool isVideo;
  const IncidentMedia({required this.url, required this.isVideo});
}
class CommunityReport {
  final String id;
  final IncidentCategory category;
  final IncidentSeverity severity;
  final String title;
  final String description;
  final double latitude;
  final double longitude;
  final String address;
  final DateTime reportedAt;
  final int upvotes;
  final bool verified;
  final bool anonymous;
  final List<IncidentMedia> media;
  final String? reporterId;
  const CommunityReport({
    required this.id,
    required this.category,
    required this.severity,
    required this.title,
    required this.description,
    required this.latitude,
    required this.longitude,
    required this.address,
    required this.reportedAt,
    this.upvotes = 0,
    this.verified = false,
    this.anonymous = false,
    this.media = const [],
    this.reporterId,
  });
  String get categoryLabel => category.name;
}
