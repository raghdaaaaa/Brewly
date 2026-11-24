import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:brewly/core/routes/app_routes.dart';
import 'package:brewly/main.dart';
import 'package:brewly/screens/home_screen.dart';

import 'fakes/fake_basket_service.dart';
import 'fakes/fake_product_service.dart';
import 'fakes/test_data.dart';

void main() {
  testWidgets('Splash screen shows, then opens the Welcome screen', (
    WidgetTester tester,
  ) async {
    SharedPreferences.setMockInitialValues({});
    await tester.pumpWidget(const BrewlyApp());

    expect(find.text('Brewly'), findsOneWidget);

    await tester.pump(const Duration(seconds: 2));
    await tester.pumpAndSettle();

    expect(find.text('Artisanal Coffee & Pastries,'), findsOneWidget);
  });

  testWidgets('Home loads products from the service without overflow', (
    WidgetTester tester,
  ) async {
    final productService = FakeProductService(
      products: buildTestProducts(),
      categories: testCategories,
      brands: testBrands,
    );

    tester.view.physicalSize = const Size(1170, 2532);
    tester.view.devicePixelRatio = 3.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      MaterialApp(
        home: HomeScreen(
          productService: productService,
          basketService: FakeBasketService(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Popular Right Now'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Tapping a product opens the details screen', (
    WidgetTester tester,
  ) async {
    final product = buildTestProducts(count: 1).first;
    final productService = FakeProductService(products: [product]);
    final basketService = FakeBasketService();

    tester.view.physicalSize = const Size(1170, 2532);
    tester.view.devicePixelRatio = 3.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      MaterialApp(
        home: HomeScreen(
          productService: productService,
          basketService: basketService,
        ),
        routes: {
          AppRoutes.detailsRoute: AppRoutes.routes[AppRoutes.detailsRoute]!,
        },
      ),
    );
    await tester.pumpAndSettle();

    await tester.scrollUntilVisible(
      find.text(product.name),
      300,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.tap(find.text(product.name));
    await tester.pumpAndSettle();

    expect(find.text('Product Detail'), findsOneWidget);
    expect(find.text('Add to cart · 95 EGP'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.add_rounded));
    await tester.pumpAndSettle();
    expect(find.text('Add to cart · 190 EGP'), findsOneWidget);

    expect(tester.takeException(), isNull);
  });
}
