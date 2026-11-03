// ============================================================================
// FITKARMA SUPABASE EDGE FUNCTION: WHATSAPP WEBHOOK
// ============================================================================

import { verifyMetaSignature } from './signature.ts';
import { normalizeIndianPhoneNumber, resolveUserProfile } from './phone_matcher.ts';
import { MetaWhatsAppClient } from './meta_client.ts';
import { WhatsAppMediaFetcher } from './media_fetcher.ts';
import { GroqAudioTranscriber } from './audio_transcriber.ts';
import { ConversationalMealPipeline, type MealPipelineOutput } from './meal_pipeline.ts';
import { WhatsAppCardBuilder } from './card_builder.ts';
import { WhatsAppCommitHandler } from './commit_handler.ts';
import type { MetaWebhookPayload, MetaInboundMessage, WhatsAppInteractionRecord } from './schemas.ts';

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

export interface InboundProcessingDeps {
  verifyToken?: string;
  appSecret?: string;
  metaClient?: MetaWhatsAppClient;
  mediaFetcher?: WhatsAppMediaFetcher;
  audioTranscriber?: GroqAudioTranscriber;
  mealPipeline?: ConversationalMealPipeline;
  lookupProfile?: (phone: string) => Promise<{ id: string; user_id: string; display_name: string | null; phone_number: string } | null>;
  recordInteraction?: (interaction: {
    wa_message_id: string;
    user_id: string | null;
    phone_number: string;
    message_type: string;
    raw_input: string | null;
    status: string;
    candidate_items?: unknown[];
    total_calories?: number;
    total_protein?: number;
    total_carbs?: number;
    total_fat?: number;
  }) => Promise<boolean>; // returns false if duplicate
  updateInteractionPrediction?: (
    waMessageId: string,
    output: MealPipelineOutput,
  ) => Promise<void>;
  getInteractionById?: (id: string) => Promise<WhatsAppInteractionRecord | null>;
  updateInteractionStatus?: (id: string, status: 'confirmed' | 'cancelled' | 'expired') => Promise<void>;
  insertFoodLogs?: (entries: Array<{
    user_id: string;
    logged_at: string;
    meal_slot: string;
    food_name: string;
    portion_quantity: number;
    portion_unit: string;
    calories: number;
    protein_grams: number;
    carbs_grams: number;
    fat_grams: number;
  }>) => Promise<number>;
}

