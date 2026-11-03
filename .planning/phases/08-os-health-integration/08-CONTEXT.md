# Phase 8 Context: OS Health Integration (Health Connect & Apple Health)

## Phase Purpose
Connect FitKarma to Android Health Connect and iOS Apple Health / HealthKit for bidirectional biometric synchronization, multi-source deduplication, and source attribution while respecting platform battery/background execution constraints.

## User Constraints & Core Directives
1. **No Vendor Leakage into Domain (ADR-004)**:
   - Platform Health Connect and Apple HealthKit types must never leak into the domain layer. All external observations must normalize cleanly into canonical FitKarma primitives (`StepRecord`, `SleepRecord`, `VitalRecord`, `BodyMetricEntry`, `HealthQuantity`, `HealthSource`).
2. **Deterministic Deduplication**:
   - Wearable data and manual user entries will collide. Manual entries take precedence by default; overlapping interval records (e.g. step windows, sleep intervals, duplicate weight readings within a time threshold) must be de-duplicated without loss of user intent.
3. **Graceful Revocation**:
   - When a user revokes health permissions in OS Settings, the app must not crash, display unhandled errors, or corrupt local encrypted SQLite tables.
4. **Battery & Background Sync Limits**:
   - Neither Android nor iOS allows unlimited background execution. Health synchronization must observe minimum intervals (e.g., >= 15 min), support incremental change tokens, and avoid aggressive polling.
5. **Non-Medical Framing**:
   - All external biometric telemetry must display non-prescriptive, statutory wellness notices.

## Architecture Boundaries
- `lib/features/os_health/domain/`:
  - `platform_health_adapter.dart`: Adapter interface (`isAvailable`, `getPermissionStatus`, `requestPermissions`, `fetchRecords`, `fetchChanges`, `revokePermissions`).
  - `health_data_types.dart`: Canonical types enum (`steps`, `sleep`, `heartRate`, `weight`, `bloodPressure`, `bloodGlucose`) and permission states.
  - `biometric_deduplication_engine.dart`: Collision detection and reconciliation strategy between manual and OS health inputs.
- `lib/features/os_health/data/`:
  - `health_connect_adapter.dart`: Android Health Connect mapping.
  - `apple_health_adapter.dart`: iOS Apple HealthKit mapping.
  - `mock_platform_health_adapter.dart`: Fully deterministic cross-platform mock adapter for unit/widget tests.
  - `health_integration_service.dart`: High-level sync service orchestrating imports into Drift repositories.
  - `health_background_sync_manager.dart`: Battery-conscious background scheduler and failure telemetry.
- `lib/features/os_health/presentation/`:
  - `os_health_sync_card.dart`: Settings/Dashboard card displaying connection status, permission chips, last sync time, and "Sync Now" button.

