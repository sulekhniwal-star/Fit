import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../shared/theme/app_colors.dart';
import '../../../shared/theme/app_radii.dart';
import '../../../shared/theme/app_spacing.dart';
import '../../../shared/theme/app_typography.dart';
import '../../../shared/widgets/action_button.dart';
import '../../../shared/widgets/app_scaffold.dart';
import '../../../shared/widgets/bento_card.dart';
import 'auth_state_notifier.dart';
import 'otp_verification_screen.dart';

class PhoneLoginScreen extends ConsumerStatefulWidget {
  const PhoneLoginScreen({super.key});

  @override
  ConsumerState<PhoneLoginScreen> createState() => _PhoneLoginScreenState();
}

class _PhoneLoginScreenState extends ConsumerState<PhoneLoginScreen> {
  final TextEditingController _phoneController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  bool _isValid = false;

  @override
  void initState() {
    super.initState();
    _phoneController.addListener(_validateInput);
  }

  void _validateInput() {
    final text = _phoneController.text.trim();
    // Valid Indian phone numbers: 10 digits starting with 6, 7, 8, or 9
    final isValid = RegExp(r'^[6-9]\d{9}$').hasMatch(text);
    if (isValid != _isValid) {
      setState(() {
        _isValid = isValid;
      });
    }
  }

  @override
  void dispose() {
    _phoneController.removeListener(_validateInput);
    _phoneController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  Future<void> _handleGetOtp() async {
    if (!_isValid) return;
    final phone = _phoneController.text.trim();
    await ref.read(authStateNotifierProvider.notifier).sendOtp(phone);
  }

  Future<void> _handleGoogleSignIn() async {
    await ref.read(authStateNotifierProvider.notifier).signInWithGoogle();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<AuthState>(authStateNotifierProvider, (previous, next) {
      if (next is AuthOtpSent) {
        Navigator.of(context).push(
          MaterialPageRoute<void>(
            builder: (context) => OtpVerificationScreen(
              phoneNumber: next.phoneNumber,
              resendCooldownSeconds: next.resendCooldownSeconds,
            ),
          ),
        );
      }
    });

    final authState = ref.watch(authStateNotifierProvider);
    final isLoading = authState is AuthAuthenticating;
    final errorMessage = authState is AuthErrorState ? authState.failure.message : null;

    return AppScaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: AppSpacing.xl),
                // Brand Header
                Center(
                  child: Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.12),
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
                    ),
                    child: const Icon(
                      Icons.fitness_center_rounded,
                      color: AppColors.primary,
                      size: 32,
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                Text(
                  'FitKarma',
                  style: AppTypography.display.copyWith(color: AppColors.textPrimary),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  "India's Intelligent Health Operating System",
                  style: AppTypography.bodySecondary.copyWith(color: AppColors.textSecondary),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppSpacing.xxl),

                // Phone Input Bento Card
                BentoCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Mobile Number',
                        style: AppTypography.title.copyWith(color: AppColors.textPrimary),
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        'We will send a 6-digit verification code',
                        style: AppTypography.caption.copyWith(color: AppColors.textSecondary),
                      ),
                      const SizedBox(height: AppSpacing.md),
                      Container(
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(AppRadii.md),
                          border: Border.all(
                            color: _isValid ? AppColors.primary : AppColors.glassBorder,
                            width: _isValid ? 1.5 : 1.0,
                          ),
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: AppSpacing.md,
                                vertical: AppSpacing.md,
                              ),
                              decoration: const BoxDecoration(
                                border: Border(
                                  right: BorderSide(color: AppColors.glassBorder),
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Text(
                                    '🇮🇳',
                                    style: TextStyle(fontSize: 18),
                                  ),
                                  const SizedBox(width: AppSpacing.xs),
                                  Text(
                                    '+91',
                                    style: AppTypography.title.copyWith(
                                      color: AppColors.textPrimary,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: TextField(
                                key: const Key('phone_input_field'),
                                controller: _phoneController,
                                focusNode: _focusNode,
                                keyboardType: TextInputType.phone,
                                maxLength: 10,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                ],
                                style: AppTypography.title.copyWith(
                                  color: AppColors.textPrimary,
                                  letterSpacing: 1.5,
                                ),
                                decoration: InputDecoration(
                                  counterText: '',
                                  hintText: '98765 43210',
                                  hintStyle: AppTypography.bodySecondary.copyWith(
                                    color: AppColors.textSecondary.withValues(alpha: 0.6),
                                  ),
                                  border: InputBorder.none,
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: AppSpacing.md,
                                    vertical: AppSpacing.md,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (errorMessage != null) ...[
                        const SizedBox(height: AppSpacing.sm),
                        Text(
                          errorMessage,
                          key: const Key('auth_error_text'),
                          style: AppTypography.caption.copyWith(color: AppColors.error),
                        ),
                      ],
                      const SizedBox(height: AppSpacing.lg),
                      ActionButton(
                        key: const Key('get_otp_button'),
                        label: 'Get OTP',
                        isLoading: isLoading,
                        onPressed: _isValid ? _handleGetOtp : null,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: AppSpacing.xl),

                // Alternative Login Divider
                Row(
                  children: [
                    const Expanded(child: Divider(color: AppColors.glassBorder)),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                      child: Text(
                        'OR',
                        style: AppTypography.caption.copyWith(color: AppColors.textSecondary),
                      ),
                    ),
                    const Expanded(child: Divider(color: AppColors.glassBorder)),
                  ],
                ),

                const SizedBox(height: AppSpacing.xl),

                // Google Sign In
                ActionButton(
                  key: const Key('google_signin_button'),
                  label: 'Continue with Google',
                  variant: ActionButtonVariant.outline,
                  icon: Icons.g_mobiledata_rounded,
                  isLoading: isLoading,
                  onPressed: _handleGoogleSignIn,
                ),

                const SizedBox(height: AppSpacing.xxl),
                Text(
                  'By continuing, you agree to FitKarma\'s Terms and DPDP Privacy Policy.',
                  style: AppTypography.caption.copyWith(
                    color: AppColors.textSecondary,
                    fontSize: 11,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppSpacing.lg),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
