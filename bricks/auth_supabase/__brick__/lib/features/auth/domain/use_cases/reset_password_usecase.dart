import 'package:injectable/injectable.dart';
import '../entities/auth_result.dart';
import '../repositories/auth_repository.dart';

@lazySingleton
class ResetPasswordUseCase {
  final AuthRepository _authRepository;

  ResetPasswordUseCase(this._authRepository);

  Future<AuthResult> call(String email) async {
    return await _authRepository.resetPassword(email);
  }
}