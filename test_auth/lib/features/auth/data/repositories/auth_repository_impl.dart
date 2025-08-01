import '../../domain/entities/auth_result.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../remote/data_sources/firebase_auth_remote_data_source.dart';
import '../../../../core/di/service_locator.dart';

class AuthRepositoryImpl implements AuthRepository {
  final FirebaseAuthRemoteDataSource _remoteDataSource;

  AuthRepositoryImpl() : _remoteDataSource = ServiceLocator.get<FirebaseAuthRemoteDataSource>();

  @override
  Future<AuthResult> signInWithEmailAndPassword(String email, String password) async {
    try {
      final userModel = await _remoteDataSource.signInWithEmailAndPassword(email, password);
      return AuthResult.success(userModel.toEntity());
    } catch (e) {
      return AuthResult.failure(e.toString());
    }
  }

  @override
  Future<AuthResult> createUserWithEmailAndPassword(String email, String password) async {
    try {
      final userModel = await _remoteDataSource.createUserWithEmailAndPassword(email, password);
      return AuthResult.success(userModel.toEntity());
    } catch (e) {
      return AuthResult.failure(e.toString());
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
      return const AuthResult.success(UserEntity(
        uid: '',
        email: '',
        emailVerified: false,
        createdAt: null,
      ) as UserEntity);
    } catch (e) {
      return AuthResult.failure(e.toString());
    }
  }

  @override
  Future<UserEntity?> getCurrentUser() async {
    final userModel = await _remoteDataSource.getCurrentUser();
    return userModel?.toEntity();
  }

  @override
  Stream<UserEntity?> get authStateChanges {
    return _remoteDataSource.authStateChanges.map((userModel) => userModel?.toEntity());
  }

  @override
  Future<AuthResult> signInWithGoogle() async {
    try {
      final userModel = await _remoteDataSource.signInWithGoogle();
      return AuthResult.success(userModel.toEntity());
    } catch (e) {
      return AuthResult.failure(e.toString());
    }
  }

  @override
  Future<void> sendEmailVerification() async {
    await _remoteDataSource.sendEmailVerification();
  }
}