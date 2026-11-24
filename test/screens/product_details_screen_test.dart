import 'package:brewly/screens/product_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../fakes/fake_basket_service.dart';
import '../fakes/fake_product_service.dart';
import '../fakes/test_data.dart';

void main() {
  testWidgets('product details renders without overflow', (tester) async {
    final product = buildTestProducts(count: 1).first;
    final productService = FakeProductService(products: [product]);
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
            home: ProductDetailsScreen(
              product: product,
              productService: productService,
              basketService: basketService,
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(tester.takeException(), isNull);
      }
    }
  });

  testWidgets('loads a product by id when only the id is passed', (
    tester,
  ) async {
    final product = buildTestProducts(count: 1).first;
    final productService = FakeProductService(products: [product]);
    final basketService = FakeBasketService();

    await tester.pumpWidget(
      MaterialApp(
        home: ProductDetailsScreen(
          productId: product.id,
          productService: productService,
          basketService: basketService,
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text(product.name), findsOneWidget);
    expect(find.text('Add to cart · 95 EGP'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('asks the user to log in before adding to the cart', (
    tester,
  ) async {
    final product = buildTestProducts(count: 1).first;
    final productService = FakeProductService(products: [product]);
    final basketService = FakeBasketService();

    await tester.pumpWidget(
      MaterialApp(
        home: ProductDetailsScreen(
          product: product,
          productService: productService,
          basketService: basketService,
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.textContaining('Add to cart'));
    await tester.pump();

    expect(
      find.text('Please log in to add items to your cart.'),
      findsOneWidget,
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('quantity updates the total and the heart animates', (
    tester,
  ) async {
    final product = buildTestProducts(count: 1).first;
    final productService = FakeProductService(products: [product]);
    final basketService = FakeBasketService();

    tester.view.physicalSize = const Size(320, 640);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      MaterialApp(
        home: ProductDetailsScreen(
          product: product,
          productService: productService,
          basketService: basketService,
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Add to cart · 95 EGP'), findsOneWidget);
    expect(find.byIcon(Icons.favorite_border_rounded), findsOneWidget);

    await tester.tap(find.byIcon(Icons.add_rounded));
    await tester.pumpAndSettle();
    expect(find.text('Add to cart · 190 EGP'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.favorite_border_rounded));
    await tester.pumpAndSettle();
    expect(find.byIcon(Icons.favorite_rounded), findsOneWidget);

    await tester.tap(find.byIcon(Icons.remove_rounded));
    await tester.pumpAndSettle();
    expect(find.text('Add to cart · 95 EGP'), findsOneWidget);

    expect(tester.takeException(), isNull);
  });
}
