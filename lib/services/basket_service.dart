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

  Future<CustomerBasket> getBasket() async {
    try {
      final json = await _client.get(_basketPath);
      final basket = _parseBasket(json);
      _publish(basket);
      return basket;
    } on AppException catch (error) {
      if (error.statusCode == 500) {
        final empty = CustomerBasket.empty();
        _publish(empty);
        return empty;
      }
      rethrow;
    }
  }

  Future<CustomerBasket> addItem({
    required int productId,
    int quantity = 1,
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

  Future<CustomerBasket> updateItemQuantity({
    required int productId,
    required int quantity,
  }) async {
    return addItem(productId: productId, quantity: quantity);
  }

  Future<void> clearBasket() async {
    try {
      await _client.delete(_basketPath);
    } catch (_) {}
    final empty = CustomerBasket.empty();
    _publish(empty);
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
