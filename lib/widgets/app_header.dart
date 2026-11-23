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
