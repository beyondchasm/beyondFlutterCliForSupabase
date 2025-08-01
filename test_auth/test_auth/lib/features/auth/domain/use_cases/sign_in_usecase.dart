import '../entities/auth_result.dart';
import '../repositories/auth_repository.dart';
import '../../../../core/di/service_locator.dart';

class SignInUseCase {
  final AuthRepository _authRepository;

  SignInUseCase() : _authRepository = ServiceLocator.get<AuthRepository>();

  Future<AuthResult> call(String email, String password) async {
    return await _authRepository.signInWithEmailAndPassword(email, password);
  }
}