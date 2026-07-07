# `lib/` — AegisHer Source

This directory is the canonical Flutter source for the AegisHer mobile app (Android + iOS).

It follows a strict **Clean Architecture** layout organised by feature, with a shared `core/` for cross-cutting infrastructure and a shared `shared/` for widgets/utils that are reused across features without belonging to one.

> Looking for how to run the app, environment variables, testing, or CI? See the project-root [`README.md`](../README.md).
> Looking for per-feature docs? See the README inside each directory under [`features/`](features/) below.

---

## Folder Map

```
lib/
├── main.dart                 # App entry — MaterialApp.router, theme wiring, providers
├── core/                     # Cross-cutting infrastructure (no business logic)
│   ├── config/               # Build-time constants, --dart-define readers
│   ├── di/                   # Dependency-injection (get_it + Riverpod scope)
│   ├── error/                # Typed exceptions, Failure → UI mapper
│   ├── network/              # Dio client, interceptors, retry policy, mock adapter
│   ├── router/               # GoRouter config, deep links, redirect guards
│   ├── storage/              # flutter_secure_storage + Drift schema, sync_queue
│   ├── theme/                # ThemeData + design_tokens (this ferment's home)
│   ├── utils/                # Responsive helpers, formatters, misc utilities
│   └── widgets/              # GlassCard, NeumorphicButton, AnimatedGradientBackground, …
├── features/                 # One folder per business capability
│   ├── auth/                 # Login, signup, biometric, session restore
│   ├── safety/               # DPSI engine, safety-pulse ticker, recommended actions
│   ├── map/                  # Live Mapbox map, route polylines, overlays
│   ├── community/            # Incident reports, filters, offline submission
│   ├── sos/                  # One-tap emergency, evidence capture, deep link
│   ├── safe_zones/           # Nearby POIs (police, hospital, pharmacy, …)
│   ├── chatbot/              # AI chat UI, intent classification, stubbed replies
│   ├── settings/             # Theme, language, a11y, notifications, account
│   ├── location/             # Geolocation, permissions, geocoding
│   └── notifications/        # FCM stubs + flutter_local_notifications
├── shared/                   # Reused across features but not core infrastructure
│   ├── models/               # Cross-feature Freezed entities (rare; prefer per-feature)
│   ├── widgets/              # Shared presentation widgets
│   └── utils/                # Shared utilities (formatters, validators)
├── theme/                    # Legacy AppTheme entry point — kept for back-compat
├── models/                   # Legacy Freezed models (migrating to features/<f>/domain/)
├── screens/                  # Legacy screens — Foundation MVP lives here; migrating to features/<f>/presentation/
├── services/                 # Legacy service classes — migrating to features/<f>/data/
└── widgets/                  # Legacy custom widgets — migrated to core/widgets/ + features/<f>/presentation/
```

> The Foundation MVP intentionally keeps the legacy `models/`, `screens/`, `services/`, `widgets/`, and `theme/` directories so the app runs end-to-end against the new design system. Each subsequent phase migrates a feature off the legacy tree and into its proper `features/<feature>/{data,domain,presentation}` home.

---

## The `core/` Convention

Everything in `core/` is **infrastructure**, not business logic. A module here must be reusable across at least two features.

