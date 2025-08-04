import '../../domain/entities/auth_result.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../remote/data_sources/supabase_auth_remote_data_source.dart';
import '../../../../core/di/service_locator.dart';

class AuthRepositoryImpl implements AuthRepository {
  final SupabaseAuthRemoteDataSource _remoteDataSource;

  AuthRepositoryImpl()
    : _remoteDataSource = ServiceLocator.get<SupabaseAuthRemoteDataSource>();

  @override
  Future<AuthResult> signInWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      final userModel = await _remoteDataSource.signInWithEmailAndPassword(
        email,
        password,
      );
      return AuthResult.success(userModel.toEntity());
    } catch (e) {
      return AuthResult.failure(e.toString().replaceFirst('Exception: ', ''));
    }
  }

  @override
  Future<AuthResult> signUpWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      final userModel = await _remoteDataSource.signUpWithEmailAndPassword(
        email,
        password,
      );
      return AuthResult.success(userModel.toEntity());
    } catch (e) {
      return AuthResult.failure(e.toString().replaceFirst('Exception: ', ''));
    }
  }

  @override
  Future<void> signOut() async {
    await _remoteDataSource.signOut();
  }

  @override
  Future<AuthResult> resetPassword(String email) async {
    try {
      await _remoteDataSource.resetPassword(email);
      return AuthResult.success(
        UserEntity(
              id: '',
              email: '',
              emailConfirmed: false,
              createdAt: DateTime.now(),
            )
            as UserEntity,
      );
    } catch (e) {
      return AuthResult.failure(e.toString().replaceFirst('Exception: ', ''));
    }
  }

  @override
  Future<UserEntity?> getCurrentUser() async {
    final userModel = await _remoteDataSource.getCurrentUser();
    return userModel?.toEntity();
  }

  @override
  Stream<UserEntity?> get authStateChanges {
    return _remoteDataSource.authStateChanges.map(
      (userModel) => userModel?.toEntity(),
    );
  }

  @override
  Future<AuthResult> signInWithGoogle() async {
    try {
      final userModel = await _remoteDataSource.signInWithGoogle();
      return AuthResult.success(userModel.toEntity());
    } catch (e) {
      return AuthResult.failure(e.toString().replaceFirst('Exception: ', ''));
    }
  }

  @override
  Future<void> confirmEmail(String token) async {
    await _remoteDataSource.confirmEmail(token);
  }
}
