import { successResponse } from '../_shared/envelope.ts';

Deno.serve(async (req: Request) => {
  const requestId = req.headers.get('x-request-id') ?? crypto.randomUUID();

  const response = successResponse(requestId, {
    status: 'healthy',
    timestamp: new Date().toISOString(),
    service: 'FitKarma Supabase Edge API',
  });

  return new Response(JSON.stringify(response), {
    headers: {
      'Content-Type': 'application/json',
      'x-request-id': requestId,
    },
    status: 200,
  });
});

