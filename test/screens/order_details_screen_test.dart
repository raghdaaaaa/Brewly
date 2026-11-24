import 'package:brewly/models/order.dart';
import 'package:brewly/screens/order_details_screen.dart';
import 'package:brewly/services/dummy/dummy_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../fakes/fake_order_service.dart';

void main() {
  testWidgets('order details screen renders without overflow', (tester) async {
    final order = dummyOrders.first;
    for (final size in [
      const Size(320, 640),
      const Size(360, 800),
      const Size(390, 844),
      const Size(430, 932),
    ]) {
      for (final scale in [1.0, 1.3]) {
        tester.view.physicalSize = size;
        tester.view.devicePixelRatio = 1.0;
        tester.platformDispatcher.textScaleFactorTestValue = scale;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);
        addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);

        await tester.pumpWidget(
          MaterialApp(home: OrderDetailsScreen(order: order)),
        );
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
        expect(find.textContaining(order.id), findsWidgets);
      }
    }
  });

  testWidgets('order details screen loads order by orderId from service', (
    tester,
  ) async {
    const apiOrder = Order(
      id: '88',
      orderDate: '2026-11-24',
      status: 'Pending',
      total: 250,
      deliveryCost: 35,
      subTotal: 215,
      items: [
        OrderItem(
          name: 'Spanish Iced Latte',
          pictureUrl: '',
          price: 215,
          quantity: 1,
        ),
      ],
    );
    final orderService = FakeOrderService(orders: [apiOrder]);

    await tester.pumpWidget(
      MaterialApp(
        home: OrderDetailsScreen(orderId: 88, orderService: orderService),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Order #88'), findsOneWidget);
    expect(find.text('Spanish Iced Latte'), findsOneWidget);
    expect(find.text('250 EGP'), findsOneWidget);
  });
}
