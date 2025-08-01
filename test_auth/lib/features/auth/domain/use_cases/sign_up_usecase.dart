import '../entities/auth_result.dart';
import '../repositories/auth_repository.dart';
import '../../../../core/di/service_locator.dart';

class SignUpUseCase {
  final AuthRepository _authRepository;

  SignUpUseCase() : _authRepository = ServiceLocator.get<AuthRepository>();

  Future<AuthResult> call(String email, String password) async {
    return await _authRepository.createUserWithEmailAndPassword(email, password);
  }
}