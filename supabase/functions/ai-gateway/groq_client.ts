// FitKarma Groq AI Multi-Model Client (TASK 058)
import {
  MEAL_ANALYSIS_SYSTEM_PROMPT,
  HINGLISH_COACHING_SYSTEM_PROMPT,
  type MealAnalysisPayload,
  type HinglishCoachingPayload,
  validateAndNormalizeMealResponse,
} from './schemas.ts';

export interface GroqClientOptions {
  apiKey?: string;
  baseUrl?: string;
  timeoutMs?: number;
  maxRetries?: number;
  isMock?: boolean;
}

export class GroqClient {
  private readonly apiKey: string;
  private readonly baseUrl: string;
  private readonly timeoutMs: number;
  private readonly maxRetries: number;
  private readonly isMock: boolean;

  constructor(options: GroqClientOptions = {}) {
    const envApiKey = typeof Deno !== 'undefined' ? Deno.env.get('GROQ_API_KEY') : (typeof process !== 'undefined' ? process.env.GROQ_API_KEY : '');
    const envAppEnv = typeof Deno !== 'undefined' ? Deno.env.get('APP_ENV') : (typeof process !== 'undefined' ? process.env.APP_ENV : '');
    this.apiKey = options.apiKey ?? envApiKey ?? '';
    this.baseUrl = options.baseUrl ?? 'https://api.groq.com/openai/v1/chat/completions';
    this.timeoutMs = options.timeoutMs ?? 15000;
    this.maxRetries = options.maxRetries ?? 2;
    this.isMock = options.isMock ?? (this.apiKey.length === 0 || envAppEnv === 'test');
  }

  async analyzeMealText(prompt: string): Promise<MealAnalysisPayload> {
    if (this.isMock) {
      return this._generateMockMealAnalysis(prompt);
    }

    const body = {
      model: 'llama-3.3-70b-versatile',
      messages: [
        { role: 'system', content: MEAL_ANALYSIS_SYSTEM_PROMPT },
        { role: 'user', content: `Analyze this Indian meal: "${prompt}"` },
      ],
      response_format: { type: 'json_object' },
      temperature: 0.2,
      max_tokens: 1024,
    };

    const rawResponse = await this._postWithRetry(body);
    const parsed = JSON.parse(rawResponse);
    return validateAndNormalizeMealResponse(parsed);
  }

  async analyzeMealPhoto(imageBase64: string): Promise<MealAnalysisPayload> {
    if (this.isMock) {
      return this._generateMockPhotoAnalysis();
    }

    // Ensure data URL prefix format
    const formattedUrl = imageBase64.startsWith('data:')
      ? imageBase64
      : `data:image/jpeg;base64,${imageBase64}`;

    const body = {
      model: 'llama-3.2-11b-vision-preview',
      messages: [
        { role: 'system', content: MEAL_ANALYSIS_SYSTEM_PROMPT },
        {
          role: 'user',
          content: [
            {
              type: 'text',
              text: 'Identify all visible Indian dishes, bowls/katoris, bread counts, and portion volumes in this food image.',
            },
            {
              type: 'image_url',
              image_url: { url: formattedUrl },
            },
          ],
        },
      ],
      response_format: { type: 'json_object' },
      temperature: 0.2,
      max_tokens: 1024,
    };

    const rawResponse = await this._postWithRetry(body);
    const parsed = JSON.parse(rawResponse);
    return validateAndNormalizeMealResponse(parsed);
  }

  async generateHinglishCoaching(
    contextText: string,
    macros: { calories: number; protein: number; carbs: number; fat: number }
  ): Promise<HinglishCoachingPayload> {
    if (this.isMock) {
      return {
        headline: 'Badhiya Meal!',
        hinglish_text:
          'Aapka meal well-balanced hai! Protein target achieve karne ke liye dinner mein paneer ya dahi zaroor include karein.',
        tone: 'supportive',
        statutory_disclaimer: 'Lifestyle wellness indicator only.',
      };
    }

    const body = {
      model: 'llama-3.1-8b-instant',
      messages: [
        { role: 'system', content: HINGLISH_COACHING_SYSTEM_PROMPT },
        {
          role: 'user',
          content: `User logged meal context: "${contextText}". Cumulative macros today: ${macros.calories} kcal, ${macros.protein}g protein, ${macros.carbs}g carbs, ${macros.fat}g fat. Give a supportive 2-line Hinglish tip.`,
        },
      ],
      response_format: { type: 'json_object' },
      temperature: 0.5,
      max_tokens: 256,
    };

    const rawResponse = await this._postWithRetry(body);
    const parsed = JSON.parse(rawResponse);

    return {
      headline: typeof parsed.headline === 'string' ? parsed.headline : 'Health Coaching Insight',
      hinglish_text:
        typeof parsed.hinglish_text === 'string'
          ? parsed.hinglish_text
          : 'Badhiya tracking! Consistent hydration aur balanced diet maintain karein.',
      tone: typeof parsed.tone === 'string' ? parsed.tone : 'supportive',
      statutory_disclaimer: 'Lifestyle wellness indicator only.',
    };
  }

