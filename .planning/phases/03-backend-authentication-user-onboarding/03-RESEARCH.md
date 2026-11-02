# Phase 03: Backend, Authentication & User Onboarding - Research

**Researched:** 2026-11-02  
**Domain:** Supabase Postgres RLS, Edge Functions, Phone OTP / Google Auth, User Profile Domain & Onboarding  
**Confidence:** HIGH  

<user_constraints>
## User Constraints (from CONTEXT.md)

### Locked Decisions
- **Universal Default-Deny RLS**: Every user table must enforce Row Level Security with strict `auth.uid() = user_id` checks.
- **Cascading Delete**: Every user-owned table carries `user_id references auth.users(id) on delete cascade` for DPDP Act 2023 compliance.
- **Client Security Boundary**: Zero server secrets in Flutter client. Client uses only `SUPABASE_ANON_KEY`.
- **Authentication**: Phone number OTP as primary authentication mechanism for India, with 60-second resend throttle and timeout handling. Google OAuth as secondary.
- **Onboarding Flow**: Must capture essential biometrics (age, sex, height, weight, activity, diet), explicit DPDP consent, and optional Ayurveda/Dosha profile before reaching the main app.

### Claude's Discretion
- Organization of Supabase migration files in `supabase/migrations/`.
- Mock implementation pattern for testing Flutter Auth and Profile repositories offline.
</user_constraints>

<architectural_responsibility_map>
## Architectural Responsibility Map

| Capability | Primary Tier | Secondary Tier | Rationale |
|------------|-------------|----------------|-----------|
| Relational Schema & RLS | Supabase Postgres | — | Authoritative cloud data storage and data isolation boundary |
| Edge Function Scaffold | Supabase Edge Functions (Deno) | — | Secure server compute for webhooks, AI routing, and admin logic |
| Auth Client & Session | Mobile Client (`supabase_flutter`) | Supabase Auth API | Handles JWT storage, refresh tokens, and authentication state |
| User Profile Domain | Mobile Domain (`lib/features/profile/`) | Presentation | Validates health attributes and calculates metabolic baselines |
| Onboarding Wizard | Mobile Presentation (`lib/features/onboarding/`) | Riverpod Router | Guides new users through setup and gates entry to `/dashboard` |
</architectural_responsibility_map>

<research_summary>
## Summary

Phase 3 establishes the cloud backend infrastructure and the entry doorway for users. Using Supabase, the backend schema is structured as versioned declarative SQL migrations in `supabase/migrations/`. Every table declared in `Brain/data_model.md` (`profiles`, `food_catalog`, `recipes`, `cooking_multipliers`, `health_observations`, `food_logs`, `workouts`, `sleep_recovery_logs`, `habits`, `medications`, `family_health_relationships`, `entitlements`, `push_tokens`, `storage_assets`, `audit_deletion_operations`) has Row Level Security (RLS) enabled with explicit user policies.

The Flutter client integrates `supabase_flutter` behind a clean `AuthRepository` abstraction, isolating third-party SDK calls and enabling 100% offline unit and widget testing with mock implementations.

The onboarding wizard implements a responsive, bento-styled multi-step flow using `AppScaffold`, `BentoCard`, and `ActionButton`, verifying user inputs (height in cm, weight in kg, activity factor, and dietary preference), collecting explicit consent under India's DPDP Act 2023, and persisting the resulting profile before transitioning the user to the active health dashboard.

**Primary recommendation:** Establish the versioned SQL migration and Edge Function envelope first, implement the mockable `AuthRepository` and screens next, and build the profile domain with onboarding wizard tests.
</research_summary>

<standard_stack>
## Standard Stack

### Client
| Library | Version | Purpose | Why Standard |
|---------|---------|---------|--------------|
| `supabase_flutter` | `^2.8.0` | Supabase Auth, Storage, & Database client | Official Supabase Flutter SDK |
| `flutter_riverpod` | `^2.5.1` | Auth & Onboarding state management | Compile-safe state and dependency injection |

### Backend / Database
- **PostgreSQL 15+**: Declarative schema migrations with uuid primary keys and `timestamptz`.
- **Row Level Security (RLS)**: Enforces table tenancy at database engine level.
- **Deno / TypeScript**: Lightweight serverless Edge Functions for API envelopes.
</standard_stack>

<verification_guidelines>
## Verification Guidelines

1. **SQL Schema & RLS**: Verify that every table has `ENABLE ROW LEVEL SECURITY` and `ON DELETE CASCADE` on `user_id`.
2. **Auth Service Testing**: Verify phone OTP send, verify, retry throttle, and invalid code failure states using mock repositories.
3. **Profile Validation**: Verify that age > 0, height (50–300 cm), and weight (20–400 kg) are validated before saving.
4. **Onboarding Flow**: Verify that new users can transition from Step 1 through Step 5 (consent) to reach `/dashboard`.
5. **Static Analysis**: Verify `flutter analyze --fatal-infos` passes with 0 issues.
</verification_guidelines>

