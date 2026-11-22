// A product category (from GET /api/Products/categories).
class Category {
  const Category({
    required this.id,
    required this.name,
    this.pictureUrl,
  });

  final int id;
  final String name;
  final String? pictureUrl;
}
