import 'package:flutter/material.dart';

import '../core/errors/app_exception.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_spacing.dart';
import '../core/theme/app_text_styles.dart';
import '../models/order.dart';
import '../services/order_service.dart';
import '../widgets/app_header.dart';
import '../widgets/error_retry.dart';
import '../widgets/loading_indicator.dart';
import '../widgets/orders/order_card.dart';
import '../widgets/orders/orders_empty_state.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key, this.orderService});

  final OrderService? orderService;

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  late final OrderService _orderService = widget.orderService ?? OrderService();
  late Future<List<Order>> _ordersFuture;

  @override
  void initState() {
    super.initState();
    _ordersFuture = _fetchOrders();
  }

  Future<List<Order>> _fetchOrders() {
    return _orderService.getOrders();
  }

  void _reload() {
    setState(() {
      _ordersFuture = _fetchOrders();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            _reload();
            await _ordersFuture.catchError((_) => <Order>[]);
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
                    return const LoadingIndicator();
                  }

                  if (snapshot.hasError) {
                    final error = snapshot.error;
                    return ErrorRetry(
                      message: error is AppException
                          ? error.message
                          : 'Could not load your orders. Please try again.',
                      onRetry: _reload,
                    );
                  }

                  final orders = snapshot.data ?? const [];
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
