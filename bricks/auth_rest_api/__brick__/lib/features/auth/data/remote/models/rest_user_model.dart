import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../domain/entities/user_entity.dart';

part 'freezed/rest_user_model.freezed.dart';
part 'freezed/rest_user_model.g.dart';

@freezed
class RestUserModel with _$RestUserModel {
  const factory RestUserModel({
    required String id,
    required String email,
    String? phone,
    Map<String, dynamic>? userMetadata,
    required bool emailConfirmed,
    required DateTime createdAt,
    DateTime? lastSignInAt,
  }) = _RestUserModel;

  const RestUserModel._();

  factory RestUserModel.fromJson(Map<String, dynamic> json) =>
      _$RestUserModelFromJson(json);

  UserEntity toEntity() {
    return UserEntity(
      id: id,
      email: email,
      phone: phone,
      userMetadata: userMetadata,
      emailConfirmed: emailConfirmed,
      createdAt: createdAt,
      lastSignInAt: lastSignInAt,
    );
  }
}