import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';

class OrderTrackButton extends StatelessWidget {
  const OrderTrackButton({super.key, required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      color: AppColors.backgroundColor,
      child: SafeArea(
        top: false,
        child: SizedBox(
          width: double.infinity,
          height: 52,
          child: FilledButton.icon(
            onPressed: onTap,
            icon: const Icon(
              Icons.local_shipping_outlined,
              color: AppColors.cardColor,
              size: 20,
            ),
            label: Text(
              'Track Order',
              style: AppTextStyles.buttonLabelBold.copyWith(
                color: AppColors.cardColor,
              ),
            ),
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.primaryColor,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(AppRadius.pill)),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
