import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';

/// The yellow loyalty pill next to the Home greeting.
class PointsPill extends StatelessWidget {
  const PointsPill({super.key, required this.points});

  final int points;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: 6,
      ),
      decoration: const BoxDecoration(
        color: AppColors.accentColor,
        borderRadius: BorderRadius.all(Radius.circular(AppRadius.pill)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.workspace_premium_rounded,
            size: 14,
            color: AppColors.onAccentColor,
          ),
          const SizedBox(width: AppSpacing.xs),
          Text('$points Pts', style: AppTextStyles.points),
        ],
      ),
    );
  }
}
