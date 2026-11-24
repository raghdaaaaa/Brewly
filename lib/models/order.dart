import '../core/utils/json_parsers.dart';
class OrderItem {
  const OrderItem({
    required this.name,
    required this.pictureUrl,
    required this.price,
    required this.quantity,
  });

  final String name;
  final String pictureUrl;
  final double price;
  final int quantity;

  double get lineTotal => price * quantity;

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      name: Json.asString(json['productName'] ?? json['name']),
      pictureUrl: Json.asString(json['pictureUrl']),
      price: Json.asDouble(json['price']),
      quantity: Json.asInt(json['quantity'], fallback: 1),
    );
  }
}

class Order {
  const Order({
    required this.id,
    required this.orderDate,
    required this.status,
    required this.total,
    required this.items,
    this.deliveryMethod = 'Zamalek Express Dispatch',
    this.deliveryCost = 35.0,
    this.subTotal = 0.0,
  });

  final String id;
  final String orderDate;
  final String status;
  final double total;
  final List<OrderItem> items;
  final String deliveryMethod;
  final double deliveryCost;
  final double subTotal;

  double get subtotal {
    if (subTotal > 0) return subTotal;
    double sum = 0;
    for (final item in items) {
      sum += item.lineTotal;
    }
    return sum;
  }

  factory Order.fromJson(Map<String, dynamic> json) {
    final rawItems = json['items'];
    return Order(
      id: Json.asString(json['id']),
      orderDate: Json.asString(json['orderDate']),
      status: Json.asString(json['status']),
      total: Json.asDouble(json['total']),
      deliveryMethod: Json.asString(json['deliveryMethod']),
      deliveryCost: Json.asDouble(json['deliveryCost']),
      subTotal: Json.asDouble(json['subTotal']),
      items: rawItems is List
          ? rawItems
              .whereType<Map>()
              .map((item) => OrderItem.fromJson(Map<String, dynamic>.from(item)))
              .toList()
          : const [],
    );
  }
}

