import '../core/utils/json_parsers.dart';
import 'product.dart';
class ProductPage {
  const ProductPage({
    required this.pageIndex,
    required this.pageSize,
    required this.count,
    required this.products,
  });

  final int pageIndex;
  final int pageSize;
  final int count;
  final List<Product> products;

  bool get hasMore => pageIndex * pageSize < count;

  factory ProductPage.fromJson(Map<String, dynamic> json) {
    final raw = json['data'];
    return ProductPage(
      pageIndex: Json.asInt(
        json['page_Index'],
        fallback: Json.asInt(json['pageIndex'], fallback: 1),
      ),
      pageSize: Json.asInt(
        json['page_Size'],
        fallback: Json.asInt(json['pageSize']),
      ),
      count: Json.asInt(json['count']),
      products: raw is List
          ? raw
              .whereType<Map>()
              .map((item) => Product.fromJson(Map<String, dynamic>.from(item)))
              .toList()
          : const [],
    );
  }
}
