# Location Feature

Geolocation services: current-location fetch, live stream, geocoding/reverse-geocoding, and permission handling.

## Folder Layout

- **`data/`** — `LocationRepository`, `GeocodingRepository`, `LocationPermissionHandler` (wraps `permission_handler`).
- **`domain/`** — `Location`, `LocationStream`, `Address` entities, `GetCurrentLocationUseCase`, `WatchLocationUseCase`, `ReverseGeocodeUseCase`.
- **`presentation/`** — `LocationProvider` (Riverpod stream wrapper), permission-prompt widgets.

## Public Surface

- **Riverpod providers:** `currentLocationProvider`, `locationStreamProvider`, `locationPermissionProvider`
- **Use cases:** `GetCurrentLocationUseCase`, `WatchLocationUseCase`, `ReverseGeocodeUseCase`

## Permissions

`LocationPermissionHandler` requests `Permission.locationWhenInUse` (or `Permission.locationAlways` for SOS live-share). All permission flows are surfaced through `permission_handler` — see `core/error/` for the typed `LocationDeniedException` / `LocationServiceDisabledException`.

## Related

- See [map](../map/) for the user-location marker.
- See [sos](../sos/) for the live-location-share during an active SOS.
- See [safety](../safety/) for the location-driven DPSI recompute.
