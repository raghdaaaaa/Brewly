import 'package:brewly/screens/address_screen.dart';
import 'package:brewly/services/dummy/dummy_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('address screen renders without overflow', (tester) async {
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
        await tester.pumpWidget(
          const MaterialApp(
            home: AddressScreen(initialAddress: dummyAddress),
          ),
        );
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
        expect(find.text('My Address'), findsOneWidget);
        expect(find.text('Save'), findsOneWidget);
      }
    }
  });
}
