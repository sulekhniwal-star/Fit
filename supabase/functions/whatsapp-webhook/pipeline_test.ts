// ============================================================================
// AUDIO TRANSCRIPTION & CONVERSATIONAL MEAL PIPELINE TESTS
// Run with: node --experimental-strip-types pipeline_test.ts
// ============================================================================

import assert from 'node:assert/strict';
import { WhatsAppMediaFetcher } from './media_fetcher.ts';
import { GroqAudioTranscriber } from './audio_transcriber.ts';
import { ConversationalMealPipeline } from './meal_pipeline.ts';
import { handleWebhookRequest } from './index.ts';
import { MetaWhatsAppClient } from './meta_client.ts';

async function computeHmacHex(payload: string, secret: string): Promise<string> {
  const encoder = new TextEncoder();
  const key = await crypto.subtle.importKey(
    'raw',
    encoder.encode(secret),
    { name: 'HMAC', hash: 'SHA-256' },
    false,
    ['sign'],
  );
  const signature = await crypto.subtle.sign('HMAC', key, encoder.encode(payload));
  return Array.from(new Uint8Array(signature))
    .map((b) => b.toString(16).padStart(2, '0'))
    .join('');
}

async function runPipelineTests() {
  console.log('--- RUNNING AUDIO & MEAL PIPELINE TESTS ---');

  // Test 1: In-memory media fetching
  {
    const fetcher = new WhatsAppMediaFetcher({ isMock: true });
    const media = await fetcher.fetchAudioBytes('media_id_voice_note_123');

    assert.equal(media.mimeType, 'audio/ogg; codecs=opus');
    assert.equal(media.byteLength, 128);
    assert.equal(media.data.length, 128);
    console.log('✓ Test 1: WhatsAppMediaFetcher downloads in-memory binary stream');
  }

  // Test 2: Ephemeral memory zeroing (DPDP Act 2023 compliance)
  {
    const fetcher = new WhatsAppMediaFetcher({ isMock: true });
    const media = await fetcher.fetchAudioBytes('media_id_voice_note_123');
    assert.notEqual(media.data[10], 0);

    WhatsAppMediaFetcher.purgeEphemeralBuffer(media);
    assert.equal(media.data.every((byte) => byte === 0), true);
    console.log('✓ Test 2: DPDP Act 2023 lifecycle - audio memory buffer is completely zeroed out');
  }

  // Test 3: GroqAudioTranscriber transcribes voice note and purges memory
  {
    const fetcher = new WhatsAppMediaFetcher({ isMock: true });
    const media = await fetcher.fetchAudioBytes('media_id_voice_note_123');
    const transcriber = new GroqAudioTranscriber({ isMock: true });

    const result = await transcriber.transcribeAudio(media);
    assert.equal(result.text.includes('roti'), true);
    assert.equal(result.detectedLanguage, 'hi');
    // Verify buffer was automatically zeroed out inside transcriber
    assert.equal(media.data.every((byte) => byte === 0), true);
    console.log('✓ Test 3: GroqAudioTranscriber generates Hindi transcript and purges media buffer');
  }

  // Test 4: Medical boundary blocks clinical diagnostic queries
  {
    const pipeline = new ConversationalMealPipeline({ isMock: true });
    const clinicalText = 'This herbal kadha cures diabetes permanently.';

    const output = await pipeline.processInboundMealText(clinicalText);
    assert.equal(output.isMedicalQuery, true);
    assert.equal(output.items.length, 0);
    assert.equal(output.medicalRefusalMessage?.includes('licensed physician'), true);
    console.log('✓ Test 4: Medical boundary filter blocks clinical queries and provides statutory referral');
  }

  // Test 5: ConversationalMealPipeline extracts Indian dishes and macros
  {
    const pipeline = new ConversationalMealPipeline({ isMock: true });
    const mealText = '2 phulka roti and 1 katori dal tadka with paneer';

    const output = await pipeline.processInboundMealText(mealText);
    assert.equal(output.isMedicalQuery, false);
    assert.equal(output.items.length >= 2, true);
    assert.equal(output.totalCalories > 200, true);
    assert.equal(output.statutoryDisclaimer.includes('Nutritional estimate only'), true);
    assert.equal(output.hinglishInsight.length > 0, true);
    console.log('✓ Test 5: ConversationalMealPipeline extracts candidate dishes with portions and macros');
  }

  // Test 6: End-to-end voice note webhook handling
  {
    let recordedInteraction: any = null;
    let updatedPrediction: any = null;

    const mockProfileLookup = async (phone: string) => ({
      id: 'prof_1',
      user_id: 'user_123',
      display_name: 'Priya Sharma',
      phone_number: phone,
    });

    const mockRecord = async (interaction: any) => {
      recordedInteraction = interaction;
      return true;
    };

    const mockUpdate = async (waMsgId: string, output: any) => {
      updatedPrediction = output;
    };

    const voiceNoteWebhook = {
      object: 'whatsapp_business_account',
      entry: [
        {
          id: 'waba_1',
          changes: [
            {
              field: 'messages',
              value: {
                messaging_product: 'whatsapp',
                metadata: { display_phone_number: '123', phone_number_id: 'pn_1' },
                messages: [
                  {
                    from: '919876543210',
                    id: 'wamid.VOICE_NOTE_MSG_99',
                    timestamp: '1730645000',
                    type: 'audio',
                    audio: {
                      id: 'audio_media_123',
                      mime_type: 'audio/ogg; codecs=opus',
                    },
                  },
                ],
              },
            },
          ],
        },
      ],
    };

    const secret = 'test_secret_abc';
    const payloadStr = JSON.stringify(voiceNoteWebhook);
    const sig = await computeHmacHex(payloadStr, secret);

    const req = new Request('https://fitkarma.supabase.co/functions/v1/whatsapp-webhook', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'x-hub-signature-256': `sha256=${sig}`,
      },
      body: payloadStr,
    });

    const res = await handleWebhookRequest(req, {
      appSecret: secret,
      lookupProfile: mockProfileLookup,
      recordInteraction: mockRecord,
      updateInteractionPrediction: mockUpdate,
    });

    assert.equal(res.status, 200);
    assert.equal(recordedInteraction.message_type, 'audio');
    assert.equal(recordedInteraction.user_id, 'user_123');
    assert.equal(updatedPrediction.items.length >= 2, true);
    assert.equal(updatedPrediction.totalCalories > 0, true);
    console.log('✓ Test 6: Inbound voice note webhook successfully downloads, transcribes, and extracts meal');
  }

  console.log('\nALL 6 PIPELINE TESTS PASSED! 🚀');
}

runPipelineTests().catch((err) => {
  console.error('Pipeline test failed:', err);
  process.exit(1);
});
