import 'dart:async';
import 'package:flutter/material.dart';
import '../../../shared/theme/app_colors.dart';
import '../../../shared/theme/app_radii.dart';
import '../../../shared/theme/app_spacing.dart';

class RestTimerWidget extends StatefulWidget {
  final int initialDurationSeconds;
  final VoidCallback? onFinished;
  final VoidCallback? onDismissed;
  final bool autoStart;

  const RestTimerWidget({
    super.key,
    this.initialDurationSeconds = 60,
    this.onFinished,
    this.onDismissed,
    this.autoStart = true,
  });

  @override
  State<RestTimerWidget> createState() => _RestTimerWidgetState();
}

class _RestTimerWidgetState extends State<RestTimerWidget> {
  late int _totalDuration;
  late int _remainingSeconds;
  bool _isRunning = false;
  Timer? _timer;

  static const List<int> _presetOptions = [30, 60, 90, 120];

  @override
  void initState() {
    super.initState();
    _totalDuration = widget.initialDurationSeconds;
    _remainingSeconds = widget.initialDurationSeconds;
    if (widget.autoStart) {
      _startTimer();
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timer?.cancel();
    setState(() => _isRunning = true);
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds > 1) {
        setState(() => _remainingSeconds--);
      } else {
        _timer?.cancel();
        setState(() {
          _remainingSeconds = 0;
          _isRunning = false;
        });
        widget.onFinished?.call();
      }
    });
  }

  void _pauseTimer() {
    _timer?.cancel();
    setState(() => _isRunning = false);
  }

  void _resetTimer(int seconds) {
    _timer?.cancel();
    setState(() {
      _totalDuration = seconds;
      _remainingSeconds = seconds;
      _isRunning = false;
    });
    _startTimer();
  }

  void _addSeconds(int seconds) {
    setState(() {
      _totalDuration += seconds;
      _remainingSeconds += seconds;
    });
  }

  String _formatTime(int totalSecs) {
    final mins = (totalSecs ~/ 60).toString().padLeft(2, '0');
    final secs = (totalSecs % 60).toString().padLeft(2, '0');
    return '$mins:$secs';
  }

  @override
  Widget build(BuildContext context) {
    final progress = _totalDuration > 0 ? (_remainingSeconds / _totalDuration).clamp(0.0, 1.0) : 0.0;
    final isDone = _remainingSeconds == 0;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surfaceElevated,
        borderRadius: AppRadii.borderMd,
        border: Border.all(
          color: isDone ? AppColors.primary : AppColors.glassBorder,
          width: isDone ? 2.0 : 1.0,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.timer_outlined,
                    color: isDone ? AppColors.primary : AppColors.textSecondary,
                    size: 20,
                  ),
                  const SizedBox(width: AppSpacing.xs),
                  Text(
                    isDone ? 'Rest Complete! Ready for next set.' : 'Rest Timer',
                    style: TextStyle(
                      color: isDone ? AppColors.primary : AppColors.textSecondary,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              if (widget.onDismissed != null)
                IconButton(
                  icon: const Icon(Icons.close, size: 18, color: AppColors.textSecondary),
                  onPressed: widget.onDismissed,
                  visualDensity: VisualDensity.compact,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: 72,
                    height: 72,
                    child: CircularProgressIndicator(
                      value: progress,
                      strokeWidth: 6,
                      backgroundColor: AppColors.surface,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        isDone ? AppColors.success : AppColors.primary,
                      ),
                    ),
                  ),
                  Text(
                    _formatTime(_remainingSeconds),
                    style: TextStyle(
                      color: isDone ? AppColors.primary : AppColors.textPrimary,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.0,
                    ),
                  ),
                ],
              ),
              const SizedBox(width: AppSpacing.lg),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      IconButton.filled(
                        key: const Key('rest_timer_play_pause'),
                        onPressed: isDone ? () => _resetTimer(60) : (_isRunning ? _pauseTimer : _startTimer),
                        icon: Icon(_isRunning ? Icons.pause : Icons.play_arrow),
                        style: IconButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: AppColors.background,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.xs),
                      OutlinedButton(
                        key: const Key('rest_timer_add_15'),
                        onPressed: () => _addSeconds(15),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.textPrimary,
                          side: const BorderSide(color: AppColors.glassBorder),
                          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
                        ),
                        child: const Text('+15s'),
                      ),
                      const SizedBox(width: AppSpacing.xs),
                      TextButton(
                        key: const Key('rest_timer_skip'),
                        onPressed: () {
                          _timer?.cancel();
                          setState(() {
                            _remainingSeconds = 0;
                            _isRunning = false;
                          });
                          widget.onDismissed?.call();
                        },
                        child: const Text(
                          'Skip',
                          style: TextStyle(color: AppColors.textSecondary),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Wrap(
                    spacing: AppSpacing.xs,
                    children: _presetOptions.map((secs) {
                      final isSelected = _totalDuration == secs && !isDone;
                      return ChoiceChip(
                        label: Text('${secs}s'),
                        selected: isSelected,
                        onSelected: (_) => _resetTimer(secs),
                        labelStyle: TextStyle(
                          fontSize: 11,
                          color: isSelected ? AppColors.background : AppColors.textSecondary,
                          fontWeight: FontWeight.bold,
                        ),
                        selectedColor: AppColors.primary,
                        backgroundColor: AppColors.surface,
                        padding: EdgeInsets.zero,
                        visualDensity: VisualDensity.compact,
                      );
                    }).toList(),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
