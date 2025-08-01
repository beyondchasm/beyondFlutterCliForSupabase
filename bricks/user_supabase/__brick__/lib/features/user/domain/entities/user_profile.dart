import 'package:freezed_annotation/freezed_annotation.dart';

part 'freezed/user_profile.freezed.dart';
part 'freezed/user_profile.g.dart';

@freezed
class UserProfile with _$UserProfile {
  const factory UserProfile({
    required String id,
    required String email,
    String? displayName,
    String? photoUrl,
    String? phoneNumber,
    Map<String, dynamic>? customClaims,
    required DateTime createdAt,
    DateTime? lastSignInAt,
    DateTime? updatedAt,
  }) = _UserProfile;

  factory UserProfile.fromJson(Map<String, dynamic> json) =>
      _$UserProfileFromJson(json);
}