// One product line inside an order (OrderItemDto).
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

  // price x quantity
  double get lineTotal => price * quantity;
}

// One order of the user (OrderToReturnDto).
class Order {
  const Order({
    required this.id,
    required this.orderDate,
    required this.status,
    required this.total,
    required this.items,
  });

  final String id;
  final String orderDate;
  final String status;
  final double total;
  final List<OrderItem> items;

  // Sum of the item line totals (the price before delivery).
  double get subtotal {
    double sum = 0;
    for (final item in items) {
      sum += item.lineTotal;
    }
    return sum;
  }
}
