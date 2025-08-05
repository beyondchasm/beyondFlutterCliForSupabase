import '../entities/user_profile.dart';

abstract class UserRepository {
  Future<UserProfile> getUserProfile(String userId);
  Future<UserProfile> createUserProfile(UserProfile userProfile);
  Future<UserProfile> updateUserProfile(UserProfile userProfile);
  Future<void> deleteUserProfile(String userId);
  Stream<UserProfile?> getUserProfileStream(String userId);
  Future<String> uploadProfileImage(String userId, String filePath);
  Future<void> deleteProfileImage(String userId);
  Future<List<UserProfile>> searchUserProfiles(String query, {int limit = 20});
}