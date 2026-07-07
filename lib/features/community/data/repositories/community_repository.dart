import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/incident.dart';

abstract class CommunityRepository {
  Future<List<CommunityReport>> recentReports({double? latitude, double? longitude, double radiusKm = 5});
  Future<CommunityReport> submitReport(CommunityReport report);
  Future<int> voteReport(String reportId);
}

class MockCommunityRepository implements CommunityRepository {
  static const _d = Duration(milliseconds: 500);
  @override
  Future<List<CommunityReport>> recentReports({double? latitude, double? longitude, double radiusKm = 5}) async {
    await Future<void>.delayed(_d);
    return [
      CommunityReport(id: 'c1', category: IncidentCategory.poorLighting, severity: IncidentSeverity.medium, title: 'Broken streetlight', description: 'Light has been out for 3 days on 5th Ave', latitude: 19.076, longitude: 72.877, address: '5th Ave, near park', reportedAt: DateTime.now().subtract(const Duration(hours: 12)), upvotes: 8, verified: true),
      CommunityReport(id: 'c2', category: IncidentCategory.suspiciousActivity, severity: IncidentSeverity.low, title: 'Suspicious loitering', description: 'Person lingering near parked cars at night', latitude: 19.073, longitude: 72.881, address: 'Oak Ave', reportedAt: DateTime.now().subtract(const Duration(hours: 24)), upvotes: 4, verified: false),
      CommunityReport(id: 'c3', category: IncidentCategory.harassment, severity: IncidentSeverity.high, title: 'Verbal harassment', description: 'Catcalling incident reported by 3 users', latitude: 19.078, longitude: 72.875, address: 'Main St & 3rd', reportedAt: DateTime.now().subtract(const Duration(days: 2)), upvotes: 22, verified: true, anonymous: true),
    ];
  }
  @override
  Future<CommunityReport> submitReport(CommunityReport report) async { await Future<void>.delayed(_d); return report; }
  @override
  Future<int> voteReport(String reportId) async { await Future<void>.delayed(const Duration(milliseconds: 200)); return 1; }
}

final communityRepositoryProvider = Provider<CommunityRepository>((ref) => MockCommunityRepository());
