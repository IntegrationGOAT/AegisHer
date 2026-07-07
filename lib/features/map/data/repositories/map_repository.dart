import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/route.dart';

abstract class MapRepository {
  Future<Route> safestRoute({required double startLat, required double startLng, required double endLat, required double endLng});
}

class MockMapRepository implements MapRepository {
  static const _d = Duration(milliseconds: 700);
  @override
  Future<Route> safestRoute({required double startLat, required double startLng, required double endLat, required double endLng}) async {
    await Future<void>.delayed(_d);
    final mid = RouteSegment(latitude: (startLat + endLat) / 2, longitude: (startLng + endLng) / 2, safetyScore: 72.0, warnings: const ['Moderate lighting']);
    return Route(
      id: 'r_${DateTime.now().millisecondsSinceEpoch}',
      segments: [
        RouteSegment(latitude: startLat, longitude: startLng, safetyScore: 85.0),
        mid,
        RouteSegment(latitude: endLat, longitude: endLng, safetyScore: 90.0),
      ],
      overallSafetyScore: 82.3,
      distanceKm: 2.5,
      estimatedMinutes: 35,
      hazards: const [Hazard(id: 'h1', type: 'lighting', latitude: 19.07, longitude: 72.87, description: 'Broken streetlight')],
    );
  }
}

final mapRepositoryProvider = Provider<MapRepository>((ref) => MockMapRepository());
