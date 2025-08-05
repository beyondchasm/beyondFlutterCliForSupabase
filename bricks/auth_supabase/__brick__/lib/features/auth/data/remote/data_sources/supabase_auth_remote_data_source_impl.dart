import 'dart:io';
import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/supabase_user_model.dart';
import 'supabase_auth_remote_data_source.dart';
import '../../../domain/entities/auth_result.dart';

@LazySingleton(as: SupabaseAuthRemoteDataSource)
class SupabaseAuthRemoteDataSourceImpl implements SupabaseAuthRemoteDataSource {
  final SupabaseClient _supabaseClient;

  SupabaseAuthRemoteDataSourceImpl(this._supabaseClient);

  @override
  Future<SupabaseUserModel> signInWithEmailAndPassword(String email, String password) async {
    try {
      final response = await _supabaseClient.auth.signInWithPassword(
        email: email,
        password: password,
      );
      
      if (response.user == null) {
        throw Exception('Sign in failed');
      }
      
      return SupabaseUserModel.fromSupabaseUser(response.user!);
    } on AuthException catch (e) {
      throw Exception(_getAuthErrorMessage(e.message));
    }
  }

  @override
  Future<SupabaseUserModel> signUpWithEmailAndPassword(String email, String password) async {
    try {
      final response = await _supabaseClient.auth.signUp(
        email: email,
        password: password,
      );
      
      if (response.user == null) {
        throw Exception('Sign up failed');
      }
      
      return SupabaseUserModel.fromSupabaseUser(response.user!);
    } on AuthException catch (e) {
      throw Exception(_getAuthErrorMessage(e.message));
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await _supabaseClient.auth.signOut();
    } on AuthException catch (e) {
      throw Exception(_getAuthErrorMessage(e.message));
    }
  }

  @override
  Future<void> resetPassword(String email) async {
    try {
      await _supabaseClient.auth.resetPasswordForEmail(email);
    } on AuthException catch (e) {
      throw Exception(_getAuthErrorMessage(e.message));
    }
  }

  @override
  Future<SupabaseUserModel?> getCurrentUser() async {
    final user = _supabaseClient.auth.currentUser;
    return user != null ? SupabaseUserModel.fromSupabaseUser(user) : null;
  }

  @override
  Stream<SupabaseUserModel?> get authStateChanges {
    return _supabaseClient.auth.onAuthStateChange.map((data) {
      final user = data.session?.user;
      return user != null ? SupabaseUserModel.fromSupabaseUser(user) : null;
    });
  }

  @override
  Future<SupabaseUserModel> signInWithGoogle() async {
    try {
      final response = await _supabaseClient.auth.signInWithOAuth(
        OAuthProvider.google,
      );
      
      if (response == false) {
        throw Exception('Google sign in was cancelled or failed');
      }

      // Wait for auth state change
      await Future.delayed(const Duration(seconds: 2));
      
      final user = _supabaseClient.auth.currentUser;
      if (user == null) {
        throw Exception('Google sign in failed - no user found');
      }
      
      return SupabaseUserModel.fromSupabaseUser(user);
    } catch (e) {
      throw Exception('Google sign in failed: $e');
    }
  }

  @override
  Future<void> confirmEmail(String token) async {
    try {
      await _supabaseClient.auth.verifyOTP(
        type: OtpType.email,
        token: token,
        email: '', // Email should be provided in real implementation
      );
    } on AuthException catch (e) {
      throw _handleAuthError(e);
    }
  }

  @override
  Future<SupabaseUserModel> signInWithApple() async {
    try {
      final response = await _supabaseClient.auth.signInWithOAuth(
        OAuthProvider.apple,
        redirectTo: 'your-app://auth-callback',
      );
      
      if (response == false) {
        throw const AuthException('Apple sign in was cancelled or failed');
      }

      // Wait for auth state change
      await Future.delayed(const Duration(seconds: 2));
      
      final user = _supabaseClient.auth.currentUser;
      if (user == null) {
        throw const AuthException('Apple sign in failed - no user found');
      }
      
      return SupabaseUserModel.fromSupabaseUser(user);
    } catch (e) {
      throw _handleAuthError(e);
    }
  }

