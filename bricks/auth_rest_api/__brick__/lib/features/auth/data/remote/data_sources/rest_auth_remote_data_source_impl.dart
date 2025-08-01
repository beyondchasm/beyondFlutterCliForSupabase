import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/rest_user_model.dart';
import 'rest_auth_remote_data_source.dart';
import '../../../../core/config/environment.dart';

class RestAuthRemoteDataSourceImpl implements RestAuthRemoteDataSource {
  final http.Client _httpClient;
  final String baseUrl;

  RestAuthRemoteDataSourceImpl({
    http.Client? httpClient,
    String? baseUrl,
  })  : _httpClient = httpClient ?? http.Client(),
        baseUrl = baseUrl ?? EnvironmentConfig.baseUrl;

  @override
  Future<RestUserModel> signInWithEmailAndPassword(String email, String password) async {
    try {
      final response = await _httpClient.post(
        Uri.parse('$baseUrl/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        await _saveToken(data['token']);
        return RestUserModel.fromJson(data['user']);
      } else {
        final error = jsonDecode(response.body);
        throw Exception(error['message'] ?? 'Sign in failed');
      }
    } catch (e) {
      throw Exception('Sign in failed: $e');
    }
  }

  @override
  Future<RestUserModel> signUpWithEmailAndPassword(String email, String password) async {
    try {
      final response = await _httpClient.post(
        Uri.parse('$baseUrl/auth/register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode == 201) {
        final data = jsonDecode(response.body);
        await _saveToken(data['token']);
        return RestUserModel.fromJson(data['user']);
      } else {
        final error = jsonDecode(response.body);
        throw Exception(error['message'] ?? 'Sign up failed');
      }
    } catch (e) {
      throw Exception('Sign up failed: $e');
    }
  }

  @override
  Future<void> signOut() async {
    try {
      final token = await _getToken();
      if (token != null) {
        await _httpClient.post(
          Uri.parse('$baseUrl/auth/logout'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
        );
      }
    } finally {
      await _removeToken();
    }
  }

  @override
  Future<void> resetPassword(String email) async {
    try {
      final response = await _httpClient.post(
        Uri.parse('$baseUrl/auth/forgot-password'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email}),
      );

      if (response.statusCode != 200) {
        final error = jsonDecode(response.body);
        throw Exception(error['message'] ?? 'Password reset failed');
      }
    } catch (e) {
      throw Exception('Password reset failed: $e');
    }
  }

  @override
  Future<RestUserModel?> getCurrentUser() async {
    try {
      final token = await _getToken();
      if (token == null) return null;

      final response = await _httpClient.get(
        Uri.parse('$baseUrl/auth/me'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return RestUserModel.fromJson(data['user']);
      } else if (response.statusCode == 401) {
        await _removeToken();
        return null;
      } else {
        throw Exception('Failed to get current user');
      }
    } catch (e) {
      return null;
    }
  }

  @override
  Future<String> refreshToken() async {
    try {
      final token = await _getToken();
      if (token == null) throw Exception('No token found');

      final response = await _httpClient.post(
        Uri.parse('$baseUrl/auth/refresh'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final newToken = data['token'];
        await _saveToken(newToken);
        return newToken;
      } else {
        throw Exception('Token refresh failed');
      }
    } catch (e) {
      throw Exception('Token refresh failed: $e');
    }
  }

  Future<void> _saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);
  }

  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }

  Future<void> _removeToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
  }
}