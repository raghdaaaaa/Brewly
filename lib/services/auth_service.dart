import '../models/address.dart';
import '../models/user.dart';
import 'api_service.dart';

class AuthService {
  AuthService({ApiService? apiService})
      : _apiService = apiService ?? ApiService();

  static final AuthService instance = AuthService();

  final ApiService _apiService;

  User? _currentUser;

  User? get currentUser => _currentUser;

  String? get token => _currentUser?.token;

  bool get isLoggedIn => _currentUser != null && _currentUser!.token.isNotEmpty;

  Future<User> login({
    required String email,
    required String password,
  }) async {
    final user = await _apiService.login(email: email, password: password);
    _setCurrentUser(user);
    return user;
  }

  Future<User> register({
    required String displayName,
    required String email,
    required String phoneNumber,
    required String password,
  }) async {
    final user = await _apiService.register(
      displayName: displayName,
      email: email,
      phoneNumber: phoneNumber,
      password: password,
    );
    _setCurrentUser(user);
    return user;
  }

  Future<bool> emailExists(String email) {
    return _apiService.emailExists(email);
  }

  Future<Address?> getAddress() {
    return _apiService.getAddress();
  }

  Future<Address> updateAddress(Address address) {
    return _apiService.updateAddress(address);
  }

  Future<User> fetchCurrentUser() async {
    final user = await _apiService.getCurrentUser();
    _setCurrentUser(user);
    return user;
  }

  void logout() {
    _currentUser = null;
    _apiService.token = null;
  }

  void _setCurrentUser(User user) {
    _currentUser = user;
    _apiService.token = user.token;
  }
}
