enum SafeZoneCategory { police, hospital, pharmacy, shelter, trustedBusiness }
class SafeZone {
  final String id;
  final String name;
  final SafeZoneCategory category;
  final double latitude;
  final double longitude;
  final String address;
  final double distanceKm;
  final String? hours;
  final double? rating;
  final String? phone;
  const SafeZone({required this.id, required this.name, required this.category, required this.latitude, required this.longitude, required this.address, required this.distanceKm, this.hours, this.rating, this.phone});
  String get categoryLabel {
    switch (category) {
      case SafeZoneCategory.police: return 'Police';
      case SafeZoneCategory.hospital: return 'Hospital';
      case SafeZoneCategory.pharmacy: return 'Pharmacy';
      case SafeZoneCategory.shelter: return 'Shelter';
      case SafeZoneCategory.trustedBusiness: return 'Trusted';
    }
  }
}
