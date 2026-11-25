import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../auth/auth_emblem.dart';

class BrewlyBrandLockup extends StatelessWidget {
  const BrewlyBrandLockup({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.xs,
      ),
      decoration: const BoxDecoration(
        color: AppColors.cardColor,
        borderRadius: BorderRadius.all(Radius.circular(AppRadius.pill)),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowBlack05,
            blurRadius: 1,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: AppSpacing.xxl,
            height: AppSpacing.xxl,
            child: FittedBox(child: AuthEmblem()),
          ),
          SizedBox(width: AppSpacing.xs),
          Text('Brewly', style: AppTextStyles.brandLabel),
        ],
      ),
    );
  }
}
