// Unit & Guardrail Verification for AI Gateway (TASK 058, 059, 063)
import { sanitizePromptText, enforceMedicalBoundaryOnText, applyMedicalGuardrailsToResponse } from './guardrails.ts';
import { validateAndNormalizeMealResponse } from './schemas.ts';
import { GroqClient } from './groq_client.ts';

// Simple assertion helper
function assert(condition: boolean, message: string) {
  if (!condition) {
    throw new Error(`Assertion failed: ${message}`);
  }
}

async function runTests() {
  console.log('--- Running AI Gateway Guardrails & Schema Tests ---');

  // Test 1: PII Sanitization
  const sampleWithPii = 'My number is +91-9876543210 and email test.user@gmail.com. I ate 2 rotis with Bearer eyJhbGciOiJIUzI1Ni';
  const scrubbed = sanitizePromptText(sampleWithPii);
  assert(!scrubbed.includes('+91-9876543210'), 'Phone number should be redacted');
  assert(!scrubbed.includes('test.user@gmail.com'), 'Email should be redacted');
  assert(scrubbed.includes('[REDACTED_PHONE]'), 'Redacted phone tag present');
  assert(scrubbed.includes('[REDACTED_EMAIL]'), 'Redacted email tag present');
  assert(scrubbed.includes('[REDACTED_TOKEN]'), 'Auth token redacted');
  console.log('✓ Test 1: PII Sanitization passed');

  // Test 2: Medical Boundary Guardrails
  const medicalViolation = 'Drinking this bitter gourd juice cures diabetes completely and you should stop taking insulin!';
  const boundaryCheck = enforceMedicalBoundaryOnText(medicalViolation);
  assert(boundaryCheck.isProhibited, 'Prohibited medical claim must be flagged');
  assert(!boundaryCheck.sanitizedText.includes('cures diabetes'), 'Cure claim should be sanitized');
  assert(boundaryCheck.warningNotice?.includes('wellness tracking estimates'), 'Statutory disclaimer attached');
  console.log('✓ Test 2: Medical Boundary Guardrail passed');

  // Test 3: Response Guardrails & Mandatory Disclaimer
  const mockResponse = {
    summary: 'Ate 2 rotis and kadha which cures cancer completely.',
    hinglish_insight: 'Badhiya meal, stop taking medication if you feel good!',
    items: [],
  };
  const { result, warnings } = applyMedicalGuardrailsToResponse(mockResponse);
  assert(warnings.length >= 2, 'Should have flagged two prohibited medical claims');
  assert(!String(result.summary).includes('cures cancer'), 'Summary cured claim sanitized');
  assert(typeof result.statutory_disclaimer === 'string', 'Statutory disclaimer guaranteed');
  console.log('✓ Test 3: Response Guardrail Sanitation passed');

  // Test 4: Schema Validation with Malformed / Incomplete Input
  const malformedInput = {
    summary: 'Partial meal',
    items: [
      {
        food_name: 'Dal',
        quantity: -5, // Invalid negative
        estimated_calories: 200,
      },
    ],
    confidence_overall: 1.5, // Clamped to 1.0
  };
  const normalized = validateAndNormalizeMealResponse(malformedInput);
  assert(normalized.items.length === 1, 'Normalized items count matches');
  assert(normalized.items[0].quantity === 1.0, 'Invalid quantity fallback to 1.0');
  assert(normalized.confidence_overall === 1.0, 'Confidence clamped to 1.0');
  assert(normalized.statutory_disclaimer.length > 0, 'Disclaimer present in schema');
  console.log('✓ Test 4: Schema Validation and Normalization passed');

  // Test 5: GroqClient Mock Routing
  const client = new GroqClient({ isMock: true });
  const textRes = await client.analyzeMealText('2 rotis and 1 katori dal tadka with curd');
  assert(textRes.items.length >= 3, 'Mock should identify roti, dal, and curd');
  assert(textRes.items.some((i) => i.food_name.includes('Roti')), 'Identified roti');
  assert(textRes.items.some((i) => i.food_name.includes('Dal')), 'Identified dal');

  const photoRes = await client.analyzeMealPhoto('base64dummydata');
  assert(photoRes.items.length >= 2, 'Photo mock should return candidate items');
  console.log('✓ Test 5: GroqClient Multi-Model Mock Routing passed');

  console.log('--- ALL AI GATEWAY TESTS PASSED ---');
}

runTests().catch((e) => {
  console.error(e);
  if (typeof process !== 'undefined') {
    process.exit(1);
  }
});
