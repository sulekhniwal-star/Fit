// ============================================================================
// TRADITIONAL INDIAN FESTIVE FOOD CATALOG & MACRO PROFILES
// ============================================================================

class FestiveFood {
  final String id;
  final String name;
  final String hindiName;
  final String portionDescription;
  final double portionGrams;
  final double calories;
  final double proteinGrams;
  final double carbsGrams;
  final double fatGrams;
  final String festivalAffiliation;
  final String culturalNote;

  const FestiveFood({
    required this.id,
    required this.name,
    required this.hindiName,
    required this.portionDescription,
    required this.portionGrams,
    required this.calories,
    required this.proteinGrams,
    required this.carbsGrams,
    required this.fatGrams,
    required this.festivalAffiliation,
    required this.culturalNote,
  });

  static const List<FestiveFood> catalog = [
    FestiveFood(
      id: 'food_besan_laddoo',
      name: 'Besan Laddoo',
      hindiName: 'बेसन का लड्डू',
      portionDescription: '1 medium piece',
      portionGrams: 45.0,
      calories: 220.0,
      proteinGrams: 4.2,
      carbsGrams: 26.0,
      fatGrams: 11.0,
      festivalAffiliation: 'Diwali / Ganesh Chaturthi',
      culturalNote: 'Roasted gram flour with pure ghee and cardamom. Dense source of energy and healthy fats.',
    ),
    FestiveFood(
      id: 'food_kaju_katli',
      name: 'Kaju Katli (Kaju Barfi)',
      hindiName: 'काजू कतली',
      portionDescription: '1 diamond piece',
      portionGrams: 20.0,
      calories: 95.0,
      proteinGrams: 2.1,
      carbsGrams: 11.5,
      fatGrams: 4.8,
      festivalAffiliation: 'Diwali / Raksha Bandhan',
      culturalNote: 'Cashew nut fudge. Cashews provide magnesium, zinc, and heart-healthy monounsaturated fats.',
    ),
    FestiveFood(
      id: 'food_gujiya',
      name: 'Gujiya (Karanji)',
      hindiName: 'गुझिया',
      portionDescription: '1 medium piece',
      portionGrams: 60.0,
      calories: 260.0,
      proteinGrams: 4.5,
      carbsGrams: 32.0,
      fatGrams: 13.0,
      festivalAffiliation: 'Holi / Diwali',
      culturalNote: 'Crisp pastry stuffed with khoya, dry fruits, and grated coconut. Traditional Holi sweet.',
    ),
    FestiveFood(
      id: 'food_modak',
      name: 'Ukadiche Modak (Steamed)',
      hindiName: 'उकडीचे मोदक',
      portionDescription: '1 piece',
      portionGrams: 50.0,
      calories: 135.0,
      proteinGrams: 2.0,
      carbsGrams: 24.0,
      fatGrams: 3.8,
      festivalAffiliation: 'Ganesh Chaturthi',
      culturalNote: 'Steamed rice flour dumpling filled with fresh coconut and jaggery. Naturally lower in fat than fried sweets.',
    ),
    FestiveFood(
      id: 'food_sheer_khurma',
      name: 'Sheer Khurma',
      hindiName: 'शीर खुरमा',
      portionDescription: '1 small katori (150ml)',
      portionGrams: 150.0,
      calories: 240.0,
      proteinGrams: 6.5,
      carbsGrams: 34.0,
      fatGrams: 9.0,
      festivalAffiliation: 'Eid ul-Fitr',
      culturalNote: 'Rich vermicelli pudding prepared with milk, dates, saffron, and dry fruits. Rich in calcium and iron.',
    ),
    FestiveFood(
      id: 'food_kheer',
      name: 'Traditional Rice Kheer',
      hindiName: 'चावल की खीर',
      portionDescription: '1 medium katori (150ml)',
      portionGrams: 150.0,
      calories: 210.0,
      proteinGrams: 5.2,
      carbsGrams: 31.0,
      fatGrams: 7.5,
      festivalAffiliation: 'Navratri / Onam / Diwali',
      culturalNote: 'Slow-simmered basmati rice with whole milk, cardamom, and nuts. Good source of slow-digesting carbs and dairy protein.',
    ),
    FestiveFood(
      id: 'food_biryani',
      name: 'Festive Dum Biryani',
      hindiName: 'दम बिरयानी',
      portionDescription: '1 standard plate',
      portionGrams: 300.0,
      calories: 520.0,
      proteinGrams: 26.0,
      carbsGrams: 58.0,
      fatGrams: 20.0,
      festivalAffiliation: 'Eid / Dussehra / Celebrations',
      culturalNote: 'Aromatic layered basmati rice with marinated protein, whole spices, and saffron. Wholesome celebratory meal.',
    ),
    FestiveFood(
      id: 'food_til_laddoo',
      name: 'Til Gud Laddoo',
      hindiName: 'तिल गुड़ लड्डू',
      portionDescription: '1 piece',
      portionGrams: 30.0,
      calories: 140.0,
      proteinGrams: 3.5,
      carbsGrams: 16.0,
      fatGrams: 7.5,
      festivalAffiliation: 'Makar Sankranti / Lohri / Pongal',
      culturalNote: 'Sesame seeds and jaggery. Exceptional natural source of bioavailable plant calcium, iron, and warming winter thermogenesis.',
    ),
  ];
}

