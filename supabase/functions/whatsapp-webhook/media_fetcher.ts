// ============================================================================
// META GRAPH API EPHEMERAL MEDIA FETCHER (DPDP ACT 2023 COMPLIANT)
// ============================================================================

export interface MediaFetchResult {
  mimeType: string;
  data: Uint8Array;
  byteLength: number;
}

export class WhatsAppMediaFetcher {
  private readonly accessToken: string;
  private readonly isMock: boolean;

  constructor(options?: { accessToken?: string; isMock?: boolean }) {
    this.accessToken = options?.accessToken || '';
    this.isMock = options?.isMock || false;
  }

  /**
   * Downloads an audio/voice note stream from Meta Graph API entirely in memory.
   *
   * DPDP Act 2023 Compliance Guarantee:
   * - Never written to temporary storage, file system, or persistent cloud bucket.
   * - Retained exclusively in ephemeral RAM for the duration of transcription.
   */
  async fetchAudioBytes(mediaId: string): Promise<MediaFetchResult> {
    if (this.isMock || !this.accessToken) {
      // Mock audio binary: 128 bytes simulating OGG Opus container
      const mockBytes = new Uint8Array(128);
      for (let i = 0; i < mockBytes.length; i++) mockBytes[i] = i % 256;
      return {
        mimeType: 'audio/ogg; codecs=opus',
        data: mockBytes,
        byteLength: mockBytes.length,
      };
    }

    // Step 1: Query Meta Graph API for temporary download URL
    const metaUrl = `https://graph.facebook.com/v21.0/${mediaId}`;
    const metaResponse = await fetch(metaUrl, {
      headers: {
        Authorization: `Bearer ${this.accessToken}`,
      },
    });

    if (!metaResponse.ok) {
      const err = await metaResponse.text();
      throw new Error(`Failed to retrieve media URL from Meta (${metaResponse.status}): ${err}`);
    }

    const metaJson = (await metaResponse.json()) as { url?: string; mime_type?: string };
    if (!metaJson.url) {
      throw new Error('Meta Graph API response did not contain media download URL');
    }

    // Step 2: Download the raw audio stream in memory with 10MB limit and 15s timeout
    const controller = new AbortController();
    const timeout = setTimeout(() => controller.abort(), 15000);

    try {
      const downloadResponse = await fetch(metaJson.url, {
        headers: {
          Authorization: `Bearer ${this.accessToken}`,
          'User-Agent': 'FitKarma-HealthOS-AudioFetcher/1.0',
        },
        signal: controller.signal,
      });

      if (!downloadResponse.ok) {
        throw new Error(`Failed to download audio binary (${downloadResponse.status})`);
      }

      const buffer = await downloadResponse.arrayBuffer();
      const uint8 = new Uint8Array(buffer);

      if (uint8.byteLength > 10 * 1024 * 1024) {
        throw new Error(`Audio exceeds maximum 10MB size limit (${uint8.byteLength} bytes)`);
      }

      return {
        mimeType: metaJson.mime_type || 'audio/ogg',
        data: uint8,
        byteLength: uint8.byteLength,
      };
    } finally {
      clearTimeout(timeout);
    }
  }

  /**
   * Securely zeroes out in-memory audio buffers after transcription.
   */
  static purgeEphemeralBuffer(result: MediaFetchResult): void {
    result.data.fill(0);
  }
}
