// ============================================================================
// GROQ WHISPER SPEECH-TO-TEXT TRANSCRIBER (whisper-large-v3)
// ============================================================================

import { WhatsAppMediaFetcher, type MediaFetchResult } from './media_fetcher.ts';

export interface TranscriptionResult {
  text: string;
  detectedLanguage?: string;
  durationSeconds?: number;
  isMock?: boolean;
}

export class GroqAudioTranscriber {
  private readonly apiKey: string;
  private readonly isMock: boolean;

  constructor(options?: { apiKey?: string; isMock?: boolean }) {
    this.apiKey = options?.apiKey || '';
    this.isMock = options?.isMock || false;
  }

  /**
   * Transcribes Indian audio voice notes to text using Groq's whisper-large-v3 model.
   *
   * Audio buffer is securely zeroed out immediately following dispatch.
   */
  async transcribeAudio(media: MediaFetchResult): Promise<TranscriptionResult> {
    if (this.isMock || !this.apiKey) {
      // Clean buffer immediately in mock mode as well
      WhatsAppMediaFetcher.purgeEphemeralBuffer(media);
      return {
        text: 'Maine do roti aur ek katori dal tadka khaya',
        detectedLanguage: 'hi',
        durationSeconds: 4.5,
        isMock: true,
      };
    }

    try {
      const formData = new FormData();
      const audioBlob = new Blob([media.data], { type: media.mimeType });
      formData.append('file', audioBlob, 'voice_note.ogg');
      formData.append('model', 'whisper-large-v3');
      formData.append(
        'prompt',
        'Indian meal logging voice note in Hindi, English, or Hinglish: roti, dal, sabzi, katori, chawal, dahi, paneer, thali.',
      );
      formData.append('temperature', '0.0');

      const response = await fetch('https://api.groq.com/openai/v1/audio/transcriptions', {
        method: 'POST',
        headers: {
          Authorization: `Bearer ${this.apiKey}`,
        },
        body: formData,
      });

      if (!response.ok) {
        const errorText = await response.text();
        throw new Error(`Groq Whisper API error (${response.status}): ${errorText}`);
      }

      const json = (await response.json()) as { text?: string; language?: string; duration?: number };
      const transcribedText = (json.text || '').trim();

      return {
        text: transcribedText,
        detectedLanguage: json.language || 'hi',
        durationSeconds: json.duration,
      };
    } finally {
      // DPDP Act 2023: Zero out memory buffer immediately after sending
      WhatsAppMediaFetcher.purgeEphemeralBuffer(media);
    }
  }
}

