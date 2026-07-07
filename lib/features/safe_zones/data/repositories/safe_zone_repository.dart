import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/safe_zone.dart';

abstract class SafeZoneRepository {
  Future<List<SafeZone>> list({double? latitude, double? longitude});
  Future<List<SafeZone>> byCategory(SafeZoneCategory category);
}

class MockSafeZoneRepository implements SafeZoneRepository {
  static const _d = Duration(milliseconds: 400);
  static const _zones = <SafeZone>[
    SafeZone(id: 'sz1', name: 'City Police Station', category: SafeZoneCategory.police, latitude: 19.076, longitude: 72.877, address: '100 Main St', distanceKm: 0.8, hours: '24/7', rating: 4.2, phone: '100'),
    SafeZone(id: 'sz2', name: 'Apollo Hospital', category: SafeZoneCategory.hospital, latitude: 19.080, longitude: 72.881, address: '200 Health Ave', distanceKm: 1.4, hours: '24/7', rating: 4.5, phone: '+91 22 1234 5678'),
    SafeZone(id: 'sz3', name: 'MedPlus Pharmacy', category: SafeZoneCategory.pharmacy, latitude: 19.074, longitude: 72.876, address: '15 Care Rd', distanceKm: 0.6, hours: '8am-10pm', rating: 4.0),
    SafeZone(id: 'sz4', name: "Women's Shelter", category: SafeZoneCategory.shelter, latitude: 19.072, longitude: 72.880, address: 'Confidential', distanceKm: 2.1, hours: '24/7', phone: '+91 22 9999 0000'),
    SafeZone(id: 'sz5', name: 'Cafe Aurora (Trusted)', category: SafeZoneCategory.trustedBusiness, latitude: 19.077, longitude: 72.878, address: '88 Park Lane', distanceKm: 0.4, hours: '7am-11pm', rating: 4.8),
  ];

  @override
  Future<List<SafeZone>> list({double? latitude, double? longitude}) async { await Future<void>.delayed(_d); return _zones; }
  @override
  Future<List<SafeZone>> byCategory(SafeZoneCategory category) async { await Future<void>.delayed(_d); return _zones.where((z) => z.category == category).toList(); }
}

final safeZoneRepositoryProvider = Provider<SafeZoneRepository>((ref) => MockSafeZoneRepository());
