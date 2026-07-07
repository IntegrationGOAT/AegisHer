# SOS Feature

One-tap emergency activation: hold-to-confirm, countdown, evidence capture, live location share to emergency contacts, and dispatch hooks (logged — no real 911).

## Folder Layout

- **`data/`** — `SosRepository`, `EmergencyContactsRepository`, `EvidenceCaptureService` (location, audio, sensor snapshot).
- **`domain/`** — `SosEvent`, `EmergencyContact`, `EvidenceSnapshot`, `ActivateSosUseCase`, `CancelSosUseCase`, `ShareLiveLocationUseCase`.
- **`presentation/`** — `SosScreen` (one-tap + hold-to-confirm), `SosCountdownWidget`, `SosActiveBanner`, `EmergencyContactsScreen`, `sosControllerProvider`.

## Public Surface

- **Screens:** `presentation/screens/sos_screen.dart`, `emergency_contacts_screen.dart`
- **Riverpod controllers:** `sosControllerProvider`, `emergencyContactsProvider`
- **Use cases:** `ActivateSosUseCase`, `CancelSosUseCase`, `ShareLiveLocationUseCase`

## Deep Link

Open the SOS screen directly from outside the app via the URI scheme:

```
aegisher://sos
```

Wired in `core/router/app_router.dart` as a `GoRouter` top-level route.

## Safety Note

This module **does not** contact real emergency services. Dispatch is logged to the console and surfaced as a stub event in the SOS event log. Replace `SosRepository.dispatchToEmergencyServices` with a real provider integration before shipping.

## Related

- See [location](../location/) for the live-location stream.
- See [core/router](../../core/router/) for the deep-link route.
- See [notifications](../notifications/) for the foreground-service-style local-notification while SOS is active.
