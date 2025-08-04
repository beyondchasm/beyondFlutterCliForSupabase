// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'supabase_user_profile_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SupabaseUserProfileModelImpl _$$SupabaseUserProfileModelImplFromJson(
  Map<String, dynamic> json,
) => _$SupabaseUserProfileModelImpl(
  id: json['id'] as String,
  email: json['email'] as String,
  displayName: json['display_name'] as String?,
  photoUrl: json['photo_url'] as String?,
  phoneNumber: json['phone_number'] as String?,
  customClaims: json['custom_claims'] as Map<String, dynamic>?,
  createdAt: json['created_at'] as String,
  lastSignInAt: json['last_sign_in_at'] as String?,
  updatedAt: json['updated_at'] as String?,
);

Map<String, dynamic> _$$SupabaseUserProfileModelImplToJson(
  _$SupabaseUserProfileModelImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'email': instance.email,
  'display_name': instance.displayName,
  'photo_url': instance.photoUrl,
  'phone_number': instance.phoneNumber,
  'custom_claims': instance.customClaims,
  'created_at': instance.createdAt,
  'last_sign_in_at': instance.lastSignInAt,
  'updated_at': instance.updatedAt,
};
