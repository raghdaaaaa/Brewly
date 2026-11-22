// One product of the menu.
// The fields match the API, but fromJson() is added later in the API step.
class Product {
  const Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.pictureUrl,
    required this.brandName,
    required this.categoryName,
  });

  final int id;
  final String name;
  final String description;
  final double price;
  final String pictureUrl;
  final String brandName;
  final String categoryName;
}
