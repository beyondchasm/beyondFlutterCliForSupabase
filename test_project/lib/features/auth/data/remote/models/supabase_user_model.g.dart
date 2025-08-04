// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'supabase_user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SupabaseUserModelImpl _$$SupabaseUserModelImplFromJson(
  Map<String, dynamic> json,
) => _$SupabaseUserModelImpl(
  id: json['id'] as String,
  email: json['email'] as String,
  phone: json['phone'] as String?,
  userMetadata: json['userMetadata'] as Map<String, dynamic>?,
  emailConfirmed: json['emailConfirmed'] as bool,
  createdAt: DateTime.parse(json['createdAt'] as String),
  lastSignInAt: json['lastSignInAt'] == null
      ? null
      : DateTime.parse(json['lastSignInAt'] as String),
);

Map<String, dynamic> _$$SupabaseUserModelImplToJson(
  _$SupabaseUserModelImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'email': instance.email,
  'phone': instance.phone,
  'userMetadata': instance.userMetadata,
  'emailConfirmed': instance.emailConfirmed,
  'createdAt': instance.createdAt.toIso8601String(),
  'lastSignInAt': instance.lastSignInAt?.toIso8601String(),
};
