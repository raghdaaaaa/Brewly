import 'package:flutter/material.dart';

import '../../core/constants/app_assets.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';

/// Top bar with back button, title "Checkout", share button, and avatar.
class CheckoutTopBar extends StatelessWidget {
  const CheckoutTopBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: AppSizes.backButton,
          height: AppSizes.backButton,
          child: Material(
            color: AppColors.softSurfaceColor,
            shape: const CircleBorder(),
            child: InkWell(
              onTap: () => Navigator.of(context).maybePop(),
              customBorder: const CircleBorder(),
              child: const Center(
                child: Icon(
                  Icons.arrow_back_rounded,
                  size: 20,
                  color: AppColors.textColor,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.lg),
        const Expanded(
          child: Text(
            'Checkout',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.detailsTopBarTitle,
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Container(
          width: AppSizes.detailsAvatar,
          height: AppSizes.detailsAvatar,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.cardColor, width: 2),
            image: const DecorationImage(
              image: AssetImage(AppAssets.userAvatar),
              fit: BoxFit.cover,
            ),
          ),
        ),
      ],
    );
  }
}
