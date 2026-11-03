# Roadmap: FitKarma

## Overview

FitKarma's roadmap translates the master product specification and 24-phase implementation plan (`Todo.md`) into a structured GSD execution pathway. Spanning three major release milestones—**Milestone 1: Competitive MVP (Months 1–3)**, **Milestone 2: India-First Differentiation (Months 4–6)**, and **Milestone 3: Category Leadership (Months 7–12)**—the roadmap takes FitKarma from a clean greenfield Flutter and Supabase foundation through offline-first health tracking, deep Indian nutrition intelligence, WhatsApp voice AI logging, and full DPDP Act 2023 compliance.

---

## Phases

- [x] **Phase 1: Repository Initialization & Engineering Foundation** - Flutter 3.x project setup, linting, Riverpod structure, logging, and error handling.
- [x] **Phase 2: Design System & UI Foundation** - Dark theme (`#0D0F12`), glassmorphism, spring physics, and English/Hindi localization.
- [x] **Phase 3: Backend, Authentication & User Onboarding** - Supabase schema scaffold, RLS, phone OTP + Google auth, and biometric onboarding wizard.
- [x] **Phase 4: Offline-First Data Foundation** - Drift + SQLCipher encrypted local storage, persistent mutation outbox, and sync state machine.
- [x] **Phase 5: Health Data Core** - Offline and syncable tracking for weight, measurements, sleep, water, mood, vitals, and medication.
- [x] **Phase 6: Indian Nutrition Engine** - 500+ Indian food database, household portion units, raw/cooked conversion, tadka slider, and Family Recipe Splitter.
- [x] **Phase 7: Workout & Fitness Core** - Structured exercise catalog, offline workout logger, rest timers, and volume progression tracking.
- [ ] **Phase 8: OS Health Integration** - Google Health Connect and Apple HealthKit integration with bidirectional deduplication and background sync.
- [ ] **Phase 9: Daily Intelligence Package & Health OS Brain** - Deterministic DIP orchestration engine generating contextual daily home feeds.
- [ ] **Phase 10: AI Foundation & Server-Side Gateway** - Supabase Edge Functions AI gateway with Groq multi-model routing, prompt safety, and meal analysis.
- [ ] **Phase 11: WhatsApp AI Logging** - WhatsApp webhook, Hinglish voice transcription, entity extraction, and conversational confirmation loop.
- [ ] **Phase 12: Festivals, Fasting, AQI & India-First UX** - Fasting schedule tracking, real-time AQI workout adjustments, and cultural calendar context.
- [ ] **Phase 13: Women's Health & Specialized Tracking** - Menstrual cycle tracking, symptom logging, and phase-aware lifestyle coaching with privacy vault locking.
- [ ] **Phase 14: Family Health & Caregiver Governance** - Family care dashboard, explicit consent invites, role-based sharing, and crisis alert triggers.
- [ ] **Phase 15: Monetization, Payments & Razorpay** - Razorpay checkout for UPI and cards, server-side webhook verification, and UPI AutoPay subscriptions.
- [ ] **Phase 16: Ads, Notifications & Engagement** - Free-tier privacy-conscious AdMob integration and FCM push notification pipeline.
- [ ] **Phase 17: Data Vault, Privacy & DPDP Act Compliance** - DPDP consent manager, full JSON/CSV data export, and 28-table cascading right-to-erasure.
- [ ] **Phase 18: Admin / FitKarma Hub** - Operational web dashboard for managing food catalogs, system telemetry, and user support.
- [ ] **Phase 19: External Data Sources & Collection Pipeline** - Responsible data ingestion pipelines with validation schemas and rate limiters.
- [ ] **Phase 20: Analytics, Telemetry & Product Insights** - Anonymized event tracking, privacy-preserving metrics, and Sentry crash reporting with PII scrubbing.
- [ ] **Phase 21: Testing, Verification & Hardening** - Full test pyramid coverage (unit, Drift persistence, Riverpod, Golden UI, and pgTAP RLS).
- [ ] **Phase 22: CI/CD & Release Engineering** - GitHub Actions workflow building signed Android APKs/AABs, iOS bundles, and automated quality gates.
- [ ] **Phase 23: Production Readiness & Launch Gate** - Production environment provisioning, domain configuration, and pre-launch security audits.
- [ ] **Phase 24: Post-MVP Category Leadership** - ABDM/ABHA integration, clinical metabolic pipelines, and tier-2/tier-3 localization expansions.

