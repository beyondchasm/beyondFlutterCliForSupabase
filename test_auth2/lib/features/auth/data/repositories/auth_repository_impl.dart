import 'dart:async';
import '../../domain/entities/auth_result.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../remote/data_sources/rest_auth_remote_data_source.dart';
import '../../../../core/di/service_locator.dart';

class AuthRepositoryImpl implements AuthRepository {
  final RestAuthRemoteDataSource _remoteDataSource;
  final StreamController<UserEntity?> _authStateController = StreamController<UserEntity?>.broadcast();

  AuthRepositoryImpl() : _remoteDataSource = ServiceLocator.get<RestAuthRemoteDataSource>() {
    _initializeAuthState();
  }

  void _initializeAuthState() async {
    final currentUser = await _remoteDataSource.getCurrentUser();
    _authStateController.add(currentUser?.toEntity());
  }

  @override
  Future<AuthResult> signInWithEmailAndPassword(String email, String password) async {
    try {
      final userModel = await _remoteDataSource.signInWithEmailAndPassword(email, password);
      final user = userModel.toEntity();
      _authStateController.add(user);
      return AuthResult.success(user);
    } catch (e) {
      return AuthResult.failure(e.toString().replaceFirst('Exception: ', ''));
    }
  }

  @override
  Future<AuthResult> signUpWithEmailAndPassword(String email, String password) async {
    try {
      final userModel = await _remoteDataSource.signUpWithEmailAndPassword(email, password);
      final user = userModel.toEntity();
      _authStateController.add(user);
      return AuthResult.success(user);
    } catch (e) {
      return AuthResult.failure(e.toString().replaceFirst('Exception: ', ''));
    }
  }

  @override
  Future<void> signOut() async {
    await _remoteDataSource.signOut();
    _authStateController.add(null);
  }

  @override
  Future<AuthResult> resetPassword(String email) async {
    try {
      await _remoteDataSource.resetPassword(email);
      return const AuthResult.success(UserEntity(
        id: '',
        email: '',
        emailConfirmed: false,
        createdAt: null,
      ) as UserEntity);
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
  Stream<UserEntity?> get authStateChanges => _authStateController.stream;

  @override
  Future<AuthResult> signInWithGoogle() async {
    // REST API doesn't typically support Google Sign-In directly
    // This would need to be implemented with OAuth2 flow
    return const AuthResult.failure('Google Sign-In not supported with REST API backend');
  }

  @override
  Future<void> confirmEmail(String token) async {
    // Implementation depends on your REST API design
    throw UnimplementedError('Email confirmation not implemented');
  }

  void dispose() {
    _authStateController.close();
  }
}