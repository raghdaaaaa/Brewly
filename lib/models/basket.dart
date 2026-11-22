// One line of the shopping basket.
class BasketItem {
  BasketItem({
    required this.id,
    required this.productName,
    required this.pictureUrl,
    required this.price,
    this.quantity = 1,
  });

  final int id;
  final String productName;
  final String pictureUrl;
  final double price;

  // The user can change this with the quantity counter.
  int quantity;

  // price × quantity
  double get lineTotal => price * quantity;
}

// The whole basket of the logged in user.
class CustomerBasket {
  CustomerBasket({required this.id, required this.items});

  final String id;
  final List<BasketItem> items;

  double get total {
    double sum = 0;
    for (final item in items) {
      sum += item.lineTotal;
    }
    return sum;
  }
}
