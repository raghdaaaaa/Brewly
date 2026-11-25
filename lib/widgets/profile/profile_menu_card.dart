import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';

class ProfileMenuCard extends StatelessWidget {
  const ProfileMenuCard({
    super.key,
    required this.onOrdersTap,
    required this.onAddressTap,
    required this.onSettingsTap,
    required this.onHelpTap,
  });

  final VoidCallback onOrdersTap;
  final VoidCallback onAddressTap;
  final VoidCallback onSettingsTap;
  final VoidCallback onHelpTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardColor,
        borderRadius: BorderRadius.circular(AppRadius.xl),
        boxShadow: [
          BoxShadow(
            color: AppColors.textColor.withValues(alpha: 0.04),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          _MenuItemRow(
            icon: Icons.receipt_long_outlined,
            title: 'My Orders',
            onTap: onOrdersTap,
            isFirst: true,
          ),
          const Divider(
            height: 1,
            thickness: 1,
            indent: AppSpacing.lg,
            endIndent: AppSpacing.lg,
            color: AppColors.borderColor,
          ),
          _MenuItemRow(
            icon: Icons.location_on_outlined,
            title: 'My Address',
            onTap: onAddressTap,
          ),
          const Divider(
            height: 1,
            thickness: 1,
            indent: AppSpacing.lg,
            endIndent: AppSpacing.lg,
            color: AppColors.borderColor,
          ),
          _MenuItemRow(
            icon: Icons.tune_rounded,
            title: 'Settings',
            onTap: onSettingsTap,
          ),
          const Divider(
            height: 1,
            thickness: 1,
            indent: AppSpacing.lg,
            endIndent: AppSpacing.lg,
            color: AppColors.borderColor,
          ),
          _MenuItemRow(
            icon: Icons.headset_mic_outlined,
            title: 'Help & Support',
            onTap: onHelpTap,
            isLast: true,
          ),
        ],
      ),
    );
  }
}

class _MenuItemRow extends StatelessWidget {
  const _MenuItemRow({
    required this.icon,
    required this.title,
    required this.onTap,
    this.isFirst = false,
    this.isLast = false,
  });

  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final bool isFirst;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.vertical(
        top: isFirst ? const Radius.circular(AppRadius.xl) : Radius.zero,
        bottom: isLast ? const Radius.circular(AppRadius.xl) : Radius.zero,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: 14,
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: const BoxDecoration(
                color: AppColors.softSurfaceColor,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Icon(
                  icon,
                  size: 22,
                  color: AppColors.primaryColor,
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.lg),
            Expanded(
              child: Text(
                title,
                style: AppTextStyles.subtitle,
              ),
            ),
            const Icon(
              Icons.chevron_right_rounded,
              size: 20,
              color: AppColors.chevronColor,
            ),
          ],
        ),
      ),
    );
  }
}
