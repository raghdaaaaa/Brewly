import 'package:flutter/material.dart';

import '../services/dummy/dummy_data.dart';
import '../widgets/orders/order_card.dart';
import '../widgets/orders/orders_empty_state.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Orders')),
      body: dummyOrders.isEmpty
          ? const OrdersEmptyState()
          : ListView.builder(
              itemCount: dummyOrders.length,
              itemBuilder: (context, index) => OrderCard(
                order: dummyOrders[index],
              ),
            ),
    );
  }
}
