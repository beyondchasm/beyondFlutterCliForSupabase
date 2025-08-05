import 'package:injectable/injectable.dart';
import '../entities/auth_result.dart';
import '../repositories/auth_repository.dart';

@lazySingleton
class SignInUseCase {
  final AuthRepository _authRepository;

  SignInUseCase(this._authRepository);

  Future<AuthResult> call(String email, String password) async {
    return await _authRepository.signInWithEmailAndPassword(email, password);
  }
}