// ============================================================================
// WHATSAPP INTERACTIVE CONFIRMATION & FOOD LOG COMMIT TEST RUNNER
// ============================================================================

import assert from 'node:assert/strict';
import { WhatsAppCardBuilder } from './card_builder.ts';
import { WhatsAppCommitHandler, inferMealSlot } from './commit_handler.ts';
import { MetaWhatsAppClient } from './meta_client.ts';
import { handleWebhookRequest } from './index.ts';
import type { WhatsAppInteractionRecord } from './schemas.ts';
import type { MealPipelineOutput } from './meal_pipeline.ts';

async function runInteractiveTests() {
  console.log('🧪 Starting WhatsApp Interactive Confirmation & Commit Tests...\n');

  // Test 1: WhatsAppCardBuilder payload structure and character limit
  console.log('1. Testing WhatsAppCardBuilder payload and constraints...');
  const sampleMealOutput: MealPipelineOutput = {
    rawTranscript: 'Maine 2 roti aur 1 katori dal khayi',
    items: [
      {
        food_name: 'Roti (Chapati)',
        quantity: 2,
        unit: 'piece',
        estimated_calories: 104,
        protein_g: 3.1,
        carbs_g: 17.5,
        fat_g: 0.4,
        confidence_score: 0.95,
      },
      {
        food_name: 'Dal Tadka',
        quantity: 1,
        unit: 'katori',
        estimated_calories: 140,
        protein_g: 7.2,
        carbs_g: 18.0,
        fat_g: 4.5,
        confidence_score: 0.9,
      },
    ],
    totalCalories: 348,
    totalProtein: 13.4,
    totalCarbs: 53.0,
    totalFat: 5.3,
    confidenceScore: 0.92,
    hinglishInsight: 'Badhiya! Balanced meal with wholesome lentils and wheat.',
    statutoryDisclaimer: 'Non-medical nutritional estimate. Consult a registered dietitian for medical advice.',
    isMedicalQuery: false,
  };

  const card = WhatsAppCardBuilder.buildMealConfirmationCard(
    '+919876543210',
    'wamid.TEST1234',
    sampleMealOutput,
  );

  assert.equal(card.to, '919876543210');
  assert.equal(card.type, 'interactive');
  assert.equal(card.interactive.action.buttons.length, 2);
  assert.equal(card.interactive.action.buttons[0].reply.id, 'confirm_meal_wamid.TEST1234');
  assert.equal(card.interactive.action.buttons[1].reply.id, 'cancel_meal_wamid.TEST1234');
  assert.ok(
    card.interactive.body.text.length < 1024,
    `Body text (${card.interactive.body.text.length}) must be under 1024 characters`,
  );
  assert.ok(card.interactive.body.text.includes('Non-medical nutritional estimate'));
  assert.ok(card.interactive.body.text.includes('2 piece Roti (Chapati)'));
  assert.ok(card.interactive.body.text.includes('1 katori Dal Tadka'));
  console.log('   ✅ Card builder produced valid Meta interactive message under 1024 chars');

  // Test 2: inferMealSlot by Indian time of day
  console.log('2. Testing inferMealSlot time-of-day mapping...');
  const bfastDate = new Date('2026-11-03T08:30:00');
  const lunchDate = new Date('2026-11-03T13:15:00');
  const snackDate = new Date('2026-11-03T17:00:00');
  const dinnerDate = new Date('2026-11-03T20:45:00');
  const lateDinnerDate = new Date('2026-11-03T01:30:00');

  assert.equal(inferMealSlot(bfastDate), 'breakfast');
  assert.equal(inferMealSlot(lunchDate), 'lunch');
  assert.equal(inferMealSlot(snackDate), 'snack');
  assert.equal(inferMealSlot(dinnerDate), 'dinner');
  assert.equal(inferMealSlot(lateDinnerDate), 'dinner');
  console.log('   ✅ Indian meal slots correctly mapped (breakfast, lunch, snack, dinner)');

  // Test 3: WhatsAppCommitHandler - confirm_meal execution
  console.log('3. Testing WhatsAppCommitHandler confirm_meal flow...');
  let mockInteraction: WhatsAppInteractionRecord = {
    id: 'rec_001',
    user_id: 'user_fit_123',
    wa_message_id: 'wamid.TEST1234',
    phone_number: '+919876543210',
    message_type: 'text',
    raw_input: '2 roti and dal',
    candidate_items: sampleMealOutput.items,
    total_calories: 348,
    total_protein: 13.4,
    total_carbs: 53.0,
    total_fat: 5.3,
    status: 'pending',
    created_at: new Date().toISOString(),
    updated_at: new Date().toISOString(),
  };

  const insertedFoodLogs: unknown[] = [];
  const metaClient = new MetaWhatsAppClient({ isMock: true });

  const confirmResult = await WhatsAppCommitHandler.handleButtonReply(
    'confirm_meal_wamid.TEST1234',
    metaClient,
    {
      getInteractionById: async (id) => (id === 'wamid.TEST1234' || id === 'rec_001' ? mockInteraction : null),
      updateInteractionStatus: async (id, status) => {
        mockInteraction.status = status;
      },
      insertFoodLogs: async (entries) => {
        insertedFoodLogs.push(...entries);
        return entries.length;
      },
    },
  );

  assert.equal(confirmResult.handled, true);
  assert.equal(confirmResult.action, 'confirmed');
  assert.equal(confirmResult.insertedCount, 2);
  assert.equal(mockInteraction.status, 'confirmed');
  assert.equal(insertedFoodLogs.length, 2);
  assert.equal((insertedFoodLogs[0] as { food_name: string }).food_name, 'Roti (Chapati)');
  console.log('   ✅ confirm_meal successfully inserted food logs and updated interaction status');

  // Test 4: Prevent duplicate replay when already confirmed
  console.log('4. Testing duplicate tap protection...');
  const duplicateResult = await WhatsAppCommitHandler.handleButtonReply(
    'confirm_meal_wamid.TEST1234',
    metaClient,
    {
      getInteractionById: async () => mockInteraction,
      updateInteractionStatus: async () => {},
      insertFoodLogs: async () => 0,
    },
  );
  assert.equal(duplicateResult.handled, true);
  assert.equal(duplicateResult.action, 'already_processed');
  assert.equal(insertedFoodLogs.length, 2, 'No new food logs should be inserted on duplicate');
  console.log('   ✅ Duplicate button taps safely ignored without re-inserting');

  // Test 5: Cancel meal interaction
  console.log('5. Testing cancel_meal flow...');
  let cancelInteraction: WhatsAppInteractionRecord = {
    id: 'rec_002',
    user_id: 'user_fit_123',
    wa_message_id: 'wamid.CANCEL123',
    phone_number: '+919876543210',
    message_type: 'text',
    raw_input: 'samosa and tea',
    candidate_items: [],
    total_calories: 250,
    total_protein: 4,
    total_carbs: 30,
    total_fat: 12,
    status: 'pending',
    created_at: new Date().toISOString(),
    updated_at: new Date().toISOString(),
  };

  const cancelResult = await WhatsAppCommitHandler.handleButtonReply(
    'cancel_meal_wamid.CANCEL123',
    metaClient,
    {
      getInteractionById: async () => cancelInteraction,
      updateInteractionStatus: async (id, status) => {
        cancelInteraction.status = status;
      },
      insertFoodLogs: async () => 0,
    },
  );

  assert.equal(cancelResult.handled, true);
  assert.equal(cancelResult.action, 'cancelled');
  assert.equal(cancelInteraction.status, 'cancelled');
  console.log('   ✅ cancel_meal cancelled interaction with zero database food log insertions');

  // Test 6: Expired interaction (> 6 hours old)
  console.log('6. Testing expired interaction handling...');
  const sevenHoursAgo = new Date(Date.now() - 7 * 60 * 60 * 1000).toISOString();
  let expiredInteraction: WhatsAppInteractionRecord = {
    id: 'rec_003',
    user_id: 'user_fit_123',
    wa_message_id: 'wamid.EXPIRED123',
    phone_number: '+919876543210',
    message_type: 'text',
    raw_input: 'old meal',
    candidate_items: sampleMealOutput.items,
    total_calories: 348,
    total_protein: 13.4,
    total_carbs: 53.0,
    total_fat: 5.3,
    status: 'pending',
    created_at: sevenHoursAgo,
    updated_at: sevenHoursAgo,
  };

  const expireResult = await WhatsAppCommitHandler.handleButtonReply(
    'confirm_meal_wamid.EXPIRED123',
    metaClient,
    {
      getInteractionById: async () => expiredInteraction,
      updateInteractionStatus: async (id, status) => {
        expiredInteraction.status = status;
      },
      insertFoodLogs: async () => 0,
    },
  );

  assert.equal(expireResult.handled, true);
  assert.equal(expireResult.action, 'expired');
  assert.equal(expiredInteraction.status, 'expired');
  console.log('   ✅ Expired interactions (> 6 hrs) rejected and marked expired');

  // Test 7: End-to-end handleWebhookRequest with interactive message POST
  console.log('7. Testing handleWebhookRequest interactive button reply integration...');
  let e2eStatus = 'pending';
  let e2eFoodLogsCount = 0;

  const interactiveWebhookBody = JSON.stringify({
    object: 'whatsapp_business_account',
    entry: [
      {
        id: 'entry_01',
        changes: [
          {
            field: 'messages',
            value: {
              messaging_product: 'whatsapp',
              metadata: {
                display_phone_number: '919999999999',
                phone_number_id: 'phone_01',
              },
              messages: [
                {
                  from: '919876543210',
                  id: 'wamid.E2E_REPLY_1',
                  timestamp: `${Math.floor(Date.now() / 1000)}`,
                  type: 'interactive',
                  interactive: {
                    type: 'button_reply',
                    button_reply: {
                      id: 'confirm_meal_wamid.ORIGINAL_1',
                      title: '✅ Confirm & Log',
                    },
                  },
                },
              ],
            },
          },
        ],
      },
    ],
  });

  const e2eReq = new Request('http://localhost:54321/functions/v1/whatsapp-webhook', {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: interactiveWebhookBody,
  });

  const e2eRes = await handleWebhookRequest(e2eReq, {
    appSecret: 'test_secret',
    metaClient,
    getInteractionById: async (id) => ({
      id: 'rec_e2e',
      user_id: 'user_e2e_456',
      wa_message_id: id,
      phone_number: '+919876543210',
      message_type: 'text',
      raw_input: 'dosa',
      candidate_items: [
        {
          food_name: 'Plain Dosa',
          quantity: 1,
          unit: 'piece',
          estimated_calories: 168,
          protein_g: 3.9,
          carbs_g: 29.0,
          fat_g: 3.7,
        },
      ],
      total_calories: 168,
      total_protein: 3.9,
      total_carbs: 29.0,
      total_fat: 3.7,
      status: e2eStatus as 'pending',
      created_at: new Date().toISOString(),
      updated_at: new Date().toISOString(),
    }),
    updateInteractionStatus: async (id, status) => {
      e2eStatus = status;
    },
    insertFoodLogs: async (entries) => {
      e2eFoodLogsCount += entries.length;
      return entries.length;
    },
  });

  assert.equal(e2eRes.status, 200);
  assert.equal(e2eStatus, 'confirmed');
  assert.equal(e2eFoodLogsCount, 1);
  console.log('   ✅ End-to-end webhook interactive button reply processed and committed 1 meal');

  console.log('\n🎉 ALL 7 INTERACTIVE CONFIRMATION & COMMIT TESTS PASSED!\n');
}

runInteractiveTests().catch((err) => {
  console.error('❌ Interactive Test Suite Failed:', err);
  process.exit(1);
});
