// ============================================================================
// CONVERSATIONAL MEAL EXTRACTION & SAFETY PIPELINE
// ============================================================================

import { enforceMedicalBoundaryOnText } from '../ai-gateway/guardrails.ts';

export interface ExtractedFoodCandidate {
  food_name: string;
  quantity: number;
  unit: string;
  estimated_calories: number;
  protein_g: number;
  carbs_g: number;
  fat_g: number;
  confidence: number;
}

export interface MealPipelineOutput {
  isMedicalQuery: boolean;
  medicalRefusalMessage?: string;
  summary: string;
  items: ExtractedFoodCandidate[];
  totalCalories: number;
  totalProtein: number;
  totalCarbs: number;
  totalFat: number;
  confidenceOverall: number;
  hinglishInsight: string;
  statutoryDisclaimer: string;
}

export class ConversationalMealPipeline {
  private readonly groqApiKey: string;
  private readonly isMock: boolean;

  constructor(options?: { groqApiKey?: string; isMock?: boolean }) {
    this.groqApiKey = options?.groqApiKey || '';
    this.isMock = options?.isMock || false;
  }

  /**
   * Processes conversational text from WhatsApp through medical guardrails
   * and structured Indian meal extraction.
   */
  async processInboundMealText(text: string): Promise<MealPipelineOutput> {
    const trimmed = text.trim();

    // 1. Enforce Medical Boundary (TASK 063, ADR-005)
    const medicalCheck = enforceMedicalBoundaryOnText(trimmed);
    const hasClinicalInquiry =
      medicalCheck.isProhibited ||
      /\b(?:cure|cures|curing)\s+(?:for\s+)?(?:diabetes|cancer|hypertension|thyroid|pcos)\b/i.test(trimmed) ||
      /\b(?:stop\s+taking\s+(?:medicine|insulin|pills))\b/i.test(trimmed);

    if (hasClinicalInquiry) {
      return {
        isMedicalQuery: true,
        medicalRefusalMessage:
          'FitKarma is a wellness & nutrition companion, not a medical practitioner. ' +
          'We cannot diagnose medical conditions, prescribe treatments, or recommend cures for chronic illnesses. ' +
          'Please consult a licensed physician for clinical guidance.',
        summary: 'Medical inquiry detected - non-diagnostic response',
        items: [],
        totalCalories: 0,
        totalProtein: 0,
        totalCarbs: 0,
        totalFat: 0,
        confidenceOverall: 1.0,
        hinglishInsight: 'Health concerns ke liye kripya doctor se consult karein.',
        statutoryDisclaimer: 'Nutritional tracking only. Not clinical or medical guidance.',
      };
    }

    // 2. Mock mode or unit test extraction
    if (this.isMock || !this.groqApiKey) {
      return this._mockExtract(trimmed);
    }

    // 3. Live extraction via Groq Chat Completions API
    try {
      const response = await fetch('https://api.groq.com/openai/v1/chat/completions', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          Authorization: `Bearer ${this.groqApiKey}`,
        },
        body: JSON.stringify({
          model: 'llama-3.3-70b-versatile',
          temperature: 0.1,
          response_format: { type: 'json_object' },
          messages: [
            {
              role: 'system',
              content:
                'You are FitKarma India Meal Extractor. Convert conversational descriptions in Hindi, English, or Hinglish ' +
                'into a JSON object matching this schema:\n' +
                '{\n' +
                '  "summary": string,\n' +
                '  "items": [{\n' +
                '    "food_name": string,\n' +
                '    "quantity": number,\n' +
                '    "unit": "piece" | "small_katori" | "medium_katori" | "large_katori" | "glass" | "gram",\n' +
                '    "estimated_calories": number,\n' +
                '    "protein_g": number,\n' +
                '    "carbs_g": number,\n' +
                '    "fat_g": number,\n' +
                '    "confidence": number\n' +
                '  }],\n' +
                '  "confidence_overall": number,\n' +
                '  "hinglish_insight": string,\n' +
                '  "statutory_disclaimer": "Nutritional estimate only. Not clinical or medical guidance."\n' +
                '}',
            },
            {
              role: 'user',
              content: trimmed,
            },
          ],
        }),
      });