---

## Phase Details

### Phase 1: Repository Initialization & Engineering Foundation
**Goal**: Bootstrap a clean, production-grade Flutter 3.24+ repository with Riverpod 2.x, strict analysis rules, structured logging, centralized error taxonomy, and automated test harnesses.  
**Depends on**: Nothing (First phase)  
**Requirements**: ENG-01  
**Success Criteria**:
  1. Flutter project boots on emulator/device with zero compilation or analyzer warnings.
  2. Layered folder architecture (presentation, domain, data) is established with clear dependency boundaries.
  3. Environment configuration and secrets abstraction prevent credential leakage.
**Plans**: 3 plans

Plans:
- [x] 01-01: Repository Audit, Doc-Lint Gate & Flutter Application Bootstrap
- [x] 01-02: Security Boundaries, Folder Architecture & Riverpod Dependency Injection
- [x] 01-03: Route Navigation, Error Taxonomy, Observability & Remote Config

---

### Phase 2: Design System & UI Foundation
**Goal**: Implement the authoritative visual language: dark-mode primary (`#0D0F12`), glassmorphism tokens, spring animations, bento grid widgets, and bilingual English/Hindi localization.  
**Depends on**: Phase 1  
**Requirements**: ENG-02, ENG-03  
**Success Criteria**:
  1. Theme tokens, color palette, and typography match `Brain/ui_spec.md`.
  2. Shared UI components (cards, buttons, sliders, dialogs) render consistently in dark mode.
  3. UI seamlessly switches between English and Hindi with persisted locale preferences.
**Plans**: 3 plans

Plans:
- [x] 02-01: Design Tokens, Dark Theme & Spring Physics
- [x] 02-02: Localization (EN/HI) & Accessibility Primitives
- [x] 02-03: Shared UI Primitives & Bento Grid Components

---

### Phase 3: Backend, Authentication & User Onboarding
**Goal**: Establish the Supabase workspace, apply baseline database schemas with strict RLS policies, implement Phone OTP + Google Auth, and build the onboarding health profile setup.  
**Depends on**: Phase 2  
**Requirements**: AUTH-01, AUTH-02, AUTH-03, AUTH-04  
**Success Criteria**:
  1. Supabase schema migrations apply cleanly with 100% RLS coverage on all tables.
  2. Users can authenticate via phone number OTP and Google OAuth.
  3. Onboarding flow accurately captures baseline user metrics and persists them to the user profile.
**Plans**: 3 plans

Plans:
- [x] 03-01: Supabase Workspace, Baseline Schema & Universal RLS
- [x] 03-02: Supabase Client, Phone OTP & Google Auth Service
- [x] 03-03: User Profile Domain & Multi-Step Onboarding Wizard

---

### Phase 4: Offline-First Data Foundation
**Goal**: Build the offline resilience engine using Drift with SQLCipher encryption, a persistent mutation outbox, and a deterministic sync state machine.  
**Depends on**: Phase 3  
**Requirements**: DATA-01, DATA-02, DATA-03  
**Success Criteria**:
  1. All local SQLite database files are encrypted at rest with SQLCipher.
  2. Mutations recorded offline survive app termination and automatically flush upon reconnection.
  3. Conflict resolution tests prove zero data loss during concurrent edits.
**Plans**: 3 plans

Plans:
- [x] 04-01: Drift Local Database, Schema Foundation & Encryption Contract
- [x] 04-02: Persistent Offline Outbox Queue & Sync State Machine Coordinator
- [x] 04-03: Supabase Sync Repository Pattern, Realtime Bridge & Offline/Conflict UX

---

### Phase 5: Health Data Core
**Goal**: Implement local-first tracking and visualization for core biometric data: weight, measurements, sleep, water, mood, vitals, and medications.  
**Depends on**: Phase 4  
**Requirements**: HLTH-01, HLTH-02, HLTH-03  
**Success Criteria**:
  1. User can log any core health metric completely offline.
  2. Historical charts and trends display accurate daily, weekly, and monthly aggregations.
  3. Vitals outside healthy ranges trigger appropriate warnings without giving medical diagnoses.
**Plans**: 3 plans

Plans:
- [x] 05-01: Core Health Primitives, Weight & Body Measurements Logging
- [x] 05-02: Daily Steps, Sleep, Water & Mood Tracking
- [x] 05-03: Vitals, Medication Adherence, Habits & Unified Health Dashboard

