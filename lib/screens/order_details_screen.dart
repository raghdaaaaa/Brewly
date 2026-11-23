import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../models/order.dart';
import '../../services/dummy/dummy_data.dart';
import '../widgets/orders/order_status_chip.dart';

class OrderDetailsScreen extends StatelessWidget {
  const OrderDetailsScreen({super.key, this.order});

  final Order? order;

  @override
  Widget build(BuildContext context) {
    final Order? order = this.order;
    if (order == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Order Details')),
        body: const Center(
          child: Text('Order not found', style: AppTextStyles.bodyMuted),
        ),
      );
    }
    final delivery = dummyDeliveryMethods.first;
    return Scaffold(
      appBar: AppBar(title: const Text('Order Details')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.md,
          ),
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(order.id, style: AppTextStyles.pageTitle),
                ),
                OrderStatusChip(status: order.status),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            Text(order.orderDate, style: AppTextStyles.caption),
            const SizedBox(height: AppSpacing.lg),
            const Text('Items', style: AppTextStyles.sectionTitle),
            const SizedBox(height: AppSpacing.sm),
            for (final item in order.items)
              _ItemRow(item: item),
            const SizedBox(height: AppSpacing.lg),
            const Text('Shipping address', style: AppTextStyles.sectionTitle),
            const SizedBox(height: AppSpacing.sm),
            Text(
              '${dummyAddress.firstName} ${dummyAddress.lastName}',
              style: AppTextStyles.cardTitle,
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(dummyAddress.street, style: AppTextStyles.caption),
            Text(
              '${dummyAddress.city}, ${dummyAddress.country}',
              style: AppTextStyles.caption,
            ),
            const SizedBox(height: AppSpacing.lg),
            const Text('Delivery method', style: AppTextStyles.sectionTitle),
            const SizedBox(height: AppSpacing.sm),
            Text(delivery.shortName, style: AppTextStyles.cardTitle),
            const SizedBox(height: AppSpacing.xs),
            Text(
              '${delivery.deliveryTime} · '
              '${delivery.cost == 0 ? 'Free' : '${delivery.cost.toStringAsFixed(0)} EGP'}',
              style: AppTextStyles.caption,
            ),
            const SizedBox(height: AppSpacing.lg),
            const Text('Summary', style: AppTextStyles.sectionTitle),
            const SizedBox(height: AppSpacing.sm),
            _SummaryRow('Subtotal', '${order.subtotal.toStringAsFixed(0)} EGP'),
            const SizedBox(height: AppSpacing.sm),
            _SummaryRow(
              'Delivery',
              delivery.cost == 0
                  ? 'Free'
                  : '${delivery.cost.toStringAsFixed(0)} EGP',
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: AppSpacing.md),
              child: Divider(height: 1),
            ),
            _SummaryRow(
              'Total',
              '${order.total.toStringAsFixed(0)} EGP',
              emphasize: true,
            ),
            const SizedBox(height: AppSpacing.lg),
            FilledButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Back to Orders'),
            ),
          ],
        ),
      ),
    );
  }
}

class _ItemRow extends StatelessWidget {
  const _ItemRow({required this.item});

  final OrderItem item;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(AppRadius.sm),
            child: SizedBox(
              width: 48,
              height: 48,
              child: Image.network(
                item.pictureUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: AppColors.softSurfaceColor,
                    child: const Icon(
                      Icons.local_cafe,
                      size: 18,
                      color: AppColors.mutedTextColor,
                    ),
                  );
                },
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  item.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.cardTitle,
                ),
                const SizedBox(height: 2),
                Text('x${item.quantity}', style: AppTextStyles.caption),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              '${item.lineTotal.toStringAsFixed(0)} EGP',
              textAlign: TextAlign.right,
              style: AppTextStyles.priceSmall,
            ),
          ),
        ],
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow(this.label, this.value, {this.emphasize = false});

  final String label;
  final String value;
  final bool emphasize;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(label, style: AppTextStyles.bodyMuted),
        ),
        Text(
          value,
          style: emphasize ? AppTextStyles.priceTotal : AppTextStyles.summaryValue,
          textAlign: TextAlign.right,
        ),
      ],
    );
  }
}
