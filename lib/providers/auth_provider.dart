import 'package:flutter/material.dart';
import '../auth/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();

  bool _isLoading = false;
  bool get isLoading => _isLoading;
  bool get isLoggedIn => _authService.isLoggedIn;
  Map<String, dynamic>? get user => _authService.user;

  Future<void> init() async {
    await _authService.init();
    notifyListeners();
  }

  Future<String?> login(String email, String password) async {
    _isLoading = true;
    notifyListeners();

    final res = await _authService.login(email, password);

    _isLoading = false;
    notifyListeners();

    if (res['success'] != true) {
      return res['message'] ?? 'Login gagal';
    }
    return null;
  }

  Future<String?> register(String name, String email, String password, String role) async {
    _isLoading = true;
    notifyListeners();

    final res = await _authService.register(name, email, password, role);

    _isLoading = false;
    notifyListeners();

    if (res['success'] != true) {
      return res['message'] ?? 'Registrasi gagal';
    }
    return null;
  }

  Future<void> logout() async {
    await _authService.logout();
    notifyListeners();
  }
}
