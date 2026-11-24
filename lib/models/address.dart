import '../core/utils/json_parsers.dart';
class Address {
  const Address({
    required this.firstName,
    required this.lastName,
    required this.street,
    required this.city,
    required this.country,
  });

  final String firstName;
  final String lastName;
  final String street;
  final String city;
  final String country;

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      firstName: Json.asString(json['firstName']),
      lastName: Json.asString(json['lastName']),
      street: Json.asString(json['street']),
      city: Json.asString(json['city']),
      country: Json.asString(json['country']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'street': street,
      'city': city,
      'country': country,
    };
  }
}

