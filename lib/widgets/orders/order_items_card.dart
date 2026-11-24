import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../models/order.dart';

/// Card showing the items in the order, with category pills and price breakdown.
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
                  receiptNumber.isNotEmpty ? 'Receipt #$receiptNumber' : 'Receipt',
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
            if (i > 0) const Divider(height: 24, color: AppColors.borderColor),
            _OrderItemRow(item: order.items[i], index: i),
          ],
        ],
      ),
    );
  }
}

class _OrderItemRow extends StatelessWidget {
  const _OrderItemRow({required this.item, required this.index});

  final OrderItem item;
  final int index;

  @override
  Widget build(BuildContext context) {
    final isBakery = item.name.toLowerCase().contains('chocolat') ||
        item.name.toLowerCase().contains('croissant') ||
        item.name.toLowerCase().contains('pain') ||
        index % 2 == 1;

    final badgeText = isBakery ? 'TBS BAKERY' : 'BREWLY RESERVE';
    final badgeBg = isBakery ? const Color(0xFFFEF3C7) : const Color(0xFFDCFCE7);
    final badgeColor = isBakery ? const Color(0xFFB45309) : const Color(0xFF15803D);

    final subtitle = isBakery
        ? 'Warm · Extra Flaky Layer'
        : 'Oat Milk · Whole Bean Grind';

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(AppRadius.md),
          child: SizedBox(
            width: 60,
            height: 60,
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
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: badgeBg,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  badgeText,
                  style: TextStyle(
                    fontFamily: AppTextStyles.fontFamily,
                    fontSize: 9,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.5,
                    color: badgeColor,
                  ),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                item.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.cardTitle,
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.caption,
              ),
              const SizedBox(height: 6),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Qty: ${item.quantity}', style: AppTextStyles.caption),
                  Text(
                    '${item.lineTotal.toStringAsFixed(0)} EGP',
                    style: AppTextStyles.priceSmall.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
