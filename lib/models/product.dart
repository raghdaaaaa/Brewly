import '../core/utils/json_parsers.dart';
class Product {
  const Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.pictureUrl,
    required this.brandId,
    required this.brandName,
    required this.categoryId,
    required this.categoryName,
  });

  final int id;
  final String name;
  final String description;
  final double price;
  final String pictureUrl;
  final int brandId;
  final String brandName;
  final int categoryId;
  final String categoryName;

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: Json.asInt(json['id']),
      name: Json.asString(json['name']),
      description: Json.asString(json['description']),
      price: Json.asDouble(json['price']),
      pictureUrl: Json.asString(json['pictureUrl']),
      brandId: Json.asInt(json['brandId']),
      brandName: Json.asString(json['brand']),
      categoryId: Json.asInt(json['categoryId']),
      categoryName: Json.asString(json['category']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'pictureUrl': pictureUrl,
      'price': price,
      'brandId': brandId,
      'brand': brandName,
      'categoryId': categoryId,
      'category': categoryName,
    };
  }
}
