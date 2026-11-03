# Phase 10 Research: AI Foundation & Server-Side Gateway

## 1. Groq Infrastructure & Multi-Model Strategy
- **Why Server-Side Gateway**:
  - Direct client-to-LLM calls violate ADR-002, expose API secrets, make rate limiting impossible, and prevent auditing or centralized prompt caching.
  - Supabase Edge Functions provide an ultra-low latency, globally distributed TypeScript/Deno runtime.
- **Model Specialization**:
  1. `llama-3.3-70b-versatile` ($text \rightarrow JSON$):
     - Unsurpassed token speed (~250–300 tokens/sec on Groq LPU).
     - Deep contextual understanding of multilingual Indian food idioms (*"ek katori dal fry"*, *"2 butter roti"*, *"thoda sa chawal"*).
  2. `llama-3.2-11b-vision-preview` ($image \rightarrow JSON$):
     - Multimodal vision model capable of distinguishing complex multi-dish Indian platters (thalis, bowls of curry vs dal, flatbreads).
     - Provides estimated container geometry and relative portion ratios.
  3. `llama-3.1-8b-instant` ($coaching \rightarrow text$):
     - Lowest latency (< 150ms roundtrip), perfect for natural Hinglish conversational feedback.

## 2. Structured JSON Output Schema Contract
Groq supports `response_format: { type: "json_object" }`. The system prompt specifies the canonical schema:

```json
{
  "summary": "String overview of detected meal",
  "items": [
    {
      "food_name": "String (e.g. Roti / Chapati)",
      "matched_category": "grains | pulses | vegetables | dairy | meat | sweets",
      "quantity": 2.0,
      "unit": "piece | small_katori | medium_katori | large_katori | glass | gram | tablespoon",
      "cooking_state": "cooked | raw",
      "tadka_level": "none | low | medium | heavy",
      "estimated_calories": 160.0,
      "protein_g": 6.0,
      "carbs_g": 32.0,
      "fat_g": 1.0,
      "confidence": 0.95
    }
  ],
  "confidence_overall": 0.92,
  "uncertainty_reasons": ["Estimated oil used in dal tadka without visual cooking trace"],
  "hinglish_insight": "Protein accha hai, but dinner mein thoda fiber add kar sakte hain!",
  "statutory_disclaimer": "Nutritional estimate only. Not clinical or medical guidance."
}
```

## 3. Indian Food Database Normalization
- The AI Gateway produces candidate item tokens.
- The client-side `IndianFoodMatcher` queries the local `DriftFoodCatalogRepository` (Phase 6):
  1. Fuzzy match candidate name against 500+ Indian regional dishes.
  2. If verified dish is matched: use verified baseline nutritional density ($4\text{ kcal/g protein}$, $4\text{ kcal/g carbs}$, $9\text{ kcal/g fat}$) and authentic yield multipliers.
  3. If no match in catalog: fallback to model-provided macronutrient estimates with an explicit `isUnverifiedItem: true` flag and reduced confidence score.

## 4. Privacy, Ephemeral Media & DPDP Act 2023
- **Media Ephemerality**:
  - Image bytes sent to `/v1/ai/photo-analyze` are held in memory during the Groq inference call and immediately discarded.
  - Zero storage in cloud buckets or server logs.
  - Image preview on mobile client is stored in local app cache and cleaned automatically.
- **PII Scrubbing**:
  - Server-side gateway inspects user prompt text and removes Indian phone numbers (`+91`, `9xxxxxxxxx`), email addresses, and auth tokens before dispatching to external LLM endpoints.

## 5. Medical Safety Guardrails (ADR-005, TASK 063)
- The gateway and client enforce dual-layer safety:
  1. System Prompt Guardrail: Explicit negative constraints preventing disease diagnosis or Ayurvedic cure claims.
  2. Post-Inference RegEx & Keyword Guardrail: Scans generated text for prohibited assertions (e.g., *"this will cure your diabetes"*, *"stop taking your prescribed medicine"*). If detected, triggers automated sanitization and attaches standard clinical disclaimers.
