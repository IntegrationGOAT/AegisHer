# Notifications Feature

Push (FCM) and local notification integration: foreground banners, background handlers, and topic subscriptions.

## Folder Layout

- **`data/`** — `PushTokenRepository`, `LocalNotificationService` (`flutter_local_notifications`), FCM token fetch + refresh.
- **`domain/`** — `PushToken`, `NotificationPayload`, `SubscribeToTopicUseCase`, `UnsubscribeFromTopicUseCase`.
- **`presentation/`** — `ForegroundMessageHandler`, notification-preferences UI (delegated to `settings/`).

## Public Surface

- **Services:** `LocalNotificationService`, `PushTokenRepository`
- **Riverpod providers:** `pushTokenProvider`, `notificationPermissionProvider`
- **Hooks:** `foregroundMessageStreamProvider` (FCM `onMessage`)

## Stubbing

FCM is **stubbed by default** — the token fetcher returns a deterministic mock token and `onMessage` is never invoked. To wire real push, drop the FCM credentials into `android/app/google-services.json` and `ios/Runner/GoogleService-Info.plist`, then set `--dart-define=USE_MOCKS=false`.

## Related

- See [settings](../settings/) for the in-app notification preferences UI.
- See [sos](../sos/) for the foreground-service-style local notification while SOS is active.
- See [core/error](../../core/error/) for the typed `NotificationPermissionDeniedException`.