| Subfolder     | Owns                                                                  |
|---------------|-----------------------------------------------------------------------|
| `config/`     | Build-time constants (API base URL, Mapbox token, feature flags) loaded via `--dart-define`. |
| `di/`         | `get_it` registrations + Riverpod scope helpers; the single composition root. |
| `error/`      | `Failure`/`Exception` base types, `Either<Failure, T>` style helpers, the global error mapper. |
| `network/`    | `Dio` instance, auth interceptor, retry policy, mock adapter for tests. |
| `router/`     | `GoRouter` configuration, deep-link routes (`aegisher://sos`), auth-state redirect guards. |
| `storage/`    | `flutter_secure_storage` wrapper, Drift schema, the `sync_queue` table used by offline-first features. |
| `theme/`      | `ThemeData` + `design_tokens.dart` (this ferment's home — see below). |
| `utils/`      | `Responsive` helpers, `DateFormatter`, `DistanceFormatter`, validators. |
| `widgets/`    | Glass, neumorphic, animated-gradient, futuristic-button, page-transition primitives. |

### Design System Specifics

- `lib/theme/app_theme.dart` — the legacy entry point. Exposes `AppTheme.lightTheme`, `AppTheme.darkTheme`, `AppTheme.electricCyan`, `AppTheme.violet`, `AppTheme.obsidian`, `AppTheme.charcoal`, `AppTheme.signalGreen/Amber/Red`, plus 19 back-compat symbol aliases.
- `lib/core/theme/design_tokens.dart` — the canonical design-token library for new code:
  `AegisSpacing` (0–80 scale), `AegisRadius`, `AegisElevation`, `AegisBlur`, `AegisMotion` (durations + curves), `AegisGradients`, and the `GlassNeumorphicTokens` `ThemeExtension` (paired into `ThemeData` via `glassTokensFor(brightness)`).
- `lib/core/utils/responsive.dart` — `Breakpoints` (compact 600, medium 1024, foldable aspect 0.65), `DeviceClass` enum, `Responsive.value(context, compact:, medium:, expanded:)`, `Responsive.isFoldable`, and the `AegisLayout` builder wrapper.

---

## The `features/` Convention

Every business capability lives under `features/<feature>/` and follows a strict three-layer split:

```
features/<feature>/
├── data/        # Repositories (impls), data sources (remote + local), DTOs
├── domain/      # Entities, value objects, use cases, repository interfaces
└── presentation/  # Screens, widgets, Riverpod controllers
```

**Rule of thumb:**

- `domain/` depends on **nothing** except Dart core + Flutter foundation types. Pure.
- `data/` depends on `domain/` + `core/` (network, storage).
- `presentation/` depends on `domain/` + `core/theme` + `core/widgets` + `core/router`. Never on `data/` directly — go through a Riverpod provider.

### Feature READMEs

Each feature has a README describing its folder layout, public surface, mock-vs-live toggles, and related features:

- [`features/auth/README.md`](features/auth/README.md) — login, signup, biometric, session restore.
- [`features/safety/README.md`](features/safety/README.md) — DPSI engine, safety pulse, recommendations.
- [`features/map/README.md`](features/map/README.md) — Mapbox map, routes, overlays.
- [`features/community/README.md`](features/community/README.md) — incident reports, filters, offline submission.
- [`features/sos/README.md`](features/sos/README.md) — one-tap emergency, evidence, deep link `aegisher://sos`.
- [`features/safe_zones/README.md`](features/safe_zones/README.md) — nearby POIs (police, hospital, pharmacy, …).
- [`features/chatbot/README.md`](features/chatbot/README.md) — AI chat UI, intent classification, stubbed replies.
- [`features/settings/README.md`](features/settings/README.md) — theme, language, a11y, notifications, account.
- [`features/location/README.md`](features/location/README.md) — geolocation, permissions, geocoding.
- [`features/notifications/README.md`](features/notifications/README.md) — FCM stubs + local notifications.

---

## The `shared/` Convention

`shared/` is for things that are reused across multiple features but don't fit cleanly into `core/`:

- `shared/models/` — cross-feature Freezed entities (use sparingly; prefer per-feature `domain/`).
- `shared/widgets/` — presentation primitives that aren't infrastructure (e.g., a generic `EmptyState` widget).
- `shared/utils/` — formatters/validators that aren't tied to one feature (e.g., `EmailValidator`).

If a thing in `shared/` is only used by one feature, move it into that feature's `presentation/`. If it's used everywhere, move it into `core/`.

---

## Environment Variables (Build-Time)

Pass via `--dart-define=KEY=value` on the `flutter run` / `flutter build` command line.

| Variable         | Purpose                                                                  | Default |
|------------------|--------------------------------------------------------------------------|---------|
| `MAPBOX_TOKEN`   | Public Mapbox access token for `mapbox_maps_flutter`.                    | *(empty → map screen renders the placeholder)* |
| `API_BASE_URL`   | Base URL for the backend REST API (Dio).                                 | `https://api.aegisher.example.com` |
| `WS_URL`         | WebSocket endpoint for live safety-pulse / map updates.                  | `wss://ws.aegisher.example.com` |
| `USE_MOCKS`      | `true` → repositories return canned mock data; `false` → hit real APIs. | `true` |

Example:

```bash
flutter run \
  --dart-define=MAPBOX_TOKEN=pk.eyJ… \
  --dart-define=API_BASE_URL=https://api.staging.aegisher.example.com \
  --dart-define=WS_URL=wss://ws.staging.aegisher.example.com \
  --dart-define=USE_MOCKS=false
```

---

## Run Commands

```bash
# Install dependencies
flutter pub get

# Code generation (Freezed / json_serializable / Riverpod / Drift)
dart run build_runner build --delete-conflicting-outputs

# Static analysis (must exit 0)
flutter analyze

# Unit + widget tests
flutter test

# Integration test (requires a device or emulator)
flutter test integration_test/smoke_test.dart

# Android debug APK
flutter build apk --debug

# iOS debug (no codesign — for CI)
flutter build ios --no-codesign --debug

# Run on a connected device with mock data
flutter run --dart-define=USE_MOCKS=true
```

---

## Testing Strategy

| Layer                | Tool                          | What we test                                                              |
|----------------------|-------------------------------|---------------------------------------------------------------------------|
| Domain (use cases)   | `flutter test` (unit)         | `CalculateDpsiUseCase`, `GetSafestRouteUseCase`, `AuthController`, `SubmitIncidentReportUseCase`, `ChatbotRepository`, `SafeZoneRepository`. |
| Presentation widgets | `flutter test` (widget)       | `LoginScreen`, `DpsiGauge`, `SosCountdown`, `ReportIncidentScreen`, `ChatbotScreen`, `SettingsScreen`. |
| End-to-end flow      | `flutter test integration_test/` | Launch → onboarding → signup → home → SOS activation → settings logout. |
| Visual regression    | `flutter test --golden-tags`  | Light/dark themes, 390x844 / 768x1024 / 800x1200 breakpoints.             |

Tests live under `test/` (mirrors `lib/`) and `integration_test/` (smoke flows).

---

## Accessibility

- **Semantic labels** on every interactive widget — `Semantics(button: true, label: '…')` is the floor, not the ceiling.
- **Touch targets** ≥ 48×48 dp on every button, chip, and icon hit-area.
- **Contrast** verified for the cyan / violet / obsidian palette against both light and dark surfaces in [`core/theme/design_tokens.dart`](core/theme/design_tokens.dart).
- **Reduce motion** — every animation in `core/widgets/` honors `MediaQuery.disableAnimations`; the `AegisMotion` tokens can be globally dampened via `accessibilityControllerProvider` in `features/settings/`.
- **Text scaling** — layouts use `MediaQuery.textScaler` to stay readable up to 200 %; verified at 390×844.

---

## Troubleshooting

| Symptom                                                                                              | Fix                                                                                                  |
|------------------------------------------------------------------------------------------------------|------------------------------------------------------------------------------------------------------|
| `Map integration` placeholder shows instead of the live map.                                         | Pass `--dart-define=MAPBOX_TOKEN=pk.…` (and a valid token). The placeholder is the intentional fallback. |
| `Connection refused` from Dio.                                                                       | You forgot `--dart-define=USE_MOCKS=true`, or your `API_BASE_URL` is unreachable.                   |
| `flutter pub get` fails with version solving errors.                                                  | Confirm Dart SDK ≥ 3.5.0 (`dart --version`) and Flutter ≥ 3.24.0 (`flutter --version`).             |
| `dart run build_runner build` errors with stale generated files.                                     | Re-run with `--delete-conflicting-outputs`.                                                          |
| `flutter analyze` reports new errors after a refactor.                                               | Run `dart fix --apply` then re-run `flutter analyze`.                                                |
| Drift schema mismatch on cold start.                                                                 | Bump the schema version in `core/storage/` and add a migration step.                                |
| The SOS button does nothing.                                                                         | By design — SOS activation is gated behind the hold-to-confirm gesture (3 s). See `features/sos/`.   |

---

## Migration Notes (Foundation → MVP)

The Foundation MVP (this ferment) ships the legacy tree intact so the app boots. The migration plan is:

1. **Phase 2** — Domain + mocks + Riverpod scaffolding under each `features/*/domain/` and `data/`.
2. **Phase 3** — Architecture infrastructure: `core/network`, `core/storage`, `core/router`, `core/di`.
3. **Phase 4** — Auth feature wired through Riverpod; biometric gate.
4. **Phase 5** — Safety + Map + Community + SOS feature wiring.
5. **Phase 6** — Safe Zones + Chatbot + Settings + Notifications + Tests + CI + Docs.

After Phase 6, `lib/models/`, `lib/screens/`, `lib/services/`, `lib/widgets/` (the legacy roots) will be deleted and `lib/main.dart` will switch to `MaterialApp.router` with the GoRouter from `core/router/`.
