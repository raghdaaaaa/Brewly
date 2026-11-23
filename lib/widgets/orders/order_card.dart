import 'package:flutter/material.dart';

import '../../core/routes/app_routes.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../models/order.dart';
import 'order_status_chip.dart';

class OrderCard extends StatelessWidget {
  const OrderCard({super.key, required this.order});

  final Order order;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(
          context,
          AppRoutes.orderDetailsRoute,
          arguments: order,
        );
      },
      child: Card(
        margin: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.sm,
        ),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      order.id,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.title,
                    ),
                  ),
                  const SizedBox(width: 6),
                  OrderStatusChip(status: order.status),
                ],
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(order.orderDate, style: AppTextStyles.caption),
              const SizedBox(height: AppSpacing.sm),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      '${order.items.length} '
                      '${order.items.length == 1 ? 'item' : 'items'}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.cardTitleMuted,
                    ),
                  ),
                  const Spacer(),
                  Expanded(
                    child: Text(
                      '${order.total.toStringAsFixed(0)} EGP',
                      textAlign: TextAlign.right,
                      style: AppTextStyles.priceTotal,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
