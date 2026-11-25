import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart' show ValueNotifier;
import 'package:shared_preferences/shared_preferences.dart';

import '../core/errors/app_exception.dart';
import '../models/basket.dart';
import '../models/product.dart';

class BasketService {
  BasketService({Future<SharedPreferences> Function()? preferencesProvider})
    : _preferencesProvider =
          preferencesProvider ?? SharedPreferences.getInstance;

  static const String _storageKey = 'brewly_local_basket_v1';

  final Future<SharedPreferences> Function() _preferencesProvider;

  static final ValueNotifier<int> itemCount = ValueNotifier<int>(0);
  static final ValueNotifier<double> total = ValueNotifier<double>(0);

  static Future<void> _mutationQueue = Future<void>.value();

  Future<CustomerBasket> getBasket() {
    return _runExclusive(() async {
      final basket = CustomerBasket(id: '', items: await _readItems());
      _publish(basket);
      return basket;
    });
  }

  Future<CustomerBasket> addQuantity({
    required Product product,
    int quantity = 1,
  }) {
    return _runExclusive(() async {
      if (quantity < 1) {
        throw const AppException('Quantity must be greater than zero.');
      }
      if (product.id <= 0 ||
          product.name.trim().isEmpty ||
          !product.price.isFinite ||
          product.price < 0) {
        throw const AppException('The selected product is invalid.');
      }

      final items = await _readItems();
      final existingIndex = items.indexWhere(
        (item) => item.productId == product.id,
      );
      if (existingIndex < 0) {
        items.add(
          BasketItem(
            id: product.id,
            productId: product.id,
            productName: product.name,
            pictureUrl: product.pictureUrl,
            price: product.price,
            quantity: quantity,
          ),
        );
      } else {
        final existing = items[existingIndex];
        items[existingIndex] = BasketItem(
          id: existing.id,
          productId: existing.productId,
          productName: existing.productName,
          pictureUrl: existing.pictureUrl,
          price: existing.price,
          quantity: existing.quantity + quantity,
        );
      }

      await _saveItems(items);
      final basket = CustomerBasket(id: '', items: items);
      _publish(basket);
      return basket;
    });
  }

  Future<CustomerBasket> addItem({required Product product, int quantity = 1}) {
    return addQuantity(product: product, quantity: quantity);
  }

  Future<CustomerBasket> updateItemQuantity({
    required int productId,
    required int quantity,
  }) {
    if (quantity == 0) {
      return removeItem(productId: productId);
    }
    if (quantity < 0) {
      throw const AppException('Quantity cannot be negative.');
    }

    return _runExclusive(() async {
      final items = await _readItems();
      final index = items.indexWhere((item) => item.productId == productId);
      if (index >= 0) {
        final existing = items[index];
        items[index] = BasketItem(
          id: existing.id,
          productId: existing.productId,
          productName: existing.productName,
          pictureUrl: existing.pictureUrl,
          price: existing.price,
          quantity: quantity,
        );
      }
      await _saveItems(items);
      final basket = CustomerBasket(id: '', items: items);
      _publish(basket);
      return basket;
    });
  }

  Future<CustomerBasket> removeItem({required int productId}) {
    return _runExclusive(() async {
      final items = await _readItems();
      items.removeWhere((item) => item.productId == productId);
      await _saveItems(items);
      final basket = CustomerBasket(id: '', items: items);
      _publish(basket);
      return basket;
    });
  }

  Future<void> clearBasket() {
    return _runExclusive(() async {
      final preferences = await _getPreferences();
      await _removeStoredBasket(preferences);
      final empty = CustomerBasket(id: '', items: const []);
      _publish(empty);
    });
  }

  Future<List<BasketItem>> _readItems() async {
    final preferences = await _getPreferences();
    String? stored;
    try {
      stored = preferences.getString(_storageKey);
    } catch (_) {
      throw const AppException('Could not read your saved basket.');
    }
    if (stored == null) {
      return [];
    }

    try {
      final decoded = jsonDecode(stored);
      if (decoded is! List) {
        throw const FormatException('Stored basket must be a list.');
      }
      return decoded.map(_parseStoredItem).toList();
    } on FormatException {
      await _removeStoredBasket(preferences);
      return [];
    }
  }

  BasketItem _parseStoredItem(Object? value) {
    if (value is! Map) {
      throw const FormatException('Stored basket item must be an object.');
    }

    final productId = value['productId'];
    final productName = value['productName'];
    final pictureUrl = value['pictureUrl'];
    final price = value['price'];
    final quantity = value['quantity'];
    if (productId is! int ||
        productId <= 0 ||
        productName is! String ||
        productName.trim().isEmpty ||
        pictureUrl is! String ||
        price is! num ||
        !price.isFinite ||
        price < 0 ||
        quantity is! int ||
        quantity < 1) {
      throw const FormatException('Stored basket item is invalid.');
    }

    return BasketItem(
      id: productId,
      productId: productId,
      productName: productName,
      pictureUrl: pictureUrl,
      price: price.toDouble(),
      quantity: quantity,
    );
  }

  Future<void> _saveItems(List<BasketItem> items) async {
    final preferences = await _getPreferences();
    bool saved;
    try {
      saved = await preferences.setString(
        _storageKey,
        jsonEncode(items.map((item) => item.toJson()).toList()),
      );
    } catch (_) {
      throw const AppException('Could not save your basket on this device.');
    }
    if (!saved) {
      throw const AppException('Could not save your basket on this device.');
    }
  }

  Future<void> _removeStoredBasket(SharedPreferences preferences) async {
    bool removed;
    try {
      removed = await preferences.remove(_storageKey);
    } catch (_) {
      throw const AppException('Could not update your saved basket.');
    }
    if (!removed) {
      throw const AppException('Could not update your saved basket.');
    }
  }

  Future<SharedPreferences> _getPreferences() async {
    try {
      return await _preferencesProvider();
    } catch (_) {
      throw const AppException('Local basket storage is unavailable.');
    }
  }

  Future<T> _runExclusive<T>(Future<T> Function() action) {
    final result = _mutationQueue.then((_) => action());
    _mutationQueue = result.then<void>(
      (_) {},
      onError: (Object error, StackTrace stackTrace) {},
    );
    return result;
  }

  void _publish(CustomerBasket basket) {
    itemCount.value = basket.totalQuantity;
    total.value = basket.total;
  }
}
