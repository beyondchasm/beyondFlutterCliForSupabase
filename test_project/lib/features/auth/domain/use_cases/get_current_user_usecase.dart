import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';
import '../../../../core/di/service_locator.dart';

class GetCurrentUserUseCase {
  final AuthRepository _authRepository;

  GetCurrentUserUseCase() : _authRepository = ServiceLocator.get<AuthRepository>();

  Future<UserEntity?> call() async {
    return await _authRepository.getCurrentUser();
  }

  Stream<UserEntity?> get authStateChanges => _authRepository.authStateChanges;
}