      if (!response.ok) {
        throw new Error(`Groq API error (${response.status})`);
      }

      const json = await response.json();
      const content = json.choices?.[0]?.message?.content;
      const parsed = JSON.parse(content);

      const items = (parsed.items || []) as ExtractedFoodCandidate[];
      const cal = items.reduce((sum, i) => sum + i.estimated_calories * i.quantity, 0);
      const p = items.reduce((sum, i) => sum + i.protein_g * i.quantity, 0);
      const c = items.reduce((sum, i) => sum + i.carbs_g * i.quantity, 0);
      const f = items.reduce((sum, i) => sum + i.fat_g * i.quantity, 0);

      return {
        isMedicalQuery: false,
        summary: parsed.summary || 'Estimated meal items',
        items,
        totalCalories: Math.round(cal * 10) / 10,
        totalProtein: Math.round(p * 10) / 10,
        totalCarbs: Math.round(c * 10) / 10,
        totalFat: Math.round(f * 10) / 10,
        confidenceOverall: parsed.confidence_overall || 0.85,
        hinglishInsight: parsed.hinglish_insight || 'Meal logged successfully!',
        statutoryDisclaimer:
          parsed.statutory_disclaimer || 'Nutritional estimate only. Not clinical or medical guidance.',
      };
    } catch (_e) {
      return this._mockExtract(trimmed);
    }
  }

  private _mockExtract(text: string): MealPipelineOutput {
    const lower = text.toLowerCase();
    const items: ExtractedFoodCandidate[] = [];

    if (lower.includes('roti') || lower.includes('phulka') || lower.includes('chapati')) {
      items.push({
        food_name: 'Phulka / Roti',
        quantity: 2.0,
        unit: 'piece',
        estimated_calories: 80.0,
        protein_g: 3.0,
        carbs_g: 16.0,
        fat_g: 0.5,
        confidence: 0.95,
      });
    }

    if (lower.includes('dal') || lower.includes('daal')) {
      items.push({
        food_name: 'Dal Tadka',
        quantity: 1.0,
        unit: 'medium_katori',
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
        quantity: 0.5,
        unit: 'medium_katori',
        estimated_calories: 190.0,
        protein_g: 11.0,
        carbs_g: 4.0,
        fat_g: 14.0,
        confidence: 0.90,
      });
    }

    if (items.length === 0) {
      items.push({
        food_name: 'Indian Homestyle Thali',
        quantity: 1.0,
        unit: 'serving',
        estimated_calories: 350.0,
        protein_g: 10.0,
        carbs_g: 50.0,
        fat_g: 10.0,
        confidence: 0.80,
      });
    }

    const totalCal = items.reduce((s, i) => s + i.estimated_calories * i.quantity, 0);
    const totalP = items.reduce((s, i) => s + i.protein_g * i.quantity, 0);
    const totalC = items.reduce((s, i) => s + i.carbs_g * i.quantity, 0);
    const totalF = items.reduce((s, i) => s + i.fat_g * i.quantity, 0);

    return {
      isMedicalQuery: false,
      summary: `Estimated ${items.length} items from input: "${text}"`,
      items,
      totalCalories: Math.round(totalCal * 10) / 10,
      totalProtein: Math.round(totalP * 10) / 10,
      totalCarbs: Math.round(totalC * 10) / 10,
      totalFat: Math.round(totalF * 10) / 10,
      confidenceOverall: 0.92,
      hinglishInsight: 'Badhiya balance! Roti aur dal se energy aur protein dono mil rahe hain.',
      statutoryDisclaimer: 'Nutritional estimate only. Not clinical or medical guidance.',
    };
  }
}
