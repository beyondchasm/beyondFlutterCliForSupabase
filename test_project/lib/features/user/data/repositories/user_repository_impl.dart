import '../../domain/entities/user_profile.dart';
import '../../domain/repositories/user_repository.dart';
import '../remote/data_sources/supabase_user_remote_data_source.dart';
import '../remote/models/supabase_user_profile_model.dart';
import '../../../../core/di/service_locator.dart';

class UserRepositoryImpl implements UserRepository {
  final SupabaseUserRemoteDataSource _remoteDataSource;

  UserRepositoryImpl() : _remoteDataSource = ServiceLocator.get<SupabaseUserRemoteDataSource>();

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
  Stream<UserProfile?> getUserProfileStream(String userId) {
    return _remoteDataSource.getUserProfileStream(userId).map((model) => model?.toEntity());
  }
}