import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../core/constants/app_assets.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_spacing.dart';
import '../core/theme/app_text_styles.dart';

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
          borderRadius: const BorderRadius.all(
            Radius.circular(AppRadius.pill),
          ),
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
          Expanded(
            child: Text(
              title!,
              style: AppTextStyles.pageTitle,
            ),
          ),
      ],
    );
  }
}

/// Top navigation bar (location block + bell + avatar).
class AppHeaderTop extends StatelessWidget {
  const AppHeaderTop({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
      child: Row(
        children: [
          const Expanded(
            child: Text(
              'BREWLY ROASTERS / Zamalek, Cairo',
              style: AppTextStyles.brandCaps,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          IconButton(
            tooltip: 'Notifications',
            icon: const Icon(
              Icons.notifications_outlined,
              size: 20,
              color: AppColors.mutedTextColor,
            ),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Coming soon')),
              );
            },
          ),
          Container(
            width: 32,
            height: 32,
            decoration: const BoxDecoration(
              color: AppColors.primaryColor,
              shape: BoxShape.circle,
            ),
            child: const Center(
              child: Text('OE', style: AppTextStyles.avatarInitials),
            ),
          ),
        ],
      ),
    );
  }
}
