import 'dart:async';

import 'package:flutter/foundation.dart' show ValueNotifier;

import '../core/errors/app_exception.dart';
import '../models/basket.dart';
import 'api_client.dart';

class BasketService {
  BasketService({ApiClient? client}) : _client = client ?? ApiClient.shared;

  final ApiClient _client;

  static const String _basketPath = '/api/Basket';

  static final ValueNotifier<int> itemCount = ValueNotifier<int>(0);
  static final ValueNotifier<double> total = ValueNotifier<double>(0);

  static Future<void> _mutationQueue = Future<void>.value();

  Future<CustomerBasket> getBasket() {
    return _runExclusive(() async {
      try {
        final basket = await _fetchBasket();
        _publish(basket);
        return basket;
      } on AppException catch (error) {
        if (error.statusCode == 500 &&
            error.message == 'Internal Server Error') {
          final empty = CustomerBasket.empty();
          _publish(empty);
          return empty;
        }
        rethrow;
      }
    });
  }

  Future<CustomerBasket> addQuantity({
    required int productId,
    int quantity = 1,
  }) async {
    return _runExclusive(() async {
      final basket = await _fetchBasket();
      var existingQuantity = 0;
      for (final item in basket.items) {
        if (item.productId == productId) {
          existingQuantity = item.quantity;
          break;
        }
      }
      return _postQuantity(
        productId: productId,
        quantity: existingQuantity + quantity,
      );
    });
  }

  Future<CustomerBasket> addItem({
    required int productId,
    int quantity = 1,
  }) {
    return _runExclusive(
      () => _postQuantity(productId: productId, quantity: quantity),
    );
  }

  Future<CustomerBasket> updateItemQuantity({
    required int productId,
    required int quantity,
  }) async {
    return _runExclusive(
      () => _postQuantity(productId: productId, quantity: quantity),
    );
  }

  Future<void> clearBasket() {
    return _runExclusive(() async {
      await _client.delete(_basketPath);
      final empty = CustomerBasket.empty();
      _publish(empty);
    });
  }

  Future<CustomerBasket> _fetchBasket() async {
    final json = await _client.get(_basketPath);
    return _parseBasket(json);
  }

  Future<CustomerBasket> _postQuantity({
    required int productId,
    required int quantity,
  }) async {
    final json = await _client.post(
      _basketPath,
      body: {
        'productId': productId,
        'quantity': quantity,
      },
    );
    final basket = _parseBasket(json);
    _publish(basket);
    return basket;
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

  CustomerBasket _parseBasket(dynamic value) {
    if (value is Map<String, dynamic>) {
      return CustomerBasket.fromJson(value);
    }
    if (value is Map) {
      return CustomerBasket.fromJson(Map<String, dynamic>.from(value));
    }
    throw const AppException(
      'The server returned an unexpected response. Please try again.',
    );
  }
}