  @override
  Future<void> resendEmailConfirmation(String email) async {
    try {
      await _supabaseClient.auth.resend(
        type: OtpType.email,
        email: email,
      );
    } on AuthException catch (e) {
      throw _handleAuthError(e);
    }
  }

  @override
  Future<void> updatePassword(String newPassword) async {
    try {
      await _supabaseClient.auth.updateUser(
        UserAttributes(password: newPassword),
      );
    } on AuthException catch (e) {
      throw _handleAuthError(e);
    }
  }

  @override
  Future<void> updateEmail(String newEmail) async {
    try {
      await _supabaseClient.auth.updateUser(
        UserAttributes(email: newEmail),
      );
    } on AuthException catch (e) {
      throw _handleAuthError(e);
    }
  }

  @override
  Future<bool> verifySession() async {
    try {
      final session = _supabaseClient.auth.currentSession;
      if (session == null) return false;
      
      // 세션 만료 체크
      final expiresAt = DateTime.fromMillisecondsSinceEpoch(session.expiresAt! * 1000);
      if (expiresAt.isBefore(DateTime.now())) {
        return false;
      }
      
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<void> refreshSession() async {
    try {
      await _supabaseClient.auth.refreshSession();
    } on AuthException catch (e) {
      throw _handleAuthError(e);
    }
  }

  @override
  Future<Map<String, dynamic>> getSessionInfo() async {
    try {
      final session = _supabaseClient.auth.currentSession;
      if (session == null) {
        return {'isValid': false, 'message': 'No active session'};
      }
      
      final expiresAt = DateTime.fromMillisecondsSinceEpoch(session.expiresAt! * 1000);
      final now = DateTime.now();
      final isExpired = expiresAt.isBefore(now);
      final timeToExpiry = expiresAt.difference(now);
      
      return {
        'isValid': !isExpired,
        'expiresAt': expiresAt.toIso8601String(),
        'timeToExpiry': timeToExpiry.inMinutes,
        'isExpired': isExpired,
        'userId': session.user.id,
        'email': session.user.email,
      };
    } catch (e) {
      return {'isValid': false, 'message': e.toString()};
    }
  }

  /// 향상된 에러 처리 시스템
  AuthException _handleAuthError(Object error) {
    if (error is AuthException) {
      return AuthException(
        message: _getLocalizedErrorMessage(error.message),
        statusCode: error.statusCode,
      );
    } else if (error is SocketException) {
      return const AuthException(
        'Network connection failed. Please check your internet connection.',
      );
    } else if (error is FormatException) {
      return const AuthException(
        'Invalid data format received from server.',
      );
    } else {
      return AuthException(
        'An unexpected error occurred: ${error.toString()}',
      );
    }
  }

  String _getLocalizedErrorMessage(String message) {
    final errorMap = {
      'Invalid login credentials': '이메일 또는 비밀번호가 올바르지 않습니다.',
      'Email not confirmed': '이메일 인증을 완료해주세요.',
      'User already registered': '이미 등록된 이메일입니다.',
      'Password should be at least': '비밀번호는 최소 8자 이상이어야 합니다.',
      'Unable to validate email address': '올바른 이메일 주소를 입력해주세요.',
      'Signup is disabled': '현재 회원가입이 비활성화되어 있습니다.',
      'Too many requests': '너무 많은 요청이 발생했습니다. 잠시 후 다시 시도해주세요.',
      'User not found': '등록되지 않은 이메일입니다.',
      'Token has expired': '인증 토큰이 만료되었습니다. 다시 로그인해주세요.',
      'Weak password': '비밀번호가 너무 약합니다. 더 강력한 비밀번호를 사용해주세요.',
    };

    for (final entry in errorMap.entries) {
      if (message.toLowerCase().contains(entry.key.toLowerCase())) {
        return entry.value;
      }
    }

    return message.isNotEmpty ? message : '알 수 없는 오류가 발생했습니다. 다시 시도해주세요.';
  }

  /// 에러 타입 분류
  AuthErrorType _getErrorType(String message) {
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