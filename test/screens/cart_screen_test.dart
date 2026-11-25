import 'package:brewly/core/errors/app_exception.dart';
import 'package:brewly/screens/cart_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../fakes/fake_basket_service.dart';
import '../fakes/test_data.dart';

class _FailingClearBasketService extends FakeBasketService {
  _FailingClearBasketService({super.items});

  @override
  Future<void> clearBasket() async {
    throw const AppException('Failed to clear cart');
  }
}

void main() {
  testWidgets('cart screen renders without overflow', (tester) async {
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

        final basketService = FakeBasketService(items: buildTestBasketItems());
        await tester.pumpWidget(
          MaterialApp(
            home: CartScreen(
              onBrowseMenu: () {},
              basketService: basketService,
            ),
          ),
        );
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
        expect(find.text('Your Basket'), findsOneWidget);
        expect(
          find.text('Proceed to checkout', skipOffstage: false),
          findsOneWidget,
        );
      }
    }
  });

  testWidgets('cart screen shows error and keeps items if clearBasket fails', (
    tester,
  ) async {
    final basketItems = buildTestBasketItems();
    final basketService = _FailingClearBasketService(items: basketItems);
    await tester.pumpWidget(
      MaterialApp(
        home: CartScreen(
          onBrowseMenu: () {},
          basketService: basketService,
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byTooltip('Clear cart'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Clear'));
    await tester.pumpAndSettle();

    expect(find.text('Failed to clear cart'), findsOneWidget);
    expect(find.text(basketItems.first.productName), findsOneWidget);
  });

  testWidgets('decreasing a single item to zero removes it from the basket', (
    tester,
  ) async {
    final basketItems = buildTestBasketItems();
    final basketService = FakeBasketService(items: basketItems);
    await tester.pumpWidget(
      MaterialApp(
        home: CartScreen(
          onBrowseMenu: () {},
          basketService: basketService,
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.remove_rounded).first);
    await tester.pumpAndSettle();
    expect(find.text(basketItems.first.productName), findsOneWidget);
    expect(find.text('1'), findsNWidgets(2));

    await tester.tap(find.byIcon(Icons.remove_rounded).first);
    await tester.pumpAndSettle();
    expect(find.text(basketItems.first.productName), findsNothing);
    expect(find.text(basketItems.last.productName), findsOneWidget);
  });
}
