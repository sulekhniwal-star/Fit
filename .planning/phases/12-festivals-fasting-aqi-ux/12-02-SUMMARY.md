# 12-02 Plan Summary: Real-Time AQI Engine & Outdoor Workout Safety Adaptor

## Overview
Plan 12-02 implements a privacy-first, CPCB-calibrated Air Quality Index (AQI) engine and workout safety advisor (`CULT-01`, `TASK 070`). It dynamically protects respiratory health by advising against hazardous outdoor exercise during high-pollution days and automatically generates indoor alternatives (Indoor Treadmill, Bodyweight HIIT, Surya Namaskar Flow, and Restorative Yoga). Lookups adhere strictly to the DPDP Act 2023 with coarse city-level resolution or manual city selection without tracking granular GPS coordinates.

## Deliverables Created / Updated
1. **CPCB NAQI Domain Models**:
   - `lib/features/cultural/domain/aqi_models.dart`: Models for all 6 official Central Pollution Control Board (CPCB) NAQI bands: Good (0-50), Satisfactory (51-100), Moderate (101-200), Poor (201-300), Very Poor (301-400), and Severe (401-500+) with official color codes, health impacts, and outdoor exercise advisories.
   - `lib/features/cultural/domain/aqi_workout_advisory.dart`: Workout safety engine mapping hazardous outdoor activities to indoor cardio, strength, or yoga alternatives with PM2.5/PM10 respiratory health precautions.
2. **Privacy-Conscious AQI Service & Cache**:
   - `lib/features/cultural/data/aqi_service.dart`: `AqiService` with 2-hour TTL caching, offline fallback, and coarse Indian city resolution covering 15 major metropolitan and Tier-1/2 cities.
3. **State Management**:
   - `lib/features/cultural/presentation/aqi_state_notifier.dart`: `AqiStateNotifier` streaming current AQI readings, active advisories, and supporting instant manual city switching.
4. **Interactive UI Widgets**:
   - `lib/features/cultural/presentation/aqi_badge.dart`: CPCB color-coded compact and expanded badge.
   - `lib/features/cultural/presentation/aqi_context_card.dart`: Dashboard BentoCard showing city, AQI badge, and workout advice.
   - `lib/features/cultural/presentation/aqi_details_sheet.dart`: Modal bottom sheet with fine (PM2.5) and coarse (PM10) particulate breakdown, full CPCB band guide, indoor workout cards, and city selector chips.
   - `lib/features/workout/presentation/workout_dashboard_screen.dart`: Embedded `AqiContextCard` directly on the workout dashboard for pre-workout environmental safety checks.
5. **Automated Verification**:
   - `test/features/cultural/aqi_domain_test.dart` (4 tests)
   - `test/features/cultural/aqi_service_test.dart` (3 tests)
   - `test/features/cultural/aqi_widget_test.dart` (3 tests)
   - `test/features/workout/workout_dashboard_screen_test.dart` (verified end-to-end integration)

## Test Results
- **Unit & Widget Tests**: 25/25 passing across cultural and workout test suites.
- **Flutter Code Analysis**: 0 issues (`No issues found!`, ran with `--fatal-infos`).
- **Core Constraints**: Coarse city selection, zero GPS device tracking, offline-resilient cache.
