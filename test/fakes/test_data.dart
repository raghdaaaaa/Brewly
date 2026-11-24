import 'package:brewly/models/brand.dart';
import 'package:brewly/models/category.dart';
import 'package:brewly/models/product.dart';

/// Long values so the overflow tests use the worst-case names.
const String longProductName =
    'Ethiopia Guji Natural Single Origin Espresso Roast';
const String longProductDescription =
    'Floral, stone fruit and dark chocolate notes with a long syrupy finish.';
const String longCategoryName = 'Specialty Single Origin Filter Roasts';
const String longBrandName = 'Zamalek Artisan Roasters and Sourdough Bakery';

const List<Category> testCategories = [
  Category(id: 1, name: longCategoryName),
  Category(id: 2, name: 'Espresso'),
  Category(id: 3, name: 'Pastries'),
  Category(id: 4, name: 'Cold Brew'),
  Category(id: 5, name: 'Beans'),
];

const List<Brand> testBrands = [
  Brand(id: 1, name: longBrandName),
  Brand(id: 2, name: 'Brewly Roasters'),
  Brand(id: 3, name: 'Cairo Coffee Lab'),
];

List<Product> buildTestProducts({int count = 12}) {
  return List.generate(count, (index) {
    return Product(
      id: index + 1,
      name: '$longProductName ${index + 1}',
      description: longProductDescription,
      price: 95 + index * 10.5,
      pictureUrl: '',
      brandId: 1,
      brandName: longBrandName,
      categoryId: 1,
      categoryName: longCategoryName,
    );
  });
}
