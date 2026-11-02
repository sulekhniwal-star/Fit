# Requirements: FitKarma

**Defined:** 2026-11-02  
**Core Value:** India's smartest, most private Health OS combining offline-first local storage, deep Indian cultural/nutritional realities, and zero-friction WhatsApp logging without compromising user data sovereignty.

---

## v1 Requirements (Full Vision Roadmap)

### 1. Foundation & Design System (Phases 1–2)
- [ ] **ENG-01**: Flutter 3.24+ project scaffolded with Dart 3.5+, Riverpod 2.x, strict analysis options, structured logging, and clean domain/data/presentation layers.
- [ ] **ENG-02**: Dark-mode primary design system (`#0D0F12`), glassmorphism, spring physics, and responsive bento grid layouts implemented.
- [ ] **ENG-03**: Full English (en) and Hindi (hi) localization configured with language selector and RTL/locale persistence.

### 2. Backend & Authentication (Phase 3)
- [ ] **AUTH-01**: Supabase local/declarative schema and migration scaffold initialized with universal Row Level Security (RLS) policies.
- [ ] **AUTH-02**: Supabase Auth integrated for phone number OTP authentication with retry throttle and fallback.
- [ ] **AUTH-03**: Google OAuth sign-in flow implemented and integrated with user profile bootstrapping.
- [ ] **AUTH-04**: Onboarding wizard capturing user physical biometrics, dietary habits, and baseline health goals.

### 3. Offline-First & Data Sync (Phase 4)
- [ ] **DATA-01**: Local encrypted relational store using Drift + SQLCipher initialized with schema migration tests.
- [ ] **DATA-02**: Persistent offline outbox queuing mutations with retry, backoff, and idempotent idempotency keys.
- [ ] **DATA-03**: Bi-directional sync engine resolving conflicts with timestamp-based or domain-specific policies.

### 4. Health Data Core (Phase 5)
- [ ] **HLTH-01**: Metric logging for weight, body measurements, water intake, sleep sessions, and daily mood.
- [ ] **HLTH-02**: Medication reminders and habit tracking working with offline persistence and push notifications.
- [ ] **HLTH-03**: Vitals tracking (blood pressure, blood glucose) with clinical range alerts and historical charts.

### 5. Indian Nutrition Engine (Phase 6)
- [ ] **NUTR-01**: Seeded Indian food database with 500+ regional dishes, street food, and staple recipes.
- [ ] **NUTR-02**: Native Indian household portion units (`katori`, `glass`, `spoon`, `piece`, `serving`, roti count).
- [ ] **NUTR-03**: Raw vs. cooked food conversion with configurable cooking yield multipliers.
- [ ] **NUTR-04**: Interactive Tadka / Tempering slider adjusting oil/ghee estimates (Low, Medium, High).
- [ ] **NUTR-05**: Family Recipe Splitter dividing batch cooking into proportional individual servings.
- [ ] **NUTR-06**: Dynamic TDEE calculation accounting for activity levels, metabolic history, and adaptive targets.

### 6. Workout & Fitness (Phase 7)
- [ ] **FIT-01**: Structured exercise library with muscle group targeting and equipment filtering.
- [ ] **FIT-02**: Offline workout logger for strength, cardio, yoga, and custom routines.
- [ ] **FIT-03**: Rest timer, set/rep logging, and volume progression analysis.

### 7. OS Health Integration (Phase 8)
- [ ] **OSHL-01**: Android Health Connect integration reading and writing steps, sleep, workouts, and calories with granular permission handling.
- [ ] **OSHL-02**: Apple HealthKit integration for iOS supporting bi-directional background sync and de-duplication.

### 8. Daily Intelligence Package / Brain (Phase 9)
- [ ] **BRAIN-01**: Deterministic DIP orchestration assembling a prioritized, contextual daily action feed on app boot.
- [ ] **BRAIN-02**: Adaptive recommendation engine tailoring daily advice based on recovery, nutrition, and schedule.

### 9. AI Foundation & Vision (Phase 10)
- [ ] **AI-01**: Secure server-side AI gateway deployed via Supabase Edge Functions with Groq multi-model routing.
- [ ] **AI-02**: AI meal analysis pipeline extracting foods, macronutrients, and estimated portions from natural text.
- [ ] **AI-03**: Photo meal analysis using vision models with explicit uncertainty scores and user confirmation screens.

### 10. WhatsApp Conversational Interface (Phase 11)
- [ ] **WAPP-01**: Webhook handler receiving WhatsApp incoming messages with phone number account linking.
- [ ] **WAPP-02**: Audio voice note transcription pipeline supporting Hinglish, Hindi, and regional speech.
- [ ] **WAPP-03**: Automated nutrition extraction and interactive confirmation reply via WhatsApp.

### 11. Culture, Fasting & Environment (Phase 12)
- [ ] **CULT-01**: Fasting tracking supporting cultural fasting schedules (Navratri, Ramadan, Ekadashi, Karwa Chauth, intermittent).
- [ ] **CULT-02**: Real-time AQI weather integration adjusting outdoor workout recommendations based on air quality.

### 12. Women's Health (Phase 13)
- [ ] **WOMEN-01**: Private menstrual cycle logging, symptom tracking, and phase-aware nutrition/workout guidance.
- [ ] **WOMEN-02**: Dedicated privacy toggle for cycle data with local encryption lock.

