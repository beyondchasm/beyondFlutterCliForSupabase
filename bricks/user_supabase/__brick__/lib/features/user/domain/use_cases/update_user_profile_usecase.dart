import 'package:injectable/injectable.dart';
import '../entities/user_profile.dart';
import '../repositories/user_repository.dart';

@lazySingleton
class UpdateUserProfileUseCase {
  final UserRepository _repository;

  UpdateUserProfileUseCase(this._repository);

  Future<UserProfile> call(UserProfile userProfile) async {
    return await _repository.updateUserProfile(userProfile);
  }
}