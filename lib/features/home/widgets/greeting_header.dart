import 'package:flutter/material.dart';
import 'package:samir_pet/core/constants/app_colors.dart';
import 'package:samir_pet/core/constants/app_typography.dart';
import 'package:samir_pet/core/utils/time_utils.dart';

class GreetingHeader extends StatelessWidget {
  final String petName;
  final VoidCallback onSettingsTap;
  final VoidCallback? onDemoTap;

  const GreetingHeader({
    super.key,
    required this.petName,
    required this.onSettingsTap,
    this.onDemoTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final greeting = TimeUtils.getGreetingForTime('Samir');

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Greeting & Subtitle
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  greeting,
                  style: AppTypography.greeting.copyWith(
                    color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Your companion is right here with you',
                  style: AppTypography.caption.copyWith(
                    color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                  ),
                ),
              ],
            ),
          ),
          // Action Buttons
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (onDemoTap != null)
                IconButton(
                  onPressed: onDemoTap,
                  icon: const Icon(Icons.developer_mode_rounded),
                  tooltip: 'Demo Mode',
                  color: AppColors.accent,
                ),
              Container(
                decoration: BoxDecoration(
                  color: AppColors.glassColor(Theme.of(context).brightness),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColors.glassBorder(Theme.of(context).brightness),
                  ),
                ),
                child: IconButton(
                  onPressed: onSettingsTap,
                  icon: const Icon(Icons.tune_rounded),
                  tooltip: 'Settings',
                  color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
