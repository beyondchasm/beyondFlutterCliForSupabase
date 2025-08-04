import '../repositories/user_repository.dart';
import '../../../../core/di/service_locator.dart';

class DeleteUserProfileUseCase {
  final UserRepository _repository;

  DeleteUserProfileUseCase() : _repository = ServiceLocator.get<UserRepository>();

  Future<void> call(String userId) async {
    return await _repository.deleteUserProfile(userId);
  }
}