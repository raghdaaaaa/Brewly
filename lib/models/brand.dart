import '../core/utils/json_parsers.dart';

class Brand {
  const Brand({
    required this.id,
    required this.name,
  });

  final int id;
  final String name;

  factory Brand.fromJson(Map<String, dynamic> json) {
    return Brand(
      id: Json.asInt(json['id']),
      name: Json.asString(json['name']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}
