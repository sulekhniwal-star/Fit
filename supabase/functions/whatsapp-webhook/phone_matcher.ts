// ============================================================================
// PHONE NUMBER NORMALIZATION & FITKARMA ACCOUNT RESOLVER
// ============================================================================

import type { UserProfileLookupResult } from './schemas.ts';

/**
 * Normalizes any incoming Indian phone string to standard E.164 format (+91XXXXXXXXXX).
 * Handles:
 * - "919876543210" -> "+919876543210"
 * - "+919876543210" -> "+919876543210"
 * - "09876543210" -> "+919876543210"
 * - "9876543210" -> "+919876543210"
 */
export function normalizeIndianPhoneNumber(rawPhone: string): string {
  if (!rawPhone) return '';

  // Remove non-digit characters except leading plus
  let cleaned = rawPhone.trim().replace(/[^\d+]/g, '');

  if (cleaned.startsWith('+')) {
    cleaned = cleaned.substring(1);
  }

  // Handle leading 0 (e.g. 09876543210)
  if (cleaned.startsWith('0') && cleaned.length === 11) {
    cleaned = cleaned.substring(1);
  }

  // If 10 digits (e.g. 9876543210), prefix with Indian country code 91
  if (cleaned.length === 10) {
    cleaned = '91' + cleaned;
  }

  // If 12 digits starting with 91, format with leading +
  if (cleaned.length === 12 && cleaned.startsWith('91')) {
    return '+' + cleaned;
  }

  return '+' + cleaned;
}

export type ProfileLookupFn = (e164Phone: string) => Promise<{
  id: string;
  user_id: string;
  display_name: string | null;
  phone_number: string;
} | null>;

/**
 * Resolves an inbound WhatsApp phone number to an existing FitKarma user profile.
 */
export async function resolveUserProfile(
  rawFrom: string,
  lookupFn: ProfileLookupFn,
): Promise<UserProfileLookupResult> {
  const normalized = normalizeIndianPhoneNumber(rawFrom);

  if (!normalized) {
    return { isLinked: false, phoneNumber: rawFrom };
  }

  const profile = await lookupFn(normalized);

  if (!profile) {
    return {
      isLinked: false,
      phoneNumber: normalized,
    };
  }

  return {
    isLinked: true,
    userId: profile.user_id,
    displayName: profile.display_name ?? undefined,
    phoneNumber: normalized,
  };
}

