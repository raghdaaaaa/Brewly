import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../models/order.dart';
import '../../services/dummy/dummy_data.dart';
import '../widgets/orders/order_details_top_bar.dart';
import '../widgets/orders/order_items_card.dart';
import '../widgets/orders/order_payment_card.dart';
import '../widgets/orders/order_track_button.dart';

class OrderDetailsScreen extends StatelessWidget {
  const OrderDetailsScreen({super.key, this.order});

  final Order? order;

  @override
  Widget build(BuildContext context) {
    final effectiveOrder = order ?? dummyOrders.first;

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.lg,
                  vertical: AppSpacing.md,
                ),
                children: [
                  OrderDetailsTopBar(orderId: effectiveOrder.id),
                  const SizedBox(height: AppSpacing.lg),
                  OrderItemsCard(order: effectiveOrder),
                  const SizedBox(height: AppSpacing.lg),
                  OrderPaymentCard(order: effectiveOrder),
                  const SizedBox(height: AppSpacing.lg),
                ],
              ),
            ),
            OrderTrackButton(
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Order #${effectiveOrder.id} is in preparation',
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
