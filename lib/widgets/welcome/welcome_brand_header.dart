import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../core/constants/app_assets.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';

/// Round emerald brand mark, steam accent and "Brewly" wordmark.
class WelcomeBrandHeader extends StatelessWidget {
  const WelcomeBrandHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        top: AppSpacing.sm,
        bottom: AppSpacing.lg,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 56,
            height: 56,
            child: Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.center,
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: const BoxDecoration(
                    color: AppColors.primaryColor,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primaryShadow20,
                        blurRadius: 6,
                        spreadRadius: -1,
                        offset: Offset(0, 2),
                      ),
                      BoxShadow(
                        color: AppColors.primaryShadow20,
                        blurRadius: 4,
                        spreadRadius: -2,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: 18,
                  height: 18,
                  child: SvgPicture.asset(AppAssets.welcomeSteamIcon),
                ),
                Positioned(
                  top: -4,
                  right: 10,
                  child: Row(
                    children: [
                      Container(
                        width: AppSpacing.sm,
                        height: AppSpacing.sm,
                        decoration: BoxDecoration(
                          color: AppColors.accentColor.withValues(alpha: 0.75),
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.xs),
                      Container(
                        width: AppSpacing.sm,
                        height: AppSpacing.sm,
                        decoration: const BoxDecoration(
                          color: AppColors.accentColor,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Brewly', style: AppTextStyles.displayTitle),
              const SizedBox(width: 6),
              Container(
                width: 6,
                height: 6,
                decoration: const BoxDecoration(
                  color: AppColors.accentColor,
                  shape: BoxShape.circle,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
