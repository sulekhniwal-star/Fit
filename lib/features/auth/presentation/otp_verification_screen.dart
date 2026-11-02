import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../app/router/app_router.dart';
import '../../../shared/theme/app_colors.dart';
import '../../../shared/theme/app_radii.dart';
import '../../../shared/theme/app_spacing.dart';
import '../../../shared/theme/app_typography.dart';
import '../../../shared/widgets/action_button.dart';
import '../../../shared/widgets/app_scaffold.dart';
import '../../../shared/widgets/bento_card.dart';
import 'auth_state_notifier.dart';

class OtpVerificationScreen extends ConsumerStatefulWidget {
  final String phoneNumber;
  final int resendCooldownSeconds;

  const OtpVerificationScreen({
    super.key,
    required this.phoneNumber,
    this.resendCooldownSeconds = 60,
  });

  @override
  ConsumerState<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends ConsumerState<OtpVerificationScreen> {
  final TextEditingController _otpController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  late int _cooldownSeconds;
  Timer? _timer;
  bool _isComplete = false;

  @override
  void initState() {
    super.initState();
    _cooldownSeconds = widget.resendCooldownSeconds;
    _startCooldownTimer();
    _otpController.addListener(_handleOtpChange);
  }

  void _startCooldownTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_cooldownSeconds > 0) {
        setState(() {
          _cooldownSeconds--;
        });
      } else {
        timer.cancel();
      }
    });
  }

  void _handleOtpChange() {
    final text = _otpController.text.trim();
    final isComplete = text.length == 6;
    if (isComplete != _isComplete) {
      setState(() {
        _isComplete = isComplete;
      });
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _otpController.removeListener(_handleOtpChange);
    _otpController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  Future<void> _handleVerify() async {
    if (!_isComplete) return;
    final code = _otpController.text.trim();
    await ref.read(authStateNotifierProvider.notifier).verifyOtp(widget.phoneNumber, code);
  }

  Future<void> _handleResend() async {
    if (_cooldownSeconds > 0) return;
    await ref.read(authStateNotifierProvider.notifier).sendOtp(widget.phoneNumber);
    setState(() {
      _cooldownSeconds = widget.resendCooldownSeconds;
    });
    _startCooldownTimer();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<AuthState>(authStateNotifierProvider, (previous, next) {
      if (next is AuthAuthenticated) {
        ref.read(isAuthenticatedProvider.notifier).state = true;
        if (Navigator.of(context).canPop()) {
          Navigator.of(context).pop();
        }
      }
    });

    final authState = ref.watch(authStateNotifierProvider);
    final isLoading = authState is AuthAuthenticating;
    final errorMessage = authState is AuthErrorState ? authState.failure.message : null;

    final displayPhone = widget.phoneNumber.startsWith('+91')
        ? widget.phoneNumber
        : '+91 ${widget.phoneNumber}';

    return AppScaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: AppColors.textPrimary),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
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
                      Icons.mark_email_read_rounded,
                      color: AppColors.primary,
                      size: 32,
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                Text(
                  'Verify Phone',
                  style: AppTypography.display.copyWith(color: AppColors.textPrimary),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  'Enter the 6-digit code sent to $displayPhone',
                  style: AppTypography.bodySecondary.copyWith(color: AppColors.textSecondary),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppSpacing.xxl),

                BentoCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'One-Time Password',
                        style: AppTypography.title.copyWith(color: AppColors.textPrimary),
                      ),
                      const SizedBox(height: AppSpacing.md),
                      Container(
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(AppRadii.md),
                          border: Border.all(
                            color: _isComplete ? AppColors.primary : AppColors.glassBorder,
                            width: _isComplete ? 1.5 : 1.0,
                          ),
                        ),
                        child: TextField(
                          key: const Key('otp_input_field'),
                          controller: _otpController,
                          focusNode: _focusNode,
                          keyboardType: TextInputType.number,
                          maxLength: 6,
                          textAlign: TextAlign.center,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          style: AppTypography.display.copyWith(
                            color: AppColors.textPrimary,
                            letterSpacing: 12.0,
                            fontWeight: FontWeight.bold,
                          ),
                          decoration: InputDecoration(
                            counterText: '',
                            hintText: '••••••',
                            hintStyle: AppTypography.display.copyWith(
                              color: AppColors.textSecondary.withValues(alpha: 0.3),
                              letterSpacing: 12.0,
                            ),
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: AppSpacing.md,
                              vertical: AppSpacing.lg,
                            ),
                          ),
                        ),
                      ),
                      if (errorMessage != null) ...[
                        const SizedBox(height: AppSpacing.sm),
                        Text(
                          errorMessage,
                          key: const Key('otp_error_text'),
                          style: AppTypography.caption.copyWith(color: AppColors.error),
                        ),
                      ],
                      const SizedBox(height: AppSpacing.lg),
                      ActionButton(
                        key: const Key('verify_otp_button'),
                        label: 'Verify & Continue',
                        isLoading: isLoading,
                        onPressed: _isComplete ? _handleVerify : null,
                      ),
                      const SizedBox(height: AppSpacing.md),
                      Center(
                        child: TextButton(
                          key: const Key('resend_otp_button'),
                          onPressed: _cooldownSeconds == 0 && !isLoading ? _handleResend : null,
                          child: Text(
                            _cooldownSeconds > 0
                                ? 'Resend code in ${_cooldownSeconds}s'
                                : 'Resend code',
                            style: AppTypography.caption.copyWith(
                              color: _cooldownSeconds == 0
                                  ? AppColors.primary
                                  : AppColors.textSecondary,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
