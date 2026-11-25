import 'dart:convert';

import 'package:brewly/core/errors/app_exception.dart';
import 'package:brewly/models/product.dart';
import 'package:brewly/services/basket_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  const basketStorageKey = 'brewly_local_basket_v1';
  const product = Product(
    id: 7,
    name: 'API-selected Ethiopian Pour Over',
    description: 'Floral and bright.',
    price: 95.5,
    pictureUrl: 'https://example.test/product-7.png',
    brandId: 2,
    brandName: 'Brewly Roasters',
    categoryId: 3,
    categoryName: 'Coffee',
  );

  setUp(() {
    SharedPreferences.setMockInitialValues({});
    BasketService.itemCount.value = 0;
    BasketService.total.value = 0;
  });

  test(
    'missing local basket loads empty without inventing a basket ID',
    () async {
      final basket = await BasketService().getBasket();

      expect(basket.id, isEmpty);
      expect(basket.items, isEmpty);
      expect(BasketService.itemCount.value, 0);
      expect(BasketService.total.value, 0);
    },
  );

  test(
    'adds selected product, increments repeats and persists across instances',
    () async {
      final basketService = BasketService();
      await basketService.addQuantity(product: product, quantity: 2);
      final basket = await BasketService().addQuantity(product: product);
      final restored = await BasketService().getBasket();

      expect(basket.id, isEmpty);
      expect(basket.items, hasLength(1));
      expect(basket.items.single.productId, product.id);
      expect(basket.items.single.productName, product.name);
      expect(basket.items.single.pictureUrl, product.pictureUrl);
      expect(basket.items.single.price, product.price);
      expect(basket.items.single.quantity, 3);
      expect(basket.totalQuantity, 3);
      expect(basket.total, 286.5);
      expect(restored.items.single.quantity, 3);
      expect(BasketService.itemCount.value, 3);
      expect(BasketService.total.value, 286.5);

      final preferences = await SharedPreferences.getInstance();
      final stored =
          jsonDecode(preferences.getString(basketStorageKey)!) as List<dynamic>;
      expect(stored.single['productName'], product.name);
    },
  );

  test('serializes concurrent additions without losing quantity', () async {
    await Future.wait([
      BasketService().addQuantity(product: product),
      BasketService().addQuantity(product: product),
      BasketService().addQuantity(product: product),
    ]);

    final basket = await BasketService().getBasket();
    expect(basket.items.single.quantity, 3);
    expect(BasketService.itemCount.value, 3);
  });

  test(
    'updates quantity, removes one product and clears persisted basket',
    () async {
      final basketService = BasketService();
      await basketService.addQuantity(product: product, quantity: 2);
      await basketService.updateItemQuantity(
        productId: product.id,
        quantity: 5,
      );

      var basket = await basketService.getBasket();
      expect(basket.items.single.quantity, 5);
      expect(basket.totalQuantity, 5);
      expect(basket.total, 477.5);

      basket = await basketService.updateItemQuantity(
        productId: product.id,
        quantity: 0,
      );
      expect(basket.items, isEmpty);
      expect(BasketService.itemCount.value, 0);
      expect(BasketService.total.value, 0);

      await basketService.addQuantity(product: product);
      await basketService.clearBasket();
      final restored = await BasketService().getBasket();
      expect(restored.id, isEmpty);
      expect(restored.items, isEmpty);
      expect(BasketService.itemCount.value, 0);
      expect(BasketService.total.value, 0);

      final preferences = await SharedPreferences.getInstance();
      expect(preferences.getString(basketStorageKey), isNull);
    },
  );

  test('invalid stored basket data is removed and loads as empty', () async {
    SharedPreferences.setMockInitialValues({
      basketStorageKey: '{"not":"a basket"}',
    });

    final basket = await BasketService().getBasket();
    final preferences = await SharedPreferences.getInstance();

    expect(basket.items, isEmpty);
    expect(preferences.getString(basketStorageKey), isNull);
  });

  test('invalid stored basket item is removed and loads as empty', () async {
    SharedPreferences.setMockInitialValues({
      basketStorageKey: jsonEncode([
        {
          'productId': product.id,
          'productName': product.name,
          'pictureUrl': product.pictureUrl,
          'price': product.price,
          'quantity': 0,
        },
      ]),
    });

    final basket = await BasketService().getBasket();
    final preferences = await SharedPreferences.getInstance();

    expect(basket.items, isEmpty);
    expect(preferences.getString(basketStorageKey), isNull);
  });

  test('storage failures surface as an application error', () async {
    final basketService = BasketService(
      preferencesProvider: () async => throw StateError('storage unavailable'),
    );

    await expectLater(
      basketService.getBasket(),
      throwsA(
        isA<AppException>().having(
          (error) => error.message,
          'message',
          'Local basket storage is unavailable.',
        ),
      ),
    );
    await expectLater(
      basketService.addQuantity(product: product),
      throwsA(isA<AppException>()),
    );
  });
}
