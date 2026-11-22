// The delivery address of the user (GET/PUT /api/Account/Address).
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
}
