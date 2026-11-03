// ============================================================================
// AQI WORKOUT ADVISORY & INDOOR ALTERNATIVE GENERATOR
// ============================================================================

import 'aqi_models.dart';

enum OutdoorWorkoutType {
  running,
  cycling,
  walking,
  sports,
  generalOutdoor,
}

class IndoorWorkoutAlternative {
  final String title;
  final String hindiTitle;
  final String description;
  final int estimatedDurationMinutes;
  final String intensity;
  final List<String> benefits;

  const IndoorWorkoutAlternative({
    required this.title,
    required this.hindiTitle,
    required this.description,
    required this.estimatedDurationMinutes,
    required this.intensity,
    required this.benefits,
  });
}

class AqiWorkoutAdvisory {
  final AqiReading reading;
  final bool isOutdoorWorkoutSafe;
  final String primaryRecommendation;
  final String hindiRecommendation;
  final List<IndoorWorkoutAlternative> indoorAlternatives;
  final List<String> respiratorySafetyTips;

  const AqiWorkoutAdvisory({
    required this.reading,
    required this.isOutdoorWorkoutSafe,
    required this.primaryRecommendation,
    required this.hindiRecommendation,
    required this.indoorAlternatives,
    required this.respiratorySafetyTips,
  });

  static AqiWorkoutAdvisory generateAdvisory(AqiReading reading) {
    final aqi = reading.aqi;

    if (aqi <= 50) {
      return AqiWorkoutAdvisory(
        reading: reading,
        isOutdoorWorkoutSafe: true,
        primaryRecommendation: 'Air quality is excellent. Ideal day for outdoor runs, cycling, and park workouts!',
        hindiRecommendation: 'हवा की गुणवत्ता बेहतरीन है। बाहर दौड़ने और कसरत करने के लिए उत्तम दिन!',
        indoorAlternatives: const [],
        respiratorySafetyTips: const [
          'Take deep breaths and enjoy outdoor cardio.',
          'Stay hydrated with water or nimbu pani.',
        ],
      );
    }

    if (aqi <= 100) {
      return AqiWorkoutAdvisory(
        reading: reading,
        isOutdoorWorkoutSafe: true,
        primaryRecommendation: 'Air quality is satisfactory. Generally safe for outdoor fitness.',
        hindiRecommendation: 'हवा की गुणवत्ता संतोषजनक है। बाहर वर्कआउट करना सुरक्षित है।',
        indoorAlternatives: const [],
        respiratorySafetyTips: const [
          'Sensitive runners should keep exertion moderate.',
          'Avoid heavy traffic arterial roads during peak hours.',
        ],
      );
    }

    if (aqi <= 200) {
      return AqiWorkoutAdvisory(
        reading: reading,
        isOutdoorWorkoutSafe: false,
        primaryRecommendation: 'Moderate air pollution. People with asthma or breathing sensitivity should exercise indoors.',
        hindiRecommendation: 'मध्यम प्रदूषण। अस्थमा या सांस की संवेदनशीलता वाले लोग घर के अंदर कसरत करें।',
        indoorAlternatives: [
          const IndoorWorkoutAlternative(
            title: 'Treadmill Interval Run',
            hindiTitle: 'ट्रेडमिल अंतराल दौड़',
            description: 'Maintain cardio conditioning indoors with zero toxic particulate inhalation.',
            estimatedDurationMinutes: 25,
            intensity: 'Moderate - High',
            benefits: ['Zero PM2.5 lung load', 'Calibrated pace control', 'Joint-friendly deck'],
          ),
          const IndoorWorkoutAlternative(
            title: 'Hatha Yoga & Surya Namaskar Flow',
            hindiTitle: 'सूर्य नमस्कार और हठ योग',
            description: '12 rounds of dynamic Surya Namaskar followed by calming Pranayama.',
            estimatedDurationMinutes: 30,
            intensity: 'Moderate',
            benefits: ['Core strength', 'Spinal mobility', 'Diaphragmatic lung expansion'],
          ),
        ],
        respiratorySafetyTips: const [
          'Prefer early morning workouts before vehicular exhaust peaks.',
          'Consider wearing an N95 mask if jogging along main urban roads.',
        ],
      );
    }

    if (aqi <= 300) {
      return AqiWorkoutAdvisory(
        reading: reading,
        isOutdoorWorkoutSafe: false,
        primaryRecommendation: 'AQI is Poor. Outdoor running or cycling is hazardous to your lungs today. We strongly recommend indoor training.',
        hindiRecommendation: 'हवा खराब है। बाहर दौड़ना या साइकिल चलाना फेफड़ों के लिए हानिकारक है। घर के अंदर कसरत करें।',
        indoorAlternatives: [
          const IndoorWorkoutAlternative(
            title: 'Bodyweight HIIT Circuit',
            hindiTitle: 'बॉडीवेट एचआईआईटी सर्किट',
            description: 'Jumping jacks, mountain climbers, squats, and pushups in 4 rounds.',
            estimatedDurationMinutes: 20,
            intensity: 'High',
            benefits: ['High calorie burn', 'Zero equipment needed', 'Clean indoor air'],
          ),
          const IndoorWorkoutAlternative(
            title: 'Indoor Strength & Dumbbell Flow',
            hindiTitle: 'इंडोर स्ट्रेंथ और डंबल वर्कआउट',
            description: 'Compound resistance training targeting upper and lower body.',
            estimatedDurationMinutes: 35,
            intensity: 'Moderate - High',
            benefits: ['Builds lean muscle', 'Safe respiratory rate', 'Metabolic boost'],
          ),
          const IndoorWorkoutAlternative(
            title: 'Surya Namaskar & Pranayama',
            hindiTitle: 'सूर्य नमस्कार और प्राणायाम',
            description: '15 rounds of Surya Namaskar + Anulom Vilom for lung vitality.',
            estimatedDurationMinutes: 25,
            intensity: 'Moderate',
            benefits: ['Cleanses bronchial passages', 'Restores autonomic calm', 'Zero air strain'],
          ),
        ],
        respiratorySafetyTips: const [
          'High PM2.5 levels penetrate deep into lung alveoli during cardio.',
          'Keep windows closed and run an air purifier if available.',
          'Wear an N95/N99 respirator for essential outdoor transit.',
        ],
      );
    }

    // Very Poor or Severe (301+)
    return AqiWorkoutAdvisory(
      reading: reading,
      isOutdoorWorkoutSafe: false,
      primaryRecommendation: 'Hazardous air quality (${reading.aqi} AQI). Strictly avoid outdoor physical exertion. Stick to gentle indoor movement.',
      hindiRecommendation: 'गंभीर वायु प्रदूषण (${reading.aqi} AQI)। बाहर किसी भी प्रकार की कसरत से बचें। घर के अंदर हल्का योग करें।',
      indoorAlternatives: [
        const IndoorWorkoutAlternative(
          title: 'Gentle Restorative Yoga & Mobility',
          hindiTitle: 'सौम्य योग और मोबिलिटी',
          description: 'Gentle spinal stretches, cat-cow, child\'s pose, and light mobility without heavy panting.',
          estimatedDurationMinutes: 20,
          intensity: 'Low',
          benefits: ['Prevents heavy pulmonary ventilation', 'Relieves postural tightness', 'Promotes rest'],
        ),
        const IndoorWorkoutAlternative(
          title: 'Pranayama & Diaphragmatic Breathwork',
          hindiTitle: 'प्राणायाम और श्वसन अभ्यास',
          description: 'Anulom Vilom, Bhramari, and deep belly breathing to calm the nervous system.',
          estimatedDurationMinutes: 15,
          intensity: 'Low',
          benefits: ['Strengthens lung capacity safely', 'Reduces respiratory irritation', 'Stress relief'],
        ),
      ],
      respiratorySafetyTips: const [
        'Prolonged outdoor exposure today causes severe respiratory and vascular inflammation.',
        'Drink warm tulsi-ginger-haldi water to soothe throat and airways.',
        'Strictly avoid outdoor sports, running, or high-ventilation workouts.',
      ],
    );
  }
}
