# Phase 6 Context: Indian Nutrition Engine

## 1. Phase Metadata
- **Phase Number**: 06
- **Phase Name**: Indian Nutrition Engine
- **Milestone**: Milestone 1: Competitive MVP
- **Requirements**: NUTR-01, NUTR-02, NUTR-03, NUTR-04, NUTR-05, NUTR-06
- **Primary Brain References**:
  - `Brain/data_model.md` (§2 Entities: `food_catalog`, `recipes`, `cooking_multipliers`, `food_logs`, `portions`)
  - `Brain/trd.md` (§4 Nutrition engine: raw/cooked, multipliers, household portions, Tadka estimates)
  - `Brain/decisions.md` (ADR-005 India-first nutrition, portion estimates as estimates)
  - `Brain/master_rules.md` (Deterministic nutrition arithmetic, portion estimates explicitly labeled)
  - `Todo.md` (Tasks 033, 033A, 034, 035, 036, 037, 038, 039, 040, 041, 042, 043, 044)

---

## 2. Scope & Objectives
FitKarma's nutrition moat lies in solving the unique realities of Indian eating habits that Western calorie trackers fail to model:
1. **500+ Indian Regional Food Catalog (NUTR-01 / TASK 033 & 033A)**:
   - High-fidelity nutrition values (calories, protein, carbs, fat, fiber per 100g) covering North Indian, South Indian, East, West, Street Food, Festival Foods, Sweets, and Homemade staples.
   - Bilingual / Hinglish search (e.g. searching "chawal", "bhaat", "rice", or "paneer tikka").
   - Cached locally in encrypted Drift tables with zero network latency.

2. **Native Indian Household Portion Sizing (NUTR-02 / TASK 034)**:
   - Indians do not weigh food on a scale before eating; they measure in household units:
     - `katori` (Small ~150ml, Medium ~200ml, Large ~250ml)
     - `glass` (~250ml)
     - `spoon` / `tsp` (~5g), `tbsp` (~15g)
     - `roti` / `chapati` count (with thickness/grain variants)
     - `idli` count, `piece`, `serving`
   - Deterministic density-based conversion factors per food category.

3. **Raw vs. Cooked Conversion & Cooking Multipliers (NUTR-03 / TASK 035 & 036)**:
   - Grains and pulses absorb 2-3x water during boiling, dramatically lowering caloric density per 100g.
   - Leafy greens and proteins lose water and shrink.
   - Versioned cooking multipliers preserve historical logs even if baseline formulas are tuned.

4. **Tadka / Tempering Fat Slider (NUTR-04 / TASK 037)**:
   - Everyday sabzis and dals vary by 100-250 calories based entirely on how much oil/ghee the cook used for the "chhonk/tadka".
   - Low (1 tsp / ~5g), Medium (2 tsp / ~10g), High (1 tbsp / ~15g) oil/ghee tempering options.
   - Explicitly marked as estimates to preserve user trust and compliance.

5. **Family Recipe Splitter (NUTR-05 / TASK 038 & 041)**:
   - Homemade food in India is cooked in batch pots for entire households.
   - Users can create a recipe with total ingredients, then log a personal percentage (e.g. 25%, 33%, 50%) or katoris consumed.
   - Calculates exact fractional macros deterministically.

6. **Dynamic TDEE & Nutrition Dashboard (NUTR-06 / TASK 042, 043, 044)**:
   - Dynamic TDEE engine incorporating body metrics, 7-day weight trend from Phase 5, and caloric intake history.
   - Beautiful Bento Nutrition Dashboard displaying daily macro goals, meal slot logging (Breakfast, Lunch, Dinner, Snack), and energy balance.
   - Mounted to `/nutrition` route.

---

## 3. Scope Fences
- **In Scope**:
  - Local Drift tables for food catalog, portions, cooking multipliers, recipes, and food logs.
  - Offline food search, portion calculations, and multiplier arithmetic.
  - Riverpod state management and SyncableRepository outbox integration.
  - Complete UI for food search, manual logging, Tadka slider, Family Recipe Splitter, and Nutrition Dashboard.
- **Out of Scope (Deferred to Later Phases)**:
  - Inbound WhatsApp food logging webhook and server-side NLP transcription (deferred to Phase 12).
  - Computer vision meal scanning / photo food recognition (deferred to Phase 13).
  - Online cloud vector semantic recipe search (`TASK 039A` / pgvector, deferred to Phase 18).
