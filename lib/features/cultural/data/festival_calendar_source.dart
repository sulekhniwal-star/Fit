// ============================================================================
// EXTENSIBLE INDIAN FESTIVAL CALENDAR SOURCE
// ============================================================================

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/fasting_protocol.dart';
import '../domain/festival_models.dart';
import '../domain/festive_food.dart';

abstract class FestivalCalendarSource {
  Future<List<FestivalEvent>> getUpcomingFestivals({DateTime? fromDate, int daysLookahead = 30});
  Future<FestivalEvent?> getActiveFestival({DateTime? forDate});
}

class StaticIndianFestivalCalendar implements FestivalCalendarSource {
  final List<FestivalEvent> _festivals;

  StaticIndianFestivalCalendar([List<FestivalEvent>? customFestivals])
      : _festivals = customFestivals ?? _defaultFestivals;

  static final List<FestivalEvent> _defaultFestivals = [
    FestivalEvent(
      id: 'fest_diwali',
      name: 'Diwali (Deepavali)',
      hindiName: 'दीपावली (दिवाली)',
      startDate: DateTime(2026, 11, 1),
      endDate: DateTime(2026, 11, 5),
      description: 'The festival of lights celebrating the victory of light over darkness and good over evil.',
      culturalGreeting: 'Happy Diwali! Wishing you and your family health and prosperity.',
      hindiCulturalGreeting: 'शुभ दीपावली! आपको और आपके परिवार को सुख, शांति और स्वास्थ्य की शुभकामनाएं।',
      traditionalFoods: [
        FestiveFood.catalog.firstWhere((f) => f.id == 'food_besan_laddoo'),
        FestiveFood.catalog.firstWhere((f) => f.id == 'food_kaju_katli'),
        FestiveFood.catalog.firstWhere((f) => f.id == 'food_kheer'),
      ],
      isFastingAssociated: false,
      balanceTips: const [
        'Pair sweets with fiber or nuts to stabilize blood glucose.',
        'Enjoy a morning workout before festive evening dinners.',
        'Stay hydrated with warm water throughout the festivities.',
      ],
    ),
    FestivalEvent(
      id: 'fest_navratri_sharad',
      name: 'Sharad Navratri & Dussehra',
      hindiName: 'शारदीय नवरात्रि और दशहरा',
      startDate: DateTime(2026, 10, 11),
      endDate: DateTime(2026, 10, 20),
      description: 'Nine nights honoring the Divine Feminine with devotion, sattvic fasting, and Garba/Dandiya.',
      culturalGreeting: 'Subho Bijoya & Happy Dussehra!',
      hindiCulturalGreeting: 'नवरात्रि और विजयदशमी की हार्दिक शुभकामनाएं!',
      traditionalFoods: [
        FestiveFood.catalog.firstWhere((f) => f.id == 'food_kheer'),
      ],
      isFastingAssociated: true,
      fastingProtocolType: FastingProtocolType.navratri,
      balanceTips: const [
        'Sattvic grains like Kuttu and Singhara are high in protein and gluten-free.',
        'Garba and Dandiya Raas double up as fantastic high-energy cardio!',
        'Opt for roasted makhana instead of deep-fried sabudana vadas.',
      ],
    ),
    FestivalEvent(
      id: 'fest_karwa_chauth',
      name: 'Karwa Chauth',
      hindiName: 'करवा चौथ',
      startDate: DateTime(2026, 10, 28),
      endDate: DateTime(2026, 10, 28),
      description: 'Sacred sunrise-to-moonrise waterless (Nirjala) fast observed for familial health and marital bliss.',
      culturalGreeting: 'Happy Karwa Chauth!',
      hindiCulturalGreeting: 'करवा चौथ की हार्दिक शुभकामनाएं!',
      traditionalFoods: [
        FestiveFood.catalog.firstWhere((f) => f.id == 'food_kheer'),
      ],
      isFastingAssociated: true,
      fastingProtocolType: FastingProtocolType.karwaChauth,
      balanceTips: const [
        'Pre-dawn Sargi: Consume complex carbs, coconut water, and soaked almonds.',
        'Avoid strenuous outdoor cardio or heavy sun exposure during fasting hours.',
        'Break fast gently with water first, followed by easily digestible warm food.',
      ],
    ),
    FestivalEvent(
      id: 'fest_eid_ul_fitr',
      name: 'Eid ul-Fitr',
      hindiName: 'ईद-उल-फ़ितर',
      startDate: DateTime(2026, 3, 20),
      endDate: DateTime(2026, 3, 22),
      description: 'Joyous festival concluding the holy month of Ramadan, celebrated with prayers, charity, and feasts.',
      culturalGreeting: 'Eid Mubarak! May blessings, peace, and health be with you.',
      hindiCulturalGreeting: 'ईद मुबारक! आप सभी को सुख और सेहत की मुबारकबाद।',
      traditionalFoods: [
        FestiveFood.catalog.firstWhere((f) => f.id == 'food_sheer_khurma'),
        FestiveFood.catalog.firstWhere((f) => f.id == 'food_biryani'),
      ],
      isFastingAssociated: true,
      fastingProtocolType: FastingProtocolType.ramadanRoza,
      balanceTips: const [
        'Savor Sheer Khurma in moderate katoris alongside abundant water.',
        'Accompany biryani with plenty of cucumber-onion raita for gut probiotics.',
        'Take an evening family walk after festive meals.',
      ],
    ),
    FestivalEvent(
      id: 'fest_holi',
      name: 'Holi - Festival of Colors',
      hindiName: 'होली',
      startDate: DateTime(2026, 3, 3),
      endDate: DateTime(2026, 3, 4),
      description: 'Vibrant celebration of spring, renewal, love, and the harvest.',
      culturalGreeting: 'Happy Holi! Play safe, colorful, and joyful.',
      hindiCulturalGreeting: 'होली के पावन पर्व की हार्दिक शुभकामनाएं!',
      traditionalFoods: [
        FestiveFood.catalog.firstWhere((f) => f.id == 'food_gujiya'),
      ],
      isFastingAssociated: false,
      balanceTips: const [
        'Drink plenty of water before playing colors to maintain hydration.',
        'Enjoy 1-2 freshly baked or air-fried gujiyas mindfully.',
        'Natural herbal thandai with fennel and seeds is soothing for pitta.',
      ],
    ),
    FestivalEvent(
      id: 'fest_ganesh_chaturthi',
      name: 'Ganesh Chaturthi',
      hindiName: 'गणेश चतुर्थी',
      startDate: DateTime(2026, 9, 14),
      endDate: DateTime(2026, 9, 24),
      description: 'Ten-day celebration welcoming Lord Ganesha, the remover of obstacles.',
      culturalGreeting: 'Ganpati Bappa Morya!',
      hindiCulturalGreeting: 'गणेश चतुर्थी की हार्दिक शुभकामनाएं!',
      traditionalFoods: [
        FestiveFood.catalog.firstWhere((f) => f.id == 'food_modak'),
      ],
      isFastingAssociated: false,
      balanceTips: const [
        'Steamed Ukadiche Modak is naturally lower in fat and rich in prebiotic jaggery.',
        'Enjoy modaks after meals rather than on an empty stomach.',
      ],
    ),
    FestivalEvent(
      id: 'fest_makar_sankranti',
      name: 'Makar Sankranti / Pongal / Lohri',
      hindiName: 'मकर संक्रांति / पोंगल / लोहड़ी',
      startDate: DateTime(2026, 1, 14),
      endDate: DateTime(2026, 1, 15),
      description: 'Harvest celebration marking the sun transition into Capricorn (Uttarayana).',
      culturalGreeting: 'Happy Makar Sankranti & Happy Pongal!',
      hindiCulturalGreeting: 'मकर संक्रांति और पोंगल की शुभकामनाएं!',
      traditionalFoods: [
        FestiveFood.catalog.firstWhere((f) => f.id == 'food_til_laddoo'),
      ],
      isFastingAssociated: false,
      balanceTips: const [
        'Til (sesame) and Gud (jaggery) provide essential winter thermogenesis and calcium.',
        'Kite-flying outdoors offers natural Vitamin D exposure and active movement!',
      ],
    ),
  ];

  @override
  Future<List<FestivalEvent>> getUpcomingFestivals({DateTime? fromDate, int daysLookahead = 30}) async {
    final now = fromDate ?? DateTime.now();
    return _festivals.where((f) => f.isUpcoming(now, daysLookahead) || f.isCurrentlyActive(now)).toList();
  }

  @override
  Future<FestivalEvent?> getActiveFestival({DateTime? forDate}) async {
    final now = forDate ?? DateTime.now();
    for (final f in _festivals) {
      if (f.isCurrentlyActive(now)) {
        return f;
      }
    }
    return null;
  }
}

final festivalCalendarSourceProvider = Provider<FestivalCalendarSource>((ref) {
  return StaticIndianFestivalCalendar();
});

