import 'package:injectable/injectable.dart';
import '../entities/user_profile.dart';
import '../repositories/user_repository.dart';

@lazySingleton
class GetUserProfileUseCase {
  final UserRepository _repository;

  GetUserProfileUseCase(this._repository);

  Future<UserProfile> call(String userId) async {
    return await _repository.getUserProfile(userId);
  }

  Stream<UserProfile?> getStream(String userId) {
    return _repository.getUserProfileStream(userId);
  }
}