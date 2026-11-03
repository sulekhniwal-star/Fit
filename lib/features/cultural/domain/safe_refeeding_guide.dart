// ============================================================================
// SAFE REFEEDING PROTOCOL & INDIAN RECOVERY NUTRITION
// ============================================================================

class RefeedingMealOption {
  final String title;
  final String hindiTitle;
  final String portionDescription;
  final String whyItWorks;
  final int estimatedCalories;
  final double proteinGrams;

  const RefeedingMealOption({
    required this.title,
    required this.hindiTitle,
    required this.portionDescription,
    required this.whyItWorks,
    required this.estimatedCalories,
    required this.proteinGrams,
  });
}

class SafeRefeedingGuide {
  static const List<RefeedingMealOption> gentleBreakFastMeals = [
    RefeedingMealOption(
      title: 'Tender Coconut Water & Soaked Almonds',
      hindiTitle: 'नारियल पानी और भीगे बादाम',
      portionDescription: '1 fresh coconut water + 5 soaked, peeled almonds',
      whyItWorks: 'Replenishes cellular potassium, sodium, and magnesium without spiking blood sugar or taxing gastric acid.',
      estimatedCalories: 75,
      proteinGrams: 2.5,
    ),
    RefeedingMealOption(
      title: 'Moong Dal & Lauki Khichdi',
      hindiTitle: 'मूंग दाल और लौकी की खिचड़ी',
      portionDescription: '1 medium katori (soft, ghee tempered with jeera/heeng)',
      whyItWorks: 'Ayurvedic tridoshic comfort food. Yellow moong is ultra-gentle on the gut lining with prebiotic fiber.',
      estimatedCalories: 180,
      proteinGrams: 7.0,
    ),
    RefeedingMealOption(
      title: 'Fresh Papaya Bowl with Roasted Jeera',
      hindiTitle: 'पपीता और भुना जीरा',
      portionDescription: '1 medium cup diced ripe papaya',
      whyItWorks: 'Contains papain enzymes that aid protein digestion and gently restart peristalsis.',
      estimatedCalories: 60,
      proteinGrams: 0.8,
    ),
    RefeedingMealOption(
      title: 'Light Spiced Buttermilk (Chaas)',
      hindiTitle: 'छाछ (मट्ठा)',
      portionDescription: '1 tall glass (250ml) with rock salt, mint, and roasted cumin',
      whyItWorks: 'Restores intestinal probiotic flora and cools digestive heat (pitta) post-fasting.',
      estimatedCalories: 55,
      proteinGrams: 3.2,
    ),
  ];

  static const List<String> foodsToAvoidImmediately = [
    'Deep-fried snacks (Pakoras, Samosas, Bhujia) — high fat delays gastric emptying and triggers nausea.',
    'Heavy spicy gravies and excessive red chili — irritates sensitive post-fast gut lining.',
    'Concentrated sugar syrups (Gulab jamun, sodas) — causes severe insulin overshoot and reactive hypoglycemia.',
    'Large dense meat platters — taxing on digestive enzymes after prolonged rest.',
  ];

  static const String clinicalDisclaimer =
      'Statutory Advisory: Fasting is intended for wellness purposes only. '
      'Individuals who are pregnant, nursing, under 18, underweight, or managing type 1 diabetes '
      'should not fast without medical supervision.';
}
