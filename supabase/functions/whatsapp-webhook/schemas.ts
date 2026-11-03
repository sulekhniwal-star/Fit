// ============================================================================
// META WHATSAPP BUSINESS CLOUD API WEBHOOK SCHEMAS
// ============================================================================

export interface MetaContact {
  profile?: {
    name?: string;
  };
  wa_id: string; // e.g., "919876543210"
}

export interface MetaTextMessage {
  from: string;
  id: string; // wamid.HBgM...
  timestamp: string;
  type: 'text';
  text: {
    body: string;
  };
}

export interface MetaAudioMessage {
  from: string;
  id: string;
  timestamp: string;
  type: 'audio' | 'voice';
  audio: {
    id: string; // media ID
    mime_type: string;
  };
}

export interface MetaInteractiveButtonReply {
  from: string;
  id: string;
  timestamp: string;
  type: 'interactive';
  interactive: {
    type: 'button_reply';
    button_reply: {
      id: string; // e.g. "confirm_meal_UUID"
      title: string;
    };
  };
}

export type MetaInboundMessage =
  | MetaTextMessage
  | MetaAudioMessage
  | MetaInteractiveButtonReply;

export interface MetaWebhookChangeValue {
  messaging_product: 'whatsapp';
  metadata: {
    display_phone_number: string;
    phone_number_id: string;
  };
  contacts?: MetaContact[];
  messages?: MetaInboundMessage[];
}

export interface MetaWebhookEntry {
  id: string;
  changes: Array<{
    value: MetaWebhookChangeValue;
    field: string;
  }>;
}

export interface MetaWebhookPayload {
  object: 'whatsapp_business_account';
  entry: MetaWebhookEntry[];
}

export interface UserProfileLookupResult {
  isLinked: boolean;
  userId?: string;
  displayName?: string;
  phoneNumber: string;
}

export interface WhatsAppInteractionRecord {
  id: string;
  user_id: string | null;
  wa_message_id: string;
  phone_number: string;
  message_type: 'text' | 'audio' | 'interactive';
  raw_input: string | null;
  candidate_items: unknown[];
  total_calories: number;
  total_protein: number;
  total_carbs: number;
  total_fat: number;
  status: 'pending' | 'confirmed' | 'cancelled' | 'unlinked_user' | 'expired';
  metadata?: Record<string, unknown>;
  created_at: string;
  updated_at: string;
}
