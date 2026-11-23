import 'package:flutter/material.dart';

import '../core/theme/app_colors.dart';
import '../core/theme/app_spacing.dart';
import '../core/theme/app_text_styles.dart';
import '../models/order.dart';
import '../services/dummy/dummy_data.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Orders')),
      body: dummyOrders.isEmpty
          ? _buildEmptyState()
          : ListView.builder(
              itemCount: dummyOrders.length,
              itemBuilder: (context, index) =>
                  _buildOrderCard(context, dummyOrders[index]),
            ),
    );
  }

  // Simple empty state, in case the user has no orders yet.
  Widget _buildEmptyState() {
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

  // One order card: id, status, date, item count and total.
  Widget _buildOrderCard(BuildContext context, Order order) {
    return InkWell(
      onTap: () => _showOrderDetails(context, order),
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
              // Order number + status chip.
              Row(
                children: [
                  Expanded(
                    child: Text(order.id, style: AppTextStyles.title),
                  ),
                  _buildStatusChip(order.status),
                ],
              ),
              const SizedBox(height: AppSpacing.sm),

              // Order date.
              Text(order.orderDate, style: AppTextStyles.caption),
              const SizedBox(height: AppSpacing.sm),

              // Item count + total.
              Row(
                children: [
                  Text(
                    '${order.items.length} '
                    '${order.items.length == 1 ? 'item' : 'items'}',
                    style: AppTextStyles.cardTitleMuted,
                  ),
                  const Spacer(),
                  Text(
                    '${order.total.toStringAsFixed(0)} EGP',
                    style: AppTextStyles.priceTotal,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Small colored pill with the order status.
  Widget _buildStatusChip(String status) {
    final isPreparation = status == 'In preparation';
    final isCancelled = status == 'Cancelled';
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: isCancelled
            ? AppColors.errorColor
            : isPreparation
                ? AppColors.emeraldTintColor
                : AppColors.borderColor,
        borderRadius: const BorderRadius.all(
          Radius.circular(AppRadius.pill),
        ),
      ),
      child: Text(
        status,
        style: AppTextStyles.statusPill.copyWith(
          color: isCancelled || isPreparation
              ? AppColors.onAccentColor
              : AppColors.mutedTextColor,
        ),
      ),
    );
  }

  // Bottom sheet with the order details:
  // items, shipping address, delivery method, subtotal, delivery and total.
  void _showOrderDetails(BuildContext context, Order order) {
    final delivery = dummyDeliveryMethods.first;
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppRadius.lg),
        ),
      ),
      builder: (sheetContext) {
        return ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(sheetContext).size.height * 0.85,
          ),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 28),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Order id + status.
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          order.id,
                          style: AppTextStyles.titleLarge,
                        ),
                      ),
                      _buildStatusChip(order.status),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.lg),

                  // Items.
                  for (final item in order.items)
                    _buildSheetItemRow(item),

                  const SizedBox(height: AppSpacing.lg),

                  // Shipping address.
                  _buildSheetSectionTitle('Shipping address'),
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

                  // Delivery method.
                  _buildSheetSectionTitle('Delivery method'),
                  Text(delivery.shortName, style: AppTextStyles.cardTitle),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    '${delivery.deliveryTime} · '
                    '${delivery.cost == 0 ? 'Free' : '${delivery.cost.toStringAsFixed(0)} EGP'}',
                    style: AppTextStyles.caption,
                  ),
                  const SizedBox(height: AppSpacing.lg),

                  // Summary: subtotal, delivery cost and total.
                  _buildSheetSectionTitle('Summary'),
                  _buildSummaryRow(
                    'Subtotal',
                    '${order.subtotal.toStringAsFixed(0)} EGP',
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  _buildSummaryRow(
                    'Delivery',
                    delivery.cost == 0
                        ? 'Free'
                        : '${delivery.cost.toStringAsFixed(0)} EGP',
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: AppSpacing.md),
                    child: Divider(height: 1),
                  ),
                  Row(
                    children: [
                      const Text('Total', style: AppTextStyles.subtitle),
                      const Spacer(),
                      Text(
                        '${order.total.toStringAsFixed(0)} EGP',
                        style: AppTextStyles.priceTotal,
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.lg),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // One item row inside the order sheet: image, name, quantity, price.
  Widget _buildSheetItemRow(OrderItem item) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          // Small product image.
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
          Text(
            '${item.lineTotal.toStringAsFixed(0)} EGP',
            style: AppTextStyles.priceSmall,
          ),
        ],
      ),
    );
  }

  Widget _buildSheetSectionTitle(String title) {
    return Text(title, style: AppTextStyles.sectionLabel);
  }

  Widget _buildSummaryRow(String label, String value) {
    return Row(
      children: [
        Text(label, style: AppTextStyles.bodyMuted),
        const Spacer(),
        Text(value, style: AppTextStyles.summaryValue),
      ],
    );
  }
}
