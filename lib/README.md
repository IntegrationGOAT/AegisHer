# AegisHer — `lib/` Folder Convention

This directory follows a **feature-first, layered** structure for Clean Architecture
with Riverpod 2.x. Every screen, repository, controller, and model belongs to one
feature. Shared infrastructure lives in `core/`. Cross-feature primitives
(extensions, design-only widgets, generic value types) live in `shared/`.

> **Migration note.** The original `lib/{models, screens, services, widgets, theme}`
> layout is preserved at the repo root for reference and will be migrated into the
> feature folders in later phases. New code **must** live under `features/`, `core/`,
> or `shared/` — never in the legacy top-level folders.

## Layout

```
lib/
├── main.dart                          # App entry, runApp(ProviderScope(...))
├── core/                              # Cross-cutting infrastructure (no business logic)
│   ├── config/        EnvConfig, dart-define reader, feature flags
│   ├── network/       DioClient, interceptors, API contracts
│   ├── storage/       SecureStorage, DriftDatabase wiring, key-value helpers
│   ├── error/         AppException hierarchy, Failure types
│   ├── theme/         AppTheme (M3), design tokens, GlassNeumorphicTokens
│   ├── utils/         Responsive breakpoints, logger, debouncer
│   ├── widgets/       GlassCard, NeumorphicButton, AnimatedGradientBackground
│   ├── di/            GetIt registrations, provider composition roots
│   └── router/        GoRouter config, route guards, deep-link table
│
├── features/                          # One folder per business capability
│   ├── auth/          (data, domain, presentation)
│   ├── safety/        DPSI dashboard, explainable AI breakdown
│   ├── map/           Live safety map (Mapbox)
│   ├── community/     Reports feed + submission
│   ├── sos/           Emergency activation, evidence, contacts
│   ├── safe_zones/    Nearby police/hospital/pharmacy/shelter listings
│   ├── chatbot/       AI companion chat surface (stubbed)
│   ├── settings/      Theme, language, accessibility, account actions
│   ├── location/      Geolocator wrapper, permissions, last-known position
│   └── notifications/ FCM stub, local notifications, preferences
│
└── shared/                            # Cross-feature primitives
    ├── models/        Result<T>, Money, GeoPoint, branded value types
    ├── widgets/       AppLogo, EmptyState, ErrorView, SectionHeader
    └── utils/         DateFormat helpers, validators, sanitizers
```

## Inside every feature

```
features/<name>/
├── data/              # Repository implementations, remote/local DTOs, mappers
├── domain/            # Entities (Freezed), repository interfaces, use cases
└── presentation/      # Riverpod controllers, screens, widgets, navigation
```

| Layer         | Knows about               | Depends on              |
| ------------- | ------------------------- | ----------------------- |
| `domain/`     | Pure Dart + Freezed       | nothing else in the app |
| `data/`       | `domain/`, `core/network` | `domain/`               |
| `presentation/` | `domain/`, `core/theme`, `shared/` | `domain/`     |

The dependency direction is **strictly inward**: `presentation → domain ← data`.
Never import `data/` from `presentation/` — depend on `domain/` interfaces and let
Riverpod resolve the concrete repository.

## Naming

* Files: `snake_case.dart`. Freezed models end with the noun, no `_model` suffix.
* Riverpod providers: `<feature>_<thing>_provider.dart` (e.g. `auth_controller.dart`).
* Screens: `<thing>_screen.dart` and live under `features/<feature>/presentation/screens/`.
* Tests mirror the source tree: `test/features/<feature>/...`.

## Running the app

```bash
flutter pub get
dart run build_runner build --delete-conflicting-outputs
flutter analyze
flutter test
flutter run --dart-define=USE_MOCKS=true \
            --dart-define=MAPBOX_TOKEN= \
            --dart-define=API_BASE_URL=http://localhost:8000 \
            --dart-define=WS_URL=ws://localhost:8000/ws
```

See `../README.md` for the full architecture, environment-variable matrix, and CI
workflow.
