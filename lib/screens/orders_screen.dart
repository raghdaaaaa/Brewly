import 'package:flutter/material.dart';

import '../core/theme/app_colors.dart';
import '../core/theme/app_spacing.dart';
import '../core/theme/app_text_styles.dart';
import '../models/order.dart';
import '../services/dummy/dummy_data.dart';
import '../services/order_service.dart';
import '../widgets/app_header.dart';
import '../widgets/orders/order_card.dart';
import '../widgets/orders/orders_empty_state.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  late Future<List<Order>> _ordersFuture;

  @override
  void initState() {
    super.initState();
    _ordersFuture = _fetchOrders();
  }

  Future<List<Order>> _fetchOrders() async {
    try {
      final orders = await OrderService().getOrders();
      if (orders.isNotEmpty) return orders;
    } catch (_) {
      // Unauthenticated or network error; fall back to dummy orders.
    }
    return dummyOrders;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            setState(() {
              _ordersFuture = _fetchOrders();
            });
            await _ordersFuture;
          },
          child: ListView(
            padding: const EdgeInsets.fromLTRB(0, AppSpacing.sm, 0, 100),
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                child: AppHeaderTop(),
              ),
              const SizedBox(height: AppSpacing.lg),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                child: Text('My Orders', style: AppTextStyles.pageTitle),
              ),
              const SizedBox(height: AppSpacing.md),
              FutureBuilder<List<Order>>(
                future: _ordersFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Padding(
                      padding: EdgeInsets.only(top: AppSpacing.xxl),
                      child: Center(
                        child: CircularProgressIndicator(color: AppColors.primaryColor),
                      ),
                    );
                  }

                  final orders = snapshot.data ?? dummyOrders;
                  if (orders.isEmpty) {
                    return const OrdersEmptyState();
                  }

                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: orders.length,
                    itemBuilder: (context, index) => OrderCard(
                      order: orders[index],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
