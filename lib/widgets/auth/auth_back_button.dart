import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../core/constants/app_assets.dart';
import '../../core/theme/app_colors.dart';

class AuthBackButton extends StatelessWidget {
  const AuthBackButton({
    super.key,
    this.onTap,
    this.iconAsset = AppAssets.backArrow,
    this.iconWidth = 9.8125,
    this.iconHeight = 16.6667,
  });

  final VoidCallback? onTap;
  final String iconAsset;
  final double iconWidth;
  final double iconHeight;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.softSurfaceDeepColor,
      shape: const CircleBorder(),
      elevation: 2,
      shadowColor: AppColors.shadowBlack10,
      child: InkWell(
        onTap: onTap ?? () => Navigator.of(context).maybePop(),
        customBorder: const CircleBorder(),
        child: SizedBox(
          width: 44,
          height: 44,
          child: Center(
            child: SvgPicture.asset(
              iconAsset,
              width: iconWidth,
              height: iconHeight,
            ),
          ),
        ),
      ),
    );
  }
}
