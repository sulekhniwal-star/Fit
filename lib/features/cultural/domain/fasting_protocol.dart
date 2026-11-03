// ============================================================================
// FITKARMA FASTING PROTOCOLS & TAXONOMY
// ============================================================================

enum FastingProtocolType {
  // Time-Restricted Eating (Intermittent Fasting)
  if16_8,
  if14_10,
  if12_12,
  if18_6,
  if20_4,

  // Indian Cultural & Spiritual Fasts (Non-Inferred, 100% Voluntary)
  navratri,
  ekadashi,
  karwaChauth,
  ramadanRoza,
  mahaShivratri,

  // User-Configured Window
  custom,
}

class FastingProtocol {
  final FastingProtocolType type;
  final String displayName;
  final String hindiDisplayName;
  final int defaultFastHours;
  final int eatingWindowHours;
  final bool isWaterless; // Nirjala / dry fast
  final String description;
  final String culturalContext;
  final List<String> dietaryGuidelines;

  const FastingProtocol({
    required this.type,
    required this.displayName,
    required this.hindiDisplayName,
    required this.defaultFastHours,
    required this.eatingWindowHours,
    this.isWaterless = false,
    required this.description,
    required this.culturalContext,
    required this.dietaryGuidelines,
  });

  static const FastingProtocol if16_8 = FastingProtocol(
    type: FastingProtocolType.if16_8,
    displayName: '16:8 Intermittent Fast',
    hindiDisplayName: '१६:८ उपवास',
    defaultFastHours: 16,
    eatingWindowHours: 8,
    isWaterless: false,
    description: '16 hours fasting with an 8-hour eating window. Promotes fat mobilization and insulin sensitivity.',
    culturalContext: 'Popular modern intermittent fasting standard.',
    dietaryGuidelines: [
      'Water, black coffee, and green tea are allowed during fasting hours.',
      'Break fast with a balanced meal rich in protein and fiber.',
    ],
  );

  static const FastingProtocol if14_10 = FastingProtocol(
    type: FastingProtocolType.if14_10,
    displayName: '14:10 Gentle Fast',
    hindiDisplayName: '१४:१० सौम्य उपवास',
    defaultFastHours: 14,
    eatingWindowHours: 10,
    isWaterless: false,
    description: 'Gentle 14-hour fast. Ideal for beginners, women, and steady metabolic balance.',
    culturalContext: 'Balanced circadian approach without hormonal stress.',
    dietaryGuidelines: [
      'Stay well-hydrated throughout the fasting window.',
      'Focus on nutrient-dense whole foods during the 10-hour window.',
    ],
  );

  static const FastingProtocol if12_12 = FastingProtocol(
    type: FastingProtocolType.if12_12,
    displayName: '12:12 Circadian Rhythm Fast',
    hindiDisplayName: '१२:१२ प्राकृतिक उपवास',
    defaultFastHours: 12,
    eatingWindowHours: 12,
    isWaterless: false,
    description: 'Natural sun-up to sun-down metabolic alignment. Easiest sustainable daily fast.',
    culturalContext: 'Traditional Ayurvedic dinacharya guideline (eat before sunset).',
    dietaryGuidelines: [
      'Finish dinner by 8 PM and eat breakfast after 8 AM.',
      'Promotes digestive rest without prolonged calorie deficit.',
    ],
  );

  static const FastingProtocol if18_6 = FastingProtocol(
    type: FastingProtocolType.if18_6,
    displayName: '18:6 Deep Ketosis Fast',
    hindiDisplayName: '१८:६ गहन उपवास',
    defaultFastHours: 18,
    eatingWindowHours: 6,
    isWaterless: false,
    description: '18 hours fasting with a 6-hour eating window. Stimulates autophagy and glycogen clearance.',
    culturalContext: 'Intermediate intermittent fasting.',
    dietaryGuidelines: [
      'Ensure adequate electrolyte and mineral intake.',
      'Consume two complete meals during the eating window.',
    ],
  );

  static const FastingProtocol if20_4 = FastingProtocol(
    type: FastingProtocolType.if20_4,
    displayName: '20:4 Warrior Fast',
    hindiDisplayName: '२०:४ योद्धा उपवास',
    defaultFastHours: 20,
    eatingWindowHours: 4,
    isWaterless: false,
    description: '20-hour fast with a compact 4-hour evening eating window.',
    culturalContext: 'Advanced intermittent fasting.',
    dietaryGuidelines: [
      'Break fast gradually with small portions.',
      'High protein focus to prevent muscle catabolism.',
    ],
  );

  static const FastingProtocol navratri = FastingProtocol(
    type: FastingProtocolType.navratri,
    displayName: 'Navratri Vrat (Sattvic / Phalahar)',
    hindiDisplayName: 'नवरात्रि व्रत',
    defaultFastHours: 16,
    eatingWindowHours: 8,
    isWaterless: false,
    description: '9-day sacred observance focusing on gut detoxification, sattvic grains, and phalahar meals.',
    culturalContext: 'Bi-annual Vedic seasonal transition observance.',
    dietaryGuidelines: [
      'Permitted: Kuttu (buckwheat), Singhara (water chestnut), Sabudana, Makhana, fruits, dairy, rock salt (sendha namak).',
      'Avoid: Wheat, rice, pulses, onions, garlic, standard table salt, and alcohol.',
    ],
  );

