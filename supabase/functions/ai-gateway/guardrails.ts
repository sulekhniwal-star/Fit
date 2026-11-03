// FitKarma AI Safety & Medical Boundary Guardrails (TASK 059, TASK 063)

export function sanitizePromptText(text: string): string {
  let sanitized = text;

  // 1. Scrub Indian Phone Numbers (+91-9876543210, 9876543210)
  sanitized = sanitized.replace(/(?:\+91[\-\s]?)?[6-9]\d{9}/g, '[REDACTED_PHONE]');

  // 2. Scrub Emails
  sanitized = sanitized.replace(/[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}/g, '[REDACTED_EMAIL]');

  // 3. Scrub Bearer Auth Tokens
  sanitized = sanitized.replace(/Bearer\s+[A-Za-z0-9\-._~+/]+=*/gi, '[REDACTED_TOKEN]');

  return sanitized;
}

const PROHIBITED_MEDICAL_REGEXES = [
  // Cures chronic diseases
  /cure[sd]?\s+(?:diabetes|cancer|hypertension|thyroid|pcos|pcod|cardiovascular|heart\s+disease)/i,
  // Ayurvedic curative claims
  /(?:ayurveda|ayurvedic|kadha|herb[s]?)\s+(?:cures?|eradicates?)\s+[a-z\s]+/i,
  // Prescription overrides
  /stop\s+(?:taking|using|your)\s+(?:medicine|insulin|medication|pills|prescription)/i,
  // Clinical diagnostic assertions
  /you\s+(?:have|are\s+diagnosed\s+with)\s+(?:diabetes|hypertension|clinical\s+obesity)/i,
];

export const MANDATORY_STATUTORY_DISCLAIMER =
  'FitKarma observations are personal lifestyle and wellness tracking estimates only. ' +
  'They do not constitute medical diagnosis, clinical treatment, or physician advice.';

export interface MedicalBoundaryResult {
  isProhibited: boolean;
  sanitizedText: string;
  warningNotice?: string;
}

export function enforceMedicalBoundaryOnText(text: string): MedicalBoundaryResult {
  let hasViolation = false;
  let cleaned = text;

  for (const regex of PROHIBITED_MEDICAL_REGEXES) {
    if (regex.test(cleaned)) {
      hasViolation = true;
      cleaned = cleaned.replace(regex, '[Medical claims removed]');
    }
  }

  if (hasViolation) {
    return {
      isProhibited: true,
      sanitizedText: cleaned,
      warningNotice: MANDATORY_STATUTORY_DISCLAIMER,
    };
  }

  return {
    isProhibited: false,
    sanitizedText: text,
  };
}

export function applyMedicalGuardrailsToResponse(
  responseObj: Record<string, unknown>
): { result: Record<string, unknown>; warnings: string[] } {
  const warnings: string[] = [];
  const cloned = { ...responseObj };

  // Check summary
  if (typeof cloned.summary === 'string') {
    const check = enforceMedicalBoundaryOnText(cloned.summary);
    if (check.isProhibited) {
      cloned.summary = check.sanitizedText;
      warnings.push('Prohibited clinical medical claim filtered from summary.');
    }
  }

  // Check Hinglish insight
  if (typeof cloned.hinglish_insight === 'string') {
    const check = enforceMedicalBoundaryOnText(cloned.hinglish_insight);
    if (check.isProhibited) {
      cloned.hinglish_insight = check.sanitizedText;
      warnings.push('Prohibited medical advice filtered from coaching response.');
    }
  }

  // Guarantee statutory disclaimer
  cloned.statutory_disclaimer = MANDATORY_STATUTORY_DISCLAIMER;

  return { result: cloned, warnings };
}
