import 'package:flutter/material.dart';

import '../common/profile_avatar.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';

class ProductsListHeader extends StatelessWidget {
  const ProductsListHeader({
    super.key,
    required this.onShare,
    required this.title,
  });

  final VoidCallback onShare;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: AppSizes.detailsShareButton,
          height: AppSizes.detailsShareButton,
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
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: Text(
            title,
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
                Icons.share_outlined,
                size: 18,
                color: AppColors.textColor,
              ),
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        const ProfileAvatar(),
      ],
    );
  }
}