export async function handleWebhookRequest(
  req: Request,
  options?: InboundProcessingDeps,
): Promise<Response> {
  const verifyToken = options?.verifyToken || getEnv('WHATSAPP_WEBHOOK_VERIFY_TOKEN', 'fitkarma_test_verify_token');
  const appSecret = options?.appSecret || getEnv('WHATSAPP_APP_SECRET', 'test_app_secret');
  const client = options?.metaClient || new MetaWhatsAppClient({ isMock: true });
  const mediaFetcher = options?.mediaFetcher || new WhatsAppMediaFetcher({ isMock: true });
  const audioTranscriber = options?.audioTranscriber || new GroqAudioTranscriber({ isMock: true });
  const mealPipeline = options?.mealPipeline || new ConversationalMealPipeline({ isMock: true });

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
            mediaFetcher,
            audioTranscriber,
            mealPipeline,
            lookupProfile: options?.lookupProfile,
            recordInteraction: options?.recordInteraction,
            updateInteractionPrediction: options?.updateInteractionPrediction,
            getInteractionById: options?.getInteractionById,
            updateInteractionStatus: options?.updateInteractionStatus,
            insertFoodLogs: options?.insertFoodLogs,
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
    mediaFetcher: WhatsAppMediaFetcher;
    audioTranscriber: GroqAudioTranscriber;
    mealPipeline: ConversationalMealPipeline;
    lookupProfile?: (phone: string) => Promise<{ id: string; user_id: string; display_name: string | null; phone_number: string } | null>;
    recordInteraction?: (interaction: {
      wa_message_id: string;
      user_id: string | null;
      phone_number: string;
      message_type: string;
      raw_input: string | null;
      status: string;
    }) => Promise<boolean>;
    updateInteractionPrediction?: (waMessageId: string, output: MealPipelineOutput) => Promise<void>;
    getInteractionById?: (id: string) => Promise<WhatsAppInteractionRecord | null>;
    updateInteractionStatus?: (id: string, status: 'confirmed' | 'cancelled' | 'expired') => Promise<void>;
    insertFoodLogs?: (entries: Array<{
      user_id: string;
      logged_at: string;
      meal_slot: string;
      food_name: string;
      portion_quantity: number;
      portion_unit: string;
      calories: number;
      protein_grams: number;
      carbs_grams: number;
      fat_grams: number;
    }>) => Promise<number>;
  },
): Promise<void> {
  const waMessageId = msg.id;
  const rawFrom = msg.from;
  const normalizedPhone = normalizeIndianPhoneNumber(rawFrom);

  const lookupFn = deps.lookupProfile || (async () => null);
  const profileResult = await resolveUserProfile(rawFrom, lookupFn);

  let rawInput: string | null = null;
  let textToAnalyze: string | null = null;

  if (msg.type === 'text') {
    rawInput = msg.text.body;
    textToAnalyze = msg.text.body;
  } else if (msg.type === 'audio' || msg.type === 'voice') {
    rawInput = `[audio_media_id:${msg.audio.id}]`;
    try {
      // 1. Fetch audio stream entirely in memory (DPDP Act 2023 compliant)
      const media = await deps.mediaFetcher.fetchAudioBytes(msg.audio.id);
      // 2. Transcribe voice note via Groq Whisper
      const transcription = await deps.audioTranscriber.transcribeAudio(media);
      textToAnalyze = transcription.text;
      rawInput = `[voice_transcript]: ${transcription.text}`;
    } catch (e) {
      rawInput = `[audio_transcription_error]: ${e}`;
    }
  } else if (msg.type === 'interactive' && msg.interactive?.type === 'button_reply') {
    rawInput = `[button_reply:${msg.interactive.button_reply.id}]`;

    // Process interactive button reply immediately
    if (deps.getInteractionById && deps.updateInteractionStatus && deps.insertFoodLogs) {
      await WhatsAppCommitHandler.handleButtonReply(
        msg.interactive.button_reply.id,
        deps.metaClient,
        {
          getInteractionById: deps.getInteractionById,
          updateInteractionStatus: deps.updateInteractionStatus,
          insertFoodLogs: deps.insertFoodLogs,
        },
      );
      return;
    }
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
      return; // duplicate message
    }
  }

  // If sender is not linked to FitKarma, invite them to download & sign up
  if (!profileResult.isLinked) {
    await deps.metaClient.sendUnlinkedInvitation(normalizedPhone);
    return;
  }

  // If text or audio transcript is available, process through meal pipeline
  if (textToAnalyze) {
    const mealOutput = await deps.mealPipeline.processInboundMealText(textToAnalyze);

    // If medical claim / query detected, send refusal message immediately
    if (mealOutput.isMedicalQuery && mealOutput.medicalRefusalMessage) {
      await deps.metaClient.sendTextMessage(normalizedPhone, mealOutput.medicalRefusalMessage);
      return;
    }

    if (deps.updateInteractionPrediction) {
      await deps.updateInteractionPrediction(waMessageId, mealOutput);
    }

    // Build and send interactive Quick Reply button card
    if (mealOutput.items.length > 0) {
      const interactivePayload = WhatsAppCardBuilder.buildMealConfirmationCard(
        normalizedPhone,
        waMessageId,
        mealOutput,
      );
      await deps.metaClient.sendInteractiveMessage(interactivePayload);
    } else {
      await deps.metaClient.sendTextMessage(
        normalizedPhone,
        'Hum aapke meal ko samajh nahi paaye. Kripya apne khane ka naam aur matra batayein (e.g., "2 roti aur 1 katori daal"). 🥗',
      );
    }
  }
}

if (typeof Deno !== 'undefined' && Deno.serve) {
  Deno.serve(async (req: Request) => {
    return handleWebhookRequest(req);
  });
}
