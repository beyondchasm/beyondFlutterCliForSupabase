// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'supabase_user_profile_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

SupabaseUserProfileModel _$SupabaseUserProfileModelFromJson(
  Map<String, dynamic> json,
) {
  return _SupabaseUserProfileModel.fromJson(json);
}

/// @nodoc
mixin _$SupabaseUserProfileModel {
  String get id => throw _privateConstructorUsedError;
  String get email => throw _privateConstructorUsedError;
  @JsonKey(name: 'display_name')
  String? get displayName => throw _privateConstructorUsedError;
  @JsonKey(name: 'photo_url')
  String? get photoUrl => throw _privateConstructorUsedError;
  @JsonKey(name: 'phone_number')
  String? get phoneNumber => throw _privateConstructorUsedError;
  @JsonKey(name: 'custom_claims')
  Map<String, dynamic>? get customClaims => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  String get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'last_sign_in_at')
  String? get lastSignInAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'updated_at')
  String? get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this SupabaseUserProfileModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SupabaseUserProfileModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SupabaseUserProfileModelCopyWith<SupabaseUserProfileModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SupabaseUserProfileModelCopyWith<$Res> {
  factory $SupabaseUserProfileModelCopyWith(
    SupabaseUserProfileModel value,
    $Res Function(SupabaseUserProfileModel) then,
  ) = _$SupabaseUserProfileModelCopyWithImpl<$Res, SupabaseUserProfileModel>;
  @useResult
  $Res call({
    String id,
    String email,
    @JsonKey(name: 'display_name') String? displayName,
    @JsonKey(name: 'photo_url') String? photoUrl,
    @JsonKey(name: 'phone_number') String? phoneNumber,
    @JsonKey(name: 'custom_claims') Map<String, dynamic>? customClaims,
    @JsonKey(name: 'created_at') String createdAt,
    @JsonKey(name: 'last_sign_in_at') String? lastSignInAt,
    @JsonKey(name: 'updated_at') String? updatedAt,
  });
}

/// @nodoc
class _$SupabaseUserProfileModelCopyWithImpl<
  $Res,
  $Val extends SupabaseUserProfileModel
>
    implements $SupabaseUserProfileModelCopyWith<$Res> {
  _$SupabaseUserProfileModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SupabaseUserProfileModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? email = null,
    Object? displayName = freezed,
    Object? photoUrl = freezed,
    Object? phoneNumber = freezed,
    Object? customClaims = freezed,
    Object? createdAt = null,
    Object? lastSignInAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            email: null == email
                ? _value.email
                : email // ignore: cast_nullable_to_non_nullable
                      as String,
            displayName: freezed == displayName
                ? _value.displayName
                : displayName // ignore: cast_nullable_to_non_nullable
                      as String?,
            photoUrl: freezed == photoUrl
                ? _value.photoUrl
                : photoUrl // ignore: cast_nullable_to_non_nullable
                      as String?,
            phoneNumber: freezed == phoneNumber
                ? _value.phoneNumber
                : phoneNumber // ignore: cast_nullable_to_non_nullable
                      as String?,
            customClaims: freezed == customClaims
                ? _value.customClaims
                : customClaims // ignore: cast_nullable_to_non_nullable
                      as Map<String, dynamic>?,
            createdAt: null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as String,
            lastSignInAt: freezed == lastSignInAt
                ? _value.lastSignInAt
                : lastSignInAt // ignore: cast_nullable_to_non_nullable
                      as String?,
            updatedAt: freezed == updatedAt
                ? _value.updatedAt
                : updatedAt // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$SupabaseUserProfileModelImplCopyWith<$Res>
    implements $SupabaseUserProfileModelCopyWith<$Res> {
  factory _$$SupabaseUserProfileModelImplCopyWith(
    _$SupabaseUserProfileModelImpl value,
    $Res Function(_$SupabaseUserProfileModelImpl) then,
  ) = __$$SupabaseUserProfileModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String email,
    @JsonKey(name: 'display_name') String? displayName,
    @JsonKey(name: 'photo_url') String? photoUrl,
    @JsonKey(name: 'phone_number') String? phoneNumber,
    @JsonKey(name: 'custom_claims') Map<String, dynamic>? customClaims,
    @JsonKey(name: 'created_at') String createdAt,
    @JsonKey(name: 'last_sign_in_at') String? lastSignInAt,
    @JsonKey(name: 'updated_at') String? updatedAt,
  });
}

