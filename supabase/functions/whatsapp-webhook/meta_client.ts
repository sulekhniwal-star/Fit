// ============================================================================
// META WHATSAPP BUSINESS CLOUD API CLIENT
// ============================================================================

export interface WhatsAppSendResult {
  success: boolean;
  messageId?: string;
  error?: string;
}

export class MetaWhatsAppClient {
  private readonly accessToken: string;
  private readonly phoneNumberId: string;
  private readonly isMock: boolean;

  constructor(options?: {
    accessToken?: string;
    phoneNumberId?: string;
    isMock?: boolean;
  }) {
    this.accessToken = options?.accessToken || '';
    this.phoneNumberId = options?.phoneNumberId || '';
    this.isMock = options?.isMock || false;
  }

  /**
   * Sends a simple text message back to a user on WhatsApp.
   */
  async sendTextMessage(to: string, text: string): Promise<WhatsAppSendResult> {
    if (this.isMock || !this.accessToken) {
      return {
        success: true,
        messageId: `mock_wa_msg_${Date.now()}`,
      };
    }

    try {
      const url = `https://graph.facebook.com/v21.0/${this.phoneNumberId}/messages`;
      const response = await fetch(url, {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          Authorization: `Bearer ${this.accessToken}`,
        },
        body: JSON.stringify({
          messaging_product: 'whatsapp',
          recipient_type: 'individual',
          to: to.replace('+', ''),
          type: 'text',
          text: {
            preview_url: false,
            body: text,
          },
        }),
      });

      if (!response.ok) {
        const errorText = await response.text();
        return { success: false, error: `Meta API error (${response.status}): ${errorText}` };
      }

      const json = await response.json();
      const messageId = json.messages?.[0]?.id;
      return { success: true, messageId };
    } catch (e) {
      return { success: false, error: `Network error sending WhatsApp message: ${e}` };
    }
  }

  /**
   * Sends an interactive message (e.g. quick reply buttons) back to a user on WhatsApp.
   */
  async sendInteractiveMessage(payload: unknown): Promise<WhatsAppSendResult> {
    if (this.isMock || !this.accessToken) {
      return {
        success: true,
        messageId: `mock_interactive_msg_${Date.now()}`,
      };
    }

    try {
      const url = `https://graph.facebook.com/v21.0/${this.phoneNumberId}/messages`;
      const response = await fetch(url, {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          Authorization: `Bearer ${this.accessToken}`,
        },
        body: JSON.stringify(payload),
      });

      if (!response.ok) {
        const errorText = await response.text();
        return { success: false, error: `Meta API error (${response.status}): ${errorText}` };
      }

      const json = await response.json();
      const messageId = json.messages?.[0]?.id;
      return { success: true, messageId };
    } catch (e) {
      return { success: false, error: `Network error sending WhatsApp interactive message: ${e}` };
    }
  }

  /**
   * Sends a friendly onboarding template to an unregistered sender.
   */
  async sendUnlinkedInvitation(to: string): Promise<WhatsAppSendResult> {
    const text =
      `Namaste! 🙏\n\n` +
      `This phone number (${to}) is not yet linked to an active FitKarma account.\n\n` +
      `To log meals, workouts, and track health via WhatsApp in 5 seconds:\n` +
      `1. Download the FitKarma app: https://fitkarma.app/download\n` +
      `2. Sign in with this mobile number\n` +
      `3. Return here and send your meal description or voice note!\n\n` +
      `Stay healthy! 🥗`;

    return this.sendTextMessage(to, text);
  }
}

