# FitKarma

## What This Is

FitKarma is an India-first Health Operating System designed as an offline-resilient, privacy-centric health companion that works where users are — on mobile and WhatsApp. Built with Flutter 3.x, Supabase, Groq AI, and Razorpay, it delivers intelligent daily health synthesis (Daily Intelligence Package), deep Indian nutrition logging (katori, raw/cooked yields, tadka slider, family recipe splitter), WhatsApp voice/text logging in Hinglish, and full DPDP Act 2023 compliance.

## Core Value

India's smartest, most private Health OS that combines offline-first local storage, deep Indian cultural/nutritional realities, and zero-friction WhatsApp logging without compromising user data sovereignty.

## Requirements

### Validated

(None yet — ship to validate)

### Active

- [ ] **ENG-01**: Clean Flutter 3.x + Dart 3.5+ scaffold with strict linting, Riverpod 2.x, and layered architecture
- [ ] **ENG-02**: Dark-theme design system (`#0D0F12`), glassmorphism, spring physics, and bilingual EN/HI localization
- [ ] **AUTH-01**: Supabase Auth integration supporting phone OTP and Google OAuth
- [ ] **DATA-01**: Local-first encrypted database using Drift + SQLCipher with bi-directional Supabase sync outbox
- [ ] **HLTH-01**: Health data core tracking (weight, steps, sleep, mood, water, medication, habits, vitals)
- [ ] **NUTR-01**: Indian nutrition engine with 500+ regional foods, raw/cooked conversion, tadka slider, and katori/household measures
- [ ] **NUTR-02**: Family Recipe Splitter calculating individual shares from raw ingredient batch cooking
- [ ] **FIT-01**: Workout and fitness logging with offline-first tracking
- [ ] **OSHL-01**: Google Health Connect and Apple Health/HealthKit bi-directional data ingestion and deduplication
- [ ] **BRAIN-01**: Daily Intelligence Package (DIP) deterministic orchestration engine for contextual home dashboards
- [ ] **AI-01**: Server-side AI gateway via Supabase Edge Functions with Groq multi-model routing and strict safety guardrails
- [ ] **WAPP-01**: Conversational WhatsApp voice and text logging pipeline with Hinglish language understanding
- [ ] **CULT-01**: Cultural and environmental context: fasting schedules, festival adaptations, and AQI-aware health advice
- [ ] **WOMEN-01**: Women's health tracking (menstrual cycle, pregnancy, PCOS awareness) with privacy protection
- [ ] **FAM-01**: Family health governance with explicit consent, granular role-based sharing, and crisis alerts
- [ ] **PAY-01**: Razorpay integration supporting UPI, credit/debit, and UPI AutoPay subscriptions
- [ ] **DPDP-01**: Data Vault and privacy governance complying with India's DPDP Act 2023 (universal RLS, cascading right-to-erasure)
- [ ] **ADMIN-01**: FitKarma Hub admin companion platform for catalog and operational management

### Out of Scope

- **Custom Social Feed / Wall** — Defeats focus; fitness social networks suffer low retention and high moderation overhead.
- **On-Device Realtime MediaPipe Pose Estimation** — High device thermal footprint and battery drain; deferred to post-MVP.
- **Proprietary Hardware / Wearables** — FitKarma integrates with standard OS health rails (Health Connect, HealthKit) rather than custom hardware.
- **Heavy In-House Video Production** — High operational burn; focus on structured workouts and audio/text guidance.
- **Hardcoded Product Pricing** — All commercial tiers and sachet pricing must remain backend-configurable.

## Context

- Detailed architectural, product, and domain contracts reside in the `/Brain` directory (`pdr.md`, `trd.md`, `architecture.md`, `data_model.md`, `decisions.md`, `ui_spec.md`, `security.md`, `testing.md`).
- Master feature map and positioning defined in `FitKarma_Master_Documentation_v1.0.md`.
- Implementation microtask breakdown established in `Todo.md`.
- Target audience spans Tier-1 urban professionals, Tier-2/Tier-3 lower-bandwidth users, college students, and families managing household health.

## Constraints

- **Tech Stack**: Flutter 3.24+ / Dart 3.5+, Riverpod 2.x, Drift + SQLCipher, Supabase (Postgres, Auth, Storage, Edge Functions, Realtime), Groq AI, Razorpay.
- **Security & Privacy**: Complete compliance with DPDP Act 2023; all local user data encrypted at rest with SQLCipher; strict universal Supabase RLS; cascading user data erasure in 28 tables.
- **AI Architecture**: AI calls must execute server-side via Supabase Edge Functions / Groq gateway; client apps never communicate directly with LLM providers or hold provider API keys.
- **Offline First**: All user core health and meal logging must function seamlessly without active network connectivity, queuing changes in a persistent outbox.

## Key Decisions

| Decision | Rationale | Outcome |
|----------|-----------|---------|
| Drift + SQLCipher for local storage | Delivers ACID transactions, type-safety, and SQLite encryption required for sensitive health telemetry offline | — Pending |
| Server-Side Groq AI via Supabase Edge Functions | Eliminates client credential exposure, enforces prompt guardrails, and provides ultra-low latency inference | — Pending |
| Phone OTP & Google Auth via Supabase Auth | Reflects Indian consumer mobile behavior where phone OTP is the primary authentication path | — Pending |
| Razorpay UPI & UPI AutoPay | Dominant payment method in India with lowest friction and recurring subscription support | — Pending |
| Full Vision Roadmap with Fine Granularity | Directly ingests the 24-phase structure from Todo.md to preserve existing microtask alignment | — Pending |

---
*Last updated: 2026-11-02 during GSD project initialization*
