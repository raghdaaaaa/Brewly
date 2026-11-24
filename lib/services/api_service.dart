import '../core/errors/app_exception.dart';
import '../models/address.dart';
import '../models/user.dart';
import 'api_client.dart';

class ApiService {
  ApiService({ApiClient? client}) : _client = client ?? ApiClient.shared;

  final ApiClient _client;

  static const String _loginPath = '/api/Account/Login';
  static const String _registerPath = '/api/Account/Register';
  static const String _emailExistsPath = '/api/Account/emailExisits';
  static const String _addressPath = '/api/Account/Address';
  static const String _accountPath = '/api/Account';

  set token(String? value) {
    _client.authToken = value;
  }

  Future<User> login({
    required String email,
    required String password,
  }) async {
    final json = await _client.post(
      _loginPath,
      body: {
        'email': email.trim(),
        'password': password,
      },
    );
    return User.fromJson(_asJsonObject(json));
  }

  Future<User> register({
    required String displayName,
    required String email,
    required String phoneNumber,
    required String password,
  }) async {
    final json = await _client.post(
      _registerPath,
      body: {
        'displayName': displayName.trim(),
        'email': email.trim(),
        'phoneNumber': phoneNumber.trim(),
        'password': password,
      },
    );
    return User.fromJson(_asJsonObject(json));
  }

  Future<bool> emailExists(String email) async {
    final json = await _client.get(
      _emailExistsPath,
      query: {'email': email.trim()},
    );
    if (json is bool) {
      return json;
    }
    return json?.toString().toLowerCase() == 'true';
  }

  Future<Address?> getAddress() async {
    final json = await _client.get(_addressPath);
    if (json == null) return null;
    return Address.fromJson(_asJsonObject(json));
  }

  Future<Address> updateAddress(Address address) async {
    final json = await _client.put(
      _addressPath,
      body: address.toJson(),
    );
    return Address.fromJson(_asJsonObject(json));
  }

  Future<User> getCurrentUser() async {
    final json = await _client.get(_accountPath);
    return User.fromJson(_asJsonObject(json));
  }

  Map<String, dynamic> _asJsonObject(dynamic value) {
    if (value is Map<String, dynamic>) {
      return value;
    }
    if (value is Map) {
      return Map<String, dynamic>.from(value);
    }
    throw const AppException(
      'The server returned an unexpected response. Please try again.',
    );
  }
}
