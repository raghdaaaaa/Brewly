import 'package:brewly/models/address.dart';
import 'package:brewly/models/delivery_method.dart';
import 'package:brewly/models/order.dart';
import 'package:brewly/services/dummy/dummy_data.dart';
import 'package:brewly/services/order_service.dart';

/// In-memory order service for widget tests.
class FakeOrderService extends OrderService {
  FakeOrderService({
    this.deliveryMethods = dummyDeliveryMethods,
    List<Order>? orders,
  }) : _orders = orders ?? List.of(dummyOrders);

  final List<DeliveryMethod> deliveryMethods;
  final List<Order> _orders;

  @override
  Future<List<DeliveryMethod>> getDeliveryMethods() async => deliveryMethods;

  @override
  Future<Order> createOrder({
    required int deliveryMethodId,
    required Address shippingAddress,
  }) async {
    final method = deliveryMethods.firstWhere(
      (m) => m.id == deliveryMethodId,
      orElse: () => deliveryMethods.first,
    );
    final order = Order(
      id: 'ORD-${1000 + _orders.length + 1}',
      orderDate: DateTime.now().toIso8601String(),
      status: 'Pending',
      total: 275,
      deliveryMethod: method.shortName,
      deliveryCost: method.cost,
      items: const [],
    );
    _orders.add(order);
    return order;
  }

  @override
  Future<List<Order>> getOrders() async => _orders;

  @override
  Future<Order> getOrder(int id) async =>
      _orders.firstWhere((o) => o.id == '$id');
}
