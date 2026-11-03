# Phase 11 Context: WhatsApp AI Logging

## Phase Purpose
Establish FitKarma's zero-friction conversational WhatsApp logging interface. Enable Indian users to log meals effortlessly by sending natural language text (English, Hindi, Hinglish) or voice notes to the FitKarma WhatsApp Business Number. The server validates Meta webhooks, transcribes audio ephemerally using Groq Whisper, parses dishes through the AI Gateway, presents an interactive confirmation message, and commits confirmed meals directly to Supabase Postgres `food_logs` with instant sync reflection in the mobile app.

## User Constraints & Core Directives

1. **ADR-006: WhatsApp as Major Low-Friction Interface**:
   - WhatsApp text and voice logging is a core P0/P1 India-first moat.
   - Users should be able to log meals in under 5 seconds without opening the mobile app.

2. **Secure Webhook & Account Linkage**:
   - Meta WhatsApp Business Cloud API sends webhooks to `/whatsapp-webhook`.
   - Webhook must support `GET` verification handshake (`hub.mode`, `hub.verify_token`, `hub.challenge`).
   - `POST` requests must verify `X-Hub-Signature-256` HMAC-SHA256 signature against `WHATSAPP_APP_SECRET`.
   - Inbound WhatsApp sender phone numbers (`from`) are normalized to standard E.164 format and matched against `public.profiles.phone_number`.
   - If phone is not linked to an active account, send a polite onboarding invitation template with app download link.

3. **Ephemeral Audio & DPDP Act 2023 Compliance**:
   - WhatsApp voice notes (OGG Opus) are downloaded server-side in-memory via Meta Graph API.
   - Transcribed via Groq Whisper (`whisper-large-v3`) with Hindi/Hinglish language priming.
   - **Zero permanent audio retention**: audio buffers must be immediately purged from memory after transcription; audio is never persisted to disk or cloud object storage.

4. **Human-in-the-Loop Confirmation on WhatsApp (TASK 060, ADR-005)**:
   - Raw AI extractions are never committed automatically.
   - The bot replies with an interactive WhatsApp message detailing detected dishes, portions, estimated calories, and macros.
   - Quick Reply interactive buttons:
     - `Confirm & Log` (`confirm_meal_{interaction_id}`)
     - `Edit in App` (`edit_meal_{interaction_id}`)
     - `Cancel` (`cancel_meal_{interaction_id}`)
   - Only when the user taps `Confirm & Log` are items committed to `public.food_logs`.

5. **Medical Boundary & Statutory Disclaimers (TASK 063)**:
   - Every WhatsApp estimation message must contain the non-diagnostic statutory disclaimer:
     *"FitKarma nutritional estimate only. Not medical advice or clinical prescription."*
   - Rejects clinical queries or claims (e.g., cures for diabetes or hypertension).

6. **State & Synchronization**:
   - `whatsapp_interactions` table tracks incoming messages, transcriptions, candidate predictions, and confirmation status (`pending`, `confirmed`, `cancelled`, `expired`).
   - Confirmed meals written to `public.food_logs` trigger Postgres CDC / Realtime, automatically syncing to the Flutter app's local encrypted Drift database.

## Architecture Boundaries
- `supabase/functions/whatsapp-webhook/`:
  - `index.ts`: Edge Function entry point for Meta GET verification and POST event handling.
  - `signature.ts`: Meta HMAC-SHA256 signature verification.
  - `phone_matcher.ts`: Phone number normalization and profile resolution in Postgres.
  - `meta_client.ts`: Meta Graph API client for fetching media and sending interactive messages.
  - `audio_transcriber.ts`: Groq Whisper (`whisper-large-v3`) client with ephemeral memory streaming.
  - `schemas.ts`: Webhook payload types and interactive button structures.
- `supabase/migrations/`:
  - `20261103000001_whatsapp_interactions.sql`: Postgres table for correlation, idempotency, and audit logging.
- `lib/features/nutrition/`:
  - Outbox sync & realtime sync listener updates to reflect WhatsApp-logged meals in the mobile dashboard.

