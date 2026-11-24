class User {
  const User({
    required this.displayName,
    required this.email,
    required this.token,
  });

  final String displayName;
  final String email;
  final String token;

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      displayName: json['displayName'] as String? ?? '',
      email: json['email'] as String? ?? '',
      token: json['token'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'displayName': displayName,
      'email': email,
      'token': token,
    };
  }
}
