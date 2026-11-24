import '../core/utils/json_parsers.dart';

class BasketItem {
  BasketItem({
    required this.id,
    int? productId,
    required this.productName,
    required this.pictureUrl,
    required this.price,
    this.quantity = 1,
  }) : productId = productId ?? id;

  final int id;
  final int productId;
  final String productName;
  final String pictureUrl;
  final double price;

  int quantity;

  double get lineTotal => price * quantity;

  factory BasketItem.fromJson(Map<String, dynamic> json) {
    final id = Json.asInt(json['id']);
    return BasketItem(
      id: id,
      productId: Json.asInt(json['productId'], fallback: id),
      productName: Json.asString(json['productName']),
      pictureUrl: Json.asString(json['pictureUrl']),
      price: Json.asDouble(json['price']),
      quantity: Json.asInt(json['quantity'], fallback: 1),
    );
  }
}

class CustomerBasket {
  CustomerBasket({required this.id, required this.items});

  final String id;
  final List<BasketItem> items;

  factory CustomerBasket.empty() {
    return CustomerBasket(id: '', items: const []);
  }

  factory CustomerBasket.fromJson(Map<String, dynamic> json) {
    final raw = json['items'];
    return CustomerBasket(
      id: Json.asString(json['id']),
      items: raw is List
          ? raw
              .whereType<Map>()
              .map((item) => BasketItem.fromJson(Map<String, dynamic>.from(item)))
              .toList()
          : const [],
    );
  }

  double get total {
    double sum = 0;
    for (final item in items) {
      sum += item.lineTotal;
    }
    return sum;
  }

  int get totalQuantity {
    int sum = 0;
    for (final item in items) {
      sum += item.quantity;
    }
    return sum;
  }
}
