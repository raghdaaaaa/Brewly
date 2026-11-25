import 'dart:io';

import 'package:flutter/material.dart';

import '../../core/constants/app_assets.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../services/profile_image_service.dart';

class ProfileAvatar extends StatelessWidget {
  const ProfileAvatar({
    super.key,
    this.size = AppSizes.detailsAvatar,
    this.borderWidth = 2,
  });

  final double size;
  final double borderWidth;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String?>(
      valueListenable: ProfileImageService.selectedImagePath,
      builder: (context, imagePath, child) {
        return Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.cardColor, width: borderWidth),
            boxShadow: const [
              BoxShadow(
                color: AppColors.shadowBlack10,
                blurRadius: 4,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: ClipOval(
            child: imagePath == null
                ? Image.asset(AppAssets.userAvatar, fit: BoxFit.cover)
                : Image.file(
                    File(imagePath),
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Image.asset(
                        AppAssets.userAvatar,
                        fit: BoxFit.cover,
                      );
                    },
                  ),
          ),
        );
      },
    );
  }
}
