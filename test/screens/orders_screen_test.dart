import 'package:brewly/core/errors/app_exception.dart';
import 'package:brewly/models/order.dart';
import 'package:brewly/screens/orders_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../fakes/fake_order_service.dart';

class _FailingOrderService extends FakeOrderService {
  @override
  Future<List<Order>> getOrders() async {
    throw const AppException('Failed to fetch orders');
  }
}

void main() {
  testWidgets('orders screen renders without overflow', (tester) async {
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
          MaterialApp(home: OrdersScreen(orderService: FakeOrderService())),
        );
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
        expect(find.text('My Orders'), findsOneWidget);
      }
    }
  });

  testWidgets('orders screen distinguishes empty state from API error', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: OrdersScreen(orderService: FakeOrderService(orders: const [])),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('No orders yet'), findsOneWidget);

    await tester.pumpWidget(
      MaterialApp(home: OrdersScreen(orderService: _FailingOrderService())),
    );
    await tester.pumpAndSettle();
    expect(find.text('Failed to fetch orders'), findsOneWidget);
    expect(find.text('Retry'), findsOneWidget);
  });
}
