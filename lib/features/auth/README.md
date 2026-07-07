# Auth Feature

Handles login, signup, session persistence (via `flutter_secure_storage`), and biometric unlock (via `local_auth`).

## Folder Layout

- **`data/`** — `AuthRepository` (mock + real impls), remote + secure-storage data sources, `AuthDto` Freezed classes.
- **`domain/`** — `User` entity, `AuthSession` value object, `LoginUseCase`, `SignupUseCase`, `RestoreSessionUseCase`.
- **`presentation/`** — `LoginScreen`, `SignupScreen`, `OnboardingScreen`, `authControllerProvider`, form widgets.

## Public Surface

- **Screens:** `presentation/screens/login_screen.dart`, `signup_screen.dart`, `onboarding_screen.dart`
- **Riverpod controllers:** `authControllerProvider`, `sessionProvider`
- **Repository:** `AuthRepository` (interface + `MockAuthRepository` impl)
- **Secure storage:** `flutter_secure_storage` keys `auth.session`, `auth.user`

## Mock vs Live

Mocked by default when `--dart-define=USE_MOCKS=true`. Toggle off to wire to a real OAuth backend.

## Related

- See [core/storage](../../core/storage/) for the storage interface and `flutter_secure_storage` adapter.
- See [core/router](../../core/router/) for the `GoRouter` redirect rules that gate protected routes.
