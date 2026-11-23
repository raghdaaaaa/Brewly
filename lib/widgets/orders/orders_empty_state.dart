import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';

class OrdersEmptyState extends StatelessWidget {
  const OrdersEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(AppSpacing.xxl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.receipt_long_outlined,
              size: 48,
              color: AppColors.mutedTextColor,
            ),
            SizedBox(height: AppSpacing.lg),
            Text('No orders yet', style: AppTextStyles.titleLarge),
            SizedBox(height: AppSpacing.sm),
            Text(
              'Place an order from the Cart screen.',
              textAlign: TextAlign.center,
              style: AppTextStyles.bodyMuted,
            ),
          ],
        ),
      ),
    );
  }
}
