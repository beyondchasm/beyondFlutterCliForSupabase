import '../models/firebase_user_profile_model.dart';

abstract class FirebaseUserRemoteDataSource {
  Future<FirebaseUserProfileModel> getUserProfile(String userId);
  Future<FirebaseUserProfileModel> updateUserProfile(FirebaseUserProfileModel userProfile);
  Future<void> deleteUserProfile(String userId);
  Stream<FirebaseUserProfileModel?> getUserProfileStream(String userId);
}