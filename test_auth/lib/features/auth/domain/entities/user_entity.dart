import 'package:freezed_annotation/freezed_annotation.dart';

part 'freezed/user_entity.freezed.dart';
part 'freezed/user_entity.g.dart';

@freezed
class UserEntity with _$UserEntity {
  const factory UserEntity({
    required String uid,
    required String email,
    String? displayName,
    String? photoURL,
    required bool emailVerified,
    required DateTime createdAt,
    DateTime? lastSignInAt,
  }) = _UserEntity;

  factory UserEntity.fromJson(Map<String, dynamic> json) =>
      _$UserEntityFromJson(json);
}