  static const FastingProtocol ekadashi = FastingProtocol(
    type: FastingProtocolType.ekadashi,
    displayName: 'Ekadashi Vrat (Grainless Lunar Fast)',
    hindiDisplayName: 'एकादशी व्रत',
    defaultFastHours: 24,
    eatingWindowHours: 0,
    isWaterless: false,
    description: 'Twice-monthly 11th lunar day fast. Avoids all grains, rice, and beans for digestive renewal.',
    culturalContext: 'Traditional Hindu lunar digestive cleanse.',
    dietaryGuidelines: [
      'Strictly avoid: All grains (wheat, rice, oats) and lentils/beans.',
      'Permitted: Fresh fruits, coconut water, milk, nuts, and root vegetables.',
    ],
  );

  static const FastingProtocol karwaChauth = FastingProtocol(
    type: FastingProtocolType.karwaChauth,
    displayName: 'Karwa Chauth (Nirjala Sunrise-to-Moonrise)',
    hindiDisplayName: 'करवा चौथ (निर्जला)',
    defaultFastHours: 15,
    eatingWindowHours: 9,
    isWaterless: true,
    description: 'Traditional sunrise-to-moonrise waterless (Nirjala) fast.',
    culturalContext: 'Traditional Indian marital devotion and wellness fast.',
    dietaryGuidelines: [
      'Pre-fast Sargi (before sunrise): High-fiber fruits, feni, nuts, and abundant water.',
      'During fast: Completely dry (no water/food) until moon sighting.',
      'Breaking fast: Gentle sips of water first, followed by sweet mathri and light dinner.',
    ],
  );

  static const FastingProtocol ramadanRoza = FastingProtocol(
    type: FastingProtocolType.ramadanRoza,
    displayName: 'Ramadan Roza (Dawn-to-Dusk Dry Fast)',
    hindiDisplayName: 'रमज़ान रोज़ा',
    defaultFastHours: 14,
    eatingWindowHours: 10,
    isWaterless: true,
    description: 'Dawn-to-sunset dry fast from Suhoor (pre-dawn) to Iftar (sunset).',
    culturalContext: 'Islamic holy month of spiritual reflection and discipline.',
    dietaryGuidelines: [
      'Suhoor: Complex carbs (oats, whole wheat roti), high protein (eggs, paneer, lentils), and 1L+ hydration.',
      'Iftar: Break with dates, water, fresh fruits, followed by wholesome balanced dinner.',
      'Drink 2–3 liters of water between Iftar and Suhoor.',
    ],
  );

  static const FastingProtocol mahaShivratri = FastingProtocol(
    type: FastingProtocolType.mahaShivratri,
    displayName: 'Maha Shivratri Vrat',
    hindiDisplayName: 'महाशिवरात्रि व्रत',
    defaultFastHours: 24,
    eatingWindowHours: 0,
    isWaterless: false,
    description: 'Spiritual whole-day fast with fruit, milk, and light phalahar options.',
    culturalContext: 'Ancient spiritual observance honoring inner stillness.',
    dietaryGuidelines: [
      'Permitted: Milk, thandai, fruits, roasted makhana, and sendha namak preparations.',
      'Avoid: Grains, non-vegetarian food, and heavy fried dishes.',
    ],
  );

  static const FastingProtocol custom = FastingProtocol(
    type: FastingProtocolType.custom,
    displayName: 'Custom Fast',
    hindiDisplayName: 'कस्टम उपवास',
    defaultFastHours: 16,
    eatingWindowHours: 8,
    isWaterless: false,
    description: 'User-configured fasting window tailored to your personal schedule.',
    culturalContext: 'Flexible lifestyle protocol.',
    dietaryGuidelines: [
      'Hydrate well and break fast with nutrient-rich whole foods.',
    ],
  );

  static const List<FastingProtocol> allProtocols = [
    if16_8,
    if14_10,
    if12_12,
    if18_6,
    if20_4,
    navratri,
    ekadashi,
    karwaChauth,
    ramadanRoza,
    mahaShivratri,
    custom,
  ];

  static FastingProtocol fromType(FastingProtocolType type) {
    switch (type) {
      case FastingProtocolType.if16_8:
        return if16_8;
      case FastingProtocolType.if14_10:
        return if14_10;
      case FastingProtocolType.if12_12:
        return if12_12;
      case FastingProtocolType.if18_6:
        return if18_6;
      case FastingProtocolType.if20_4:
        return if20_4;
      case FastingProtocolType.navratri:
        return navratri;
      case FastingProtocolType.ekadashi:
        return ekadashi;
      case FastingProtocolType.karwaChauth:
        return karwaChauth;
      case FastingProtocolType.ramadanRoza:
        return ramadanRoza;
      case FastingProtocolType.mahaShivratri:
        return mahaShivratri;
      case FastingProtocolType.custom:
        return custom;
    }
  }
}
