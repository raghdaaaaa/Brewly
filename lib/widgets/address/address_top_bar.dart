import 'package:flutter/material.dart';

import '../common/profile_avatar.dart';
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
        const ProfileAvatar(),
      ],
    );
  }
}
