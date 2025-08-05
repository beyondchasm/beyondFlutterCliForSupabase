import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../domain/entities/user_profile.dart';

part 'supabase_user_profile_model.freezed.dart';
part 'supabase_user_profile_model.g.dart';

@freezed
class SupabaseUserProfileModel with _$SupabaseUserProfileModel {
  const factory SupabaseUserProfileModel({
    required String id,
    required String email,
    @JsonKey(name: 'display_name') String? displayName,
    @JsonKey(name: 'first_name') String? firstName,
    @JsonKey(name: 'last_name') String? lastName,
    @JsonKey(name: 'photo_url') String? photoUrl,
    @JsonKey(name: 'phone_number') String? phoneNumber,
    String? bio,
    String? website,
    String? location,
    @JsonKey(name: 'date_of_birth') String? dateOfBirth,
    @JsonKey(name: 'gender') String? gender,
    @JsonKey(name: 'is_email_verified') @Default(false) bool isEmailVerified,
    @JsonKey(name: 'is_phone_verified') @Default(false) bool isPhoneVerified,
    @JsonKey(name: 'privacy_level') @Default('public') String privacyLevel,
    @Default([]) List<String> interests,
    @Default({}) Map<String, dynamic> preferences,
    @JsonKey(name: 'social_links') @Default({}) Map<String, dynamic> socialLinks,
    @JsonKey(name: 'custom_claims') Map<String, dynamic>? customClaims,
    @JsonKey(name: 'created_at') required String createdAt,
    @JsonKey(name: 'last_sign_in_at') String? lastSignInAt,
    @JsonKey(name: 'updated_at') String? updatedAt,
    @Default('active') String status,
  }) = _SupabaseUserProfileModel;

  const SupabaseUserProfileModel._();

  factory SupabaseUserProfileModel.fromJson(Map<String, dynamic> json) =>
      _$SupabaseUserProfileModelFromJson(json);

  UserProfile toEntity() {
    return UserProfile(
      id: id,
      email: email,
      displayName: displayName,
      firstName: firstName,
      lastName: lastName,
      photoUrl: photoUrl,
      phoneNumber: phoneNumber,
      bio: bio,
      website: website,
      location: location,
      dateOfBirth: dateOfBirth != null ? DateTime.parse(dateOfBirth!) : null,
      gender: _parseGender(gender),
      isEmailVerified: isEmailVerified,
      isPhoneVerified: isPhoneVerified,
      privacyLevel: _parsePrivacyLevel(privacyLevel),
      interests: interests,
      preferences: preferences,
      socialLinks: socialLinks,
      customClaims: customClaims,
      createdAt: DateTime.parse(createdAt),
      lastSignInAt: lastSignInAt != null ? DateTime.parse(lastSignInAt!) : null,
      updatedAt: updatedAt != null ? DateTime.parse(updatedAt!) : null,
      status: _parseStatus(status),
    );
  }

  factory SupabaseUserProfileModel.fromEntity(UserProfile entity) {
    return SupabaseUserProfileModel(
      id: entity.id,
      email: entity.email,
      displayName: entity.displayName,
      firstName: entity.firstName,
      lastName: entity.lastName,
      photoUrl: entity.photoUrl,
      phoneNumber: entity.phoneNumber,
      bio: entity.bio,
      website: entity.website,
      location: entity.location,
      dateOfBirth: entity.dateOfBirth?.toIso8601String(),
      gender: entity.gender.name,
      isEmailVerified: entity.isEmailVerified,
      isPhoneVerified: entity.isPhoneVerified,
      privacyLevel: entity.privacyLevel.name,
      interests: entity.interests,
      preferences: entity.preferences,
      socialLinks: entity.socialLinks,
      customClaims: entity.customClaims,
      createdAt: entity.createdAt.toIso8601String(),
      lastSignInAt: entity.lastSignInAt?.toIso8601String(),
      updatedAt: entity.updatedAt?.toIso8601String(),
      status: entity.status.name,
    );
  }

  Map<String, dynamic> toInsert() {
    return {
      'id': id,
      'email': email,
      'display_name': displayName,
      'first_name': firstName,
      'last_name': lastName,
      'photo_url': photoUrl,
      'phone_number': phoneNumber,
      'bio': bio,
      'website': website,
      'location': location,
      'date_of_birth': dateOfBirth,
      'gender': gender,
      'is_email_verified': isEmailVerified,
      'is_phone_verified': isPhoneVerified,
      'privacy_level': privacyLevel,
      'interests': interests,
      'preferences': preferences,
      'social_links': socialLinks,
      'custom_claims': customClaims,
      'created_at': createdAt,
      'last_sign_in_at': lastSignInAt,
      'updated_at': updatedAt,
      'status': status,
    };
  }

  Map<String, dynamic> toUpdate() {
    return {
      'display_name': displayName,
      'first_name': firstName,
      'last_name': lastName,
      'photo_url': photoUrl,
      'phone_number': phoneNumber,
      'bio': bio,
      'website': website,
      'location': location,
      'date_of_birth': dateOfBirth,
      'gender': gender,
      'is_email_verified': isEmailVerified,
      'is_phone_verified': isPhoneVerified,
      'privacy_level': privacyLevel,
      'interests': interests,
      'preferences': preferences,
      'social_links': socialLinks,
      'custom_claims': customClaims,
      'updated_at': DateTime.now().toIso8601String(),
      'status': status,
    };
  }

  UserGender _parseGender(String? gender) {
    switch (gender) {
      case 'male':
        return UserGender.male;
      case 'female':
        return UserGender.female;
      case 'nonBinary':
        return UserGender.nonBinary;
      default:
        return UserGender.notSpecified;
    }
  }

  UserPrivacyLevel _parsePrivacyLevel(String privacyLevel) {
    switch (privacyLevel) {
      case 'friendsOnly':
        return UserPrivacyLevel.friendsOnly;
      case 'private':
        return UserPrivacyLevel.private;
      default:
        return UserPrivacyLevel.public;
    }
  }

  UserStatus _parseStatus(String status) {
    switch (status) {
      case 'inactive':
        return UserStatus.inactive;
      case 'suspended':
        return UserStatus.suspended;
      case 'deleted':
        return UserStatus.deleted;
      default:
        return UserStatus.active;
    }
  }
}