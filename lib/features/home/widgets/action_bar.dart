import 'package:flutter/material.dart';
import 'package:samir_pet/core/constants/app_colors.dart';
import 'package:samir_pet/core/constants/app_typography.dart';
import 'package:samir_pet/core/utils/haptic_utils.dart';

class ActionBar extends StatelessWidget {
  final VoidCallback onPet;
  final VoidCallback onTalk;
  final VoidCallback onMusic;
  final VoidCallback onSleep;
  final VoidCallback onPlay;
  final bool isMusicActive;
  final bool isSleeping;

  const ActionBar({
    super.key,
    required this.onPet,
    required this.onTalk,
    required this.onMusic,
    required this.onSleep,
    required this.onPlay,
    this.isMusicActive = false,
    this.isSleeping = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _ActionButton(
            icon: Icons.favorite_rounded,
            label: 'Pet',
            color: AppColors.accent,
            onTap: onPet,
          ),
          _ActionButton(
            icon: Icons.chat_bubble_rounded,
            label: 'Talk',
            color: AppColors.primary,
            onTap: onTalk,
          ),
          _ActionButton(
            icon: isMusicActive ? Icons.music_off_rounded : Icons.music_note_rounded,
            label: isMusicActive ? 'Stop' : 'Music',
            color: isMusicActive ? AppColors.accentGreen : AppColors.secondary,
            isActive: isMusicActive,
            onTap: onMusic,
          ),
          _ActionButton(
            icon: isSleeping ? Icons.wb_sunny_rounded : Icons.nightlight_round,
            label: isSleeping ? 'Wake' : 'Sleep',
            color: const Color(0xFF93C5FD),
            isActive: isSleeping,
            onTap: onSleep,
          ),
          _ActionButton(
            icon: Icons.sports_esports_rounded,
            label: 'Play',
            color: const Color(0xFFFBBF24),
            onTap: onPlay,
          ),
        ],
      ),
    );
  }
}

class _ActionButton extends StatefulWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;
  final bool isActive;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
    this.isActive = false,
  });

  @override
  State<_ActionButton> createState() => _ActionButtonState();
}

class _ActionButtonState extends State<_ActionButton> with SingleTickerProviderStateMixin {
  late final AnimationController _pressController;

  @override
  void initState() {
    super.initState();
    _pressController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
      lowerBound: 0.88,
      upperBound: 1.0,
      value: 1.0,
    );
  }

  @override
  void dispose() {
    _pressController.dispose();
    super.dispose();
  }

  void _onTapDown(_) => _pressController.reverse();
  void _onTapUp(_) {
    _pressController.forward();
    HapticUtils.lightTap();
    widget.onTap();
  }

  void _onTapCancel() => _pressController.forward();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      child: ScaleTransition(
        scale: _pressController,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: widget.isActive
                    ? widget.color.withValues(alpha: 0.25)
                    : AppColors.glassColor(Theme.of(context).brightness),
                shape: BoxShape.circle,
                border: Border.all(
                  color: widget.isActive
                      ? widget.color
                      : AppColors.glassBorder(Theme.of(context).brightness),
                  width: widget.isActive ? 2.0 : 1.0,
                ),
                boxShadow: widget.isActive
                    ? [
                        BoxShadow(
                          color: widget.color.withValues(alpha: 0.3),
                          blurRadius: 12,
                          spreadRadius: 2,
                        ),
                      ]
                    : [],
              ),
              child: Icon(
                widget.icon,
                color: widget.isActive ? widget.color : (isDark ? Colors.white : AppColors.lightTextPrimary),
                size: 24,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              widget.label,
              style: AppTypography.buttonLabel.copyWith(
                color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
