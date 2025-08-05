import 'package:injectable/injectable.dart';
import '../repositories/auth_repository.dart';

@lazySingleton
class SignOutUseCase {
  final AuthRepository _authRepository;

  SignOutUseCase(this._authRepository);

  Future<void> call() async {
    return await _authRepository.signOut();
  }
}