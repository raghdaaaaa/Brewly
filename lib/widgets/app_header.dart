import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../core/constants/app_assets.dart';
import '../core/routes/app_routes.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_spacing.dart';
import '../core/theme/app_text_styles.dart';
import '../models/address.dart';
import '../services/auth_service.dart';

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

/// Top navigation bar (brand + location + bell + avatar).
class AppHeaderTop extends StatelessWidget {
  const AppHeaderTop({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'BREWLY\nROASTERS',
                  style: AppTextStyles.wordmark,
                ),
                const SizedBox(height: 2),
                InkWell(
                  onTap: () => Navigator.pushNamed(context, AppRoutes.addressRoute),
                  borderRadius: BorderRadius.circular(AppRadius.sm),
                  child: ValueListenableBuilder<Address?>(
                    valueListenable: AuthService.savedAddress,
                    builder: (context, address, child) {
                      final parts = address == null
                          ? const <String>[]
                          : [
                              address.city.trim(),
                              address.country.trim(),
                            ].where((part) => part.isNotEmpty).toList();
                      final locationText =
                          parts.isEmpty ? 'Cairo, Egypt' : parts.join(', ');
                      return Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Flexible(
                            child: Text(
                              locationText,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: AppTextStyles.locationTitle,
                            ),
                          ),
                          const SizedBox(width: 2),
                          const Icon(
                            Icons.keyboard_arrow_down_rounded,
                            size: 20,
                            color: AppColors.mutedTextColor,
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          InkWell(
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Coming soon')),
              );
            },
            borderRadius: BorderRadius.circular(AppRadius.pill),
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
          Container(
            width: AppSizes.headerAction,
            height: AppSizes.headerAction,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: AppColors.cardColor,
                width: 2,
              ),
              boxShadow: const [
                BoxShadow(
                  color: AppColors.shadowBlack10,
                  blurRadius: 4,
                  offset: Offset(0, 2),
                ),
              ],
              image: const DecorationImage(
                image: AssetImage(AppAssets.userAvatar),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
