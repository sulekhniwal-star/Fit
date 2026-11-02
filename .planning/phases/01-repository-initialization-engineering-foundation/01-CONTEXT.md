# Phase 01: Repository Initialization & Engineering Foundation - Context

**Gathered:** 2026-11-02  
**Status:** Ready for planning  
**Source:** Ingested from `Todo.md` (Tasks 001–008A) & `Brain/` Architectural Specifications  

<domain>
## Phase Boundary

Phase 1 establishes the engineering substrate and foundational architecture of FitKarma:
1. Complete greenfield environment audit (Flutter/Dart toolchain, platform capabilities, documentation integrity).
2. Clean Flutter 3.24+ / Dart 3.5+ project scaffold with Android/iOS targets and smoke tests passing.
3. Secret boundaries and environment isolation (`.gitignore`, `.env.example`, client-vs-server secret separation).
4. Layered folder architecture (presentation, domain, data, core) enforcing strict dependency directions.
5. Riverpod 2.x dependency injection foundation with testable overrides.
6. Centralized auth-aware navigation and routing skeleton (`GoRouter` or declarative navigator).
7. Unified error taxonomy and Result types (`FK-xxxx` codes) with user-safe messaging.
8. Observability and logging foundation with PII redaction and Sentry boundary.
9. Backend-configurable remote config & feature flags with cached offline fallbacks.

Phase Gate: Repository audited, Flutter app boots, secrets boundary + folder/Riverpod/routing/error/logging foundations tested, doc wiring verified.
</domain>

<decisions>
## Implementation Decisions

### Toolchain & Project Identity
- **Package ID**: `com.sulekhniwal.fitkarma`
- **Flutter / Dart Baseline**: Flutter 3.24+ / Dart 3.5+ with strict `analysis_options.yaml` (zero warnings under `flutter analyze --fatal-infos`).
- **Target Platforms**: Android and iOS first.

### Security & Secret Boundaries
- **Client Credential Isolation**: No Supabase `service_role` keys, Razorpay secret keys, webhook secrets, AI provider API keys, or WhatsApp credentials may ever reside in the client application or its repository commits.
- **Environment Handling**: `.env.example` provides public development defaults; all local configuration files containing secrets must be explicitly `.gitignore`d.

### Architecture & State Management
- **State Framework**: Riverpod 2.x (`ProviderScope`, `StateNotifierProvider` / `NotifierProvider`) managing application state and service locator dependency injection.
- **Layer Separation**: Strict separation between Presentation (widgets/controllers), Domain (entities/use-cases/interfaces), Data (repositories/data sources), and Core (utilities/primitives). Data/presentation depends on domain; domain depends on nothing.

### Routing & Navigation
- **Navigation Engine**: Declarative, auth-aware router maintaining distinct routes for unauthenticated (welcome, OTP login, onboarding) vs. authenticated states (dashboard, nutrition, workouts, profile, data vault).

### Error Handling & Observability
- **Error Codes**: All errors map to standard `FK-xxxx` codes as specified in `Brain/error_handling.md`.
- **User-Facing Safety**: Internal stack traces and sensitive error details are scrubbed before reaching UI widgets.
- **PII Redaction**: Logging primitives must scrub names, phone numbers, email addresses, and medical/health telemetry from standard log sinks.

### Remote Config & Feature Flags
- **Backend Configuration**: Commercial tier names, pricing, and feature entitlements are dynamically resolved from configuration, never hardcoded constants.
- **Offline Caching**: App must retain last-known configuration to function offline with safe fallback defaults.

### Claude's Discretion
- Selection of specific lint rules adhering to `flutter_lints` / strict analysis options.
- Concrete test harness structure in `test/helpers/`.
</decisions>

<canonical_refs>
## Canonical References

**Downstream agents MUST read these before planning or implementing:**

### Architecture & Rules
- `Brain/master_rules.md` — Core invariants, coding standards, and forbidden patterns.
- `Brain/architecture.md` — Layered architecture, folder hierarchy, and dependency directions.
- `Brain/trd.md` — Technical requirements and package selections.

### Security & Error Handling
- `Brain/security.md` — Secret boundaries, encryption requirements, and DPDP rules.
- `Brain/error_handling.md` — Error code taxonomy (`FK-xxxx`) and recovery policies.

### Tasks & Verification
- `Todo.md` — Tasks 001 through 008A exact prompts and done-when criteria.
- `Brain/changelog.md` — Audit and decision log history.
</canonical_refs>

<specifics>
## Specific Tasks Mapped from Todo.md

- **TASK 001**: Repository and Environment Audit (DOC-001, DOC-002).
- **TASK 001A**: Documentation Wiring and Doc-Lint Gate.
- **TASK 002**: Bootstrap Flutter Application (smoke test, analyzer, tests passing).
- **TASK 003**: Establish Git Ignore, Environment, and Secret Boundaries.
- **TASK 004**: Establish Project Folder Architecture.
- **TASK 005**: Riverpod Application Architecture and DI overrides.
- **TASK 006**: Navigation and Route Architecture.
- **TASK 007**: Error and Result Primitives (`FK-xxxx`).
- **TASK 008**: Logging and Observability Foundation (PII redaction).
- **TASK 008A**: Feature Flags and Backend-Configurable Remote Config.
</specifics>

<deferred>
## Deferred Ideas

- Backend database migrations and Supabase tables (scheduled for Phase 3).
- UI design system tokens, themes, and glassmorphism (scheduled for Phase 2).
- Drift SQLite and SQLCipher integration (scheduled for Phase 4).
</deferred>

---
*Phase: 01-repository-initialization-engineering-foundation*
*Context gathered: 2026-11-02 from Todo.md & Brain documentation*
