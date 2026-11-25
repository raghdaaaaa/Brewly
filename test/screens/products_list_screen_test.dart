import 'package:brewly/screens/products_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../fakes/fake_basket_service.dart';
import '../fakes/fake_product_service.dart';
import '../fakes/test_data.dart';

void main() {
  testWidgets('products list screen renders without overflow', (tester) async {
    final productService = FakeProductService(products: buildTestProducts());
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
            home: ProductsListScreen(
              categoryName: longCategoryName,
              productService: productService,
              basketService: basketService,
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.textContaining(longCategoryName), findsWidgets);
        expect(find.text('Product Detail'), findsNothing);
        expect(find.text('12 items found'), findsOneWidget);
        expect(tester.takeException(), isNull);
      }
    }
  });
}
