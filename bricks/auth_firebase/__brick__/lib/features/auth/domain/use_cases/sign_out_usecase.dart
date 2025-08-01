import '../repositories/auth_repository.dart';
import '../../../../core/di/service_locator.dart';

class SignOutUseCase {
  final AuthRepository _authRepository;

  SignOutUseCase() : _authRepository = ServiceLocator.get<AuthRepository>();

  Future<void> call() async {
    return await _authRepository.signOut();
  }
}