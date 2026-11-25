import 'package:brewly/models/address.dart';
import 'package:brewly/screens/home_screen.dart';
import 'package:brewly/services/auth_service.dart';
import 'package:brewly/widgets/app_header.dart';
import 'package:brewly/widgets/home/home_greeting.dart';
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

        expect(find.text('Brewly'), findsOneWidget);
        expect(find.text('Cairo • Zamalek Roastery'), findsNothing);
        expect(find.text('DELIVERY NOW'), findsOneWidget);
        expect(find.textContaining('Good evening,'), findsOneWidget);
        expect(find.byIcon(Icons.notifications_none_rounded), findsOneWidget);

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

  testWidgets('home screen displays and updates saved address', (tester) async {
    addTearDown(() => AuthService.savedAddress.value = null);
    AuthService.savedAddress.value = const Address(
      firstName: 'Nour',
      lastName: 'Hassan',
      street: '10 Tahrir Sq',
      city: 'Cairo',
      country: 'Egypt',
    );

    await tester.pumpWidget(
      MaterialApp(
        home: HomeScreen(
          productService: FakeProductService(
            products: buildTestProducts(),
            categories: testCategories,
            brands: testBrands,
          ),
          basketService: FakeBasketService(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('10 Tahrir Sq, Cairo, Egypt'), findsOneWidget);
    expect(find.text('Cairo, Egypt'), findsNothing);

    AuthService.savedAddress.value = const Address(
      firstName: 'Nour',
      lastName: 'Hassan',
      street: '99 Corniche',
      city: 'Alexandria',
      country: 'Egypt',
    );
    await tester.pump();

    expect(find.text('99 Corniche, Alexandria, Egypt'), findsOneWidget);
    expect(find.text('Alexandria, Egypt'), findsNothing);
  });

  testWidgets('home greeting scales to stay on one line', (tester) async {
    tester.view.physicalSize = const Size(320, 640);
    tester.view.devicePixelRatio = 1;
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: Padding(
            padding: EdgeInsets.all(16),
            child: HomeGreeting(
              name: 'Raghdaa with a long family name',
              points: 125,
            ),
          ),
        ),
      ),
    );

    final greeting = tester.widget<Text>(
      find.text('Good evening, Raghdaa with a long family name 👋'),
    );
    expect(greeting.maxLines, 1);
    expect(greeting.softWrap, isFalse);
    expect(greeting.overflow, isNull);
    expect(tester.takeException(), isNull);
  });

  testWidgets('home notification shows the local order update', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: Scaffold(body: AppHeaderTop())),
    );

    await tester.tap(find.byIcon(Icons.notifications_none_rounded));
    await tester.pump();

    expect(find.text('Your coffee order is getting ready!'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
