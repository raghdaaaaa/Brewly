import 'package:flutter/material.dart';

import '../constants.dart';
import '../dummy_data.dart';
import '../models/order.dart';

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
        padding: EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.receipt_long_outlined, size: 48, color: mutedTextColor),
            SizedBox(height: 16),
            Text(
              'No orders yet',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: textColor,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Place an order from the Cart screen.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: mutedTextColor),
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
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Order number + status chip.
              Row(
                children: [
                  Expanded(
                    child: Text(
                      order.id,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: textColor,
                      ),
                    ),
                  ),
                  _buildStatusChip(order.status),
                ],
              ),
              const SizedBox(height: 8),

              // Order date.
              Text(
                order.orderDate,
                style: const TextStyle(fontSize: 12, color: mutedTextColor),
              ),
              const SizedBox(height: 8),

              // Item count + total.
              Row(
                children: [
                  Text(
                    '${order.items.length} '
                    '${order.items.length == 1 ? 'item' : 'items'}',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: mutedTextColor,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    '${order.total.toStringAsFixed(0)} EGP',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: textColor,
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

  // Small colored pill with the order status.
  Widget _buildStatusChip(String status) {
    final isPreparation = status == 'In preparation';
    final isCancelled = status == 'Cancelled';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: isCancelled
            ? errorColor
            : isPreparation
                ? emeraldTintColor
                : borderColor,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        status,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w600,
          color: isCancelled || isPreparation ? onAccentColor : mutedTextColor,
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
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
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
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: textColor,
                          ),
                        ),
                      ),
                      _buildStatusChip(order.status),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Items.
                  for (final item in order.items)
                    _buildSheetItemRow(item),

                  const SizedBox(height: 16),

                  // Shipping address.
                  _buildSheetSectionTitle('Shipping address'),
                  Text(
                    '${dummyAddress.firstName} ${dummyAddress.lastName}',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: textColor,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    dummyAddress.street,
                    style: const TextStyle(
                      fontSize: 12,
                      color: mutedTextColor,
                    ),
                  ),
                  Text(
                    '${dummyAddress.city}, ${dummyAddress.country}',
                    style: const TextStyle(
                      fontSize: 12,
                      color: mutedTextColor,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Delivery method.
                  _buildSheetSectionTitle('Delivery method'),
                  Text(
                    delivery.shortName,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: textColor,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${delivery.deliveryTime} · '
                    '${delivery.cost == 0 ? 'Free' : '${delivery.cost.toStringAsFixed(0)} EGP'}',
                    style: const TextStyle(
                      fontSize: 12,
                      color: mutedTextColor,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Summary: subtotal, delivery cost and total.
                  _buildSheetSectionTitle('Summary'),
                  _buildSummaryRow(
                    'Subtotal',
                    '${order.subtotal.toStringAsFixed(0)} EGP',
                  ),
                  const SizedBox(height: 8),
                  _buildSummaryRow(
                    'Delivery',
                    delivery.cost == 0
                        ? 'Free'
                        : '${delivery.cost.toStringAsFixed(0)} EGP',
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    child: Divider(height: 1),
                  ),
                  Row(
                    children: [
                      const Text(
                        'Total',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: textColor,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        '${order.total.toStringAsFixed(0)} EGP',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: textColor,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
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
            borderRadius: BorderRadius.circular(12),
            child: SizedBox(
              width: 48,
              height: 48,
              child: Image.network(
                item.pictureUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: softSurfaceColor,
                    child: const Icon(
                      Icons.local_cafe,
                      size: 18,
                      color: mutedTextColor,
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
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: textColor,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'x${item.quantity}',
                  style: const TextStyle(
                    fontSize: 12,
                    color: mutedTextColor,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Text(
            '${item.lineTotal.toStringAsFixed(0)} EGP',
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSheetSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: primaryColor,
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value) {
    return Row(
      children: [
        Text(label, style: const TextStyle(fontSize: 14, color: mutedTextColor)),
        const Spacer(),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: textColor,
          ),
        ),
      ],
    );
  }
}
