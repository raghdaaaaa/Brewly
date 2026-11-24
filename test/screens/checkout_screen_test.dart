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

class _RetryableOrderService extends FakeOrderService {
  int createCalls = 0;
  bool failNextCreate = false;

  @override
  Future<Order> createOrder({
    required int deliveryMethodId,
    required Address shippingAddress,
  }) async {
    createCalls++;
    if (failNextCreate) {
      failNextCreate = false;
      throw const AppException('Order creation failed');
    }
    return super.createOrder(
      deliveryMethodId: deliveryMethodId,
      shippingAddress: shippingAddress,
    );
  }
}

class _RetryableClearBasketService extends FakeBasketService {
  _RetryableClearBasketService({
    super.items,
    this.failFirstClear = true,
  });

  final bool failFirstClear;
  int clearCalls = 0;

  @override
  Future<void> clearBasket() async {
    clearCalls++;
    if (failFirstClear && clearCalls == 1) {
      throw const AppException('Basket delete failed');
    }
    await super.clearBasket();
  }
}

MaterialApp _checkoutApp({
  required FakeBasketService basketService,
  required FakeOrderService orderService,
}) {
  return MaterialApp(
    routes: {
      AppRoutes.orderSuccessRoute: (context) {
        final arguments =
            ModalRoute.of(context)!.settings.arguments! as Map<String, Object>;
        return Scaffold(
          body: Text(
            'Order Confirmed! ${arguments['orderId']} ${arguments['total']}',
          ),
        );
      },
    },
    home: CheckoutScreen(
      basketService: basketService,
      orderService: orderService,
    ),
  );
}

Future<void> _completeAddressAndSubmit(WidgetTester tester) async {
  await tester.enterText(find.byType(TextFormField).at(0), 'Omar');
  await tester.enterText(find.byType(TextFormField).at(1), 'El-Sayed');
  await tester.enterText(find.byType(TextFormField).at(2), '14 Gezira St');
  await tester.enterText(find.byType(TextFormField).at(3), 'Cairo');

  final placeOrderFinder = find.textContaining('Place order');
  await tester.ensureVisible(placeOrderFinder);
  await tester.tap(placeOrderFinder);
  await tester.pumpAndSettle();
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

  testWidgets('checkout creates order, clears basket, and navigates to success', (
    tester,
  ) async {
    final customItem = BasketItem(
      id: 99,
      productName: 'Single Origin V60',
      pictureUrl: '',
      price: 120,
      quantity: 2,
    );
    final basketService = _RetryableClearBasketService(
      items: [customItem],
      failFirstClear: false,
    );
    final orderService = _RetryableOrderService();

    await tester.pumpWidget(
      _checkoutApp(basketService: basketService, orderService: orderService),
    );
    await tester.pumpAndSettle();

    expect(find.text('240 EGP'), findsOneWidget);
    expect(find.text('275 EGP'), findsOneWidget);

    await _completeAddressAndSubmit(tester);

    expect(find.textContaining('Order Confirmed!'), findsOneWidget);
    expect(orderService.createCalls, 1);
    expect(basketService.clearCalls, 1);
    expect((await basketService.getBasket()).items, isEmpty);
  });

  testWidgets('checkout retains order and retries only basket clearing', (
    tester,
  ) async {
    final basketService = _RetryableClearBasketService(
      items: dummyBasketItems,
    );
    final orderService = _RetryableOrderService();
    await tester.pumpWidget(
      _checkoutApp(basketService: basketService, orderService: orderService),
    );
    await tester.pumpAndSettle();

    await _completeAddressAndSubmit(tester);

    expect(
      find.textContaining(
        'Order created, but the basket could not be cleared: '
        'Basket delete failed',
      ),
      findsOneWidget,
    );
    expect(orderService.createCalls, 1);
    expect(basketService.clearCalls, 1);
    expect(find.textContaining('Order Confirmed!'), findsNothing);

    await tester.pump(const Duration(seconds: 5));
    await tester.pumpAndSettle();
    await _completeAddressAndSubmit(tester);

    expect(orderService.createCalls, 1);
    expect(basketService.clearCalls, 2);
    expect(
      find.textContaining('Order Confirmed! ORD-1004 275.0'),
      findsOneWidget,
    );
    expect((await basketService.getBasket()).items, isEmpty);
  });

  testWidgets('order creation failure can be retried normally', (tester) async {
    final basketService = _RetryableClearBasketService(
      items: dummyBasketItems,
      failFirstClear: false,
    );
    final orderService = _RetryableOrderService()..failNextCreate = true;
    await tester.pumpWidget(
      _checkoutApp(basketService: basketService, orderService: orderService),
    );
    await tester.pumpAndSettle();

    await _completeAddressAndSubmit(tester);

    expect(find.text('Order creation failed'), findsOneWidget);
    expect(orderService.createCalls, 1);
    expect(basketService.clearCalls, 0);

    await _completeAddressAndSubmit(tester);

    expect(orderService.createCalls, 2);
    expect(basketService.clearCalls, 1);
    expect(find.textContaining('Order Confirmed!'), findsOneWidget);
  });
}
