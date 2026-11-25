import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../core/constants/app_assets.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_spacing.dart';
import '../core/theme/app_text_styles.dart';
import 'common/brewly_brand_lockup.dart';
import 'common/profile_avatar.dart';

/// Round back button with an optional title.
class AppHeaderBack extends StatelessWidget {
  const AppHeaderBack({super.key, this.title});

  final String? title;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        InkWell(
          onTap: () => Navigator.of(context).pop(),
          borderRadius: const BorderRadius.all(Radius.circular(AppRadius.pill)),
          child: Container(
            width: 40,
            height: 40,
            decoration: const BoxDecoration(
              color: AppColors.softSurfaceDeepColor,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppColors.shadowBlack10,
                  blurRadius: 6,
                  offset: Offset(0, 4),
                ),
                BoxShadow(
                  color: AppColors.shadowBlack10,
                  blurRadius: 4,
                  offset: Offset(-2, 2),
                ),
              ],
            ),
            child: Center(
              child: SvgPicture.asset(
                AppAssets.backArrow,
                width: 9.8125,
                height: 16.6667,
              ),
            ),
          ),
        ),
        if (title != null)
          Expanded(child: Text(title!, style: AppTextStyles.pageTitle)),
      ],
    );
  }
}

/// Home brand and action row.
class AppHeaderTop extends StatelessWidget {
  const AppHeaderTop({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
      child: Row(
        children: [
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [BrewlyBrandLockup()],
            ),
          ),
          InkWell(
            onTap: () {
              ScaffoldMessenger.of(context)
                  .showSnackBar(const SnackBar(content: Text('Coming soon')));
            },
            borderRadius: const BorderRadius.all(
              Radius.circular(AppRadius.pill),
            ),
            child: Container(
              width: AppSizes.headerAction,
              height: AppSizes.headerAction,
              decoration: const BoxDecoration(
                color: AppColors.softSurfaceColor,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.notifications_none_rounded,
                size: 20,
                color: AppColors.textColor,
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          const ProfileAvatar(size: AppSizes.headerAction, borderWidth: 2),
        ],
      ),
    );
  }
}
