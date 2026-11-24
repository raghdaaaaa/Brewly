import 'package:brewly/core/errors/app_exception.dart';
import 'package:brewly/core/routes/app_routes.dart';
import 'package:brewly/models/address.dart';
import 'package:brewly/models/basket.dart';
import 'package:brewly/models/order.dart';
import 'package:brewly/screens/checkout_screen.dart';
import 'package:brewly/services/dummy/dummy_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../fakes/fake_basket_service.dart';
import '../fakes/fake_order_service.dart';

class _FailingCreateOrderService extends FakeOrderService {
  @override
  Future<Order> createOrder({
    required int deliveryMethodId,
    required Address shippingAddress,
  }) async {
    throw const AppException('Order creation failed');
  }
}

void main() {
  testWidgets('checkout screen renders without overflow', (tester) async {
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

        final basketService = FakeBasketService(items: dummyBasketItems);
        final orderService = FakeOrderService();
        await tester.pumpWidget(
          MaterialApp(
            home: CheckoutScreen(
              basketService: basketService,
              orderService: orderService,
            ),
          ),
        );
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
        expect(find.text('Delivery Address'), findsOneWidget);
        expect(find.textContaining('Place order'), findsOneWidget);
      }
    }
  });

  testWidgets('checkout computes basket subtotal and does not succeed on error', (
    tester,
  ) async {
    final customItem = BasketItem(
      id: 99,
      productName: 'Single Origin V60',
      pictureUrl: '',
      price: 120,
      quantity: 2,
    );
    final basketService = FakeBasketService(items: [customItem]);
    final orderService = _FailingCreateOrderService();

    await tester.pumpWidget(
      MaterialApp(
        routes: {
          AppRoutes.orderSuccessRoute: (_) => const Scaffold(
                body: Text('Order Confirmed!'),
              ),
        },
        home: CheckoutScreen(
          basketService: basketService,
          orderService: orderService,
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('240 EGP'), findsOneWidget);
    expect(find.text('275 EGP'), findsOneWidget);

    await tester.enterText(find.byType(TextFormField).at(0), 'Omar');
    await tester.enterText(find.byType(TextFormField).at(1), 'El-Sayed');
    await tester.enterText(find.byType(TextFormField).at(2), '14 Gezira St');
    await tester.enterText(find.byType(TextFormField).at(3), 'Cairo');

    final placeOrderFinder = find.textContaining('Place order');
    await tester.ensureVisible(placeOrderFinder);
    await tester.tap(placeOrderFinder);
    await tester.pumpAndSettle();

    expect(find.text('Order creation failed'), findsOneWidget);
    expect(find.text('Order Confirmed!'), findsNothing);
    expect((await basketService.getBasket()).items, isNotEmpty);
  });
}
