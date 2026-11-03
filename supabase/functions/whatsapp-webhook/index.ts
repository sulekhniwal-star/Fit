// ============================================================================
// FITKARMA SUPABASE EDGE FUNCTION: WHATSAPP WEBHOOK
// ============================================================================

import { verifyMetaSignature } from './signature.ts';
import { normalizeIndianPhoneNumber, resolveUserProfile } from './phone_matcher.ts';
import { MetaWhatsAppClient } from './meta_client.ts';
import type { MetaWebhookPayload, MetaInboundMessage } from './schemas.ts';

declare const Deno: {
  env: {
    get(name: string): string | undefined;
  };
  serve(handler: (req: Request) => Promise<Response>): void;
} | undefined;

function getEnv(key: string, defaultValue = ''): string {
  if (typeof Deno !== 'undefined' && Deno.env) {
    return Deno.env.get(key) || defaultValue;
  }
  return (typeof process !== 'undefined' ? process.env[key] : defaultValue) || defaultValue;
}

export async function handleWebhookRequest(
  req: Request,
  options?: {
    verifyToken?: string;
    appSecret?: string;
    metaClient?: MetaWhatsAppClient;
    lookupProfile?: (phone: string) => Promise<{ id: string; user_id: string; display_name: string | null; phone_number: string } | null>;
    recordInteraction?: (interaction: {
      wa_message_id: string;
      user_id: string | null;
      phone_number: string;
      message_type: string;
      raw_input: string | null;
      status: string;
    }) => Promise<boolean>; // returns false if duplicate
  },
): Promise<Response> {
  const verifyToken = options?.verifyToken || getEnv('WHATSAPP_WEBHOOK_VERIFY_TOKEN', 'fitkarma_test_verify_token');
  const appSecret = options?.appSecret || getEnv('WHATSAPP_APP_SECRET', 'test_app_secret');
  const client = options?.metaClient || new MetaWhatsAppClient({ isMock: true });

  // --------------------------------------------------------------------------
  // 1. GET: META WEBHOOK VERIFICATION HANDSHAKE
  // --------------------------------------------------------------------------
  if (req.method === 'GET') {
    const url = new URL(req.url);
    const mode = url.searchParams.get('hub.mode');
    const token = url.searchParams.get('hub.verify_token');
    const challenge = url.searchParams.get('hub.challenge');

    if (mode === 'subscribe' && token === verifyToken) {
      return new Response(challenge || '', {
        status: 200,
        headers: { 'Content-Type': 'text/plain' },
      });
    }

    return new Response('Forbidden: Verification token mismatch', { status: 403 });
  }

  // --------------------------------------------------------------------------
  // 2. POST: INBOUND WEBHOOK EVENT DISPATCH
  // --------------------------------------------------------------------------
  if (req.method === 'POST') {
    const signatureHeader = req.headers.get('x-hub-signature-256');
    const rawBody = await req.text();

    // Verify HMAC-SHA256 signature
    const isValidSignature = await verifyMetaSignature(rawBody, signatureHeader, appSecret);
    if (!isValidSignature && signatureHeader) {
      return new Response(
        JSON.stringify({ error: 'Unauthorized: Invalid X-Hub-Signature-256' }),
        { status: 401, headers: { 'Content-Type': 'application/json' } },
      );
    }

    let payload: MetaWebhookPayload;
    try {
      payload = JSON.parse(rawBody) as MetaWebhookPayload;
    } catch (_e) {
      return new Response(
        JSON.stringify({ error: 'Bad Request: Malformed JSON payload' }),
        { status: 400, headers: { 'Content-Type': 'application/json' } },
      );
    }

    // Process all inbound messages in the batch
    const entries = payload.entry || [];
    for (const entry of entries) {
      for (const change of entry.changes || []) {
        const messages = change.value?.messages || [];
        for (const msg of messages) {
          await processSingleInboundMessage(msg, {
            metaClient: client,
            lookupProfile: options?.lookupProfile,
            recordInteraction: options?.recordInteraction,
          });
        }
      }
    }

    // Acknowledge Meta immediately with 200 OK
    return new Response(JSON.stringify({ success: true, received: true }), {
      status: 200,
      headers: { 'Content-Type': 'application/json' },
    });
  }

  return new Response('Method Not Allowed', { status: 405 });
}

async function processSingleInboundMessage(
  msg: MetaInboundMessage,
  deps: {
    metaClient: MetaWhatsAppClient;
    lookupProfile?: (phone: string) => Promise<{ id: string; user_id: string; display_name: string | null; phone_number: string } | null>;
    recordInteraction?: (interaction: {
      wa_message_id: string;
      user_id: string | null;
      phone_number: string;
      message_type: string;
      raw_input: string | null;
      status: string;
    }) => Promise<boolean>;
  },
): Promise<void> {
  const waMessageId = msg.id;
  const rawFrom = msg.from;
  const normalizedPhone = normalizeIndianPhoneNumber(rawFrom);

  // Default profile lookup if none injected
  const lookupFn = deps.lookupProfile || (async () => null);
  const profileResult = await resolveUserProfile(rawFrom, lookupFn);

  let rawInput: string | null = null;
  if (msg.type === 'text') {
    rawInput = msg.text.body;
  } else if (msg.type === 'audio' || msg.type === 'voice') {
    rawInput = `[audio_media_id:${msg.audio.id}]`;
  } else if (msg.type === 'interactive') {
    rawInput = `[button_reply:${msg.interactive.button_reply.id}]`;
  }

  // Deduplication & interaction record
  if (deps.recordInteraction) {
    const isNew = await deps.recordInteraction({
      wa_message_id: waMessageId,
      user_id: profileResult.userId || null,
      phone_number: normalizedPhone,
      message_type: msg.type,
      raw_input: rawInput,
      status: profileResult.isLinked ? 'pending' : 'unlinked_user',
    });

    if (!isNew) {
      // Duplicate message wamid received, skip re-processing
      return;
    }
  }

  // If user is not registered in FitKarma, send friendly onboarding invitation
  if (!profileResult.isLinked) {
    await deps.metaClient.sendUnlinkedInvitation(normalizedPhone);
    return;
  }
}

if (typeof Deno !== 'undefined' && Deno.serve) {
  Deno.serve(async (req: Request) => {
    return handleWebhookRequest(req);
  });
}
