# Map Feature

Live Mapbox map with overlays for safe zones, high-risk areas, emergency services, live community updates, user location, and route polylines.

## Folder Layout

- **`data/`** — `MapRepository`, `RouteRepository` (mock + Mapbox-backed), DTOs for Mapbox Directions API.
- **`domain/`** — `LatLng`, `Route`, `MapMarker`, `SafeZone`, `HighRiskArea`, `EmergencyService` entities, `GetSafestRouteUseCase`.
- **`presentation/`** — `MapScreen`, `MapControllerProvider` (Riverpod), `RoutePolylinePainter`, custom `MarkerLayer` widgets.

## Public Surface

- **Screens:** `presentation/screens/map_screen.dart`
- **Riverpod controllers:** `mapControllerProvider`, `routeControllerProvider`
- **Use cases:** `GetSafestRouteUseCase`, `FetchNearbySafeZonesUseCase`

## Mapbox Token

Pass via `--dart-define=MAPBOX_TOKEN=pk.eyJ…`. When the token is missing, the screen renders a clearly-labeled placeholder (gradient backdrop + cyan ring + "Map integration" caption) — the rest of the app continues to function.

## Related

- See [safe_zones](../safe_zones/) for the marker dataset overlay.
- See [community](../community/) for the live-incidents overlay.
- See [location](../location/) for the user-location marker.
- See [core/config](../../core/config/) for the `kMapboxToken` const.
