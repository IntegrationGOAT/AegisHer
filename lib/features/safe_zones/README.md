# Safe Zones Feature

Discover nearby police stations, hospitals, pharmacies, shelters, and trusted businesses.

## Folder Layout

- **`data/`** — `SafeZoneRepository`, mock POI dataset, `SafeZoneCategory` enum, distance-computation helpers.
- **`domain/`** — `SafeZone`, `SafeZoneCategory` (police/hospital/pharmacy/shelter/business), `GetNearbySafeZonesUseCase`, `GetSafeZoneDetailUseCase`.
- **`presentation/`** — `SafeZonesScreen`, `SafeZoneDetailScreen`, `CategoryFilterBar`, `SafeZoneCard`, `RouteFromHereCta`.

## Public Surface

- **Screens:** `presentation/screens/safe_zones_screen.dart`, `safe_zone_detail_screen.dart`
- **Riverpod controllers:** `safeZonesControllerProvider`, `safeZoneFilterProvider`
- **Use cases:** `GetNearbySafeZonesUseCase`, `GetSafeZoneDetailUseCase`

## Mock Data

The default dataset (50 POIs around a few major cities) ships with the app so the screen renders fully without a backend. Distance is computed client-side via haversine.

## Related

- See [map](../map/) for the Safe-Zone overlay layer.
- See [safety](../safety/) for the DPSI proximity-to-safe-zone factor.
