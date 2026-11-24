import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';

/// Logout card with red icon, label, and forward arrow.
class ProfileLogoutCard extends StatelessWidget {
  const ProfileLogoutCard({
    super.key,
    required this.onTap,
  });

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.lg),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: 14,
        ),
        decoration: BoxDecoration(
          color: AppColors.cardColor,
          borderRadius: BorderRadius.circular(AppRadius.lg),
          boxShadow: [
            BoxShadow(
              color: AppColors.textColor.withValues(alpha: 0.04),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: const BoxDecoration(
                color: AppColors.logoutIconBackground,
                shape: BoxShape.circle,
              ),
              child: const Center(
                child: Icon(
                  Icons.logout_rounded,
                  color: AppColors.errorColor,
                  size: 22,
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.lg),
            const Expanded(
              child: Text(
                'Log out',
                style: AppTextStyles.dangerLabel,
              ),
            ),
            const Icon(
              Icons.arrow_forward_rounded,
              color: AppColors.errorColor,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}
