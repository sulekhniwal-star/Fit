# Phase 4 Research: Offline-First Data Foundation

## 1. Architectural Patterns

### Local Persistence with Drift & SQLCipher
- **Core Library**: `drift` with `sqlite3` / `sqlite3_flutter_libs` / `sqlcipher_flutter_libs`.
- **Encryption Contract**:
  - Drift databases provide hook-based configuration via `setup: (rawDb) { rawDb.execute("PRAGMA key = '$key';"); }`.
  - In production, key is retrieved from OS keychain/keystore via secure storage.
  - In unit test environments, an in-memory Drift database allows fast, 100% deterministic testing without platform plugin dependencies.
- **Minimum Foundation Schema**:
  1. `sync_outbox`: stores pending mutations.
  2. `local_user_profiles`: cached user profile.
  3. `cached_records`: key-value generic store for metadata and offline catalogs.

### The Offline Outbox Pattern (TASK 021)
- Write operations are always committed locally in Drift first within a transaction that simultaneously enqueues an outbox record.
- Attributes:
  - `id`: unique client-generated UUID.
  - `entity_type`: target domain table.
  - `operation_type`: `INSERT`, `UPDATE`, `DELETE`.
  - `payload`: JSON string representation of modified entity.
  - `idempotency_key`: ensures duplicate network submissions do not create duplicate records on Supabase.
  - `status`: `pending`, `in_flight`, `failed`, `completed`.
  - `retry_count`: incremented on retryable failure (`FK-3002`).

### Sync State Machine (TASK 022)
- State progression:
  ```
  [Offline] <--- No Network ---> [Idle]
                                   │ (mutations pending or pull triggered)
                                   ▼
                              [Syncing]
                                   │
                     ┌─────────────┼─────────────┐
                     ▼             ▼             ▼
                 [Synced]       [Error]     [Conflict]
                                   │             │
                             (exponential   (user choice:
                                backoff)    mine / server)
  ```
- Exponential backoff with jitter avoids thundering herds when network recovers.
- Cancellation and resume: If sync is interrupted (app backgrounded or lost connectivity), in-flight mutations reset to `pending` and resume safely upon reconnection.

### Conflict Resolution Strategy (TASK 024A)
- **Error Code**: `FK-3003` (Data conflict detected. Reconciliation required).
- **Default Strategy**:
  - Telemetry & append-only streams (steps, water, heart rate): Last-Write-Wins (LWW) based on client observation timestamp.
  - State entities (profile, goals, settings): Version/updated_at check. If server version is newer and differs from local base version, trigger conflict state and present resolution dialog.

---

## 2. Threat Modeling & Failure Modes
- **Threat**: App terminates while outbox mutation is half-synced.
  - **Mitigation**: Two-phase outbox status: mark `in_flight` before network dispatch; only mark `completed` (or delete) after 200 OK server response. If app restarts, `in_flight` items reset to `pending`.
- **Threat**: Duplicate network request causes duplicate database row.
  - **Mitigation**: Server-side idempotency key on Supabase table ensures upserts are idempotent (`ON CONFLICT (id) DO UPDATE`).
- **Threat**: Cleartext database file extraction from device backup.
  - **Mitigation**: SQLCipher 256-bit AES database encryption at rest.

---

## 3. Recommended Plan Decomposition
1. **04-01-PLAN.md (Wave 1)**: Drift Local Database, Schema Foundations & SQLCipher Encryption Contract.
2. **04-02-PLAN.md (Wave 2)**: Persistent Offline Outbox Queue & Sync State Machine Coordinator.
3. **04-03-PLAN.md (Wave 3)**: Syncable Repository Pattern, Realtime Bridge & Offline/Conflict UI.
