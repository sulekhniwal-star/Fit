import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/localization/locale_provider.dart';
import '../../auth/presentation/auth_state_notifier.dart';
import '../../profile/data/local_profile_repository.dart';
import '../../profile/domain/dosha_calculator.dart';
import '../../profile/domain/user_profile.dart';
import '../../../shared/theme/app_colors.dart';
import '../../../shared/theme/app_radii.dart';
import '../../../shared/theme/app_spacing.dart';
import '../../../shared/theme/app_typography.dart';
import '../../../shared/widgets/action_button.dart';
import '../../../shared/widgets/app_scaffold.dart';
import '../../../shared/widgets/bento_card.dart';

class OnboardingWizardScreen extends ConsumerStatefulWidget {
  final VoidCallback? onCompleted;

  const OnboardingWizardScreen({super.key, this.onCompleted});

  @override
  ConsumerState<OnboardingWizardScreen> createState() => _OnboardingWizardScreenState();
}

class _OnboardingWizardScreenState extends ConsumerState<OnboardingWizardScreen> {
  final PageController _pageController = PageController();
  int _currentStep = 0;

  // Step 1: Language
  String _selectedLanguage = 'en';

  // Step 2: Biometrics
  final TextEditingController _ageController = TextEditingController(text: '26');
  final TextEditingController _heightController = TextEditingController(text: '172');
  final TextEditingController _weightController = TextEditingController(text: '70');
  BiologicalSex _selectedSex = BiologicalSex.male;

  // Step 3: Diet & Activity
  DietaryIdentity _selectedDiet = DietaryIdentity.vegetarian;
  ActivityLevel _selectedActivity = ActivityLevel.moderatelyActive;

  // Step 4: Health Goal & Dosha
  HealthGoal _selectedGoal = HealthGoal.maintenance;
  DoshaProfile? _doshaProfile;
  bool _includeDosha = false;
  final int _vataAnswers = 3;
  final int _pittaAnswers = 3;
  final int _kaphaAnswers = 3;

  // Step 5: DPDP Consent
  bool _dpdpConsentAccepted = false;
  bool _isSaving = false;

