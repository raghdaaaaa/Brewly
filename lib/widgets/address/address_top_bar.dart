import 'package:flutter/material.dart';

import '../../core/constants/app_assets.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';

/// Top bar in My Address screen with circular back button and user avatar.
class AddressTopBar extends StatelessWidget {
  const AddressTopBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
