import 'package:injectable/injectable.dart';
import '../entities/auth_result.dart';
import '../repositories/auth_repository.dart';

@lazySingleton
class SignUpUseCase {
  final AuthRepository _authRepository;

  SignUpUseCase(this._authRepository);

  Future<AuthResult> call(String email, String password) async {
    return await _authRepository.signUpWithEmailAndPassword(email, password);
  }
}