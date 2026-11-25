import 'dart:io';

import 'package:flutter/material.dart';

import '../../core/constants/app_assets.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../services/profile_image_service.dart';

class ProfileHeaderCard extends StatelessWidget {
  const ProfileHeaderCard({
    super.key,
    required this.name,
    required this.email,
    required this.onAvatarTap,
    required this.isPickingImage,
  });

  final String name;
  final String email;
  final VoidCallback onAvatarTap;
  final bool isPickingImage;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        vertical: AppSpacing.xl,
        horizontal: AppSpacing.lg,
      ),
      decoration: BoxDecoration(
        color: AppColors.cardColor,
        borderRadius: BorderRadius.circular(AppRadius.xl),
        gradient: const LinearGradient(
          begin: Alignment.bottomLeft,
          end: Alignment.topRight,
          colors: [
            AppColors.profileGradientStart,
            AppColors.cardColor,
            AppColors.profileGradientEnd,
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.textColor.withValues(alpha: 0.04),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              Tooltip(
                message: 'Change profile photo',
                child: InkWell(
                  onTap: isPickingImage ? null : onAvatarTap,
                  customBorder: const CircleBorder(),
                  child: Container(
                    width: 96,
                    height: 96,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.cardColor, width: 4),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.textColor.withValues(alpha: 0.08),
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: ClipOval(
                      child: ValueListenableBuilder<String?>(
                        valueListenable: ProfileImageService.selectedImagePath,
                        builder: (context, imagePath, child) {
                          if (imagePath == null) {
                            return Image.asset(
                              AppAssets.userAvatar,
                              fit: BoxFit.cover,
                            );
                          }
                          return Image.file(
                            File(imagePath),
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Image.asset(
                                AppAssets.userAvatar,
                                fit: BoxFit.cover,
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: AppColors.primaryColor,
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.cardColor, width: 2),
                  ),
                  child: const Icon(
                    Icons.camera_alt_rounded,
                    size: 16,
                    color: AppColors.cardColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(name, style: AppTextStyles.profileName),
          const SizedBox(height: AppSpacing.xs),
          Text(email, style: AppTextStyles.bodyMuted),
        ],
      ),
    );
  }
}
