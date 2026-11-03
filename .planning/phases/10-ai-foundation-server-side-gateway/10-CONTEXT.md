# Phase 10 Context: AI Foundation & Server-Side Gateway

## Phase Purpose
Establish FitKarma's server-side AI architecture using Supabase Edge Functions and Groq multi-model routing. Provide intelligent meal text analysis, photo-based dish recognition, and natural Hinglish nutrition coaching without leaking API keys to the client, compromising user privacy, or making clinical medical claims.

## User Constraints & Core Directives
1. **Server-Side Gateway Mandatory (ADR-002, ADR-019)**:
   - The Flutter mobile client must NEVER invoke LLM provider APIs (Groq, OpenAI, etc.) directly.
   - All AI requests route through Supabase Edge Functions (`supabase/functions/ai-gateway/`) with JWT authentication and strict request/response envelopes (`request_id`, `payload`, `warnings`, `error` with `FK-xxxx` codes).
2. **Multi-Model Routing via Groq**:
   - `llama-3.3-70b-versatile`: Complex meal text decomposition, ambiguous Indian ingredient parsing, macro calculations.
   - `llama-3.2-11b-vision-preview`: Photo food logging, visual dish identification, portion volume estimation.
   - `llama-3.1-8b-instant`: Low-latency conversational coaching, Hinglish summaries, quick tips.
3. **Structured Outputs & Schema Validation (TASK 059)**:
   - Prompts must enforce strict JSON Schemas (`type: "json_object"`).
   - The gateway validates schemas, handles incomplete/malformed responses gracefully, and returns deterministic fallbacks.
4. **AI Safety & Medical Boundary Guardrails (TASK 063, ADR-005)**:
   - Prohibit diagnostic claims (e.g., claiming a food or Ayurvedic herb cures diabetes, hypertension, or cancer).
   - Prohibit unsafe dietary instructions or clinical prescription overriding.
   - Include statutory non-diagnostic disclaimers on every AI output.
5. **Human-in-the-Loop Confirmation (TASK 060, TASK 062)**:
   - Raw model outputs must never directly become canonical food log entries.
   - Display candidate dishes with explicit confidence scores (`high`, `medium`, `low`) and editable portion sliders before persisting to local Drift SQLite tables.
   - Provide an instant 1-tap manual search fallback ("Not quite right? Search manually").
6. **DPDP 2023 & Ephemeral Media Retention**:
   - Images uploaded for photo analysis must be processed ephemerally.
   - PII redactor scrubs phone numbers, emails, and tokens before sending text to LLMs.

## Architecture Boundaries
- `supabase/functions/ai-gateway/`:
  - `index.ts`: Edge Function entry point routing `/meal-analyze`, `/photo-analyze`, `/coaching`.
  - `groq_client.ts`: Groq API wrapper with model routing, retries, and timeout controls.
  - `schemas.ts`: Strict JSON schema definitions for meal analysis and vision responses.
  - `guardrails.ts`: PII sanitization and prohibited clinical claim filtering.
- `lib/features/ai/domain/`:
  - `ai_models.dart`: Domain entities (`AiMealAnalysis`, `AiCandidateFood`, `AiPortionEstimate`, `AiConfidence`, `AiHinglishCoaching`).
  - `ai_safety_guardrails.dart`: Client-side validation and prohibited word scrubbers.
  - `indian_food_matcher.dart`: Matches AI food tokens against local `DriftFoodCatalogRepository`.
- `lib/features/ai/data/`:
  - `ai_gateway_client.dart`: HTTP client interfacing with Supabase Edge Functions.
  - `mock_ai_gateway_client.dart`: Deterministic mock for unit and widget testing.
- `lib/features/ai/presentation/`:
  - `ai_meal_text_logger_sheet.dart`: Freeform natural text and Hinglish meal logging sheet.
  - `photo_food_logger_screen.dart`: Camera/gallery food recognition with image preview.
  - `ai_meal_confirmation_card.dart`: Interactive candidate card with portion adjustment and confidence badge.
