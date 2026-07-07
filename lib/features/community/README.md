# Community Feature

Community-reported incidents: list view, filters, submission form, and the offline Drift sync queue.

## Folder Layout

- **`data/`** — `CommunityRepository`, `IncidentLocalDataSource` (Drift), `IncidentRemoteDataSource` (Dio), `SyncQueueDao`.
- **`domain/`** — `IncidentReport`, `IncidentType` enum, `SubmitIncidentReportUseCase`, `SyncPendingReportsUseCase`.
- **`presentation/`** — `CommunityScreen`, `ReportIncidentScreen`, `IncidentFilterBar`, `IncidentCard`, `IncidentControllerProvider`.

## Public Surface

- **Screens:** `presentation/screens/community_screen.dart`, `report_incident_screen.dart`
- **Riverpod controllers:** `communityControllerProvider`, `incidentSubmissionProvider`
- **Use cases:** `SubmitIncidentReportUseCase`, `SyncPendingReportsUseCase`, `GetNearbyIncidentsUseCase`

## Offline-First

Reports are written to the Drift `incidents` and `sync_queue` tables first, then flushed via Dio when connectivity returns. The Drift sync queue lives at `core/storage/` and is reused across features.

## Related

- See [safe_zones](../safe_zones/) for the related POI marker dataset.
- See [map](../map/) for the live-incidents overlay.
- See [core/storage](../../core/storage/) for the Drift schema and the `sync_queue` table.
