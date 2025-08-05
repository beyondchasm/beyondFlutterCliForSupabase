import 'package:injectable/injectable.dart';
import '../entities/user_profile.dart';
import '../repositories/user_repository.dart';

@lazySingleton
class CreateUserProfileUseCase {
  final UserRepository _repository;

  CreateUserProfileUseCase(this._repository);

  Future<UserProfile> call(UserProfile userProfile) async {
    final validationErrors = userProfile.validate();
    if (validationErrors.isNotEmpty) {
      throw Exception('Validation failed: ${validationErrors.join(', ')}');
    }

    return await _repository.createUserProfile(userProfile);
  }
}