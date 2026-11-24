import 'package:brewly/models/brand.dart';
import 'package:brewly/models/category.dart';
import 'package:brewly/models/product.dart';
import 'package:brewly/models/product_page.dart';
import 'package:brewly/services/product_service.dart';

/// Serves in-memory products so widget tests never touch the network.
class FakeProductService extends ProductService {
  FakeProductService({
    this.products = const [],
    this.categories = const [],
    this.brands = const [],
  });

  final List<Product> products;
  final List<Category> categories;
  final List<Brand> brands;

  @override
  Future<Product> getProduct(int id) async {
    return products.firstWhere((product) => product.id == id);
  }

  @override
  Future<List<Category>> getCategories() async => categories;

  @override
  Future<List<Brand>> getBrands() async => brands;

  @override
  Future<ProductPage> getProducts({
    int pageIndex = 1,
    int pageSize = 10,
    String? search,
    String? sort,
    int? brandId,
    int? categoryId,
  }) async {
    final filtered = products.where((product) {
      final matchesSearch = search == null ||
          search.trim().isEmpty ||
          product.name.toLowerCase().contains(search.trim().toLowerCase());
      final matchesBrand = brandId == null || product.brandId == brandId;
      final matchesCategory =
          categoryId == null || product.categoryId == categoryId;
      return matchesSearch && matchesBrand && matchesCategory;
    }).toList();

    final start = (pageIndex - 1) * pageSize;
    final end = (start + pageSize).clamp(0, filtered.length);
    final page = start >= filtered.length
        ? const <Product>[]
        : filtered.sublist(start, end);

    return ProductPage(
      pageIndex: pageIndex,
      pageSize: pageSize,
      count: filtered.length,
      products: page,
    );
  }
}
