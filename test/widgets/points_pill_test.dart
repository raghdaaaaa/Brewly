import 'package:brewly/widgets/home/points_pill.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('points pill uses compact container, icon, and text', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      const MaterialApp(
        home: MediaQuery(
          data: MediaQueryData(textScaler: TextScaler.linear(1)),
          child: Scaffold(body: Center(child: PointsPill(points: 340))),
        ),
      ),
    );

    final size = tester.getSize(
      find.descendant(
        of: find.byType(PointsPill),
        matching: find.byType(Container),
      ),
    );
    final icon = tester.widget<Icon>(
      find.byIcon(Icons.workspace_premium_rounded),
    );
    final label = tester.widget<Text>(find.text('340 Pts'));

    expect(icon.size, 10);
    expect(label.style?.fontSize, 8);
    expect(size.width, lessThan(100));
    expect(size.height, lessThan(20));
    expect(tester.takeException(), isNull);
  });
}
