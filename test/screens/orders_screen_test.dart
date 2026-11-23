import 'package:brewly/screens/orders_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

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
        await tester.pumpWidget(const MaterialApp(home: OrdersScreen()));
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
        expect(find.text('My Orders'), findsOneWidget);
      }
    }
  });
}
