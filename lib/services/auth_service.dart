import 'package:flutter/foundation.dart' show ValueNotifier;
import 'package:shared_preferences/shared_preferences.dart';

import '../core/errors/app_exception.dart';
import '../models/address.dart';
import '../models/user.dart';
import 'api_service.dart';
import 'basket_service.dart';

class AuthService {
  AuthService({ApiService? apiService})
      : _apiService = apiService ?? ApiService();

  static final AuthService instance = AuthService();

  static final ValueNotifier<User?> currentUserNotifier =
      ValueNotifier<User?>(null);
  static final ValueNotifier<Address?> savedAddress =
      ValueNotifier<Address?>(null);

  static const String _tokenKey = 'auth_token';
  static const String _displayNameKey = 'auth_display_name';
  static const String _emailKey = 'auth_email';

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
    await _setCurrentUser(user);
    await _preloadAddressAndBasket();
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
    await _setCurrentUser(user);
    await _preloadAddressAndBasket();
    return user;
  }

  Future<bool> emailExists(String email) {
    return _apiService.emailExists(email);
  }

  Future<Address?> getAddress() async {
    final address = await _apiService.getAddress();
    savedAddress.value = address;
    return address;
  }

  Future<Address> updateAddress(Address address) async {
    final saved = await _apiService.updateAddress(address);
    savedAddress.value = saved;
    return saved;
  }

  Future<User> fetchCurrentUser() async {
    final previousToken = token;
    final user = await _apiService.getCurrentUser();
    final resolvedUser = user.token.isNotEmpty || previousToken == null
        ? user
        : User(
            displayName: user.displayName,
            email: user.email,
            token: previousToken,
          );
    await _setCurrentUser(resolvedUser);
    return resolvedUser;
  }

  Future<bool> restoreSession() async {
    final prefs = await _prefs();
    if (prefs == null) {
      return false;
    }

    final savedToken = prefs.getString(_tokenKey);
    if (savedToken == null || savedToken.isEmpty) {
      return false;
    }

    final savedName = prefs.getString(_displayNameKey) ?? '';
    final savedEmail = prefs.getString(_emailKey) ?? '';

    _apiService.token = savedToken;

    try {
      final user = await _apiService.getCurrentUser();
      final resolvedUser = user.token.isNotEmpty
          ? user
          : User(
              displayName: user.displayName.isNotEmpty
                  ? user.displayName
                  : savedName,
              email: user.email.isNotEmpty ? user.email : savedEmail,
              token: savedToken,
            );
      await _setCurrentUser(resolvedUser);
      await _preloadAddressAndBasket();
      return true;
    } on AppException catch (error) {
      if (error.statusCode == 401 ||
          error.statusCode == 403 ||
          error.statusCode == 404) {
        await logout();
        return false;
      }
      if (savedName.isNotEmpty || savedEmail.isNotEmpty) {
        final cached = User(
          displayName: savedName,
          email: savedEmail,
          token: savedToken,
        );
        _currentUser = cached;
        currentUserNotifier.value = cached;
        return true;
      }
      return false;
    } catch (_) {
      return false;
    }
  }

  Future<void> logout() async {
    _currentUser = null;
    currentUserNotifier.value = null;
    savedAddress.value = null;
    _apiService.token = null;
    BasketService.itemCount.value = 0;
    BasketService.total.value = 0;

    final prefs = await _prefs();
    if (prefs != null) {
      await prefs.remove(_tokenKey);
      await prefs.remove(_displayNameKey);
      await prefs.remove(_emailKey);
    }
  }

  Future<void> _setCurrentUser(User user) async {
    _currentUser = user;
    currentUserNotifier.value = user;
    _apiService.token = user.token;

    final prefs = await _prefs();
    if (prefs != null && user.token.isNotEmpty) {
      await prefs.setString(_tokenKey, user.token);
      await prefs.setString(_displayNameKey, user.displayName);
      await prefs.setString(_emailKey, user.email);
    }
  }

  Future<void> _preloadAddressAndBasket() async {
    try {
      await getAddress();
    } catch (_) {}
    try {
      await BasketService().getBasket();
    } catch (_) {}
  }

  Future<SharedPreferences?> _prefs() async {
    try {
      return await SharedPreferences.getInstance().timeout(
        const Duration(seconds: 2),
      );
    } catch (_) {
      return null;
    }
  }
}