### 13. Family Health Governance (Phase 14)
- [ ] **FAM-01**: Multi-member family health dashboard with explicit mutual consent invitations.
- [ ] **FAM-02**: Role-based access control (caregiver view vs. independent member) and emergency vital alerts.

### 14. Monetization & Payments (Phase 15)
- [ ] **PAY-01**: Razorpay payment gateway integration for one-off UPI payments, cards, and net banking.
- [ ] **PAY-02**: Razorpay UPI AutoPay recurring subscription billing for Karma Pro and FitKarma Elite tiers.
- [ ] **PAY-03**: Server-side webhook verification granting entitlements and sachet access passes.

### 15. Ads, Notifications & Engagement (Phase 16)
- [ ] **ENGMT-01**: Privacy-conscious Google AdMob integration limited strictly to free-tier users.
- [ ] **ENGMT-02**: Firebase Cloud Messaging (FCM) push notifications with smart quiet hours and notification preferences.

### 16. Data Vault, Privacy & DPDP Compliance (Phase 17)
- [ ] **DPDP-01**: DPDP Act 2023 compliance dashboard providing complete data export (JSON/CSV) and consent manager.
- [ ] **DPDP-02**: Cascading right-to-erasure executing complete deletion across all 28 Supabase and Drift tables.

### 17. Admin Companion & Ops (Phase 18)
- [ ] **ADMIN-01**: FitKarma Hub admin web dashboard for food database curation, user support, and system health checks.

### 18. Pipelines, Analytics, Quality & Release (Phases 19–24)
- [ ] **OPS-01**: External data ingestion pipelines and scrapers running with rate limits and validation schemas.
- [ ] **OPS-02**: Anonymized privacy-first analytics and Sentry crash reporting with PII scrubbing.
- [ ] **OPS-03**: Comprehensive unit, widget, and integration test suite passing with zero analyzer warnings.
- [ ] **OPS-04**: Automated GitHub Actions CI/CD pipeline building signed release APKs and app bundles.
- [ ] **OPS-05**: Production launch readiness verification and security checklist execution.

---

## Out of Scope

| Feature | Reason |
|---------|--------|
| Custom Social Feed / Community Wall | Dilutes core health value; high moderation liability and low user retention |
| Real-time On-Device MediaPipe Pose Tracking | Excessive CPU/battery drain on budget mobile hardware; deferred to post-MVP |
| Proprietary Wearable Hardware | FitKarma acts as an OS atop existing wearables via Health Connect & HealthKit |
| In-House High-Budget Video Production | Capital-intensive; curated structured routines provide equal fitness utility |
| Hardcoded Subscription Pricing | Pricing must remain dynamically configurable via Supabase backend tables |

---

## Traceability

| Requirement | Phase | Status |
|-------------|-------|--------|
| ENG-01 | Phase 1: Repository Initialization & Engineering Foundation | Pending |
| ENG-02, ENG-03 | Phase 2: Design System & UI Foundation | Pending |
| AUTH-01, AUTH-02, AUTH-03, AUTH-04 | Phase 3: Backend, Authentication & User Onboarding | Pending |
| DATA-01, DATA-02, DATA-03 | Phase 4: Offline-First Data Foundation | Pending |
| HLTH-01, HLTH-02, HLTH-03 | Phase 5: Health Data Core | Pending |
| NUTR-01, NUTR-02, NUTR-03, NUTR-04, NUTR-05, NUTR-06 | Phase 6: Indian Nutrition Engine | Pending |
| FIT-01, FIT-02, FIT-03 | Phase 7: Workout & Fitness Core | Pending |
| OSHL-01, OSHL-02 | Phase 8: OS Health Integration (Health Connect & Apple Health) | Pending |
| BRAIN-01, BRAIN-02 | Phase 9: Daily Intelligence Package & Health OS Brain | Pending |
| AI-01, AI-02, AI-03 | Phase 10: AI Foundation & Server-Side Gateway | Pending |
| WAPP-01, WAPP-02, WAPP-03 | Phase 11: WhatsApp AI Logging | Pending |
| CULT-01, CULT-02 | Phase 12: Festivals, Fasting, AQI & India-First UX | Pending |
| WOMEN-01, WOMEN-02 | Phase 13: Women's Health & Specialized Tracking | Pending |
| FAM-01, FAM-02 | Phase 14: Family Health & Caregiver Governance | Pending |
| PAY-01, PAY-02, PAY-03 | Phase 15: Monetization, Payments & Razorpay | Pending |
| ENGMT-01, ENGMT-02 | Phase 16: Ads, Notifications & Engagement | Pending |
| DPDP-01, DPDP-02 | Phase 17: Data Vault, Privacy & DPDP Act Compliance | Pending |
| ADMIN-01 | Phase 18: Admin / FitKarma Hub | Pending |
| OPS-01 | Phase 19: External Data Sources & Collection Pipeline | Pending |
| OPS-02 | Phase 20: Analytics, Telemetry & Product Insights | Pending |
| OPS-03 | Phase 21: Testing, Verification & Hardening | Pending |
| OPS-04 | Phase 22: CI/CD & Release Engineering | Pending |
| OPS-05 | Phase 23: Production Readiness & Launch Gate | Pending |

**Coverage:**
- Total Requirements: 38
- Mapped to Phases: 38
- Unmapped: 0

---
*Requirements defined: 2026-11-02*
