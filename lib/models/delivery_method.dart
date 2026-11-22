// A delivery method (from GET /api/Orders/DeliverMethods).
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
}
