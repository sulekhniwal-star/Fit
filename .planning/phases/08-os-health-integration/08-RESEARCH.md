# Phase 8 Research: OS Health Integration (Health Connect & Apple Health)

## 1. Domain Background & OS Ecosystem
- **Android Health Connect**:
  - Introduced in Android 14 as an OS-level subsystem (and via Play Services on Android 9+).
  - Uses explicit granular permissions (e.g. `READ_STEPS`, `READ_SLEEP`, `READ_HEART_RATE`, `READ_WEIGHT`).
  - Employs `ChangesToken` mechanism for incremental updates: client requests a change token, stores it locally, and requests delta changes on subsequent runs.
- **iOS Apple Health / HealthKit**:
  - Built into iOS foundation since iOS 8.
  - Requires `NSHealthShareUsageDescription` and `NSHealthUpdateUsageDescription` in Info.plist.
  - Granular read/write permissions per HKObjectType (`HKQuantityTypeIdentifierStepCount`, `HKCategoryTypeIdentifierSleepAnalysis`, `HKQuantityTypeIdentifierHeartRate`, `HKQuantityTypeIdentifierBodyMass`).
  - Utilizes `HKAnchoredObjectQuery` with anchor tokens for efficient delta queries.
- **Cross-Platform Abstraction**:
  - To maintain testability and cross-platform consistency without introducing fragile binary dependencies on Windows development machines, the architecture uses an interface `PlatformHealthAdapter`.
  - Concrete adapters encapsulate native platform channels, and a deterministic `MockPlatformHealthAdapter` enables 100% test coverage across local, CI, and multi-platform environments.

## 2. Multi-Source Deduplication Challenges
- **Problem**: When a user tracks steps with an Apple Watch or Galaxy Watch synced via OS Health, FitKarma may also receive manual step adjustments or background sensor updates.
- **Resolution**:
  - For discrete point-in-time metrics (e.g. Weight, Blood Pressure): duplicate detection within a 15-minute time window. If a manual entry exists within 15 minutes of an OS sync entry with identical or near-identical value, manual is retained with device attribution linked.
  - For continuous / interval metrics (e.g. Steps, Sleep):
    - Steps: Compare total daily count. If wearable step count > manual count, update to higher value attributing `HealthSource.healthConnect` or `HealthSource.appleHealth`.
    - Sleep: Interval collision resolution checks overlap between `[start, end]`. If intervals overlap by > 80%, merge metadata retaining deeper stage analysis (deep sleep, REM) from wearable telemetry.

## 3. Battery & Background Execution Best Practices
- Background health queries must never run in continuous polling loops.
- Enforce minimum sync interval of 15 minutes.
- Support manual pull-to-refresh / "Sync Now" in UI.
- Record failed sync attempts with exponential backoff and error logging via `AppLogger` with PII redaction.