  @override
  void dispose() {
    _pageController.dispose();
    _ageController.dispose();
    _heightController.dispose();
    _weightController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentStep < 4) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _previousPage() {
    if (_currentStep > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  Future<void> _completeOnboarding() async {
    if (!_dpdpConsentAccepted) return;

    setState(() {
      _isSaving = true;
    });

    final authState = ref.read(authStateNotifierProvider);
    final userId = authState is AuthAuthenticated ? authState.user.id : 'local-user';

    final age = int.tryParse(_ageController.text.trim()) ?? 25;
    final height = double.tryParse(_heightController.text.trim()) ?? 170.0;
    final weight = double.tryParse(_weightController.text.trim()) ?? 70.0;

    if (_includeDosha) {
      _doshaProfile = const DoshaCalculator().calculate(
        vataPoints: _vataAnswers,
        pittaPoints: _pittaAnswers,
        kaphaPoints: _kaphaAnswers,
      );
    }

    final profile = UserProfile(
      userId: userId,
      displayName: 'FitKarma User',
      age: age,
      biologicalSex: _selectedSex,
      heightCm: height,
      weightKg: weight,
      activityLevel: _selectedActivity,
      dietaryIdentity: _selectedDiet,
      healthGoal: _selectedGoal,
      languageCode: _selectedLanguage,
      doshaProfile: _doshaProfile,
      hasAcceptedDpdpConsent: true,
      updatedAt: DateTime.now(),
    );

    final repository = ref.read(profileRepositoryProvider);
    await repository.saveProfile(profile);

    setState(() {
      _isSaving = false;
    });

    if (widget.onCompleted != null) {
      widget.onCompleted!();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Header Progress Bar
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.lg,
                vertical: AppSpacing.md,
              ),
              child: Row(
                children: [
                  if (_currentStep > 0)
                    IconButton(
                      key: const Key('wizard_back_button'),
                      icon: const Icon(Icons.arrow_back_rounded, color: AppColors.textPrimary),
                      onPressed: _previousPage,
                    )
                  else
                    const SizedBox(width: 48),
                  Expanded(
                    child: Center(
                      child: Text(
                        'Step ${_currentStep + 1} of 5',
                        style: AppTypography.caption.copyWith(
                          color: AppColors.textSecondary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 48),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(AppRadii.full),
                child: LinearProgressIndicator(
                  value: (_currentStep + 1) / 5.0,
                  backgroundColor: AppColors.surfaceElevated,
                  valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
                  minHeight: 4,
                ),
              ),
            ),

            // Page View Content
            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                onPageChanged: (page) {
                  setState(() {
                    _currentStep = page;
                  });
                },
                children: [
                  _buildLanguageStep(),
                  _buildBiometricsStep(),
                  _buildDietAndLifestyleStep(),
                  _buildGoalsAndDoshaStep(),
                  _buildDpdpConsentStep(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // STEP 1: Language
  Widget _buildLanguageStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: AppSpacing.lg),
          Text(
            'Choose Your Language\nअपनी भाषा चुनें',
            style: AppTypography.headline.copyWith(color: AppColors.textPrimary),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.xxl),
          BentoCard(
            onTap: () {
              setState(() {
                _selectedLanguage = 'en';
              });
              ref.read(localeProvider.notifier).setLocale(const Locale('en'));
            },
            child: Row(
              children: [
                const Text('🇬🇧', style: TextStyle(fontSize: 28)),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Text(
                    'English',
                    style: AppTypography.title.copyWith(color: AppColors.textPrimary),
                  ),
                ),
                if (_selectedLanguage == 'en')
                  const Icon(Icons.check_circle_rounded, color: AppColors.primary),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          BentoCard(
            onTap: () {
              setState(() {
                _selectedLanguage = 'hi';
              });
              ref.read(localeProvider.notifier).setLocale(const Locale('hi'));
            },
            child: Row(
              children: [
                const Text('🇮🇳', style: TextStyle(fontSize: 28)),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Text(
                    'हिन्दी (Hindi)',
                    style: AppTypography.title.copyWith(color: AppColors.textPrimary),
                  ),
                ),
                if (_selectedLanguage == 'hi')
                  const Icon(Icons.check_circle_rounded, color: AppColors.primary),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.xxl),
          ActionButton(
            key: const Key('language_next_button'),
            label: 'Continue',
            onPressed: _nextPage,
          ),
        ],
      ),
    );
  }

  // STEP 2: Physical Biometrics
  Widget _buildBiometricsStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Physical Biometrics',
            style: AppTypography.headline.copyWith(color: AppColors.textPrimary),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            'Baselines used to calibrate metabolic & macro targets',
            style: AppTypography.caption.copyWith(color: AppColors.textSecondary),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.xl),
          BentoCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Biological Sex',
                  style: AppTypography.title.copyWith(color: AppColors.textPrimary),
                ),
                const SizedBox(height: AppSpacing.sm),
                Row(
                  children: BiologicalSex.values.map((sex) {
                    final isSelected = _selectedSex == sex;
                    return Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() => _selectedSex = sex),
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
                          decoration: BoxDecoration(
                            color: isSelected ? AppColors.primary : AppColors.surface,
                            borderRadius: BorderRadius.circular(AppRadii.md),
                          ),
                          child: Text(
                            sex.name.toUpperCase(),
                            textAlign: TextAlign.center,
                            style: AppTypography.button.copyWith(
                              color: isSelected ? AppColors.background : AppColors.textPrimary,
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: AppSpacing.lg),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Age', style: AppTypography.caption),
                          const SizedBox(height: AppSpacing.xs),
                          TextField(
                            key: const Key('age_input'),
                            controller: _ageController,
                            keyboardType: TextInputType.number,
                            style: AppTypography.title.copyWith(color: AppColors.textPrimary),
                            decoration: const InputDecoration(
                              filled: true,
                              fillColor: AppColors.surface,
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Height (cm)', style: AppTypography.caption),
                          const SizedBox(height: AppSpacing.xs),
                          TextField(
                            key: const Key('height_input'),
                            controller: _heightController,
                            keyboardType: TextInputType.number,
                            style: AppTypography.title.copyWith(color: AppColors.textPrimary),
                            decoration: const InputDecoration(
                              filled: true,
                              fillColor: AppColors.surface,
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Weight (kg)', style: AppTypography.caption),
                          const SizedBox(height: AppSpacing.xs),
                          TextField(
                            key: const Key('weight_input'),
                            controller: _weightController,
                            keyboardType: TextInputType.number,
                            style: AppTypography.title.copyWith(color: AppColors.textPrimary),
                            decoration: const InputDecoration(
                              filled: true,
                              fillColor: AppColors.surface,
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          ActionButton(
            key: const Key('biometrics_next_button'),
            label: 'Continue',
            onPressed: _nextPage,
          ),
        ],
      ),
    );
  }

  // STEP 3: Dietary Identity & Activity Level
  Widget _buildDietAndLifestyleStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Diet & Lifestyle',
            style: AppTypography.headline.copyWith(color: AppColors.textPrimary),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.xl),
          BentoCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Dietary Pattern',
                  style: AppTypography.title.copyWith(color: AppColors.textPrimary),
                ),
                const SizedBox(height: AppSpacing.md),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: DietaryIdentity.values.map((diet) {
                    final isSelected = _selectedDiet == diet;
                    return ChoiceChip(
                      label: Text(diet.name.toUpperCase()),
                      selected: isSelected,
                      selectedColor: AppColors.primary,
                      backgroundColor: AppColors.surface,
                      labelStyle: TextStyle(
                        color: isSelected ? AppColors.background : AppColors.textPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                      onSelected: (_) => setState(() => _selectedDiet = diet),
                    );
                  }).toList(),
                ),
                const SizedBox(height: AppSpacing.lg),
                Text(
                  'Physical Activity Level',
                  style: AppTypography.title.copyWith(color: AppColors.textPrimary),
                ),
                const SizedBox(height: AppSpacing.md),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: ActivityLevel.values.map((activity) {
                    final isSelected = _selectedActivity == activity;
                    return ChoiceChip(
                      label: Text(activity.name),
                      selected: isSelected,
                      selectedColor: AppColors.techBlue,
                      backgroundColor: AppColors.surface,
                      labelStyle: TextStyle(
                        color: isSelected ? AppColors.background : AppColors.textPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                      onSelected: (_) => setState(() => _selectedActivity = activity),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          ActionButton(
            key: const Key('diet_next_button'),
            label: 'Continue',
            onPressed: _nextPage,
          ),
        ],
      ),
    );
  }

  // STEP 4: Goals & Optional Dosha
  Widget _buildGoalsAndDoshaStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Health Goals & Ayurveda',
            style: AppTypography.headline.copyWith(color: AppColors.textPrimary),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.xl),
          BentoCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Primary Health Goal',
                  style: AppTypography.title.copyWith(color: AppColors.textPrimary),
                ),
                const SizedBox(height: AppSpacing.md),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: HealthGoal.values.map((goal) {
                    final isSelected = _selectedGoal == goal;
                    return ChoiceChip(
                      label: Text(goal.name),
                      selected: isSelected,
                      selectedColor: AppColors.saffron,
                      backgroundColor: AppColors.surface,
                      labelStyle: TextStyle(
                        color: isSelected ? AppColors.background : AppColors.textPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                      onSelected: (_) => setState(() => _selectedGoal = goal),
                    );
                  }).toList(),
                ),
                const SizedBox(height: AppSpacing.lg),
                Row(
                  children: [
                    Checkbox(
                      key: const Key('dosha_assessment_toggle'),
                      value: _includeDosha,
                      onChanged: (val) => setState(() => _includeDosha = val ?? false),
                      activeColor: AppColors.saffron,
                    ),
                    Expanded(
                      child: Text(
                        'Include Ayurvedic Wellness Profiling',
                        style: AppTypography.body.copyWith(color: AppColors.textPrimary),
                      ),
                    ),
                  ],
                ),
                if (_includeDosha) ...[
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    DoshaProfile.nonMedicalDisclaimer,
                    style: AppTypography.caption.copyWith(color: AppColors.textSecondary),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          ActionButton(
            key: const Key('goals_next_button'),
            label: 'Continue',
            onPressed: _nextPage,
          ),
        ],
      ),
    );
  }

  // STEP 5: DPDP Act 2023 Consent
  Widget _buildDpdpConsentStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.shield_rounded, color: AppColors.primary, size: 28),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            'DPDP Privacy & Consent',
            style: AppTypography.headline.copyWith(color: AppColors.textPrimary),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            'Digital Personal Data Protection Act, 2023',
            style: AppTypography.caption.copyWith(color: AppColors.primary),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.xl),
          BentoCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Your Data Rights in FitKarma',
                  style: AppTypography.title.copyWith(color: AppColors.textPrimary),
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  '• Health telemetry is encrypted at rest and in transit.\n'
                  '• Data is used strictly to compute nutrition, activity, and fasting guidance.\n'
                  '• You have the statutory right to export or permanently erase your data at any time under Settings > Data Vault.\n'
                  '• FitKarma will never sell your personal data.',
                  style: AppTypography.bodySecondary.copyWith(
                    color: AppColors.textSecondary,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Checkbox(
                      key: const Key('dpdp_consent_checkbox'),
                      value: _dpdpConsentAccepted,
                      activeColor: AppColors.primary,
                      onChanged: (val) {
                        setState(() {
                          _dpdpConsentAccepted = val ?? false;
                        });
                      },
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _dpdpConsentAccepted = !_dpdpConsentAccepted;
                          });
                        },
                        child: Text(
                          'I provide explicit affirmative consent for FitKarma to process my biometric and dietary information.',
                          style: AppTypography.body.copyWith(
                            color: AppColors.textPrimary,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          ActionButton(
            key: const Key('finish_onboarding_button'),
            label: 'Finish & Enter FitKarma',
            isLoading: _isSaving,
            onPressed: _dpdpConsentAccepted ? _completeOnboarding : null,
          ),
        ],
      ),
    );
  }
}
