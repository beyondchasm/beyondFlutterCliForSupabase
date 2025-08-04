import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../domain/entities/user_entity.dart';

part 'supabase_user_model.freezed.dart';
part 'supabase_user_model.g.dart';

@freezed
class SupabaseUserModel with _$SupabaseUserModel {
  const factory SupabaseUserModel({
    required String id,
    required String email,
    String? phone,
    Map<String, dynamic>? userMetadata,
    required bool emailConfirmed,
    required DateTime createdAt,
    DateTime? lastSignInAt,
  }) = _SupabaseUserModel;

  const SupabaseUserModel._();

  factory SupabaseUserModel.fromJson(Map<String, dynamic> json) =>
      _$SupabaseUserModelFromJson(json);

  factory SupabaseUserModel.fromSupabaseUser(User user) {
    return SupabaseUserModel(
      id: user.id,
      email: user.email ?? '',
      phone: user.phone,
      userMetadata: user.userMetadata,
      emailConfirmed: user.emailConfirmedAt != null,
      createdAt: DateTime.parse(user.createdAt),
      lastSignInAt: user.lastSignInAt != null ? DateTime.parse(user.lastSignInAt!) : null,
    );
  }

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