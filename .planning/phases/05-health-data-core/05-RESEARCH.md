# Phase 5 Research: Health Data Core

## 1. Domain Architecture & Entities

### Normalized Primitives (TASK 025)
- **`HealthUnit`**: Comprehensive enum with standard SI/Imperial representations:
  - Weight: `kilograms (kg)`, `pounds (lbs)`.
  - Length/Circumference: `centimeters (cm)`, `inches (in)`.
  - Volume: `milliliters (ml)`, `liters (l)`.
  - Pressure: `mmHg`.
  - Concentration: `mg/dL`.
  - Heart: `bpm`.
  - Count: `steps`, `rating (1-5)`.
- **`HealthSource`**: Tracks origin of telemetry:
  - `manual`: Direct user entry.
  - `device`: Bluetooth peripheral or wearable.
  - `healthConnect`: Android Health Connect sync.
  - `appleHealth`: iOS HealthKit sync.
  - `calculated`: Derived metric (e.g., 7-day weight trend, BMI).

### Trend Computation & Calculations
- **Weight Moving Average**:
  $$\text{WMA}_t = \frac{\sum_{i=0}^{N-1} w_{t-i}}{N}$$
  Used to smooth out daily water weight swings and provide accurate metabolic progression feedback.
- **Sleep Boundary Handling**:
  Overnight sleep often begins on date $D$ (e.g., 23:15) and ends on date $D+1$ (e.g., 07:00). Sleep records are indexed by their awakening date for daily dashboard attribution while preserving exact start/end UTC timestamps.
- **Water Consumption Tracking**:
  Standardized quick-add options tailored to Indian household habits:
  - Small Katori / Tea Cup: 150 ml
  - Standard Steel Glass: 250 ml
  - Copper / Steel Water Bottle: 750 ml
  - Large Bottle: 1000 ml

### Medical Safety & Statutory Disclaimers
Under ASVS L1 and digital health privacy regulations:
- Any vital sign outside normal physiological ranges (e.g. systolic BP > 140 or glucose > 200 mg/dL) must display an informative notice directing the user to consult their licensed medical practitioner.
- All vital signs and medication screens must display:
  *"FitKarma observations are personal wellness tracking logs and do not constitute medical advice or clinical diagnosis."*

---

## 2. Plan Breakdown Strategy
1. **05-01-PLAN.md (Wave 1)**: Core Health Primitives, Weight & Body Measurements Logging (TASK 025, 026, 032).
2. **05-02-PLAN.md (Wave 2)**: Steps, Sleep, Water & Mood Tracking (TASK 027, 028, 029, 030).
3. **05-03-PLAN.md (Wave 3)**: Vitals (BP & Glucose), Medication Schedule, Habits & Health Dashboard (TASK 031, 032A, 032B).
