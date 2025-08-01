import '../entities/auth_result.dart';
import '../repositories/auth_repository.dart';
import '../../../../core/di/service_locator.dart';

class ResetPasswordUseCase {
  final AuthRepository _authRepository;

  ResetPasswordUseCase() : _authRepository = ServiceLocator.get<AuthRepository>();

  Future<AuthResult> call(String email) async {
    return await _authRepository.resetPassword(email);
  }
}