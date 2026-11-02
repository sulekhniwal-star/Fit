export interface ApiRequest<T = Record<string, unknown>> {
  request_id: string;
  idempotency_key?: string;
  payload: T;
}

export interface ApiError {
  code: string; // FK-xxxx
  message: string;
  retryable: boolean;
  request_id?: string;
}

export interface ApiResponse<T = Record<string, unknown>> {
  request_id: string;
  data: T | null;
  warnings: string[];
  error: ApiError | null;
}

export function successResponse<T>(requestId: string, data: T, warnings: string[] = []): ApiResponse<T> {
  return {
    request_id: requestId,
    data,
    warnings,
    error: null,
  };
}

export function errorResponse(requestId: string, code: string, message: string, retryable = false): ApiResponse<null> {
  return {
    request_id: requestId,
    data: null,
    warnings: [],
    error: {
      code,
      message,
      retryable,
      request_id: requestId,
    },
  };
}

