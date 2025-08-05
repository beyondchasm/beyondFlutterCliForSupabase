import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../domain/entities/auth_result.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../remote/data_sources/supabase_auth_remote_data_source.dart';

@LazySingleton(as: AuthRepository)
class AuthRepositoryImpl implements AuthRepository {
  final SupabaseAuthRemoteDataSource _remoteDataSource;

  AuthRepositoryImpl(this._remoteDataSource);

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
    } on AuthException catch (e) {
      return AuthResult.failure(
        message: e.message,
        errorType: _getErrorTypeFromMessage(e.message),
        code: e.statusCode,
      );
    } catch (e) {
      return AuthResult.failure(
        message: e.toString().replaceFirst('Exception: ', ''),
        errorType: AuthErrorType.unknownError,
      );
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
      
      // 이메일 확인이 필요한 경우 처리
      if (!userModel.emailConfirmed) {
        return AuthResult.emailVerificationRequired(
          email: email,
          message: '회원가입이 완료되었습니다. 이메일을 확인해주세요.',
        );
      }
      
      return AuthResult.success(userModel.toEntity());
    } on AuthException catch (e) {
      return AuthResult.failure(
        message: e.message,
        errorType: _getErrorTypeFromMessage(e.message),
        code: e.statusCode,
      );
    } catch (e) {
      return AuthResult.failure(
        message: e.toString().replaceFirst('Exception: ', ''),
        errorType: AuthErrorType.unknownError,
      );
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

  /// 에러 메시지에서 AuthErrorType 추출
  AuthErrorType _getErrorTypeFromMessage(String message) {
    if (message.contains('Invalid login credentials')) {
      return AuthErrorType.invalidCredentials;
    } else if (message.contains('Email not confirmed')) {
      return AuthErrorType.emailNotVerified;
    } else if (message.contains('User already registered')) {
      return AuthErrorType.emailAlreadyInUse;
    } else if (message.contains('Password should be at least') || 
               message.contains('Weak password')) {
      return AuthErrorType.weakPassword;
    } else if (message.contains('User not found')) {
      return AuthErrorType.userNotFound;
    } else if (message.contains('Too many requests')) {
      return AuthErrorType.tooManyRequests;
    } else if (message.contains('network') || message.contains('connection')) {
      return AuthErrorType.networkError;
    } else if (message.contains('server') || message.contains('internal')) {
      return AuthErrorType.serverError;
    } else {
      return AuthErrorType.unknownError;
    }
  }
}
