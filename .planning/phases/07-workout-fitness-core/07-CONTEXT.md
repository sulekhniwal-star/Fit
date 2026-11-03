# Phase 7 Context: Workout & Fitness Core

## 1. Phase Metadata
- **Phase Number**: 07
- **Phase Name**: Workout & Fitness Core
- **Milestone**: Milestone 1: Competitive MVP
- **Requirements**: FIT-01, FIT-02, FIT-03
- **Primary Brain References**:
  - `Brain/data_model.md` (§2 Entity: `public.workouts`, `sleep_recovery_logs`)
  - `Brain/trd.md` (§6 Health & Fitness logging, offline resilience)
  - `Brain/master_rules.md` (Deterministic arithmetic, offline-first execution)
  - `Todo.md` (Tasks 045, 046, 047, 048, 049)

---

## 2. Scope & Objectives
FitKarma's Workout & Fitness Core delivers an offline-first fitness logging system engineered for real workout conditions where gym basement connectivity is poor:
1. **Structured Exercise Library (FIT-01 / TASK 045, 046)**:
   - Categorized by muscle groups (Chest, Back, Shoulders, Legs, Core, etc.) and equipment (Bodyweight, Dumbbells, Barbell, Resistance Bands, Yoga Mat).
   - Culturally resonant Indian fitness staples included: Surya Namaskar, traditional Indian Akhada calisthenics (Dand & Baithak), and Pranayama breathwork alongside modern resistance training.
   - Cached locally in encrypted Drift tables with instant multi-facet filtering.

2. **Offline Workout Logger (FIT-02 / TASK 047, 048)**:
   - Live session tracking supporting strength, cardio, yoga, and HIIT routines.
   - Robust state machine handling app interruption, backgrounding, and offline persistence.
   - Auto-save to Drift SQLite and outbox mutation dispatch upon completion.

3. **Rest Timer, Sets/Reps & Volume Progression (FIT-03 / TASK 048, 049)**:
   - Configurable rest intervals (30s, 60s, 90s, 120s) with live countdown and haptic-ready states.
   - Per-set weight (kg) and rep tracking with warmup set flags.
   - Weekly volume calculation ($\sum \text{Sets} \times \text{Reps} \times \text{Weight}$) and recovery readiness indicators linking to Phase 5 sleep duration.
   - Production `WorkoutDashboardScreen` mounted under `/workouts`.

---

## 3. Scope Fences
- **In Scope**:
  - Local Drift tables for exercises, workout sessions, and sets.
  - Exercise library seed with 50+ curated movements across strength, yoga, and home calisthenics.
  - Active workout session state management with live rest timer.
  - Volume progression calculations and recovery readiness scoring.
  - UI for library search, active workout tracking, and workout dashboard.
- **Out of Scope (Deferred to Later Phases)**:
  - On-device MediaPipe computer vision pose estimation (deferred to Post-MVP / Phase 24).
  - Heavy streaming video library (app relies on lightweight diagrammatic/text cues).
  - Automated smartwatch workout detection (handled via Health Connect/Apple Health in Phase 8).
