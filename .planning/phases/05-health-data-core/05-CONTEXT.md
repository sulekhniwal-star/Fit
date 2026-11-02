# Phase 5 Context: Health Data Core

## 1. Phase Metadata
- **Phase Number**: 05
- **Phase Name**: Health Data Core
- **Milestone**: Milestone 1: Competitive MVP
- **Requirements**: HLTH-01, HLTH-02, HLTH-03
- **Primary Brain References**:
  - `Brain/data_model.md` (§2 Core entities: `body_metrics`, `sleep_records`, `water_logs`)
  - `Brain/trd.md` (Health tracking, offline data lifecycle)
  - `Brain/error_handling.md` (`FK-2001` Validation, `FK-3001` Offline queued)
  - `Brain/security.md` (Sensitive medical observations and non-diagnostic boundaries)
  - `Brain/ui_spec.md` (Bento layout, metric cards, dark theme tokens)
  - `Todo.md` (Tasks 025, 026, 027, 028, 029, 030, 031, 032, 032A, 032B)

---

## 2. Scope & Objectives
FitKarma's Health Data Core provides local-first, offline-capable logging and visualization for everyday wellness metrics and biological vitals. Every record is stored locally in encrypted Drift tables, queues outbox sync mutations, and surfaces actionable trends without providing clinical medical advice.

### Core Objectives:
1. **Normalized Health Primitives (TASK 025)**:
   - Establish unified domain primitives for quantity, unit, timestamp, source attribution (`manual`, `device`, `healthConnect`, `appleHealth`), and confidence level.
2. **Weight & Body Measurements Logging (TASK 026 & 032)**:
   - Record weight (kg/lbs conversion), height, and body dimensions (waist, hip, chest, arms, thighs).
   - Compute moving averages and rate of change (7-day trend).
3. **Daily Activity, Sleep, Water & Mood (TASK 027, 028, 029, 030)**:
   - Step tracking with daily totals and goal progress.
   - Sleep tracking with overnight boundary calculations across midnight and quality scoring.
   - Water tracking with quick-add presets (+250ml katori/glass, +500ml bottle) and daily goal progress.
   - Mood tracking (1-5 mood score) with sensitive encrypted notes.
4. **Vitals, Medications & Habits (TASK 031, 032A, 032B)**:
   - Blood pressure (systolic/diastolic/pulse) and blood glucose (mg/dL fasting vs post-prandial) logging.
   - Medication reminders and adherence schedule (taken/skipped) without diagnostic recommendations.
   - Non-punitive habit check-ins and streaks.
5. **Dashboard Presentation (TASK 026-032B UI)**:
   - Unified `HealthDashboardScreen` featuring responsive Bento cards for each core metric.

---

## 3. Scope Fences
- **In Scope**:
  - Local Drift tables and repository abstractions for all core health metrics.
  - Automatic synchronization via `SyncableRepository` and `OutboxQueue`.
  - Non-diagnostic presentation with statutory wellness disclaimers.
  - Intuitive quick-add sheets and Bento visualizers.
- **Out of Scope (Deferred to Later Phases)**:
  - Native Google Health Connect and Apple HealthKit platform plugins (deferred to Phase 8).
  - Indian Nutrition database & meal logging (deferred to Phase 6).
  - Workout & exercise session logs (deferred to Phase 7).
  - Continuous Glucose Monitor (CGM) sensor streaming (deferred to Phase 24).
