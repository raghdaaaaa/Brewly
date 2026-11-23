import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:brewly/constants.dart';
import 'package:brewly/main.dart';
import 'package:brewly/screens/main_screen.dart';
import 'package:brewly/screens/product_details_screen.dart';

void main() {
  testWidgets('Splash screen shows, then opens the Welcome screen', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const BrewlyApp());

    // The splash screen is shown first.
    expect(find.text('Brewly'), findsOneWidget);

    // Wait for the 2 second splash timer.
    await tester.pump(const Duration(seconds: 2));
    await tester.pumpAndSettle();

    // After the splash we are on the Welcome screen.
    expect(find.text('Artisanal Coffee & Pastries,'), findsOneWidget);
  });

  testWidgets('Home loads the dummy products without overflow', (
    WidgetTester tester,
  ) async {
    // Use a phone-sized screen.
    tester.view.physicalSize = const Size(1170, 2532);
    tester.view.devicePixelRatio = 3.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const MaterialApp(home: MainScreen()));

    // Let the fake network delay finish.
    await tester.pump(const Duration(milliseconds: 800));
    await tester.pumpAndSettle();

    expect(find.text('Popular Right Now'), findsOneWidget);
    expect(find.text('Spanish Iced Latte'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Tapping a product opens the details screen', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(1170, 2532);
    tester.view.devicePixelRatio = 3.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      MaterialApp(
        home: const MainScreen(),
        routes: {
          detailsRoute: (context) => const ProductDetailsScreen(),
        },
      ),
    );
    await tester.pump(const Duration(milliseconds: 800));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Spanish Iced Latte'));
    await tester.pumpAndSettle();

    expect(find.text('Product Detail'), findsOneWidget);
    expect(find.text('Add to cart'), findsOneWidget);

    // The total should follow the quantity.
    await tester.tap(find.byIcon(Icons.add));
    await tester.pumpAndSettle();
    expect(find.text('190 EGP'), findsOneWidget);

    expect(tester.takeException(), isNull);
  });
}
