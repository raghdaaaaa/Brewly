import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../core/constants/app_assets.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';

/// Back button, "Product Detail" title, share button and avatar.
class ProductsListHeader extends StatelessWidget {
  const ProductsListHeader({super.key, required this.onShare});

  final VoidCallback onShare;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: AppSizes.backButton,
          height: AppSizes.backButton,
          child: Material(
            color: AppColors.softSurfaceDeepColor,
            shape: const CircleBorder(),
            child: InkWell(
              onTap: () => Navigator.of(context).maybePop(),
              customBorder: const CircleBorder(),
              child: Center(
                child: SvgPicture.asset(
                  AppAssets.backArrow,
                  width: 10,
                  height: 17,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.md),
        const Expanded(
          child: Text(
            'Product Detail',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.detailsTopBarTitle,
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        SizedBox(
          width: AppSizes.headerAction,
          height: AppSizes.headerAction,
          child: Material(
            color: AppColors.softSurfaceColor,
            shape: const CircleBorder(),
            child: InkWell(
              onTap: onShare,
              customBorder: const CircleBorder(),
              child: const Icon(
                Icons.ios_share_rounded,
                size: 20,
                color: AppColors.textColor,
              ),
            ),
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
