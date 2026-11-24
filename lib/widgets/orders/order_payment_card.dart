import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/utils/formatters.dart';
import '../../models/order.dart';

/// Card showing payment summary with subtotal, delivery fee, and total paid.
class OrderPaymentCard extends StatelessWidget {
  const OrderPaymentCard({super.key, required this.order});

  final Order order;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.cardColor,
        borderRadius: BorderRadius.circular(AppRadius.xl),
        boxShadow: [
          BoxShadow(
            color: AppColors.textColor.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Payment Summary', style: AppTextStyles.sectionTitle),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              const Expanded(
                child: Text(
                  'Subtotal',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.bodyMuted,
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Text(
                Formatters.price(order.subtotal),
                style: AppTextStyles.summaryValue,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Row(
            children: [
              const Expanded(
                child: Text(
                  'Delivery Fee',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.bodyMuted,
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Text(
                Formatters.price(order.deliveryCost),
                style: AppTextStyles.summaryValue,
              ),
            ],
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: AppSpacing.md),
            child: Divider(height: 1, color: AppColors.borderColor),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Expanded(
                child: Text('Total Paid', style: AppTextStyles.cardTitle),
              ),
              const SizedBox(width: AppSpacing.md),
              Text(
                Formatters.price(order.total),
                style: AppTextStyles.priceTotal.copyWith(
                  color: AppColors.primaryColor,
                  fontSize: 22,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
