import 'package:freezed_annotation/freezed_annotation.dart';
import 'user_entity.dart';

part 'auth_result.freezed.dart';

@freezed
class AuthResult with _$AuthResult {
  const factory AuthResult.success(UserEntity user) = AuthSuccess;
  const factory AuthResult.failure(String message) = AuthFailure;
}