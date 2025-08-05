import 'package:injectable/injectable.dart';
import '../../domain/entities/user_profile.dart';
import '../../domain/repositories/user_repository.dart';
import '../remote/data_sources/supabase_user_remote_data_source.dart';
import '../remote/models/supabase_user_profile_model.dart';

@LazySingleton(as: UserRepository)
class UserRepositoryImpl implements UserRepository {
  final SupabaseUserRemoteDataSource _remoteDataSource;

  UserRepositoryImpl(this._remoteDataSource);

  @override
  Future<UserProfile> getUserProfile(String userId) async {
    final userModel = await _remoteDataSource.getUserProfile(userId);
    return userModel.toEntity();
  }

  @override
  Future<UserProfile> updateUserProfile(UserProfile userProfile) async {
    final userModel = SupabaseUserProfileModel.fromEntity(userProfile);
    final updatedModel = await _remoteDataSource.updateUserProfile(userModel);
    return updatedModel.toEntity();
  }

  @override
  Future<void> deleteUserProfile(String userId) async {
    await _remoteDataSource.deleteUserProfile(userId);
  }

  @override
  Future<UserProfile> createUserProfile(UserProfile userProfile) async {
    final userModel = SupabaseUserProfileModel.fromEntity(userProfile);
    final createdModel = await _remoteDataSource.createUserProfile(userModel);
    return createdModel.toEntity();
  }

  @override
  Stream<UserProfile?> getUserProfileStream(String userId) {
    return _remoteDataSource.getUserProfileStream(userId).map((model) => model?.toEntity());
  }

  @override
  Future<String> uploadProfileImage(String userId, String filePath) async {
    return await _remoteDataSource.uploadProfileImage(userId, filePath);
  }

  @override
  Future<void> deleteProfileImage(String userId) async {
    await _remoteDataSource.deleteProfileImage(userId);
  }

  @override
  Future<List<UserProfile>> searchUserProfiles(String query, {int limit = 20}) async {
    final models = await _remoteDataSource.searchUserProfiles(query, limit: limit);
    return models.map((model) => model.toEntity()).toList();
  }
}