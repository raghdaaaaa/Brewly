import 'package:brewly/screens/cart_screen.dart';
import 'package:brewly/services/dummy/dummy_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../fakes/fake_basket_service.dart';

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

        final basketService = FakeBasketService(items: dummyBasketItems);
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
}
