# Phase 01: Repository Initialization & Engineering Foundation - Research

**Researched:** 2026-11-02  
**Domain:** Flutter 3.24+ / Dart 3.5+ Mobile Architecture, Riverpod 2.x, Navigation, Logging & Error Taxonomy  
**Confidence:** HIGH  

<user_constraints>
## User Constraints (from CONTEXT.md)

### Locked Decisions
- **Project Baseline**: Flutter 3.24+ / Dart 3.5+ with Android and iOS targets. Package ID: `com.sulekhniwal.fitkarma`.
- **State & DI**: Riverpod 2.x (`ProviderScope`, `StateNotifierProvider` / `NotifierProvider`) with testable overrides.
- **Layer Separation**: Clean Architecture with strict dependency direction: Core/Domain at the center; Data and Presentation depend on Domain; Domain has no external dependencies.
- **Routing**: Centralized auth-aware navigation skeleton separating unauthenticated routes (onboarding, login) from authenticated routes (dashboard, health core, data vault).
- **Error Taxonomy**: Centralized error model using `FK-xxxx` codes from `Brain/error_handling.md` with display-safe sanitized messages.
- **Observability**: Structured logging with automated PII redaction and Sentry boundary without exposed secrets.
- **Remote Config**: Feature flags and pricing/tier entitlements dynamically resolved from configuration with offline cached fallbacks.
- **Secret Boundaries**: Strict zero-secret policy on client. No Supabase service-role, Razorpay, or LLM API keys in the app.

### Claude's Discretion
- Selection of specific routing library (`go_router` vs. Flutter `Navigator 2.0`).
- Exact lint configuration (`flutter_lints` with strict mode rules).
- Test harness utility patterns (`test/helpers/`).

### Deferred Ideas (OUT OF SCOPE)
- Supabase Postgres schema migrations (scheduled for Phase 3).
- Full design system tokens and glassmorphism (scheduled for Phase 2).
- Drift SQLite and SQLCipher integration (scheduled for Phase 4).
</user_constraints>

<architectural_responsibility_map>
## Architectural Responsibility Map

| Capability | Primary Tier | Secondary Tier | Rationale |
|------------|-------------|----------------|-----------|
| Project Scaffold & Toolchain | Mobile Client | Build System | Bootstraps the Flutter runtime and native Android/iOS runner targets |
| Dependency Injection | Mobile Client (Riverpod) | — | Inverts dependencies and enables mock overrides in test suites |
| Navigation & Route Guard | Mobile Client (GoRouter) | — | Controls presentation flow based on authentication state |
| Error Primitives (`FK-xxxx`) | Core Domain | Presentation/UI | Standardizes error categorization across client and server boundaries |
| PII Redaction & Log Sinks | Core Infrastructure | Sentry (Observability) | Ensures compliance with DPDP Act 2023 by scrubbing health telemetry before emission |
| Remote Config & Flag Engine | Core Infrastructure | Local Cache | Resolves features and pricing dynamically with offline resilience |
</architectural_responsibility_map>

<research_summary>
## Summary

Phase 1 establishes the engineering foundation of FitKarma upon which all subsequent 23 phases rely. Flutter 3.24+ and Dart 3.5+ provide strong sealed classes, pattern matching, and native sound null safety. Riverpod 2.x serves as the single dependency injection container and state management backbone, allowing deterministic unit testing through `ProviderContainer(overrides: [...])`.

For navigation, `go_router` is the industry standard for declarative routing in Flutter, providing deep linking, redirect guards for auth transitions, and nested navigation shells. Error handling is modeled using a sealed `Result<T, Failure>` pattern where every failure encapsulates an `FK-xxxx` code, a user-safe message, and scrubbed technical metadata.

Logging leverages a centralized logger that intercepts all console and diagnostic events, passing them through an automated DPDP PII redaction filter before emitting to debug consoles or Sentry crash monitors.

**Primary recommendation:** Establish the clean folder structure, strict `analysis_options.yaml`, and foundational Riverpod/Result/Router classes with 100% test pass rates before creating any feature code.
</research_summary>

<standard_stack>
## Standard Stack

### Core
| Library | Version | Purpose | Why Standard |
|---------|---------|---------|--------------|
| `flutter_riverpod` | `^2.5.1` | State management & dependency injection | Compile-safe, testable without BuildContext, official standard |
| `go_router` | `^14.2.0` | Declarative routing & auth redirect guards | First-party supported, deep-link ready, shell route support |
| `logger` | `^2.4.0` | Structured logging | Clean log levels with custom printer/redaction pipeline |
| `sentry_flutter` | `^8.7.0` | Crash monitoring boundary | De-facto industry standard for mobile exception tracking |
| `shared_preferences` | `^2.3.0` | Key-value store for offline flags & cache | Lightweight, cross-platform persistence for local settings |

### Dev / Tooling
| Library | Version | Purpose | When to Use |
|---------|---------|---------|-------------|
| `flutter_lints` | `^4.0.0` | Static analysis rule set | Enforcing strict code hygiene |
| `flutter_test` | SDK | Unit and widget test runner | All automated test suites |

### Alternatives Considered
| Instead of | Could Use | Tradeoff |
|------------|-----------|----------|
| `go_router` | `auto_route` | `go_router` is officially maintained by Flutter team and avoids code generation overhead for basic routes |
| `flutter_riverpod` | `bloc` | `bloc` requires significant boilerplate; Riverpod offers cleaner DI overrides and asynchronous state handling |
</standard_stack>

<architecture_patterns>
## Architecture Patterns

### Layer Dependency Direction
```text
Presentation Layer (Widgets, Pages, Controllers/Notifiers)
       ↓ (depends on)
 Domain Layer (Entities, Use Cases, Repositories Interfaces, Failures)
       ↑ (implements)
  Data Layer (Repository Impls, Local/Remote Data Sources, DTOs)
       ↓ (uses)
  Core Layer (Result Primitives, Error Taxonomy, Logger, Environment)
```

Rules:
1. Domain never imports Flutter UI (`package:flutter/material.dart`).
2. Data implements Domain repository interfaces.
3. Presentation reads Domain entities and invokes Notifiers.
4. Core contains universal utilities and types used across all layers.

### Error Taxonomy Pattern
```dart
sealed class Failure {
  final String code; // e.g., 'FK-0001'
  final String message;
  final Object? cause;
  const Failure({required this.code, required this.message, this.cause});
}

class ValidationFailure extends Failure { ... }
class AuthFailure extends Failure { ... }
class NetworkFailure extends Failure { ... }
class OfflineFailure extends Failure { ... }
class ServerFailure extends Failure { ... }
```
</architecture_patterns>

<verification_guidelines>
## Verification Guidelines

1. **Toolchain & Audit**: Verify Flutter and Dart versions; document exact tooling state.
2. **Scaffold & Build**: Verify `flutter pub get`, `flutter analyze`, and `flutter test` succeed with zero errors and zero warnings.
3. **Secret Protection**: Test that `.gitignore` ignores `.env*` files (except `.env.example`).
4. **Architecture Isolation**: Ensure mock overrides function in Riverpod `ProviderContainer` without network or platform bindings.
5. **PII Redaction**: Verify that sensitive fields (phone, email, medical tokens) are scrubbed before reaching logger sinks.
</verification_guidelines>

