import '../entities/user_profile.dart';

abstract class UserRepository {
  Future<UserProfile> getUserProfile(String userId);
  Future<UserProfile> updateUserProfile(UserProfile userProfile);
  Future<void> deleteUserProfile(String userId);
  Stream<UserProfile?> getUserProfileStream(String userId);
}