import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../domain/entities/user_profile.dart';

part 'freezed/supabase_user_profile_model.freezed.dart';
part 'freezed/supabase_user_profile_model.g.dart';

@freezed
class SupabaseUserProfileModel with _$SupabaseUserProfileModel {
  const factory SupabaseUserProfileModel({
    required String id,
    required String email,
    @JsonKey(name: 'display_name') String? displayName,
    @JsonKey(name: 'photo_url') String? photoUrl,
    @JsonKey(name: 'phone_number') String? phoneNumber,
    @JsonKey(name: 'custom_claims') Map<String, dynamic>? customClaims,
    @JsonKey(name: 'created_at') required String createdAt,
    @JsonKey(name: 'last_sign_in_at') String? lastSignInAt,
    @JsonKey(name: 'updated_at') String? updatedAt,
  }) = _SupabaseUserProfileModel;

  const SupabaseUserProfileModel._();

  factory SupabaseUserProfileModel.fromJson(Map<String, dynamic> json) =>
      _$SupabaseUserProfileModelFromJson(json);

  UserProfile toEntity() {
    return UserProfile(
      id: id,
      email: email,
      displayName: displayName,
      photoUrl: photoUrl,
      phoneNumber: phoneNumber,
      customClaims: customClaims,
      createdAt: DateTime.parse(createdAt),
      lastSignInAt: lastSignInAt != null ? DateTime.parse(lastSignInAt!) : null,
      updatedAt: updatedAt != null ? DateTime.parse(updatedAt!) : null,
    );
  }

  factory SupabaseUserProfileModel.fromEntity(UserProfile entity) {
    return SupabaseUserProfileModel(
      id: entity.id,
      email: entity.email,
      displayName: entity.displayName,
      photoUrl: entity.photoUrl,
      phoneNumber: entity.phoneNumber,
      customClaims: entity.customClaims,
      createdAt: entity.createdAt.toIso8601String(),
      lastSignInAt: entity.lastSignInAt?.toIso8601String(),
      updatedAt: entity.updatedAt?.toIso8601String(),
    );
  }

  Map<String, dynamic> toInsert() {
    return {
      'id': id,
      'email': email,
      'display_name': displayName,
      'photo_url': photoUrl,
      'phone_number': phoneNumber,
      'custom_claims': customClaims,
      'created_at': createdAt,
      'last_sign_in_at': lastSignInAt,
      'updated_at': updatedAt,
    };
  }

  Map<String, dynamic> toUpdate() {
    return {
      'display_name': displayName,
      'photo_url': photoUrl,
      'phone_number': phoneNumber,
      'custom_claims': customClaims,
      'updated_at': DateTime.now().toIso8601String(),
    };
  }
}