# Phase 7 Research: Workout & Fitness Core

## 1. Technical Architecture & Formulas

### 1.1 Exercise Model & Taxonomy
- **Requirement**: FIT-01
- **Muscle Groups**:
  - Upper Body Push: `chest`, `shoulders`, `triceps`
  - Upper Body Pull: `back`, `biceps`
  - Lower Body: `quadriceps`, `hamstrings`, `calves`, `glutes`
  - Core & Stability: `coreAbs`
  - Full Body / Functional: `fullBody`
- **Equipment Types**:
  - `bodyweight`, `dumbbells`, `barbell`, `kettlebell`, `resistanceBands`, `cableMachine`, `yogaMat`, `cardioMachine`
- **Home Workout Suitability**:
  - Indian context: Many users train at home with limited space or a pair of dumbbells/resistance bands.
  - Traditional Indian exercises:
    - *Surya Namaskar* (Sun Salutation 12-step flow)
    - *Dand* (Hindu pushup: diving arched spinal pushup targeting chest, shoulders, and core)
    - *Baithak* (Hindu deep squat: rhythmic full knee flexion targeting quads and calves)

### 1.2 Workout Session State Machine
- **Lifecycle States**:
  - `idle`: No active workout
  - `active`: Live workout ongoing, timer ticking
  - `resting`: Rest timer running between sets
  - `completed`: Logged to local database and outbox queued
  - `paused`: Interrupted session (preserved in SQLite across app restarts)
- **Data Persistence**:
  - Store ongoing session in `workout_sessions_table` and `workout_sets_table` with `in_progress` status.
  - If app terminates or device reboots, resume seamlessly without lost data.

### 1.3 Volume Progression Arithmetic
- **Formula**:
  $$\text{Set Volume (kg)} = \text{Weight (kg)} \times \text{Reps}$$
  $$\text{Exercise Volume (kg)} = \sum_{\text{working sets}} \text{Set Volume}$$
  $$\text{Session Volume (kg)} = \sum \text{Exercise Volume}$$
  - Warmup sets (`isWarmup == true`) are tracked for execution but omitted from primary working volume progression.
  - Bodyweight exercises default to a standardized percentage (e.g. 65% of user body weight for pushups/pullups) or raw rep counts.

### 1.4 Recovery Readiness Index
- **Inputs**:
  - Previous night's sleep duration from Phase 5 `sleep_records` table (target: 8h / 480 min).
  - Training volume in the preceding 48 hours.
  - User subjective perceived exertion (RPE 1-10) and mood from Phase 5 `mood_logs`.
- **Readiness Classification**:
  - `High Readiness` (Green): Sleep $\ge$ 7h, low acute muscle fatigue -> "Prime for high intensity / heavy compound lifts"
  - `Moderate Readiness` (Yellow): Sleep 6-7h, moderate recent volume -> "Standard working sets; maintain steady effort"
  - `Low Readiness / Recovery Priority` (Orange): Sleep < 6h or consecutive high-volume days -> "Focus on light mobility, yoga, or deload"

---

## 2. Threat Model (ASVS L1)
- **Local Storage Encryption**: Workout logs and active session notes must reside inside SQLCipher encrypted tables.
- **Injury Prevention Guidance**: Rest timers and volume indicators must clearly state they are educational training logs, not licensed personal training or physical therapy prescriptions.
