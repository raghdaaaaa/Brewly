import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../core/constants/app_assets.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';

/// The white "BREWLY" pill in the Register header.
class RegisterBrandChip extends StatelessWidget {
  const RegisterBrandChip({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.sm,
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
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: const BoxDecoration(
              color: AppColors.primaryColor,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: SvgPicture.asset(
                AppAssets.registerBrandIcon,
                width: 11.25,
                height: 11.25,
              ),
            ),
          ),
          const SizedBox(width: 6),
          const Text('BREWLY', style: AppTextStyles.brandLabel),
        ],
      ),
    );
  }
}
