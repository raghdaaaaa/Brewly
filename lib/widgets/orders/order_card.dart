import 'package:flutter/material.dart';

import '../../core/routes/app_routes.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/utils/formatters.dart';
import '../../models/order.dart';
import 'order_status_chip.dart';

/// Card representing one order in the My Orders list.
class OrderCard extends StatelessWidget {
  const OrderCard({super.key, required this.order});

  final Order order;

  @override
  Widget build(BuildContext context) {
    final normalized = order.status.toLowerCase();
    final isInPreparation =
        normalized.contains('preparation') || normalized.contains('pending');
    final isCancelled = normalized.contains('cancel');

    final IconData statusIcon;
    final Color statusIconColor;

    if (isCancelled) {
      statusIcon = Icons.cancel_outlined;
      statusIconColor = AppColors.errorColor;
    } else if (isInPreparation) {
      statusIcon = Icons.receipt_long_outlined;
      statusIconColor = AppColors.primaryColor;
    } else {
      statusIcon = Icons.check_circle_outline_rounded;
      statusIconColor = AppColors.textColor;
    }

    return InkWell(
      onTap: () {
        Navigator.pushNamed(
          context,
          AppRoutes.orderDetailsRoute,
          arguments: order,
        );
      },
      borderRadius: BorderRadius.circular(AppRadius.xl),
      child: Container(
        margin: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.xs,
        ),
        padding: const EdgeInsets.all(AppSpacing.md),
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
            Row(
              children: [
                Icon(statusIcon, size: 16, color: statusIconColor),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '#${order.id}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.title,
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        Formatters.orderDate(order.orderDate),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.caption,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: AppSpacing.xs),
                OrderStatusChip(status: order.status),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            Row(
              mainAxisAlignment: isInPreparation
                  ? MainAxisAlignment.spaceBetween
                  : MainAxisAlignment.end,
              children: [
                if (isInPreparation) ...[
                  Expanded(
                    child: Text(
                      Formatters.price(order.total),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.priceTotal,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Flexible(
                    child: SizedBox(
                      height: 36,
                      child: FilledButton(
                        onPressed: () {
                          Navigator.pushNamed(
                            context,
                            AppRoutes.orderDetailsRoute,
                            arguments: order,
                          );
                        },
                        style: FilledButton.styleFrom(
                          backgroundColor: AppColors.primaryColor,
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.md,
                          ),
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(AppRadius.pill),
                            ),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Flexible(
                              child: Text(
                                'Track Order',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: AppTextStyles.buttonLabel.copyWith(
                                  fontSize: 11,
                                  color: AppColors.cardColor,
                                ),
                              ),
                            ),
                            const SizedBox(width: AppSpacing.xs),
                            const Icon(
                              Icons.arrow_forward_rounded,
                              size: 14,
                              color: AppColors.cardColor,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ] else ...[
                  Text(
                    Formatters.price(order.total),
                    style: AppTextStyles.priceTotal,
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}
