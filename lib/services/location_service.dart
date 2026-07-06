import 'dart:math';

class LocationService {
  // Singleton pattern
  static final LocationService _instance = LocationService._internal();
  factory LocationService() => _instance;
  LocationService._internal();

  /// Get current location
  Future<Map<String, double>> getCurrentLocation() async {
    // TODO: Replace with actual GPS/location plugin
    await Future.delayed(const Duration(milliseconds: 300));
    return {
      'latitude': 19.0760,
      'longitude': 72.8777,
    };
  }

  /// Calculate distance between two coordinates in km
  double calculateDistance(
    double startLat,
    double startLng,
    double endLat,
    double endLng,
  ) {
    const double earthRadius = 6371;
    final double dLat = _degreesToRadians(endLat - startLat);
    final double dLng = _degreesToRadians(endLng - startLng);
    final double a = pow(sin(dLat / 2), 2) +
        cos(_degreesToRadians(startLat)) *
            cos(_degreesToRadians(endLat)) *
            pow(sin(dLng / 2), 2);
    final double c = 2 * atan2(sqrt(a), sqrt(1 - a));
    return earthRadius * c;
  }

  double _degreesToRadians(double degrees) {
    return degrees * (pi / 180);
  }
}