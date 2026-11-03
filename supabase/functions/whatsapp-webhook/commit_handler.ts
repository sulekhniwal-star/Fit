// ============================================================================
// WHATSAPP INTERACTIVE BUTTON CALLBACK & FOOD LOG COMMIT ENGINE
// ============================================================================

import type { MetaWhatsAppClient } from './meta_client.ts';
import type { WhatsAppInteractionRecord } from './schemas.ts';

export interface CommitResult {
  handled: boolean;
  action: 'confirmed' | 'cancelled' | 'expired' | 'already_processed' | 'not_found';
  insertedCount: number;
  messageText: string;
}

export function inferMealSlot(date: Date = new Date()): 'breakfast' | 'lunch' | 'dinner' | 'snack' {
  const hours = date.getHours();
  const minutes = date.getMinutes();
  const timeVal = hours + minutes / 60;

  if (timeVal >= 5.0 && timeVal < 11.5) return 'breakfast';
  if (timeVal >= 11.5 && timeVal < 16.0) return 'lunch';
  if (timeVal >= 16.0 && timeVal < 19.5) return 'snack';
  return 'dinner';
}

export class WhatsAppCommitHandler {
  /**
   * Processes button clicks from WhatsApp interactive quick replies.
   */
  static async handleButtonReply(
    buttonId: string,
    metaClient: MetaWhatsAppClient,
    deps: {
      getInteractionById: (id: string) => Promise<WhatsAppInteractionRecord | null>;
      updateInteractionStatus: (id: string, status: 'confirmed' | 'cancelled' | 'expired') => Promise<void>;
      insertFoodLogs: (entries: Array<{
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
  ): Promise<CommitResult> {
    const isConfirm = buttonId.startsWith('confirm_meal_');
    const isCancel = buttonId.startsWith('cancel_meal_');

    if (!isConfirm && !isCancel) {
      return {
        handled: false,
        action: 'not_found',
        insertedCount: 0,
        messageText: 'Unrecognized action',
      };
    }

    const interactionId = buttonId.replace(isConfirm ? 'confirm_meal_' : 'cancel_meal_', '').trim();
    const interaction = await deps.getInteractionById(interactionId);

    if (!interaction) {
      return {
        handled: true,
        action: 'not_found',
        insertedCount: 0,
        messageText: 'Interaction not found or already purged',
      };
    }

    const recipientPhone = interaction.phone_number;

    // Check if already processed
    if (interaction.status !== 'pending') {
      const alreadyMsg = `This meal estimate was already ${interaction.status}. You can send a new meal anytime! 👍`;
      await metaClient.sendTextMessage(recipientPhone, alreadyMsg);
      return {
        handled: true,
        action: 'already_processed',
        insertedCount: 0,
        messageText: alreadyMsg,
      };
    }

    // Check expiration: 6-hour threshold
    const createdAtTime = new Date(interaction.created_at).getTime();
    const nowTime = Date.now();
    const sixHoursMs = 6 * 60 * 60 * 1000;
    if (nowTime - createdAtTime > sixHoursMs) {
      await deps.updateInteractionStatus(interactionId, 'expired');
      const expireMsg = '⏳ This meal confirmation expired (older than 6 hours). Please send a new voice note or text!';
      await metaClient.sendTextMessage(recipientPhone, expireMsg);
      return {
        handled: true,
        action: 'expired',
        insertedCount: 0,
        messageText: expireMsg,
      };
    }

    // Handle Cancel
    if (isCancel) {
      await deps.updateInteractionStatus(interactionId, 'cancelled');
      const cancelMsg = '❌ Meal logging cancelled. Send your next meal whenever you are ready!';
      await metaClient.sendTextMessage(recipientPhone, cancelMsg);
      return {
        handled: true,
        action: 'cancelled',
        insertedCount: 0,
        messageText: cancelMsg,
      };
    }

    // Handle Confirm
    if (isConfirm && interaction.user_id) {
      const items = (interaction.candidate_items || []) as Array<{
        food_name: string;
        quantity: number;
        unit: string;
        estimated_calories: number;
        protein_g: number;
        carbs_g: number;
        fat_g: number;
      }>;

      const slot = inferMealSlot(new Date(interaction.created_at));
      const foodLogEntries = items.map((item) => ({
        user_id: interaction.user_id!,
        logged_at: interaction.created_at,
        meal_slot: slot,
        food_name: item.food_name,
        portion_quantity: item.quantity,
        portion_unit: item.unit,
        calories: Math.round(item.estimated_calories * item.quantity * 10) / 10,
        protein_grams: Math.round(item.protein_g * item.quantity * 10) / 10,
        carbs_grams: Math.round(item.carbs_g * item.quantity * 10) / 10,
        fat_grams: Math.round(item.fat_g * item.quantity * 10) / 10,
      }));

      const inserted = await deps.insertFoodLogs(foodLogEntries);
      await deps.updateInteractionStatus(interactionId, 'confirmed');

      const successMsg =
        `✅ Logged ${inserted} dishes to your ${slot.toUpperCase()}!\n\n` +
        `Total: ~${Math.round(interaction.total_calories)} kcal logged.\n` +
        `View your updated progress in the FitKarma app! 🎯`;

      await metaClient.sendTextMessage(recipientPhone, successMsg);

      return {
        handled: true,
        action: 'confirmed',
        insertedCount: inserted,
        messageText: successMsg,
      };
    }

    return {
      handled: false,
      action: 'not_found',
      insertedCount: 0,
      messageText: 'Could not commit meal',
    };
  }
}

