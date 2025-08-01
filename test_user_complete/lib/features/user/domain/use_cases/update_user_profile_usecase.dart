import '../entities/user_profile.dart';
import '../repositories/user_repository.dart';
import '../../../../core/di/service_locator.dart';

class UpdateUserProfileUseCase {
  final UserRepository _repository;

  UpdateUserProfileUseCase() : _repository = ServiceLocator.get<UserRepository>();

  Future<UserProfile> call(UserProfile userProfile) async {
    return await _repository.updateUserProfile(userProfile);
  }
}