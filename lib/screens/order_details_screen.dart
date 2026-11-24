import 'package:flutter/material.dart';

import '../core/errors/app_exception.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_spacing.dart';
import '../models/order.dart';
import '../services/order_service.dart';
import '../widgets/common/empty_view.dart';
import '../widgets/error_retry.dart';
import '../widgets/loading_indicator.dart';
import '../widgets/orders/order_details_top_bar.dart';
import '../widgets/orders/order_items_card.dart';
import '../widgets/orders/order_payment_card.dart';
import '../widgets/orders/order_track_button.dart';

class OrderDetailsScreen extends StatefulWidget {
  const OrderDetailsScreen({
    super.key,
    this.order,
    this.orderId,
    this.orderService,
  });

  final Order? order;
  final int? orderId;
  final OrderService? orderService;

  @override
  State<OrderDetailsScreen> createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {
  late final OrderService _orderService = widget.orderService ?? OrderService();

  Order? _order;
  Future<Order>? _orderFuture;

  int? get _resolvedOrderId {
    if (widget.orderId != null) {
      return widget.orderId;
    }
    if (widget.order != null) {
      return int.tryParse(widget.order!.id);
    }
    return null;
  }

  @override
  void initState() {
    super.initState();
    _order = widget.order;
    final id = _resolvedOrderId;
    if (_order == null && id != null) {
      _orderFuture = _orderService.getOrder(id);
    } else if (_order != null && id != null) {
      _refreshFromApi(id);
    }
  }

  Future<void> _refreshFromApi(int id) async {
    try {
      final fresh = await _orderService.getOrder(id);
      if (!mounted) return;
      setState(() {
        _order = fresh;
      });
    } catch (_) {}
  }

  void _retryLoad() {
    final id = _resolvedOrderId;
    if (id == null) return;
    setState(() {
      _orderFuture = _orderService.getOrder(id);
    });
  }

  Widget _buildOrderContent(BuildContext context, Order order) {
    final statusLabel =
        order.status.isNotEmpty ? order.status.toLowerCase() : 'in preparation';

    return Column(
      children: [
        Expanded(
          child: ListView(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.lg,
              vertical: AppSpacing.md,
            ),
            children: [
              OrderDetailsTopBar(orderId: order.id),
              const SizedBox(height: AppSpacing.lg),
              OrderItemsCard(order: order),
              const SizedBox(height: AppSpacing.lg),
              OrderPaymentCard(order: order),
              const SizedBox(height: AppSpacing.lg),
            ],
          ),
        ),
        OrderTrackButton(
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Order #${order.id} is $statusLabel'),
              ),
            );
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final loaded = _order;
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SafeArea(
        child: loaded != null
            ? _buildOrderContent(context, loaded)
            : _orderFuture == null
                ? EmptyView(
                    icon: Icons.receipt_long_outlined,
                    title: 'Order not found',
                    message: 'Open an order from My Orders to see its details.',
                    actionLabel: 'Go back',
                    onAction: () => Navigator.of(context).maybePop(),
                  )
                : FutureBuilder<Order>(
                    future: _orderFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const LoadingIndicator();
                      }
                      if (snapshot.hasError) {
                        final error = snapshot.error;
                        return ErrorRetry(
                          message: error is AppException
                              ? error.message
                              : 'Could not load order details. Please try again.',
                          onRetry: _retryLoad,
                        );
                      }
                      final fetched = snapshot.data;
                      if (fetched == null) {
                        return EmptyView(
                          icon: Icons.receipt_long_outlined,
                          title: 'Order not found',
                          message:
                              'Open an order from My Orders to see its details.',
                          actionLabel: 'Go back',
                          onAction: () => Navigator.of(context).maybePop(),
                        );
                      }
                      return _buildOrderContent(context, fetched);
                    },
                  ),
      ),
    );
  }
}
