// FitKarma AI Gateway Structured Output Schemas (TASK 059)

export interface MealCandidateItem {
  food_name: string;
  matched_category: string;
  quantity: number;
  unit: string;
  cooking_state: string;
  tadka_level: string;
  estimated_calories: number;
  protein_g: number;
  carbs_g: number;
  fat_g: number;
  confidence: number;
  is_unverified?: boolean;
}

export interface MealAnalysisPayload {
  summary: string;
  items: MealCandidateItem[];
  confidence_overall: number;
  uncertainty_reasons: string[];
  hinglish_insight: string;
  statutory_disclaimer: string;
}

export interface HinglishCoachingPayload {
  headline: string;
  hinglish_text: string;
  tone: string;
  statutory_disclaimer: string;
}

export const MEAL_ANALYSIS_SYSTEM_PROMPT = `
You are FitKarma's Indian Nutrition AI Engine.
Analyze the user's meal description (or photo observations) into structured Indian dishes, authentic household portion units, and macronutrients.

Allowed units:
- "piece" (for roti, paratha, idli, samosa, eggs)
- "small_katori" (150ml - dal, curd, sabzi)
- "medium_katori" (200ml - standard katori)
- "large_katori" (250ml - large serving)
- "glass" (250ml - chaas, milk, lassi)
- "tablespoon" (15g - ghee, chutney, sugar)
- "gram" (standard grams)

Allowed cooking states: "cooked", "raw"
Allowed tadka levels: "none", "low", "medium", "heavy"

IMPORTANT: You MUST respond in pure, valid JSON with no markdown wrapping. Follow this exact schema:
{
  "summary": "String describing total meal",
  "items": [
    {
      "food_name": "String standard dish name (e.g. Phulka / Roti, Dal Tadka)",
      "matched_category": "grains | pulses | vegetables | dairy | meat | sweets",
      "quantity": 2.0,
      "unit": "piece | small_katori | medium_katori | large_katori | glass | tablespoon | gram",
      "cooking_state": "cooked",
      "tadka_level": "medium",
      "estimated_calories": 160.0,
      "protein_g": 6.0,
      "carbs_g": 32.0,
      "fat_g": 2.0,
      "confidence": 0.95
    }
  ],
  "confidence_overall": 0.90,
  "uncertainty_reasons": ["Estimated oil in tadka without visual verification"],
  "hinglish_insight": "Friendly 1-line nutrition tip in conversational Hinglish",
  "statutory_disclaimer": "Nutritional estimate only. Not clinical or medical guidance."
}

SAFETY RULES:
- Never make clinical diagnoses or disease cure claims.
- If quantity is unspecified, assume 1 medium katori or 2 pieces.
`;

export const HINGLISH_COACHING_SYSTEM_PROMPT = `
You are FitKarma's warm, supportive Indian wellness coach.
Craft a 2-3 sentence coaching feedback in natural, modern conversational Hinglish (such as "Badhiya meal choice!", "Protein mast hai!").
Never speak in archaic formal Hindi.
Follow this exact JSON schema:
{
  "headline": "Short title",
  "hinglish_text": "2-3 sentences of positive, actionable guidance",
  "tone": "supportive",
  "statutory_disclaimer": "Lifestyle wellness indicator only."
}
`;

export function validateAndNormalizeMealResponse(raw: unknown): MealAnalysisPayload {
  if (typeof raw !== 'object' || raw === null) {
    throw new Error('Malformed AI response: expected object');
  }

  const obj = raw as Record<string, unknown>;

  const summary = typeof obj.summary === 'string' ? obj.summary : 'Analyzed Indian meal';
  const confidenceOverall = typeof obj.confidence_overall === 'number'
    ? Math.max(0.0, Math.min(1.0, obj.confidence_overall))
    : 0.70;

  const rawItems = Array.isArray(obj.items) ? obj.items : [];
  const normalizedItems: MealCandidateItem[] = [];

  for (const item of rawItems) {
    if (typeof item !== 'object' || item === null) continue;
    const it = item as Record<string, unknown>;

    const foodName = typeof it.food_name === 'string' && it.food_name.trim().length > 0
      ? it.food_name.trim()
      : 'Unspecified Indian dish';

    const quantity = typeof it.quantity === 'number' && it.quantity > 0 ? it.quantity : 1.0;
    const unit = typeof it.unit === 'string' ? it.unit : 'medium_katori';
    const cookingState = typeof it.cooking_state === 'string' ? it.cooking_state : 'cooked';
    const tadkaLevel = typeof it.tadka_level === 'string' ? it.tadka_level : 'medium';

    const calories = typeof it.estimated_calories === 'number' ? Math.max(0, it.estimated_calories) : 150.0;
    const protein = typeof it.protein_g === 'number' ? Math.max(0, it.protein_g) : 5.0;
    const carbs = typeof it.carbs_g === 'number' ? Math.max(0, it.carbs_g) : 25.0;
    const fat = typeof it.fat_g === 'number' ? Math.max(0, it.fat_g) : 4.0;
    const confidence = typeof it.confidence === 'number' ? Math.max(0.0, Math.min(1.0, it.confidence)) : 0.8;

    normalizedItems.push({
      food_name: foodName,
      matched_category: typeof it.matched_category === 'string' ? it.matched_category : 'grains',
      quantity,
      unit,
      cooking_state: cookingState,
      tadka_level: tadkaLevel,
      estimated_calories: calories,
      protein_g: protein,
      carbs_g: carbs,
      fat_g: fat,
      confidence,
    });
  }

  // Fallback item if model returned empty items list
  if (normalizedItems.length === 0) {
    normalizedItems.push({
      food_name: 'Mixed Indian Meal',
      matched_category: 'grains',
      quantity: 1.0,
      unit: 'medium_katori',
      cooking_state: 'cooked',
      tadka_level: 'medium',
      estimated_calories: 250.0,
      protein_g: 8.0,
      carbs_g: 40.0,
      fat_g: 6.0,
      confidence: 0.50,
      is_unverified: true,
    });
  }

  const uncertaintyReasons = Array.isArray(obj.uncertainty_reasons)
    ? (obj.uncertainty_reasons as unknown[]).map((r) => String(r))
    : ['Standard AI estimation variance'];

  const hinglishInsight = typeof obj.hinglish_insight === 'string' && obj.hinglish_insight.trim().length > 0
    ? obj.hinglish_insight
    : 'Aapka meal log ready hai. Portions check karke confirm karein!';

  return {
    summary,
    items: normalizedItems,
    confidence_overall: confidenceOverall,
    uncertainty_reasons: uncertaintyReasons,
    hinglish_insight: hinglishInsight,
    statutory_disclaimer: 'Nutritional estimate only. Not clinical or medical guidance.',
  };
}
