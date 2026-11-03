// ============================================================================
// META WHATSAPP WEBHOOK HMAC-SHA256 SIGNATURE VERIFICATION
// ============================================================================

/**
 * Verifies that an incoming webhook payload was authentically signed by Meta
 * using the configured WHATSAPP_APP_SECRET.
 *
 * Header format: `X-Hub-Signature-256: sha256=<hex_digest>`
 */
export async function verifyMetaSignature(
  rawBody: string,
  signatureHeader: string | null,
  appSecret: string,
): Promise<boolean> {
  if (!signatureHeader || !signatureHeader.startsWith('sha256=')) {
    return false;
  }

  if (!appSecret || appSecret.trim() === '') {
    return false;
  }

  const expectedSignatureHex = signatureHeader.substring('sha256='.length).trim();

  try {
    const encoder = new TextEncoder();
    const keyData = encoder.encode(appSecret);
    const bodyData = encoder.encode(rawBody);

    const cryptoKey = await crypto.subtle.importKey(
      'raw',
      keyData,
      { name: 'HMAC', hash: 'SHA-256' },
      false,
      ['sign'],
    );

    const signatureBuffer = await crypto.subtle.sign('HMAC', cryptoKey, bodyData);
    const computedSignatureHex = Array.from(new Uint8Array(signatureBuffer))
      .map((b) => b.toString(16).padStart(2, '0'))
      .join('');

    return constantTimeEqual(computedSignatureHex, expectedSignatureHex);
  } catch (_e) {
    return false;
  }
}

/**
 * Constant-time string equality comparison to prevent timing attacks.
 */
export function constantTimeEqual(a: string, b: string): boolean {
  if (a.length !== b.length) {
    return false;
  }

  let result = 0;
  for (let i = 0; i < a.length; i++) {
    result |= a.charCodeAt(i) ^ b.charCodeAt(i);
  }

  return result === 0;
}
