import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/utils/formatters.dart';
import '../../models/order.dart';

class OrderItemsCard extends StatelessWidget {
  const OrderItemsCard({super.key, required this.order});

  final Order order;

  @override
  Widget build(BuildContext context) {
    final receiptNumber = order.id.replaceAll(RegExp(r'[^0-9]'), '');
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
          Row(
            children: [
              Expanded(
                child: Text(
                  'Items Ordered (${order.items.length})',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.sectionTitle,
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Flexible(
                child: Text(
                  receiptNumber.isNotEmpty
                      ? 'Receipt #$receiptNumber'
                      : 'Receipt',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.caption,
                  textAlign: TextAlign.right,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          for (int i = 0; i < order.items.length; i++) ...[
            if (i > 0) const SizedBox(height: AppSpacing.sm),
            _OrderItemRow(item: order.items[i]),
          ],
        ],
      ),
    );
  }
}

class _OrderItemRow extends StatelessWidget {
  const _OrderItemRow({required this.item});

  final OrderItem item;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.sm),
      decoration: BoxDecoration(
        color: AppColors.softSurfaceColor,
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(AppRadius.md),
            child: SizedBox(
              width: 72,
              height: 72,
              child: item.pictureUrl.startsWith('assets/')
                  ? Image.asset(item.pictureUrl, fit: BoxFit.cover)
                  : Image.network(
                      item.pictureUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        color: AppColors.softSurfaceColor,
                        child: const Icon(
                          Icons.coffee_rounded,
                          color: AppColors.mutedTextColor,
                          size: 24,
                        ),
                      ),
                    ),
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: ConstrainedBox(
              constraints: const BoxConstraints(minHeight: 72),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.title,
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Qty: ${item.quantity}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.caption,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.xs),
                      Text(
                        Formatters.price(item.lineTotal),
                        style: AppTextStyles.priceSmall.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
