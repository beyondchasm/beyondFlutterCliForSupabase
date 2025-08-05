import 'dart:io';
import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/supabase_user_profile_model.dart';
import 'supabase_user_remote_data_source.dart';

@LazySingleton(as: SupabaseUserRemoteDataSource)
class SupabaseUserRemoteDataSourceImpl implements SupabaseUserRemoteDataSource {
  final SupabaseClient _supabase;
  final String _tableName = 'user_profiles';
  final String _bucketName = 'avatars';

  SupabaseUserRemoteDataSourceImpl(this._supabase);

  @override
  Future<SupabaseUserProfileModel> getUserProfile(String userId) async {
    try {
      final response = await _supabase
          .from(_tableName)
          .select()
          .eq('id', userId)
          .single();

      return SupabaseUserProfileModel.fromJson(response);
    } catch (e) {
      throw Exception('Failed to get user profile: $e');
    }
  }

  @override
  Future<SupabaseUserProfileModel> updateUserProfile(SupabaseUserProfileModel userProfile) async {
    try {
      final response = await _supabase
          .from(_tableName)
          .update(userProfile.toUpdate())
          .eq('id', userProfile.id)
          .select()
          .single();

      return SupabaseUserProfileModel.fromJson(response);
    } catch (e) {
      throw Exception('Failed to update user profile: $e');
    }
  }

  @override
  Future<void> deleteUserProfile(String userId) async {
    try {
      await _supabase
          .from(_tableName)
          .delete()
          .eq('id', userId);
    } catch (e) {
      throw Exception('Failed to delete user profile: $e');
    }
  }

  @override
  Future<SupabaseUserProfileModel> createUserProfile(SupabaseUserProfileModel userProfile) async {
    try {
      final response = await _supabase
          .from(_tableName)
          .insert(userProfile.toInsert())
          .select()
          .single();

      return SupabaseUserProfileModel.fromJson(response);
    } catch (e) {
      throw Exception('Failed to create user profile: $e');
    }
  }

  @override
  Stream<SupabaseUserProfileModel?> getUserProfileStream(String userId) {
    return _supabase
        .from(_tableName)
        .stream(primaryKey: ['id'])
        .eq('id', userId)
        .map((data) {
          if (data.isEmpty) {
            return null;
          }
          return SupabaseUserProfileModel.fromJson(data.first);
        });
  }

  @override
  Future<String> uploadProfileImage(String userId, String filePath) async {
    try {
      final file = File(filePath);
      final fileExt = filePath.split('.').last;
      final fileName = '$userId.$fileExt';
      
      await _supabase.storage
          .from(_bucketName)
          .upload(fileName, file, fileOptions: const FileOptions(upsert: true));
      
      final publicUrl = _supabase.storage
          .from(_bucketName)
          .getPublicUrl(fileName);
      
      return publicUrl;
    } catch (e) {
      throw Exception('Failed to upload profile image: $e');
    }
  }

  @override
  Future<void> deleteProfileImage(String userId) async {
    try {
      final List<FileObject> objects = await _supabase.storage
          .from(_bucketName)
          .list(path: '/');
      
      final userFiles = objects
          .where((obj) => obj.name.startsWith(userId))
          .map((obj) => obj.name)
          .toList();
      
      if (userFiles.isNotEmpty) {
        await _supabase.storage
            .from(_bucketName)
            .remove(userFiles);
      }
    } catch (e) {
      throw Exception('Failed to delete profile image: $e');
    }
  }

  @override
  Future<List<SupabaseUserProfileModel>> searchUserProfiles(String query, {int limit = 20}) async {
    try {
      final response = await _supabase
          .from(_tableName)
          .select()
          .or('display_name.ilike.%$query%,first_name.ilike.%$query%,last_name.ilike.%$query%,email.ilike.%$query%')
          .eq('status', 'active')
          .limit(limit);

      return response
          .map<SupabaseUserProfileModel>((json) => SupabaseUserProfileModel.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Failed to search user profiles: $e');
    }
  }
}