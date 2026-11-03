# Phase 11 Research: WhatsApp AI Logging

## 1. Meta WhatsApp Cloud API Architecture & Security

### Webhook Verification Handshake (GET)
Meta verifies webhook endpoints before activating event delivery:
- `hub.mode`: `'subscribe'`
- `hub.verify_token`: Shared secret string set in Meta App Dashboard and configured in Supabase Edge Functions as `WHATSAPP_WEBHOOK_VERIFY_TOKEN`.
- `hub.challenge`: Cryptographic integer/string challenge sent by Meta; endpoint must respond with HTTP 200 and return `hub.challenge` as plain text.

### Cryptographic Signature Verification (POST)
To prevent webhook spoofing, Meta signs the raw request payload using HMAC-SHA256:
- Header: `X-Hub-Signature-256: sha256=<hex_digest>`
- Algorithm: Compute HMAC-SHA256 over raw request byte stream using `WHATSAPP_APP_SECRET`.
- Constant-time comparison prevents timing attacks.
- Invalid signatures must be rejected immediately with HTTP 401.

### Webhook Event Envelope
Incoming events contain:
```json
{
  "object": "whatsapp_business_account",
  "entry": [
    {
      "id": "WABA_ID",
      "changes": [
        {
          "value": {
            "messaging_product": "whatsapp",
            "metadata": {
              "display_phone_number": "...",
              "phone_number_id": "PHONE_NUMBER_ID"
            },
            "contacts": [{ "wa_id": "919876543210", "profile": { "name": "User" } }],
            "messages": [
              {
                "from": "919876543210",
                "id": "wamid.HBgM...",
                "timestamp": "1730645000",
                "type": "text | audio | interactive",
                "text": { "body": "2 roti 1 katori dal" },
                "audio": { "id": "MEDIA_ID", "mime_type": "audio/ogg; codecs=opus" },
                "interactive": {
                  "type": "button_reply",
                  "button_reply": { "id": "confirm_meal_abc", "title": "Confirm & Log" }
                }
              }
            ]
          },
          "field": "messages"
        }
      ]
    }
  ]
}
```

---

## 2. Voice Note Pipeline & Groq Whisper Integration

### Ephemeral Media Fetch
1. Extract `audio.id` from the inbound message.
2. Query Meta Graph API:
   ```http
   GET https://graph.facebook.com/v21.0/{audio.id}
   Authorization: Bearer WHATSAPP_ACCESS_TOKEN
   ```
   Yields `{ "url": "https://lookaside.fbsbx.com/...", "mime_type": "audio/ogg; codecs=opus" }`.
3. Fetch the media payload directly using Bearer authorization.
4. **DPDP 2023 Ephemeral Lifecycle**:
   - The audio stream is kept solely in memory as a typed `Uint8Array`.
   - Never saved to temporary disk (`/tmp`), local storage, or S3/Supabase storage buckets.
   - Buffer is cleared immediately once transcription completes.

### Speech-to-Text via Groq Whisper (`whisper-large-v3`)
- Groq hosts OpenAI's `whisper-large-v3` running on LPUs with near real-time inference latency (< 500ms for a 15-second voice note).
- Endpoint: `POST https://api.groq.com/openai/v1/audio/transcriptions`
- Parameters:
  - `model`: `whisper-large-v3`
  - `file`: `new File([audioBytes], 'audio.ogg', { type: 'audio/ogg' })`
  - `prompt`: `"Indian meal logging voice note in Hindi, English, or Hinglish: roti, dal, sabzi, katori, chawal, dahi, paneer."`
  - `temperature`: 0.0
- Accurately captures colloquial Indian accents, mixed Hinglish phrases (*"Maine do phulke aur thoda sa paneer khaya"*), and background domestic noise.

---

## 3. Human-in-the-Loop Interactive Messages

### Interactive Quick Reply Message
Meta limits interactive messages to a maximum of 3 buttons:
```json
{
  "messaging_product": "whatsapp",
  "recipient_type": "individual",
  "to": "919876543210",
  "type": "interactive",
  "interactive": {
    "type": "button",
    "header": { "type": "text", "text": "🍽️ FitKarma Meal Estimate" },
    "body": {
      "text": "Aapka meal estimate:\n• 2 Phulka / Roti (~160 kcal)\n• 1 Katori Dal Tadka (~180 kcal)\n\nTotal: ~340 kcal (P: 15g, C: 54g, F: 7g)\n\n⚠️ FitKarma estimate only. Not medical advice."
    },
    "action": {
      "buttons": [
        { "type": "reply", "reply": { "id": "confirm_meal_UUID", "title": "✅ Confirm & Log" } },
        { "type": "reply", "reply": { "id": "cancel_meal_UUID", "title": "❌ Cancel" } }
      ]
    }
  }
}
```

### State & Idempotency Storage (`whatsapp_interactions`)
- Database table correlates messages across the conversational turn:
  - `id`: UUID (Primary Key)
  - `user_id`: UUID references `auth.users(id)`
  - `wa_message_id`: Text (wamid, unique for deduplication)
  - `phone_number`: Text (sender E.164 phone)
  - `message_type`: Text (`text`, `audio`, `interactive`)
  - `raw_input`: Text (transcription or text body)
  - `candidate_items`: JSONB (AI parsed items)
  - `total_calories`: Numeric
  - `total_protein`: Numeric
  - `total_carbs`: Numeric
  - `total_fat`: Numeric
  - `status`: Text (`pending`, `confirmed`, `cancelled`, `expired`)
  - `created_at`: Timestamptz
  - `confirmed_at`: Timestamptz

---

## 4. Account Linking & Safety Boundaries

### Phone Resolution
- Sender `from`: e.g. `919876543210`.
- Normalize to E.164: `+919876543210`.
- Query `public.profiles` where `phone_number = normalizedPhone`.
- If unlinked:
  - Respond with a friendly invitation template:
    *"Namaste! This phone number (+91XXXXXXXXXX) is not linked to an active FitKarma account. Download the FitKarma app and sign in with this number to enable instant WhatsApp logging: https://fitkarma.app"*
  - Does NOT reveal existing user data or process meals for unverified numbers.

### Medical Guardrails (TASK 063)
- If inbound message asks for clinical diagnosis (*"kya mujhe diabetes hai"*, *"blood sugar kam karne ki dawa"*):
  - Bot responds with statutory non-diagnostic statement:
    *"FitKarma is a wellness and nutrition tracker, not a medical practitioner. For blood sugar concerns or medication advice, please consult your physician."*
  - Refuses to log medicine as food or make prescriptive treatment claims.

