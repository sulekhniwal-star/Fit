# Phase 03: Backend, Authentication & User Onboarding - Context

**Gathered:** 2026-11-02  
**Status:** Ready for planning  
**Source:** Ingested from `Todo.md` (Tasks 012A–019), `Brain/data_model.md`, `Brain/api_contract.md`, and `Brain/security.md`

<domain>
## Phase Boundary

Phase 3 establishes the cloud backend foundation, user authentication, and profile onboarding:
1. **Supabase Backend Workspace & Schema**: Versioned declarative migrations, universal default-deny Row Level Security (RLS) across all confirmed tables, and initial Edge Function envelope helpers.
2. **Client-Side Auth Foundation**: `supabase_flutter` integration boundary, phone OTP authentication flow with throttle/timeout handling, Google OAuth sign-in, and session persistence.
3. **User Profile & Account Lifecycle**: Typed `UserProfile` entity with biometric attributes (age, sex, height, weight, activity, diet, goals), local-first repository boundary, and session transitions (logout, local wipe).
4. **Onboarding Flow**: Multi-step wizard capturing language preference, physical metrics, dietary identity, DPDP consent, and optional Ayurveda/Dosha wellness profiling.

Phase Gate: Backend stack is established with declarative migrations and RLS; phone OTP and Google sign-in, profile, and onboarding work end-to-end.
</domain>

<decisions>
## Implementation Decisions

### Supabase Architecture (Brain/data_model.md & Brain/security.md)
- **Universal Default-Deny RLS**: Every table must have RLS enabled with explicit `auth.uid() = user_id` policies for select, insert, update, and delete.
- **Cascading Deletion**: Every user-owned table carries `user_id uuid references auth.users(id) on delete cascade` to support DPDP Act 2023 erasure.
- **Client Security Boundary**: Flutter client utilizes ONLY `SUPABASE_ANON_KEY`; `service_role` keys are strictly restricted to Edge Functions and migrations.

### Authentication Flow (Todo.md Tasks 014 & 015)
- **Phone OTP Primary**: Phone number (+91) OTP authentication with a 60-second cooldown timer, resend throttle, and timeout error states.
- **Google OAuth Secondary**: Google sign-in with seamless session linking and deduplication.
- **Mockability**: `AuthRepository` interface must be mockable in Flutter test suites without requiring live network access or real SMS gateways.

### Profile & Onboarding Domain (Todo.md Tasks 016, 017, 018)
- **Biometric Attributes**: Height (cm), weight (kg), age, biological sex (required for Mifflin-St Jeor / Harris-Benedict BMR formulas), activity level (sedentary, light, moderate, very active), and dietary identity (Vegetarian, Eggetarian, Non-Veg, Vegan, Jain).
- **DPDP Consent**: Explicit consent checkbox acknowledging privacy terms and data storage before reaching main app.
- **Ayurveda / Dosha**: Purely lifestyle/wellness classification; non-medical; completely skippable and revisitable.

### Claude's Discretion
- Concrete step sequence and page transition controllers in `OnboardingWizardScreen`.
- In-memory mock implementations for automated tests.
</decisions>

<canonical_refs>
## Canonical References

- `Brain/data_model.md` — Physical baseline schema and confirmed entities.
- `Brain/security.md` — RLS invariants, key boundaries, and DPDP cascading deletion.
- `Brain/api_contract.md` — Request/response envelope (`request_id`, `idempotency_key`, `FK-xxxx`).
- `Todo.md` — Tasks 012A, 012B, 012C, 013, 014, 015, 016, 017, 018, 019 prompts and acceptance criteria.
</canonical_refs>

<specifics>
## Specific Tasks Mapped from Todo.md

- **TASK 012A**: Supabase Project, Local Stack and Versioned Migrations.
- **TASK 012B**: Baseline Relational Schema and Universal RLS (15 confirmed tables).
- **TASK 012C**: Edge Function Scaffold and API Contract Baseline.
- **TASK 013**: Supabase Client Foundation & mockable boundary.
- **TASK 014**: Phone OTP Authentication (phone entry, OTP verification, resend throttle).
- **TASK 015**: Google Sign-In flow with session persistence.
- **TASK 016**: User Profile Domain Model and Repository.
- **TASK 017**: Onboarding Flow (multi-step wizard with DPDP consent).
- **TASK 018**: Dosha/Wellness Profile Foundation (deterministic scoring).
- **TASK 019**: Account Lifecycle (logout, session restoration, local cleanup).
</specifics>

<deferred>
## Deferred Ideas

- Drift SQLite encrypted local database & sync outbox (scheduled for Phase 4).
- WhatsApp webhook endpoint handler (scheduled for Phase 11).
</deferred>

---
*Phase: 03-backend-authentication-user-onboarding*
*Context gathered: 2026-11-02 from Todo.md & Brain documentation*
