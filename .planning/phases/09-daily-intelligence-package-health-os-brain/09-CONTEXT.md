# Phase 9 Context: Daily Intelligence Package (DIP) & Health OS Brain

## Phase Purpose
Establish FitKarma's central intelligence layer: the Daily Intelligence Package (DIP). Synthesize multi-domain health telemetry (sleep, vitals, steps from Phases 5 & 8), nutrition intake and hydration (Phase 6), and workout fatigue/volume (Phase 7) into a deterministic, offline-first contextual feed that powers the home screen without overwhelming the user.

## User Constraints & Core Directives
1. **Deterministic & Offline-First (ADR-001, ADR-002)**:
   - The DIP engine must execute 100% locally on the device using pure Dart rules and cached SQLite/Drift states.
   - Zero dependency on external AI/LLMs in this phase (server-side LLM gateway is introduced in Phase 10).
2. **Cognitive Load & Focus Fence (Master Rule)**:
   - No screen should ever dump every module simultaneously.
   - The home dashboard must prioritize the top 1 primary readiness/focus signal and at most the top 3 contextual micro-actions.
3. **Graceful Degradation on Incomplete Data**:
   - The engine must compute reasonable, non-crashing baselines when some metrics (e.g. sleep or wearable data) are missing, clearly explaining what contributed to the score and which metrics were missing.
4. **Non-Medical Statutory Disclaimers (ADR-005)**:
   - All readiness scores and suggested micro-actions are wellness metrics, never medical or diagnostic conclusions.
   - Every surface displaying DIP readiness or insights must carry explicit statutory wellness wording.
5. **India-First Contextual Nuance**:
   - Incorporate culturally familiar wellness micro-actions (e.g. *Shatapawali* — post-meal 100-step stroll; hydration reminders calibrated for warm climate; gentle digestive timing).

## Architecture Boundaries
- `lib/features/brain/domain/`:
  - `dip_models.dart`: Structured inputs (`DipContextInput`) and outputs (`DailyIntelligencePackage`, `DailyReadinessScore`, `DipMicroAction`, `DipFocusSignal`, `ReadinessFactor`).
  - `daily_readiness_calculator.dart`: Mathematical model for the daily readiness score combining sleep duration/quality, resting heart rate, workout strain/ACWR, and hydration status.
  - `dip_rule_engine.dart`: Deterministic rules evaluating user telemetry and emitting prioritized micro-actions with confidence weights.
- `lib/features/brain/data/`:
  - `dip_repository.dart`: Gathers telemetry across Drift databases (`StepRepository`, `SleepRepository`, `VitalsRepository`, `NutritionRepository`, `WorkoutRepository`) and executes DIP assembly.
- `lib/features/brain/presentation/`:
  - `home_dashboard_screen.dart`: The unified home surface replacing the initial static health dashboard.
  - `daily_readiness_card.dart`: Interactive Bento card displaying readiness score, tier, and contributing factors breakdown.
  - `dip_action_feed.dart`: Prioritized carousel/list of top actionable micro-actions with deep-linking to logs or timers.
  - `quick_log_action_bar.dart`: Quick-action launcher for fast 1-tap logging (water, meal, workout, weight).
