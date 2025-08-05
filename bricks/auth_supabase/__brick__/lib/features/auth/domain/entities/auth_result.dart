import 'package:freezed_annotation/freezed_annotation.dart';
import 'user_entity.dart';

part 'auth_result.freezed.dart';

@freezed
class AuthResult with _$AuthResult {
  const factory AuthResult.success(UserEntity user) = AuthSuccess;
  const factory AuthResult.failure({
    required String message,
    required AuthErrorType errorType,
    String? code,
    Map<String, dynamic>? details,
  }) = AuthFailure;
  const factory AuthResult.loading() = AuthLoading;
  const factory AuthResult.emailVerificationRequired({
    required String email,
    String? message,
  }) = AuthEmailVerificationRequired;
}

enum AuthErrorType {
  invalidCredentials,
  networkError,
  serverError,
  weakPassword,
  emailAlreadyInUse,
  emailNotVerified,
  userNotFound,
  tooManyRequests,
  unknownError,
}