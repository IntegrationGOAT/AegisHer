# Settings Feature

User preferences: theme mode, language, accessibility controls, notification preferences, biometric toggle, account actions.

## Folder Layout

- **`data/`** — `SettingsRepository` (persists to `flutter_secure_storage` + Drift), DTOs for each settings group.
- **`domain/`** — `UserSettings`, `ThemeMode`, `Locale`, `AccessibilityPreferences`, `NotificationPreferences`, `UpdateSettingsUseCase`.
- **`presentation/`** — `SettingsScreen`, `ThemeSelector`, `LanguageSelector`, `AccessibilityPanel`, `NotificationPanel`, `settingsControllerProvider`.

## Public Surface

- **Screens:** `presentation/screens/settings_screen.dart`
- **Riverpod controllers:** `settingsControllerProvider`, `themeModeProvider`, `localeProvider`
- **Use cases:** `UpdateSettingsUseCase`, `LogoutUseCase`, `DeleteAccountUseCase`

## Persistence

Settings are mirrored to secure storage and rehydrated on cold start. Theme mode propagates through `themeModeProvider` → `GoRouter` redirect → `MaterialApp.themeMode`.

## Related

- See [auth](../auth/) for `LogoutUseCase`.
- See [notifications](../notifications/) for the in-app notification preferences UI.
- See [core/theme](../../core/theme/) for the `ThemeMode` ↔ `ThemeData` selector.
