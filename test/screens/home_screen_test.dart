import 'package:brewly/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../fakes/fake_basket_service.dart';
import '../fakes/fake_product_service.dart';
import '../fakes/test_data.dart';

void main() {
  testWidgets('home screen renders without overflow', (tester) async {
    final productService = FakeProductService(
      products: buildTestProducts(),
      categories: testCategories,
      brands: testBrands,
    );
    final basketService = FakeBasketService();

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
          MaterialApp(
            home: HomeScreen(
              key: ValueKey('${size.width}_$scale'),
              productService: productService,
              basketService: basketService,
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.text('Cairo • Zamalek Roastery'), findsOneWidget);

        // Build the rest of the list so every card is checked for overflow.
        await tester.drag(
          find.byType(SingleChildScrollView).first,
          const Offset(0, -1200),
        );
        await tester.pumpAndSettle();

        expect(tester.takeException(), isNull);
      }
    }
  });
}
