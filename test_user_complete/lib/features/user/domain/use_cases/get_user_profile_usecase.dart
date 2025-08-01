import '../entities/user_profile.dart';
import '../repositories/user_repository.dart';
import '../../../../core/di/service_locator.dart';

class GetUserProfileUseCase {
  final UserRepository _repository;

  GetUserProfileUseCase() : _repository = ServiceLocator.get<UserRepository>();

  Future<UserProfile> call(String userId) async {
    return await _repository.getUserProfile(userId);
  }

  Stream<UserProfile?> getStream(String userId) {
    return _repository.getUserProfileStream(userId);
  }
}