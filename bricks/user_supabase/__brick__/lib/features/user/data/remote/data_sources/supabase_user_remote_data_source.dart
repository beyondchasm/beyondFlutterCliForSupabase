import '../models/supabase_user_profile_model.dart';

abstract class SupabaseUserRemoteDataSource {
  Future<SupabaseUserProfileModel> getUserProfile(String userId);
  Future<SupabaseUserProfileModel> createUserProfile(SupabaseUserProfileModel userProfile);
  Future<SupabaseUserProfileModel> updateUserProfile(SupabaseUserProfileModel userProfile);
  Future<void> deleteUserProfile(String userId);
  Stream<SupabaseUserProfileModel?> getUserProfileStream(String userId);
  Future<String> uploadProfileImage(String userId, String filePath);
  Future<void> deleteProfileImage(String userId);
  Future<List<SupabaseUserProfileModel>> searchUserProfiles(String query, {int limit = 20});
}