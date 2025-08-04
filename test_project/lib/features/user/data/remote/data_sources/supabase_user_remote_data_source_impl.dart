import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/supabase_user_profile_model.dart';
import 'supabase_user_remote_data_source.dart';

class SupabaseUserRemoteDataSourceImpl implements SupabaseUserRemoteDataSource {
  final SupabaseClient _supabase;
  final String _tableName = 'user_profiles';

  SupabaseUserRemoteDataSourceImpl({
    SupabaseClient? supabase,
  }) : _supabase = supabase ?? Supabase.instance.client;

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
}