---

### Phase 6: Indian Nutrition Engine
**Goal**: Deliver FitKarma's core nutrition moat: 500+ Indian regional food items, household measurement units (katori, glass, roti count), raw/cooked conversion, tadka slider, and Family Recipe Splitter.  
**Depends on**: Phase 4  
**Requirements**: NUTR-01, NUTR-02, NUTR-03, NUTR-04, NUTR-05, NUTR-06  
**Success Criteria**:
  1. Users can search and log Indian meals using native units like katori, spoons, and roti counts.
  2. Cooking yield multipliers accurately distinguish raw vs. cooked nutritional densities.
  3. Tadka slider adjusts estimated oil/fat content with explicit "estimate" labeling.
  4. Family Recipe Splitter correctly computes individual macro shares from batch ingredients.
**Plans**: 3 plans

Plans:
- [x] 06-01: Food Catalog, Indian Portion Units & Nutrition Domain Foundation
- [x] 06-02: Raw vs. Cooked Conversion, Cooking Yield Multipliers & Tadka Fat Slider
- [x] 06-03: Family Recipe Splitter, Meal Logging, Dynamic TDEE & Nutrition Dashboard

---

### Phase 7: Workout & Fitness Core
**Goal**: Provide an offline-first fitness logging system featuring categorized exercises, workout routines, rest intervals, and volume tracking.  
**Depends on**: Phase 4  
**Requirements**: FIT-01, FIT-02, FIT-03  
**Success Criteria**:
  1. Users can browse and filter exercise libraries by target muscle and equipment.
  2. Active workouts track sets, reps, weights, and rest periods with an audible/haptic timer.
  3. Completed workouts update weekly volume metrics and sync via outbox.
**Plans**: 3 plans

Plans:
- [x] 07-01: Exercise Library, Muscle Groups, Equipment Filtering & Seed Catalog
- [x] 07-02: Active Workout Logger, Set/Rep Tracking, Rest Timer & State Machine
- [x] 07-03: Volume Progression Analysis, Recovery Readiness & Workout Dashboard

---

### Phase 8: OS Health Integration (Health Connect & Apple Health)
**Goal**: Connect to Android Health Connect and iOS Apple Health/HealthKit for bi-directional biometric sync with deduplication and source attribution.  
**Depends on**: Phase 5  
**Requirements**: OSHL-01, OSHL-02  
**Success Criteria**:
  1. App reads steps, sleep, and heart rate from OS health stores with proper permission handling.
  2. Deduplication engine resolves collisions between manual logs and wearable telemetry.
  3. User revocation of permissions is handled gracefully without crashing or corrupting local stores.
**Plans**: 3 plans

Plans:
- [ ] 08-01: Health Integration Abstraction & Deduplication Engine
- [ ] 08-02: Android Health Connect & iOS HealthKit Adapters
- [ ] 08-03: Background Sync Manager, Battery Safeguards & Sync Settings UI

---

### Phase 9: Daily Intelligence Package & Health OS Brain
**Goal**: Build the deterministic DIP rule engine that synthesizes biometric telemetry, nutrition, and schedule into a personalized daily home feed.  
**Depends on**: Phases 5, 6, 7, 8  
**Requirements**: BRAIN-01, BRAIN-02  
**Success Criteria**:
  1. Home screen dynamically renders the Daily Intelligence Package on first launch each day.
  2. No screen attempts to show all modules simultaneously; DIP prioritizes the top 3 actionable insights.
  3. Calculations run deterministically offline with cached models.
**Plans**: TBD

---

### Phase 10: AI Foundation & Server-Side Gateway
**Goal**: Deploy a secure server-side AI proxy via Supabase Edge Functions using Groq, featuring structured JSON schemas, prompt guardrails, and food text/vision parsing.  
**Depends on**: Phase 6  
**Requirements**: AI-01, AI-02, AI-03  
**Success Criteria**:
  1. Mobile client never invokes LLM APIs directly; all requests route through Edge Functions.
  2. Freeform food descriptions parse reliably into structured food database matches with confidence scores.
  3. Photo meal analysis flags uncertain ingredients and requires user confirmation before logging.
**Plans**: TBD

---

