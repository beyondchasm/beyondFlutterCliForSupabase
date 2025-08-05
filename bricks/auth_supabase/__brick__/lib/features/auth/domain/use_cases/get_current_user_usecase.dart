import 'package:injectable/injectable.dart';
import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';

@lazySingleton
class GetCurrentUserUseCase {
  final AuthRepository _authRepository;

  GetCurrentUserUseCase(this._authRepository);

  Future<UserEntity?> call() async {
    return await _authRepository.getCurrentUser();
  }

  Stream<UserEntity?> get authStateChanges => _authRepository.authStateChanges;
}