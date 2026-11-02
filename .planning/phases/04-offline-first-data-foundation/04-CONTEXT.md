# Phase 4 Context: Offline-First Data Foundation

## 1. Phase Metadata
- **Phase Number**: 04
- **Phase Name**: Offline-First Data Foundation
- **Milestone**: Milestone 1: Competitive MVP
- **Requirements**: DATA-01, DATA-02, DATA-03
- **Primary Brain References**:
  - `Brain/architecture.md` (§4 Offline sync, local persistence boundaries)
  - `Brain/data_model.md` (§2 Core entities, `sync_queue` PROPOSED specification)
  - `Brain/error_handling.md` (`FK-3001` Offline queued, `FK-3002` Sync transient, `FK-3003` Conflict)
  - `Brain/decisions.md` (ADR-001, ADR-003, ADR-018)
  - `Todo.md` (Tasks 020, 021, 022, 023, 023A, 024, 024A)

---

## 2. Scope & Objectives
FitKarma is architected from day one as an offline-first Health OS. Indian connectivity conditions in Tier-2/Tier-3 cities, basements, gym floors, and rural environments require zero app degradation when network drops.

### Core Objectives:
1. **Encrypted Local Persistence (TASK 020)**:
   - Establish Drift local database with SQLCipher encryption at rest.
   - Secure encryption key lifecycle management.
   - Versioned schema migration framework and transaction support.
   - In-memory database configuration for deterministic unit tests.
2. **Generic Offline Outbox (TASK 021)**:
   - Persistent outbox queue tracking operation ID, entity type, operation type (insert, update, delete), payload, timestamp, retry count, status, last error, and idempotency key.
   - Duplicate-suppression and retry throttling.
3. **Sync State Machine & Coordinator (TASK 022)**:
   - State transitions: `idle` $\to$ `syncing` $\to$ `synced` / `error` / `conflict`.
   - Connectivity monitoring, exponential retry backoff with jitter, and interruption-safe resume.
   - Expose reactive sync status to Riverpod.
4. **Supabase Sync Repository Pattern & Realtime (TASK 023 & 023A)**:
   - Local-as-source-of-truth repository abstraction.
   - Remote fetch and local merge, outbox push and server acknowledgement.
   - Supabase Realtime subscription bridging with deduplication against outbox acknowledged events.
5. **Offline UX & Conflict Resolution (TASK 024 & 024A)**:
   - Subtle offline status banner / indicator and pending sync count.
   - Explicit non-blaming conflict resolution handling (`FK-3003`): `keepMine`, `keepServer`, `merge` where safe.

---

## 3. Scope Fences
- **In Scope**:
  - Local database engine (Drift + SQLCipher encryption contract).
  - Outbox table and repository.
  - Sync state machine and connectivity coordinator.
  - Reusable SyncableRepository pattern.
  - Conflict resolution domain models and UI dialogs.
  - Global offline status banner and pending count indicator.
- **Out of Scope (Deferred to Later Phases)**:
  - Specific domain tables beyond the minimum foundation (Nutrition tables deferred to Phase 6, Workout tables to Phase 7, Sleep/Vitals to Phase 5).
  - Bi-directional sync of Health Connect / Apple Health (deferred to Phase 8).
  - AI photo uploads and media syncing (deferred to Phase 10).