  private async _postWithRetry(payload: Record<string, unknown>): Promise<string> {
    let lastError: Error = new Error('Unknown network failure');

    for (let attempt = 0; attempt <= this.maxRetries; attempt++) {
      const controller = new AbortController();
      const timeoutId = setTimeout(() => controller.abort(), this.timeoutMs);

      try {
        const response = await fetch(this.baseUrl, {
          method: 'POST',
          headers: {
            'Content-Type': 'application/json',
            Authorization: `Bearer ${this.apiKey}`,
          },
          body: JSON.stringify(payload),
          signal: controller.signal,
        });

        clearTimeout(timeoutId);

        if (response.ok) {
          const resJson = await response.json();
          const content = resJson.choices?.[0]?.message?.content;
          if (typeof content !== 'string') {
            throw new Error('Groq returned empty response content');
          }
          return content;
        }

        if (response.status === 429 || response.status >= 500) {
          // Retryable rate limit or upstream error
          const delayMs = Math.pow(2, attempt) * 1000;
          await new Promise((r) => setTimeout(r, delayMs));
          continue;
        }

        // Non-retryable client error
        const errText = await response.text();
        throw new Error(`Groq API error (${response.status}): ${errText}`);
      } catch (err: unknown) {
        clearTimeout(timeoutId);
        lastError = err instanceof Error ? err : new Error(String(err));
        if (attempt === this.maxRetries) break;
      }
    }

    throw lastError;
  }

  private _generateMockMealAnalysis(prompt: string): MealAnalysisPayload {
    const lower = prompt.toLowerCase();
    const items = [];

    if (lower.includes('roti') || lower.includes('phulka') || lower.includes('chapati')) {
      items.push({
        food_name: 'Phulka / Roti',
        matched_category: 'grains',
        quantity: 2.0,
        unit: 'piece',
        cooking_state: 'cooked',
        tadka_level: 'none',
        estimated_calories: 160.0,
        protein_g: 6.0,
        carbs_g: 32.0,
        fat_g: 1.0,
        confidence: 0.96,
      });
    }

    if (lower.includes('dal') || lower.includes('daal')) {
      items.push({
        food_name: 'Dal Tadka',
        matched_category: 'pulses',
        quantity: 1.0,
        unit: 'medium_katori',
        cooking_state: 'cooked',
        tadka_level: 'medium',
        estimated_calories: 180.0,
        protein_g: 9.0,
        carbs_g: 22.0,
        fat_g: 6.0,
        confidence: 0.92,
      });
    }

    if (lower.includes('paneer')) {
      items.push({
        food_name: 'Paneer Bhurji',
        matched_category: 'dairy',
        quantity: 0.5,
        unit: 'medium_katori',
        cooking_state: 'cooked',
        tadka_level: 'medium',
        estimated_calories: 190.0,
        protein_g: 11.0,
        carbs_g: 4.0,
        fat_g: 14.0,
        confidence: 0.90,
      });
    }

    if (lower.includes('curd') || lower.includes('dahi')) {
      items.push({
        food_name: 'Dahi / Plain Curd',
        matched_category: 'dairy',
        quantity: 1.0,
        unit: 'small_katori',
        cooking_state: 'raw',
        tadka_level: 'none',
        estimated_calories: 85.0,
        protein_g: 4.5,
        carbs_g: 6.0,
        fat_g: 5.0,
        confidence: 0.95,
      });
    }

    if (items.length === 0) {
      items.push({
        food_name: 'Homestyle Indian Sabzi & Rice',
        matched_category: 'grains',
        quantity: 1.0,
        unit: 'medium_katori',
        cooking_state: 'cooked',
        tadka_level: 'medium',
        estimated_calories: 280.0,
        protein_g: 7.0,
        carbs_g: 45.0,
        fat_g: 8.0,
        confidence: 0.82,
      });
    }

    return {
      summary: `Estimated ${items.length} items from input: "${prompt}"`,
      items,
      confidence_overall: 0.91,
      uncertainty_reasons: ['Tadka ghee/oil estimated using standard homestyle average'],
      hinglish_insight: 'Badhiya meal! Balanced portions aur home-cooked food maintain karein.',
      statutory_disclaimer: 'Nutritional estimate only. Not clinical or medical guidance.',
    };
  }

  private _generateMockPhotoAnalysis(): MealAnalysisPayload {
    return {
      summary: 'Detected Indian Thali with Roti, Dal, and Mixed Vegetable Curry',
      items: [
        {
          food_name: 'Phulka / Roti',
          matched_category: 'grains',
          quantity: 2.0,
          unit: 'piece',
          cooking_state: 'cooked',
          tadka_level: 'none',
          estimated_calories: 160.0,
          protein_g: 6.0,
          carbs_g: 32.0,
          fat_g: 1.0,
          confidence: 0.94,
        },
        {
          food_name: 'Dal Tadka',
          matched_category: 'pulses',
          quantity: 1.0,
          unit: 'small_katori',
          cooking_state: 'cooked',
          tadka_level: 'medium',
          estimated_calories: 150.0,
          protein_g: 7.5,
          carbs_g: 18.0,
          fat_g: 5.0,
          confidence: 0.88,
        },
        {
          food_name: 'Aloo Gobi Sabzi',
          matched_category: 'vegetables',
          quantity: 1.0,
          unit: 'medium_katori',
          cooking_state: 'cooked',
          tadka_level: 'medium',
          estimated_calories: 140.0,
          protein_g: 3.5,
          carbs_g: 18.0,
          fat_g: 6.0,
          confidence: 0.85,
        },
      ],
      confidence_overall: 0.89,
      uncertainty_reasons: [
        'Depth perception on katori depth is approximate from single photo angle',
      ],
      hinglish_insight: 'Thali mein portion sizes sahi dikh rahe hain! Khushi se enjoy karein.',
      statutory_disclaimer: 'Nutritional estimate only. Not clinical or medical guidance.',
    };
  }
}