/// @nodoc
class __$$SupabaseUserProfileModelImplCopyWithImpl<$Res>
    extends
        _$SupabaseUserProfileModelCopyWithImpl<
          $Res,
          _$SupabaseUserProfileModelImpl
        >
    implements _$$SupabaseUserProfileModelImplCopyWith<$Res> {
  __$$SupabaseUserProfileModelImplCopyWithImpl(
    _$SupabaseUserProfileModelImpl _value,
    $Res Function(_$SupabaseUserProfileModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of SupabaseUserProfileModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? email = null,
    Object? displayName = freezed,
    Object? photoUrl = freezed,
    Object? phoneNumber = freezed,
    Object? customClaims = freezed,
    Object? createdAt = null,
    Object? lastSignInAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(
      _$SupabaseUserProfileModelImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        email: null == email
            ? _value.email
            : email // ignore: cast_nullable_to_non_nullable
                  as String,
        displayName: freezed == displayName
            ? _value.displayName
            : displayName // ignore: cast_nullable_to_non_nullable
                  as String?,
        photoUrl: freezed == photoUrl
            ? _value.photoUrl
            : photoUrl // ignore: cast_nullable_to_non_nullable
                  as String?,
        phoneNumber: freezed == phoneNumber
            ? _value.phoneNumber
            : phoneNumber // ignore: cast_nullable_to_non_nullable
                  as String?,
        customClaims: freezed == customClaims
            ? _value._customClaims
            : customClaims // ignore: cast_nullable_to_non_nullable
                  as Map<String, dynamic>?,
        createdAt: null == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as String,
        lastSignInAt: freezed == lastSignInAt
            ? _value.lastSignInAt
            : lastSignInAt // ignore: cast_nullable_to_non_nullable
                  as String?,
        updatedAt: freezed == updatedAt
            ? _value.updatedAt
            : updatedAt // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$SupabaseUserProfileModelImpl extends _SupabaseUserProfileModel {
  const _$SupabaseUserProfileModelImpl({
    required this.id,
    required this.email,
    @JsonKey(name: 'display_name') this.displayName,
    @JsonKey(name: 'photo_url') this.photoUrl,
    @JsonKey(name: 'phone_number') this.phoneNumber,
    @JsonKey(name: 'custom_claims') final Map<String, dynamic>? customClaims,
    @JsonKey(name: 'created_at') required this.createdAt,
    @JsonKey(name: 'last_sign_in_at') this.lastSignInAt,
    @JsonKey(name: 'updated_at') this.updatedAt,
  }) : _customClaims = customClaims,
       super._();

  factory _$SupabaseUserProfileModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$SupabaseUserProfileModelImplFromJson(json);

  @override
  final String id;
  @override
  final String email;
  @override
  @JsonKey(name: 'display_name')
  final String? displayName;
  @override
  @JsonKey(name: 'photo_url')
  final String? photoUrl;
  @override
  @JsonKey(name: 'phone_number')
  final String? phoneNumber;
  final Map<String, dynamic>? _customClaims;
  @override
  @JsonKey(name: 'custom_claims')
  Map<String, dynamic>? get customClaims {
    final value = _customClaims;
    if (value == null) return null;
    if (_customClaims is EqualUnmodifiableMapView) return _customClaims;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  @JsonKey(name: 'created_at')
  final String createdAt;
  @override
  @JsonKey(name: 'last_sign_in_at')
  final String? lastSignInAt;
  @override
  @JsonKey(name: 'updated_at')
  final String? updatedAt;

  @override
  String toString() {
    return 'SupabaseUserProfileModel(id: $id, email: $email, displayName: $displayName, photoUrl: $photoUrl, phoneNumber: $phoneNumber, customClaims: $customClaims, createdAt: $createdAt, lastSignInAt: $lastSignInAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SupabaseUserProfileModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.displayName, displayName) ||
                other.displayName == displayName) &&
            (identical(other.photoUrl, photoUrl) ||
                other.photoUrl == photoUrl) &&
            (identical(other.phoneNumber, phoneNumber) ||
                other.phoneNumber == phoneNumber) &&
            const DeepCollectionEquality().equals(
              other._customClaims,
              _customClaims,
            ) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.lastSignInAt, lastSignInAt) ||
                other.lastSignInAt == lastSignInAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    email,
    displayName,
    photoUrl,
    phoneNumber,
    const DeepCollectionEquality().hash(_customClaims),
    createdAt,
    lastSignInAt,
    updatedAt,
  );

  /// Create a copy of SupabaseUserProfileModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SupabaseUserProfileModelImplCopyWith<_$SupabaseUserProfileModelImpl>
  get copyWith =>
      __$$SupabaseUserProfileModelImplCopyWithImpl<
        _$SupabaseUserProfileModelImpl
      >(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SupabaseUserProfileModelImplToJson(this);
  }
}

abstract class _SupabaseUserProfileModel extends SupabaseUserProfileModel {
  const factory _SupabaseUserProfileModel({
    required final String id,
    required final String email,
    @JsonKey(name: 'display_name') final String? displayName,
    @JsonKey(name: 'photo_url') final String? photoUrl,
    @JsonKey(name: 'phone_number') final String? phoneNumber,
    @JsonKey(name: 'custom_claims') final Map<String, dynamic>? customClaims,
    @JsonKey(name: 'created_at') required final String createdAt,
    @JsonKey(name: 'last_sign_in_at') final String? lastSignInAt,
    @JsonKey(name: 'updated_at') final String? updatedAt,
  }) = _$SupabaseUserProfileModelImpl;
  const _SupabaseUserProfileModel._() : super._();

  factory _SupabaseUserProfileModel.fromJson(Map<String, dynamic> json) =
      _$SupabaseUserProfileModelImpl.fromJson;

  @override
  String get id;
  @override
  String get email;
  @override
  @JsonKey(name: 'display_name')
  String? get displayName;
  @override
  @JsonKey(name: 'photo_url')
  String? get photoUrl;
  @override
  @JsonKey(name: 'phone_number')
  String? get phoneNumber;
  @override
  @JsonKey(name: 'custom_claims')
  Map<String, dynamic>? get customClaims;
  @override
  @JsonKey(name: 'created_at')
  String get createdAt;
  @override
  @JsonKey(name: 'last_sign_in_at')
  String? get lastSignInAt;
  @override
  @JsonKey(name: 'updated_at')
  String? get updatedAt;

  /// Create a copy of SupabaseUserProfileModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SupabaseUserProfileModelImplCopyWith<_$SupabaseUserProfileModelImpl>
  get copyWith => throw _privateConstructorUsedError;
}
