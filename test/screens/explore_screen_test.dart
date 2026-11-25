import 'package:brewly/screens/explore_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../fakes/fake_product_service.dart';
import '../fakes/test_data.dart';

void main() {
  testWidgets('explore screen renders without overflow', (tester) async {
    final productService = FakeProductService(categories: testCategories);

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
          MaterialApp(home: ExploreScreen(productService: productService)),
        );
        await tester.pumpAndSettle();

        expect(find.text('Explore'), findsOneWidget);
        expect(find.text('Categories'), findsOneWidget);
        expect(tester.takeException(), isNull);
      }
    }
  });
}
