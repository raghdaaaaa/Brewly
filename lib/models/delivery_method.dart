import '../core/utils/json_parsers.dart';
class DeliveryMethod {
  const DeliveryMethod({
    required this.id,
    required this.shortName,
    required this.description,
    required this.cost,
    required this.deliveryTime,
  });

  final int id;
  final String shortName;
  final String description;
  final double cost;
  final String deliveryTime;

  factory DeliveryMethod.fromJson(Map<String, dynamic> json) {
    return DeliveryMethod(
      id: Json.asInt(json['id']),
      shortName: Json.asString(json['shortName']),
      description: Json.asString(json['description']),
      cost: Json.asDouble(json['cost']),
      deliveryTime: Json.asString(json['deliveryTime']),
    );
  }
}

