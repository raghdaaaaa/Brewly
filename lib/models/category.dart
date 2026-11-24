import '../core/utils/json_parsers.dart';
class Category {
  const Category({
    required this.id,
    required this.name,
    this.pictureUrl,
  });

  final int id;
  final String name;
  final String? pictureUrl;

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: Json.asInt(json['id']),
      name: Json.asString(json['name']),
      pictureUrl: Json.asStringOrNull(json['pictureUrl']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'pictureUrl': pictureUrl,
    };
  }
}
