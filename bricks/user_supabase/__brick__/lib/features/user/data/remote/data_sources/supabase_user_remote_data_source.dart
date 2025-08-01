import '../models/supabase_user_profile_model.dart';

abstract class SupabaseUserRemoteDataSource {
  Future<SupabaseUserProfileModel> getUserProfile(String userId);
  Future<SupabaseUserProfileModel> updateUserProfile(SupabaseUserProfileModel userProfile);
  Future<void> deleteUserProfile(String userId);
  Stream<SupabaseUserProfileModel?> getUserProfileStream(String userId);
}