import '../models/rest_user_profile_model.dart';

abstract class RestUserRemoteDataSource {
  Future<RestUserProfileModel> getUserProfile(String userId);
  Future<RestUserProfileModel> updateUserProfile(RestUserProfileModel userProfile);
  Future<void> deleteUserProfile(String userId);
  Stream<RestUserProfileModel?> getUserProfileStream(String userId);
}