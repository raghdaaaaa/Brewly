import '../core/errors/app_exception.dart';
import '../models/address.dart';
import '../models/delivery_method.dart';
import '../models/order.dart';
import 'api_client.dart';

class OrderService {
  OrderService({ApiClient? client}) : _client = client ?? ApiClient.shared;

  final ApiClient _client;

  static const String _ordersPath = '/api/Orders';
  static const String _deliveryMethodsPath = '/api/Orders/DeliverMethods';

  Future<List<DeliveryMethod>> getDeliveryMethods() async {
    final json = await _client.get(_deliveryMethodsPath);
    return _asList(json)
        .map((item) => DeliveryMethod.fromJson(_asObject(item)))
        .toList();
  }

  Future<Order> createOrder({
    required int deliveryMethodId,
    required Address shippingAddress,
  }) async {
    final json = await _client.post(
      _ordersPath,
      body: {
        'deliverMethodID': deliveryMethodId,
        'shippingAddress': shippingAddress.toJson(),
      },
    );
    return Order.fromJson(_asObject(json));
  }

  Future<List<Order>> getOrders() async {
    final json = await _client.get(_ordersPath);
    return _asList(json)
        .map((item) => Order.fromJson(_asObject(item)))
        .toList();
  }

  Future<Order> getOrder(int id) async {
    final json = await _client.get('$_ordersPath/$id');
    return Order.fromJson(_asObject(json));
  }

  Map<String, dynamic> _asObject(dynamic value) {
    if (value is Map<String, dynamic>) {
      return value;
    }
    if (value is Map) {
      return Map<String, dynamic>.from(value);
    }
    throw const AppException(
      'The server returned an unexpected response. Please try again.',
    );
  }

  List<dynamic> _asList(dynamic value) {
    if (value is List) {
      return value;
    }
    throw const AppException(
      'The server returned an unexpected response. Please try again.',
    );
  }
}
