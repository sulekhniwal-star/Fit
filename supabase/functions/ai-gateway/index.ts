// FitKarma Server-Side AI Gateway (TASK 058, TASK 059, TASK 063)
import { successResponse, errorResponse } from '../_shared/envelope.ts';
import { GroqClient } from './groq_client.ts';
import { sanitizePromptText, applyMedicalGuardrailsToResponse } from './guardrails.ts';

const groqClient = new GroqClient();

Deno.serve(async (req: Request) => {
  const requestId = req.headers.get('x-request-id') ?? crypto.randomUUID();

  // 1. CORS headers
  if (req.method === 'OPTIONS') {
    return new Response(null, {
      status: 204,
      headers: {
        'Access-Control-Allow-Origin': '*',
        'Access-Control-Allow-Methods': 'POST, OPTIONS',
        'Access-Control-Allow-Headers': 'authorization, x-client-info, apikey, content-type, x-request-id',
      },
    });
  }

  if (req.method !== 'POST') {
    return new Response(
      JSON.stringify(errorResponse(requestId, 'FK-2001', 'Method not allowed. Use POST.')),
      { status: 405, headers: { 'Content-Type': 'application/json' } }
    );
  }

  // 2. Authentication check (Bearer Token)
  const authHeader = req.headers.get('authorization');
  if (!authHeader || !authHeader.startsWith('Bearer ')) {
    return new Response(
      JSON.stringify(errorResponse(requestId, 'FK-1001', 'Authentication token required (FK-1001)')),
      { status: 401, headers: { 'Content-Type': 'application/json' } }
    );
  }

  try {
    const rawBody = await req.json();
    const payload = rawBody?.payload ?? rawBody;
    const taskType = payload?.task_type;

    if (!taskType || typeof taskType !== 'string') {
      return new Response(
        JSON.stringify(
          errorResponse(
            requestId,
            'FK-2001',
            'Missing or invalid "task_type". Supported: meal_text_analysis, meal_photo_analysis, hinglish_coaching'
          )
        ),
        { status: 400, headers: { 'Content-Type': 'application/json' } }
      );
    }

    if (taskType === 'meal_text_analysis') {
      const promptText = payload.prompt;
      if (typeof promptText !== 'string' || promptText.trim().length === 0) {
        return new Response(
          JSON.stringify(errorResponse(requestId, 'FK-2001', 'Prompt text is required for meal_text_analysis')),
          { status: 400, headers: { 'Content-Type': 'application/json' } }
        );
      }

      // Step 1: PII Sanitization
      const cleanPrompt = sanitizePromptText(promptText);

      // Step 2: Groq Multi-Model Text Inference
      const analysis = await groqClient.analyzeMealText(cleanPrompt);

      // Step 3: Medical Boundary Guardrails Enforcement
      const { result, warnings } = applyMedicalGuardrailsToResponse(
        analysis as unknown as Record<string, unknown>
      );

      const response = successResponse(requestId, result, warnings);
      return new Response(JSON.stringify(response), {
        status: 200,
        headers: { 'Content-Type': 'application/json', 'x-request-id': requestId },
      });
    }

    if (taskType === 'meal_photo_analysis') {
      const imageBase64 = payload.image_base64;
      if (typeof imageBase64 !== 'string' || imageBase64.length === 0) {
        return new Response(
          JSON.stringify(errorResponse(requestId, 'FK-2001', 'Image data is required for meal_photo_analysis')),
          { status: 400, headers: { 'Content-Type': 'application/json' } }
        );
      }

      // Step 1: Groq Vision Inference (Ephemerally processed)
      const analysis = await groqClient.analyzeMealPhoto(imageBase64);

      // Step 2: Medical Guardrails Enforcement
      const { result, warnings } = applyMedicalGuardrailsToResponse(
        analysis as unknown as Record<string, unknown>
      );

      const response = successResponse(requestId, result, warnings);
      return new Response(JSON.stringify(response), {
        status: 200,
        headers: { 'Content-Type': 'application/json', 'x-request-id': requestId },
      });
    }

    if (taskType === 'hinglish_coaching') {
      const contextText = typeof payload.context === 'string' ? payload.context : 'Balanced meal';
      const macros = {
        calories: Number(payload.macros?.calories ?? 500),
        protein: Number(payload.macros?.protein ?? 20),
        carbs: Number(payload.macros?.carbs ?? 60),
        fat: Number(payload.macros?.fat ?? 15),
      };

      const coaching = await groqClient.generateHinglishCoaching(contextText, macros);

      const { result, warnings } = applyMedicalGuardrailsToResponse(
        coaching as unknown as Record<string, unknown>
      );

      const response = successResponse(requestId, result, warnings);
      return new Response(JSON.stringify(response), {
        status: 200,
        headers: { 'Content-Type': 'application/json', 'x-request-id': requestId },
      });
    }

    return new Response(
      JSON.stringify(errorResponse(requestId, 'FK-2001', `Unknown task_type: ${taskType}`)),
      { status: 400, headers: { 'Content-Type': 'application/json' } }
    );
  } catch (err: unknown) {
    const errorMsg = err instanceof Error ? err.message : String(err);
    const isTimeout = errorMsg.toLowerCase().includes('timeout') || errorMsg.toLowerCase().includes('aborted');

    const errCode = isTimeout ? 'FK-6001' : 'FK-4001';
    const clientSafeMessage = isTimeout
      ? 'AI provider timed out. Retrying with deterministic local baseline.'
      : 'AI parsing failed. Please adjust meal text or use manual search.';

    const response = errorResponse(requestId, errCode, clientSafeMessage, isTimeout);
    return new Response(JSON.stringify(response), {
      status: isTimeout ? 504 : 502,
      headers: { 'Content-Type': 'application/json', 'x-request-id': requestId },
    });
  }
});
