import 'package:injectable/injectable.dart';
import '../repositories/user_repository.dart';

@lazySingleton
class DeleteUserProfileUseCase {
  final UserRepository _repository;

  DeleteUserProfileUseCase(this._repository);

  Future<void> call(String userId) async {
    return await _repository.deleteUserProfile(userId);
  }
}