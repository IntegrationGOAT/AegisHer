# Safety Feature

The Dynamic Personal Safety Index (DPSI) engine: scoring, factors, recommendations, and the live "Safety Pulse" alerts ticker on the home dashboard.

## Folder Layout

- **`data/`** — `DpsiRepository`, `SafetyPulseRepository`, mock + remote data sources.
- **`domain/`** — `DpsiScore`, `SafetyPulseEvent`, `SafetyFactor` entities, `CalculateDpsiUseCase`, `GetSafetyPulseUseCase`.
- **`presentation/`** — animated `DpsiGauge` widget, `SafetyPulseTicker`, `ExplainableAiCard`, `RecommendedActionsList`.

## Public Surface

- **Riverpod controllers:** `dpsiControllerProvider`, `safetyPulseControllerProvider`
- **Use cases:** `CalculateDpsiUseCase`, `GetSafetyPulseUseCase`
- **Widgets:** `DpsiGauge`, `SafetyPulseTicker`, `ExplainableAiCard`

## Inputs

`CalculateDpsiUseCase` consumes location, time-of-day, recent incidents (from `community/`), safe-zone proximity (from `safe_zones/`), and a user-context object. Returns a `DpsiScore` with `score`, `level`, and `factors`.

## Related

- See [map](../map/) for the location-driven DPSI recalculation triggers.
- See [community](../community/) for incident input to the scoring engine.
- See [sos](../sos/) for the high-DPSI → auto-suggest SOS handoff.
