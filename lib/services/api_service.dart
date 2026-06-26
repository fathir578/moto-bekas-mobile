import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'http://192.168.1.17:8000/api';
  String? _token;

  static final ApiService _instance = ApiService._();
  factory ApiService() => _instance;
  ApiService._();

  void setToken(String? token) {
    _token = token;
  }

  Map<String, String> get _headers {
    final h = <String, String>{
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    if (_token != null) {
      h['Authorization'] = 'Bearer $_token';
    }
    return h;
  }

  Future<Map<String, dynamic>> get(String path, {Map<String, String>? query}) async {
    try {
      final uri = Uri.parse('$baseUrl$path').replace(queryParameters: query);
      final res = await http.get(uri, headers: _headers);
      return _handleResponse(res);
    } catch (e) {
      return {'success': false, 'message': 'Koneksi gagal: $e', 'data': null};
    }
  }

  Future<Map<String, dynamic>> post(String path, {Map<String, dynamic>? body}) async {
    try {
      final uri = Uri.parse('$baseUrl$path');
      final res = await http.post(uri, headers: _headers, body: jsonEncode(body));
      return _handleResponse(res);
    } catch (e) {
      return {'success': false, 'message': 'Koneksi gagal: $e', 'data': null};
    }
  }

  Future<Map<String, dynamic>> put(String path, {Map<String, dynamic>? body}) async {
    try {
      final uri = Uri.parse('$baseUrl$path');
      final res = await http.put(uri, headers: _headers, body: jsonEncode(body));
      return _handleResponse(res);
    } catch (e) {
      return {'success': false, 'message': 'Koneksi gagal: $e', 'data': null};
    }
  }

  Future<Map<String, dynamic>> delete(String path) async {
    try {
      final uri = Uri.parse('$baseUrl$path');
      final res = await http.delete(uri, headers: _headers);
      return _handleResponse(res);
    } catch (e) {
      return {'success': false, 'message': 'Koneksi gagal: $e', 'data': null};
    }
  }

  Map<String, dynamic> _handleResponse(http.Response res) {
    try {
      final body = jsonDecode(res.body) as Map<String, dynamic>;
      if (res.statusCode >= 200 && res.statusCode < 300) {
        return {'success': true, 'data': body['data'], 'message': body['message'] ?? ''};
      }
      return {'success': false, 'message': body['message'] ?? 'Terjadi kesalahan', 'data': null};
    } catch (_) {
      return {'success': false, 'message': 'Gagal membaca respons server', 'data': null};
    }
  }
}
