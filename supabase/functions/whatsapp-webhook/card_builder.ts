// ============================================================================
// META WHATSAPP INTERACTIVE BUTTON CARD BUILDER
// ============================================================================

import type { MealPipelineOutput } from './meal_pipeline.ts';

export interface InteractiveMessagePayload {
  messaging_product: 'whatsapp';
  recipient_type: 'individual';
  to: string;
  type: 'interactive';
  interactive: {
    type: 'button';
    header: {
      type: 'text';
      text: string;
    };
    body: {
      text: string;
    };
    action: {
      buttons: Array<{
        type: 'reply';
        reply: {
          id: string;
          title: string;
        };
      }>;
    };
  };
}

export class WhatsAppCardBuilder {
  /**
   * Builds a Meta-compliant interactive Quick Reply message with max 3 buttons.
   * Body text stays well under Meta's 1024 character limit.
   */
  static buildMealConfirmationCard(
    to: string,
    interactionId: string,
    meal: MealPipelineOutput,
  ): InteractiveMessagePayload {
    // 1. Build itemized food list
    const itemsText = meal.items
      .map(
        (item) =>
          `• ${item.quantity} ${item.unit} ${item.food_name} (~${Math.round(
            item.estimated_calories * item.quantity,
          )} kcal)`,
      )
      .join('\n');

    // 2. Build macro summary line
    const macrosLine = `Total: ~${Math.round(meal.totalCalories)} kcal (P: ${meal.totalProtein}g, C: ${meal.totalCarbs}g, F: ${meal.totalFat}g)`;

    // 3. Assemble full body text
    const bodyText =
      `Aapka meal estimate ready hai:\n\n` +
      `${itemsText}\n\n` +
      `${macrosLine}\n` +
      `💡 ${meal.hinglishInsight}\n\n` +
      `⚠️ ${meal.statutoryDisclaimer}`;

    // 4. Return Meta Interactive Button Payload
    return {
      messaging_product: 'whatsapp',
      recipient_type: 'individual',
      to: to.replace('+', ''),
      type: 'interactive',
      interactive: {
        type: 'button',
        header: {
          type: 'text',
          text: '🍽️ FitKarma Meal Estimate',
        },
        body: {
          text: bodyText,
        },
        action: {
          buttons: [
            {
              type: 'reply',
              reply: {
                id: `confirm_meal_${interactionId}`,
                title: '✅ Confirm & Log',
              },
            },
            {
              type: 'reply',
              reply: {
                id: `cancel_meal_${interactionId}`,
                title: '❌ Cancel',
              },
            },
          ],
        },
      },
    };
  }
}

