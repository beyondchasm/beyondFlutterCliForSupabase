import 'package:injectable/injectable.dart';
import '../entities/user_profile.dart';
import '../repositories/user_repository.dart';

@lazySingleton
class UpdateUserProfileUseCase {
  final UserRepository _repository;

  UpdateUserProfileUseCase(this._repository);

  Future<UserProfile> call(UserProfile userProfile) async {
    final validationErrors = userProfile.validate();
    if (validationErrors.isNotEmpty) {
      throw Exception('Validation failed: ${validationErrors.join(', ')}');
    }

    final updatedProfile = userProfile.copyWith(
      updatedAt: DateTime.now(),
    );

    return await _repository.updateUserProfile(updatedProfile);
  }
}