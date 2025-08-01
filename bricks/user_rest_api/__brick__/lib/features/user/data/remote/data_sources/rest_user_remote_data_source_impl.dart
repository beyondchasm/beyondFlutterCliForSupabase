import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/rest_user_profile_model.dart';
import 'rest_user_remote_data_source.dart';
import '../../../../core/config/environment.dart';

class RestUserRemoteDataSourceImpl implements RestUserRemoteDataSource {
  final http.Client _httpClient;
  final String baseUrl;
  final StreamController<RestUserProfileModel?> _userProfileController = StreamController<RestUserProfileModel?>.broadcast();

  RestUserRemoteDataSourceImpl({
    http.Client? httpClient,
    String? baseUrl,
  })  : _httpClient = httpClient ?? http.Client(),
        baseUrl = baseUrl ?? EnvironmentConfig.baseUrl;

  @override
  Future<RestUserProfileModel> getUserProfile(String userId) async {
    try {
      final token = await _getToken();
      final response = await _httpClient.get(
        Uri.parse('$baseUrl/users/$userId'),
        headers: {
          'Content-Type': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final userProfile = RestUserProfileModel.fromJson(data['user']);
        _userProfileController.add(userProfile);
        return userProfile;
      } else if (response.statusCode == 404) {
        throw Exception('User profile not found');
      } else {
        final error = jsonDecode(response.body);
        throw Exception(error['message'] ?? 'Failed to get user profile');
      }
    } catch (e) {
      throw Exception('Failed to get user profile: $e');
    }
  }

  @override
  Future<RestUserProfileModel> updateUserProfile(RestUserProfileModel userProfile) async {
    try {
      final token = await _getToken();
      final response = await _httpClient.put(
        Uri.parse('$baseUrl/users/${userProfile.id}'),
        headers: {
          'Content-Type': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
        body: jsonEncode(userProfile.toUpdateRequest()),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final updatedProfile = RestUserProfileModel.fromJson(data['user']);
        _userProfileController.add(updatedProfile);
        return updatedProfile;
      } else {
        final error = jsonDecode(response.body);
        throw Exception(error['message'] ?? 'Failed to update user profile');
      }
    } catch (e) {
      throw Exception('Failed to update user profile: $e');
    }
  }

  @override
  Future<void> deleteUserProfile(String userId) async {
    try {
      final token = await _getToken();
      final response = await _httpClient.delete(
        Uri.parse('$baseUrl/users/$userId'),
        headers: {
          'Content-Type': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        _userProfileController.add(null);
      } else {
        final error = jsonDecode(response.body);
        throw Exception(error['message'] ?? 'Failed to delete user profile');
      }
    } catch (e) {
      throw Exception('Failed to delete user profile: $e');
    }
  }

  @override
  Stream<RestUserProfileModel?> getUserProfileStream(String userId) {
    // Initialize with current data if available
    getUserProfile(userId).catchError((e) {
      // Ignore errors for stream initialization
    });
    
    return _userProfileController.stream;
  }

  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }

  void dispose() {
    _userProfileController.close();
  }
}