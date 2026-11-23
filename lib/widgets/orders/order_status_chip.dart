import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';

class OrderStatusChip extends StatelessWidget {
  const OrderStatusChip({super.key, required this.status});

  final String status;

  @override
  Widget build(BuildContext context) {
    final isPreparation = status == 'In preparation';
    final isCancelled = status == 'Cancelled';
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: isCancelled
            ? AppColors.errorColor
            : isPreparation
                ? AppColors.emeraldTintColor
                : AppColors.borderColor,
        borderRadius: const BorderRadius.all(
          Radius.circular(AppRadius.pill),
        ),
      ),
      child: Text(
        status,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: AppTextStyles.statusPill.copyWith(
          color: isCancelled || isPreparation
              ? AppColors.onAccentColor
              : AppColors.mutedTextColor,
        ),
      ),
    );
  }
}
