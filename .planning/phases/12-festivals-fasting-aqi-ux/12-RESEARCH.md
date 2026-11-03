# Phase 12 Research: Cultural Fasting Protocols, CPCB NAQI Standards & Festive Nutrition

## 1. Indian Fasting Protocols & Metabolic Stages

### Traditional & Intermittent Fasting Taxonomy
1. **Intermittent Fasting (Time-Restricted Eating)**:
   - **16:8 (Leangains)**: 16 hours fasting, 8 hours eating window.
   - **14:10 (Gentle)**: Ideal for beginners and women; balances circadian rhythm with hormonal stability.
   - **Circadian 12:12**: Sun-up to sun-down natural metabolic rhythm.
   - **18:6 & 20:4 (Warrior)**: Advanced fasting windows.
2. **Indian Spiritual & Cultural Fasts**:
   - **Navratri (Vrat)**: 9 consecutive days with time-restricted eating and sattvic / phalahar foods (kuttu/singhara atta, sabudana, makhana, dairy, fruits; zero grains, onions, or garlic).
   - **Ekadashi**: 11th lunar day of Shukla/Krishna Paksha (twice a month); traditional avoidance of all grains and pulses (phalahar or jalahar).
   - **Karwa Chauth**: Strict sunrise-to-moonrise Nirjala (waterless) fast observed primarily by women. Extreme care required for hydration post-moonrise.
   - **Ramadan (Roza)**: Dawn-to-dusk dry fast (Suhoor before Fajr, Iftar at Maghrib). Requires tailored hydration strategy between Iftar and Suhoor and adjusted workout timing (late evening post-Iftar).
   - **Maha Shivratri**: Full day fast with fruit, milk, and water options.
   - **Custom Fast**: User defines start time, planned duration (e.g. 12 to 36 hours), and water/dry preference.

### Metabolic Stages of Fasting
- **0–4 Hours (Anabolic / Fed Stage)**: Insulin is elevated, glucose from last meal is actively absorbed and utilized.
- **4–8 Hours (Post-Absorptive / Digestion)**: Blood glucose stabilizes; glycogen breakdown begins in liver.
- **8–12 Hours (Early Fasting / Gluconeogenesis)**: Glycogen stores deplete; liver starts converting amino acids and glycerol into glucose.
- **12–16 Hours (Ketosis Transition / Fat Mobilization)**: Insulin falls to baseline; fatty acids release from adipose tissue; mild ketone production initiates.
- **16+ Hours (Deep Ketosis & Cellular Autophagy)**: Elevated ketone bodies; cellular repair mechanisms and mitochondrial cleanup activate.

### Safe Refeeding & Breaking the Fast
Breaking a fast improperly (e.g., immediate heavy oily carbs or spicy tadka) causes gastric distress and rapid glycemic spikes. FitKarma's safe refeeding advice recommends:
- Warm water with lemon or tender coconut water for electrolyte replenishment.
- Soaked almonds/walnuts and fresh low-glycemic fruits (papaya, apple).
- Gentle easily digestible carbs & protein: moong dal khichdi, curd with roasted cumin, or clear vegetable soup.

---

## 2. Central Pollution Control Board (CPCB) National Air Quality Index (NAQI)

India's Ministry of Environment, Forest and Climate Change utilizes CPCB NAQI based on 8 key pollutants (PM2.5, PM10, NO2, SO2, CO, O3, NH3, and Pb). The prominent sub-index drivers for cardio respiratory strain are PM2.5 and PM10:

| AQI Band | Category | Color Code | Hex Code | Outdoor Health & Workout Advisory |
|---|---|---|---|---|
| 0 – 50 | **Good** | Green | `#4CAF50` | Minimal impact. Ideal for outdoor running, cycling, and sports. |
| 51 – 100 | **Satisfactory** | Light Green | `#8BC34A` | Minor breathing discomfort to sensitive people. Generally safe for all outdoor activities. |
| 101 – 200 | **Moderate** | Yellow | `#FFEB3B` | Breathing discomfort to people with asthma and heart disease. Sensitive users should reduce prolonged intense outdoor cardio. |
| 201 – 300 | **Poor** | Orange | `#FF9800` | Breathing discomfort to most people on prolonged exposure. **Switch outdoor cardio to indoor workout** (treadmill, strength, yoga). |
| 301 – 400 | **Very Poor** | Red | `#F44336` | Respiratory illness on prolonged exposure. **Avoid all outdoor exercise.** High-filtration indoor training only. |
| 401 – 500+ | **Severe** | Maroon | `#9C27B0` | Affects healthy people; serious impacts on vulnerable. **Strictly indoor gentle mobility, rest, or pranayama.** |

### Privacy & Data Abstraction
- The AQI engine must use an abstraction `AqiProvider` (supporting mock, CPCB open data, or Open-Meteo Air Quality).
- In accordance with DPDP Act 2023, coarse city selection (e.g. 50+ major Indian Tier 1/2 cities) or optional cached city-level coordinates must be used without persistent fine GPS tracking.
- Cache TTL: 2 to 4 hours to avoid redundant network queries and battery drain.

---

## 3. Indian Festival Context & Cultural Nutrition

### Major Pan-Indian & Regional Festivals
- **Diwali**: Sweets (Kaju Katli, Laddoo), snacks (Chivda, Mathri), social family dinners.
- **Holi**: Gujiya, Thandai, Malpua, Dahi Vada.
- **Eid ul-Fitr & Eid al-Adha**: Sheer Khurma, Biryani, Haleem, Seviyan.
- **Navratri & Dussehra**: Sattvic feasts, Kuttu poori, Sabudana vada, Halwa, Chana.
- **Makar Sankranti / Pongal / Lohri**: Til laddoo, Pongal (ven and sakkarai), Revdi, Sarson ka Saag with Makki Roti.
- **Ganesh Chaturthi**: Modak (ukadiche and fried), Puran Poli.
- **Onam**: Traditional Onam Sadhya (26+ dishes served on banana leaf).
- **Christmas**: Plum cake, fruit puddings, festive roast.

### Guilt-Free Nutritional Guidance
- FitKarma follows non-judgmental, shame-free nutritional framing. Festivals are celebrations of culture and family.
- Strategies:
  1. **Weekly Calorie Redistribution**: Shifting 150-200 kcal from weekdays to provide headroom for festive dinners.
  2. **Hydration & Fiber Pre-Loading**: Encouraging 2 glasses of water and raw salad/sprouts before family feasts to regulate satiety.
  3. **Tadka & Portion Awareness**: Providing accurate portion values for festive sweets without red "forbidden" warnings.
