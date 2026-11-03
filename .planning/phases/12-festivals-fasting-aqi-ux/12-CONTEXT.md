# Phase 12 Context: Festivals, Fasting, AQI & India-First UX

## Phase Objective
Deliver India-first cultural, religious, and environmental adaptations for FitKarma users:
1. **Fasting Tracker (`TASK 069`, `CULT-01`)**: Support intermittent fasting alongside major Indian cultural fasts (Navratri, Ekadashi, Karwa Chauth, Ramadan, Custom) with voluntary opt-in, zero religious inference, adaptive meal/hydration reminders, suppression of hunger guilt, and evidence-based safe refeeding guidance.
2. **AQI-Aware Fitness Adaptor (`TASK 070`, `CULT-01`)**: India CPCB (National Air Quality Index) calibrated workout recommendation engine that protects respiratory health by dynamically recommending indoor workout alternatives (HIIT, yoga, indoor cycling) during Poor/Very Poor/Severe AQI days, with privacy-preserving coarse/manual location and offline caching.
3. **Indian Festival Nutrition & Cultural Context (`TASK 071`, `CULT-02`)**: Replaceable Indian festival calendar, festive food nutrient profiling, and guilt-free dynamic calorie balance that respects cultural celebrations without inducing eating anxiety or shame.

## Boundary Conditions & Guiding Principles
- **ADR-005 & TASK 069 (Never Infer Religion)**: A user's dietary, fasting, or festival practices must NEVER be algorithmically inferred or assumed based on name, phone number, location, or language. All fasting modes and festival modules are 100% voluntary, opt-in selections.
- **Medical Boundary Guardrail (ADR-005)**: Fasting trackers must display clear clinical boundaries (fasting is not advised for pregnant/nursing mothers, type 1 diabetics, or eating disorder histories without physician guidance). Provide clear statutory disclaimers.
- **Privacy-Conscious Location (DPDP Act 2023)**: AQI lookups must never store or transmit granular GPS lat/long to third parties. Support coarse city/district level lookups or 100% manual city selection (e.g., Delhi, Mumbai, Bengaluru, Kolkata, Chennai, etc.).
- **Replaceable Calendar Source**: The festival calendar must be behind an extensible domain abstraction (`FestivalCalendarSource`) so regional calendars (e.g. Tamil, Bengali, Telugu, Hijri, Lunar Panchang) can be updated or replaced without modifying core business logic.
- **Offline Resilience**: All fasting timers, cached AQI reports, and festival food guides must function seamlessly offline with Drift local storage.

