import '../core/errors/app_exception.dart';
import '../models/brand.dart';
import '../models/category.dart';
import '../models/product.dart';
import '../models/product_page.dart';
import 'api_client.dart';

class ProductService {
  ProductService({ApiClient? client}) : _client = client ?? ApiClient.shared;

  final ApiClient _client;

  static const String _productsPath = '/api/Products';
  static const String _categoriesPath = '/api/Products/categories';
  static const String _brandsPath = '/api/Products/brands';

  static const String sortPriceAsc = 'PriceAsc';
  static const String sortPriceDesc = 'PriceDesc';

  Future<Product> getProduct(int id) async {
    final json = await _client.get('$_productsPath/$id');
    return Product.fromJson(_asObject(json));
  }

  Future<ProductPage> getProducts({
    int pageIndex = 1,
    int pageSize = 10,
    String? search,
    String? sort,
    int? brandId,
    int? categoryId,
  }) async {
    final query = <String, String>{
      'PageIndex': '$pageIndex',
      'PageSize': '$pageSize',
      if (search != null && search.trim().isNotEmpty) 'Search': search.trim(),
      if (sort != null && sort.isNotEmpty) 'sort': sort,
      if (brandId != null) 'brandId': '$brandId',
      if (categoryId != null) 'categoryId': '$categoryId',
    };
    final json = await _client.get(_productsPath, query: query);
    if (json is List) {
      if (json.isEmpty) {
        return ProductPage(
          pageIndex: pageIndex,
          pageSize: pageSize,
          count: 0,
          products: const [],
        );
      }
      final firstPage = ProductPage.fromJson(_asObject(json.first));
      if (json.length == 1) {
        return firstPage;
      }
      final products = <Product>[];
      for (final item in json) {
        products.addAll(ProductPage.fromJson(_asObject(item)).products);
      }
      return ProductPage(
        pageIndex: firstPage.pageIndex,
        pageSize: firstPage.pageSize,
        count: firstPage.count,
        products: products,
      );
    }
    return ProductPage.fromJson(_asObject(json));
  }

  Future<List<Category>> getCategories() async {
    final json = await _client.get(_categoriesPath);
    return _asList(json)
        .map((item) => Category.fromJson(_asObject(item)))
        .toList();
  }

  Future<List<Brand>> getBrands() async {
    final json = await _client.get(_brandsPath);
    return _asList(json)
        .map((item) => Brand.fromJson(_asObject(item)))
        .toList();
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
