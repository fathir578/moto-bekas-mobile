import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/api_service.dart';

class AuthService {
  static const String _tokenKey = 'auth_token';
  static const String _userKey = 'auth_user';
  static final AuthService _instance = AuthService._();
  factory AuthService() => _instance;
  AuthService._();

  bool _isLoggedIn = false;
  Map<String, dynamic>? _user;

  bool get isLoggedIn => _isLoggedIn;
  Map<String, dynamic>? get user => _user;

  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(_tokenKey);
    if (token != null) {
      ApiService().setToken(token);
      _isLoggedIn = true;
      final userData = prefs.getString(_userKey);
      if (userData != null) {
        _user = Map<String, dynamic>.from(jsonDecode(userData) as Map);
      }
    }
  }

  Future<Map<String, dynamic>> login(String email, String password) async {
    final res = await ApiService().post('/auth/login', body: {
      'email': email,
      'password': password,
    });

    if (res['success'] == true) {
      final data = res['data'] as Map<String, dynamic>;
      final token = data['token'] as String;
      _user = data['user'] as Map<String, dynamic>?;

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_tokenKey, token);
      if (_user != null) {
        await prefs.setString(_userKey, jsonEncode(_user));
      }

      ApiService().setToken(token);
      _isLoggedIn = true;
    }

    return res;
  }

  Future<Map<String, dynamic>> register(String name, String email, String password, String role) async {
    final res = await ApiService().post('/auth/register', body: {
      'name': name,
      'email': email,
      'password': password,
      'role': role,
    });

    if (res['success'] == true) {
      final data = res['data'] as Map<String, dynamic>;
      final token = data['token'] as String;
      _user = data['user'] as Map<String, dynamic>?;

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_tokenKey, token);
      if (_user != null) {
        await prefs.setString(_userKey, jsonEncode(_user));
      }

      ApiService().setToken(token);
      _isLoggedIn = true;
    }

    return res;
  }

  Future<void> logout() async {
    _isLoggedIn = false;
    _user = null;
    ApiService().setToken(null);

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
    await prefs.remove(_userKey);
  }
}
