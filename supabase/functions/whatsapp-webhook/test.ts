// ============================================================================
// WHATSAPP WEBHOOK UNIT & INTEGRATION TESTS
// Run with: node --experimental-strip-types test.ts
// ============================================================================

import assert from 'node:assert/strict';
import { handleWebhookRequest } from './index.ts';
import { verifyMetaSignature } from './signature.ts';
import { normalizeIndianPhoneNumber, resolveUserProfile } from './phone_matcher.ts';
import { MetaWhatsAppClient } from './meta_client.ts';

const TEST_SECRET = 'fitkarma_webhook_secret_key_123';
const TEST_VERIFY_TOKEN = 'fitkarma_meta_verify_token_xyz';

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

async function runTests() {
  console.log('--- RUNNING WHATSAPP WEBHOOK TESTS ---');

  // Test 1: GET challenge verification succeeds with valid verify_token
  {
    const req = new Request(
      `https://fitkarma.supabase.co/functions/v1/whatsapp-webhook?hub.mode=subscribe&hub.verify_token=${TEST_VERIFY_TOKEN}&hub.challenge=1158201207`,
      { method: 'GET' },
    );

    const res = await handleWebhookRequest(req, { verifyToken: TEST_VERIFY_TOKEN });
    assert.equal(res.status, 200);
    const body = await res.text();
    assert.equal(body, '1158201207');
    console.log('✓ Test 1: GET challenge handshake succeeds with valid token');
  }

  // Test 2: GET challenge verification rejects invalid verify_token
  {
    const req = new Request(
      `https://fitkarma.supabase.co/functions/v1/whatsapp-webhook?hub.mode=subscribe&hub.verify_token=wrong_token&hub.challenge=1158201207`,
      { method: 'GET' },
    );

    const res = await handleWebhookRequest(req, { verifyToken: TEST_VERIFY_TOKEN });
    assert.equal(res.status, 403);
    console.log('✓ Test 2: GET challenge handshake rejects invalid token with 403');
  }

  // Test 3: POST signature verification accepts valid HMAC-SHA256, rejects tampered payload
  {
    const payload = JSON.stringify({ object: 'whatsapp_business_account', entry: [] });
    const validSignature = await computeHmacHex(payload, TEST_SECRET);

    // Valid signature
    const validReq = new Request('https://fitkarma.supabase.co/functions/v1/whatsapp-webhook', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'x-hub-signature-256': `sha256=${validSignature}`,
      },
      body: payload,
    });
    const validRes = await handleWebhookRequest(validReq, { appSecret: TEST_SECRET });
    assert.equal(validRes.status, 200);

    // Tampered payload
    const tamperedReq = new Request('https://fitkarma.supabase.co/functions/v1/whatsapp-webhook', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'x-hub-signature-256': `sha256=${validSignature}`,
      },
      body: JSON.stringify({ object: 'tampered_data' }),
    });
    const tamperedRes = await handleWebhookRequest(tamperedReq, { appSecret: TEST_SECRET });
    assert.equal(tamperedRes.status, 401);

    console.log('✓ Test 3: POST HMAC-SHA256 signature verification accepts valid and rejects tampered payloads');
  }

  // Test 4: Phone number normalization
  {
    assert.equal(normalizeIndianPhoneNumber('9876543210'), '+919876543210');
    assert.equal(normalizeIndianPhoneNumber('09876543210'), '+919876543210');
    assert.equal(normalizeIndianPhoneNumber('919876543210'), '+919876543210');
    assert.equal(normalizeIndianPhoneNumber('+919876543210'), '+919876543210');
    assert.equal(normalizeIndianPhoneNumber('+91 98765 43210'), '+919876543210');
    console.log('✓ Test 4: Phone normalization correctly formats 10/11/12-digit Indian numbers to E.164');
  }

  // Test 5: Inbound deduplication
  {
    const recordedIds = new Set<string>();
    const mockRecordInteraction = async (record: { wa_message_id: string }) => {
      if (recordedIds.has(record.wa_message_id)) {
        return false; // duplicate
      }
      recordedIds.add(record.wa_message_id);
      return true; // new
    };

    const webhookBody = {
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
                    id: 'wamid.TEST_DUPLICATE_ID_1',
                    timestamp: '1730645000',
                    type: 'text',
                    text: { body: '2 rotis and dal' },
                  },
                ],
              },
            },
          ],
        },
      ],
    };

    const payloadStr = JSON.stringify(webhookBody);
    const sig = await computeHmacHex(payloadStr, TEST_SECRET);

    // First arrival: should record
    const req1 = new Request('https://fitkarma.supabase.co/functions/v1/whatsapp-webhook', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json', 'x-hub-signature-256': `sha256=${sig}` },
      body: payloadStr,
    });
    const res1 = await handleWebhookRequest(req1, {
      appSecret: TEST_SECRET,
      recordInteraction: mockRecordInteraction,
    });
    assert.equal(res1.status, 200);
    assert.equal(recordedIds.size, 1);

    // Duplicate retry from Meta: should be ignored gracefully
    const req2 = new Request('https://fitkarma.supabase.co/functions/v1/whatsapp-webhook', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json', 'x-hub-signature-256': `sha256=${sig}` },
      body: payloadStr,
    });
    const res2 = await handleWebhookRequest(req2, {
      appSecret: TEST_SECRET,
      recordInteraction: mockRecordInteraction,
    });
    assert.equal(res2.status, 200);
    assert.equal(recordedIds.size, 1); // Not duplicated
    console.log('✓ Test 5: Inbound deduplication detects existing wa_message_id and ignores duplicates');
  }

  // Test 6: Unlinked phone number triggers friendly invitation
  {
    let invitationSentTo: string | null = null;
    class MockClient extends MetaWhatsAppClient {
      override async sendUnlinkedInvitation(to: string) {
        invitationSentTo = to;
        return { success: true, messageId: 'msg_invite_1' };
      }
    }

    const payload = JSON.stringify({
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
                    from: '919999999999',
                    id: 'wamid.UNLINKED_USER_MSG',
                    timestamp: '1730645000',
                    type: 'text',
                    text: { body: 'Hello FitKarma' },
                  },
                ],
              },
            },
          ],
        },
      ],
    });

    const sig = await computeHmacHex(payload, TEST_SECRET);
    const req = new Request('https://fitkarma.supabase.co/functions/v1/whatsapp-webhook', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json', 'x-hub-signature-256': `sha256=${sig}` },
      body: payload,
    });

    const res = await handleWebhookRequest(req, {
      appSecret: TEST_SECRET,
      metaClient: new MockClient(),
      lookupProfile: async () => null, // simulates user not found
    });

    assert.equal(res.status, 200);
    assert.equal(invitationSentTo, '+919999999999');
    console.log('✓ Test 6: Unlinked phone number receives friendly invitation message');
  }

  // Test 7: Linked phone number resolves user profile successfully
  {
    const mockLookup = async (phone: string) => {
      if (phone === '+919876543210') {
        return {
          id: 'prof_1',
          user_id: 'user_uuid_123',
          display_name: 'Aarav Patel',
          phone_number: '+919876543210',
        };
      }
      return null;
    };

    const res = await resolveUserProfile('919876543210', mockLookup);
    assert.equal(res.isLinked, true);
    assert.equal(res.userId, 'user_uuid_123');
    assert.equal(res.displayName, 'Aarav Patel');
    assert.equal(res.phoneNumber, '+919876543210');
    console.log('✓ Test 7: Linked phone number successfully resolves user profile');
  }

  console.log('\nALL 7 TESTS PASSED SUCCESSFULLY! 🚀');
}

runTests().catch((err) => {
  console.error('Test failed:', err);
  process.exit(1);
});