### Phase 11: WhatsApp AI Logging
**Goal**: Implement the zero-friction conversational WhatsApp logging interface for Hinglish text and voice notes.  
**Depends on**: Phase 10  
**Requirements**: WAPP-01, WAPP-02, WAPP-03  
**Success Criteria**:
  1. Inbound WhatsApp messages verify phone number linkage to an active FitKarma account.
  2. Voice notes in Hinglish/Hindi transcribe accurately and extract meals and portions.
  3. System sends an interactive confirmation card before committing items to the user's food log.
**Plans**: TBD

---

### Phase 12: Festivals, Fasting, AQI & India-First UX
**Goal**: Integrate cultural fasting protocols, real-time air quality index (AQI) adaptations, and festival nutrition advice.  
**Depends on**: Phase 9  
**Requirements**: CULT-01, CULT-02  
**Success Criteria**:
  1. Fasting tracker supports major Indian fasts (Navratri, Ekadashi, Ramadan, etc.) with safe refeeding tips.
  2. High AQI levels trigger automatic indoor workout alternatives and respiratory precautions.
**Plans**: TBD

---

### Phase 13: Women's Health & Specialized Tracking
**Goal**: Deliver a privacy-locked cycle and symptom tracking module with cycle-aware nutrition and training suggestions.  
**Depends on**: Phase 5  
**Requirements**: WOMEN-01, WOMEN-02  
**Success Criteria**:
  1. Menstrual cycle phases (follicular, ovulatory, luteal, menstrual) calculate dynamically.
  2. Cycle data can be isolated in an encrypted vault requiring biometrics/PIN to unlock.
**Plans**: TBD

---

### Phase 14: Family Health & Caregiver Governance
**Goal**: Enable family health tracking with explicit mutual consent, role-based visibility, and elderly crisis alerts.  
**Depends on**: Phase 5  
**Requirements**: FAM-01, FAM-02  
**Success Criteria**:
  1. Family invitations require two-way cryptographic consent before any data is visible.
  2. Caregivers can view vitals and medication adherence without gaining access to private logs.
**Plans**: TBD

---

### Phase 15: Monetization, Payments & Razorpay
**Goal**: Wire Razorpay for UPI, card, and UPI AutoPay recurring subscription billing, verified strictly through server-side webhooks.  
**Depends on**: Phase 3  
**Requirements**: PAY-01, PAY-02, PAY-03  
**Success Criteria**:
  1. Razorpay checkout opens seamlessly for one-off and subscription purchases.
  2. Entitlements (Karma Pro, FitKarma Elite) activate ONLY upon validated server-side webhook receipt.
  3. UPI AutoPay recurring mandate creation and renewal cycles function properly.
**Plans**: TBD

---

### Phase 16: Ads, Notifications & Engagement
**Goal**: Integrate privacy-conscious Google AdMob for free-tier users and FCM push notifications with quiet-hour rules.  
**Depends on**: Phase 15  
**Requirements**: ENGMT-01, ENGMT-02  
**Success Criteria**:
  1. Pro and Elite users experience 100% ad-free navigation.
  2. Notifications adhere to user-configured quiet hours and delivery preferences.
**Plans**: TBD

---

### Phase 17: Data Vault, Privacy & DPDP Act Compliance
**Goal**: Implement comprehensive data sovereignty tools adhering to India's Digital Personal Data Protection (DPDP) Act 2023.  
**Depends on**: Phase 4  
**Requirements**: DPDP-01, DPDP-02  
**Success Criteria**:
  1. User can request and download a full JSON/CSV export of their entire health history.
  2. Cascading erasure triggers complete permanent deletion across all 28 database tables and local storage.
**Plans**: TBD

---

### Phase 18: Admin / FitKarma Hub
**Goal**: Build the operational companion web dashboard for catalog maintenance, recipe reviews, and user support.  
**Depends on**: Phase 3  
**Requirements**: ADMIN-01  
**Success Criteria**:
  1. Administrators can inspect, verify, and publish new food items to the global database.
  2. Role-based access ensures only authorized operators access admin functions.
**Plans**: TBD

---

### Phase 19: External Data Sources & Collection Pipeline
**Goal**: Implement verified data scrapers and ingestion scripts with strict validation against external data sets.  
**Depends on**: Phase 6  
**Requirements**: OPS-01  
**Success Criteria**:
  1. Food database ingestion pipelines normalize nutritional attributes with schema validation.
  2. Rate limiting and caching prevent upstream provider blocks.
**Plans**: TBD

---

### Phase 20: Analytics, Telemetry & Product Insights
**Goal**: Deploy privacy-preserving telemetry, app performance monitoring, and Sentry crash reporting with PII scrubbing.  
**Depends on**: Phase 1  
**Requirements**: OPS-02  
**Success Criteria**:
  1. Sentry intercepts runtime exceptions while automatically redacting names, phone numbers, and health logs.
  2. Core product metrics track user retention and feature usage without deanonymization.
**Plans**: TBD

---

### Phase 21: Testing, Verification & Hardening
**Goal**: Achieve target test coverage across unit tests, Drift persistence tests, widget tests, and pgTAP RLS suites.  
**Depends on**: Phases 1–20  
**Requirements**: OPS-03  
**Success Criteria**:
  1. 100% of critical paths (auth, offline sync, nutrition calculations, payments) have automated tests.
  2. Zero analyzer errors or warnings under `flutter analyze --fatal-infos`.
**Plans**: TBD

---

### Phase 22: CI/CD & Release Engineering
**Goal**: Set up automated GitHub Actions workflows for continuous integration, linting, testing, and release artifact generation.  
**Depends on**: Phase 21  
**Requirements**: OPS-04  
**Success Criteria**:
  1. Every pull request runs automated tests, linting, and formatting checks.
  2. Tagged releases automatically compile signed Android APKs/AABs.
**Plans**: TBD

---

### Phase 23: Production Readiness & Launch Gate
**Goal**: Conduct the final production readiness review, domain verification, and pre-launch security audits.  
**Depends on**: Phase 22  
**Requirements**: OPS-05  
**Success Criteria**:
  1. All items on `Brain/production_checklist.md` pass with documented verification evidence.
  2. Production Supabase database, Edge Functions, and secrets are hardened for public traffic.
**Plans**: TBD

---

### Phase 24: Post-MVP Category Leadership
**Goal**: Expand FitKarma with ABDM / ABHA health record integration, advanced clinical longevity markers, and deeper regional dialects.  
**Depends on**: Phase 23  
**Requirements**: Future expansions (v2)  
**Success Criteria**:
  1. ABHA M1/M2/M3 milestone milestones drafted and tested in ABDM sandbox.
  2. Advanced metabolic and biological age algorithms integrated for Elite users.
**Plans**: TBD

---

## Progress

**Execution Order:**
Phases execute in numeric order: 1 → 2 → 3 → ... → 24

| Phase | Plans Complete | Status | Completed |
|-------|----------------|--------|-----------|
| 1. Repository Initialization & Engineering Foundation | 3/3 | Complete | 2026-11-02 |
| 2. Design System & UI Foundation | 3/3 | Complete | 2026-11-02 |
| 3. Backend, Authentication & User Onboarding | 0/TBD | Not started | - |
| 4. Offline-First Data Foundation | 0/TBD | Not started | - |
| 5. Health Data Core | 0/TBD | Not started | - |
| 6. Indian Nutrition Engine | 0/TBD | Not started | - |
| 7. Workout & Fitness Core | 0/TBD | Not started | - |
| 8. OS Health Integration | 0/TBD | Not started | - |
| 9. Daily Intelligence Package & Health OS Brain | 0/TBD | Not started | - |
| 10. AI Foundation & Server-Side Gateway | 0/TBD | Not started | - |
| 11. WhatsApp AI Logging | 0/TBD | Not started | - |
| 12. Festivals, Fasting, AQI & India-First UX | 0/TBD | Not started | - |
| 13. Women's Health & Specialized Tracking | 0/TBD | Not started | - |
| 14. Family Health & Caregiver Governance | 0/TBD | Not started | - |
| 15. Monetization, Payments & Razorpay | 0/TBD | Not started | - |
| 16. Ads, Notifications & Engagement | 0/TBD | Not started | - |
| 17. Data Vault, Privacy & DPDP Act Compliance | 0/TBD | Not started | - |
| 18. Admin / FitKarma Hub | 0/TBD | Not started | - |
| 19. External Data Sources & Collection Pipeline | 0/TBD | Not started | - |
| 20. Analytics, Telemetry & Product Insights | 0/TBD | Not started | - |
| 21. Testing, Verification & Hardening | 0/TBD | Not started | - |
| 22. CI/CD & Release Engineering | 0/TBD | Not started | - |
| 23. Production Readiness & Launch Gate | 0/TBD | Not started | - |
| 24. Post-MVP Category Leadership | 0/TBD | Not started | - |

---
*Roadmap created: 2026-11-02*

