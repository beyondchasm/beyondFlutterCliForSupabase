// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'password.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$Password {
  String get value => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $PasswordCopyWith<Password> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PasswordCopyWith<$Res> {
  factory $PasswordCopyWith(Password value, $Res Function(Password) then) =
      _$PasswordCopyWithImpl<$Res, Password>;
  @useResult
  $Res call({String value});
}

/// @nodoc
class _$PasswordCopyWithImpl<$Res, $Val extends Password>
    implements $PasswordCopyWith<$Res> {
  _$PasswordCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? value = null,
  }) {
    return _then(_value.copyWith(
      value: null == value
          ? _value.value
          : value // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_PasswordCopyWith<$Res> implements $PasswordCopyWith<$Res> {
  factory _$$_PasswordCopyWith(
          _$_Password value, $Res Function(_$_Password) then) =
      __$$_PasswordCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String value});
}

/// @nodoc
class __$$_PasswordCopyWithImpl<$Res>
    extends _$PasswordCopyWithImpl<$Res, _$_Password>
    implements _$$_PasswordCopyWith<$Res> {
  __$$_PasswordCopyWithImpl(
      _$_Password _value, $Res Function(_$_Password) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? value = null,
  }) {
    return _then(_$_Password(
      null == value
          ? _value.value
          : value // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$_Password implements _Password {
  const _$_Password(this.value);

  @override
  final String value;


  @override
  String toString() {
    return 'Password._(value: $value)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_Password &&
            (identical(other.value, value) || other.value == value));
  }

  @override
  int get hashCode => Object.hash(runtimeType, value);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_PasswordCopyWith<_$_Password> get copyWith =>
      __$$_PasswordCopyWithImpl<_$_Password>(this, _$identity);
}

abstract class _Password implements Password {
  const factory _Password(final String value) = _$_Password;

  @override
  String get value;
  @override
  @JsonKey(ignore: true)
  _$$_PasswordCopyWith<_$_Password> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$PasswordValidationException {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() empty,
    required TResult Function() tooShort,
    required TResult Function() tooLong,
    required TResult Function() noUpperCase,
    required TResult Function() noLowerCase,
    required TResult Function() noDigit,
    required TResult Function() noSpecialChar,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? empty,
    TResult? Function()? tooShort,
    TResult? Function()? tooLong,
    TResult? Function()? noUpperCase,
    TResult? Function()? noLowerCase,
    TResult? Function()? noDigit,
    TResult? Function()? noSpecialChar,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? empty,
    TResult Function()? tooShort,
    TResult Function()? tooLong,
    TResult Function()? noUpperCase,
    TResult Function()? noLowerCase,
    TResult Function()? noDigit,
    TResult Function()? noSpecialChar,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_PasswordEmpty value) empty,
    required TResult Function(_PasswordTooShort value) tooShort,
    required TResult Function(_PasswordTooLong value) tooLong,
    required TResult Function(_PasswordNoUpperCase value) noUpperCase,
    required TResult Function(_PasswordNoLowerCase value) noLowerCase,
    required TResult Function(_PasswordNoDigit value) noDigit,
    required TResult Function(_PasswordNoSpecialChar value) noSpecialChar,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_PasswordEmpty value)? empty,
    TResult? Function(_PasswordTooShort value)? tooShort,
    TResult? Function(_PasswordTooLong value)? tooLong,
    TResult? Function(_PasswordNoUpperCase value)? noUpperCase,
    TResult? Function(_PasswordNoLowerCase value)? noLowerCase,
    TResult? Function(_PasswordNoDigit value)? noDigit,
    TResult? Function(_PasswordNoSpecialChar value)? noSpecialChar,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_PasswordEmpty value)? empty,
    TResult Function(_PasswordTooShort value)? tooShort,
    TResult Function(_PasswordTooLong value)? tooLong,
    TResult Function(_PasswordNoUpperCase value)? noUpperCase,
    TResult Function(_PasswordNoLowerCase value)? noLowerCase,
    TResult Function(_PasswordNoDigit value)? noDigit,
    TResult Function(_PasswordNoSpecialChar value)? noSpecialChar,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PasswordValidationExceptionCopyWith<$Res> {
  factory $PasswordValidationExceptionCopyWith(
          PasswordValidationException value,
          $Res Function(PasswordValidationException) then) =
      _$PasswordValidationExceptionCopyWithImpl<$Res,
          PasswordValidationException>;
}

/// @nodoc
class _$PasswordValidationExceptionCopyWithImpl<$Res,
        $Val extends PasswordValidationException>
    implements $PasswordValidationExceptionCopyWith<$Res> {
  _$PasswordValidationExceptionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;
}

/// @nodoc
abstract class _$$_PasswordEmptyCopyWith<$Res> {
  factory _$$_PasswordEmptyCopyWith(
          _$_PasswordEmpty value, $Res Function(_$_PasswordEmpty) then) =
      __$$_PasswordEmptyCopyWithImpl<$Res>;
}

/// @nodoc
class __$$_PasswordEmptyCopyWithImpl<$Res>
    extends _$PasswordValidationExceptionCopyWithImpl<$Res, _$_PasswordEmpty>
    implements _$$_PasswordEmptyCopyWith<$Res> {
  __$$_PasswordEmptyCopyWithImpl(
      _$_PasswordEmpty _value, $Res Function(_$_PasswordEmpty) _then)
      : super(_value, _then);
}

/// @nodoc

class _$_PasswordEmpty implements _PasswordEmpty {
  const _$_PasswordEmpty();

  @override
  String toString() {
    return 'PasswordValidationException.empty()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$_PasswordEmpty);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() empty,
    required TResult Function() tooShort,
    required TResult Function() tooLong,
    required TResult Function() noUpperCase,
    required TResult Function() noLowerCase,
    required TResult Function() noDigit,
    required TResult Function() noSpecialChar,
  }) {
    return empty();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? empty,
    TResult? Function()? tooShort,
    TResult? Function()? tooLong,
    TResult? Function()? noUpperCase,
    TResult? Function()? noLowerCase,
    TResult? Function()? noDigit,
    TResult? Function()? noSpecialChar,
  }) {
    return empty?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? empty,
    TResult Function()? tooShort,
    TResult Function()? tooLong,
    TResult Function()? noUpperCase,
    TResult Function()? noLowerCase,
    TResult Function()? noDigit,
    TResult Function()? noSpecialChar,
    required TResult orElse(),
  }) {
    if (empty != null) {
      return empty();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_PasswordEmpty value) empty,
    required TResult Function(_PasswordTooShort value) tooShort,
    required TResult Function(_PasswordTooLong value) tooLong,
    required TResult Function(_PasswordNoUpperCase value) noUpperCase,
    required TResult Function(_PasswordNoLowerCase value) noLowerCase,
    required TResult Function(_PasswordNoDigit value) noDigit,
    required TResult Function(_PasswordNoSpecialChar value) noSpecialChar,
  }) {
    return empty(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_PasswordEmpty value)? empty,
    TResult? Function(_PasswordTooShort value)? tooShort,
    TResult? Function(_PasswordTooLong value)? tooLong,
    TResult? Function(_PasswordNoUpperCase value)? noUpperCase,
    TResult? Function(_PasswordNoLowerCase value)? noLowerCase,
    TResult? Function(_PasswordNoDigit value)? noDigit,
    TResult? Function(_PasswordNoSpecialChar value)? noSpecialChar,
  }) {
    return empty?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_PasswordEmpty value)? empty,
    TResult Function(_PasswordTooShort value)? tooShort,
    TResult Function(_PasswordTooLong value)? tooLong,
    TResult Function(_PasswordNoUpperCase value)? noUpperCase,
    TResult Function(_PasswordNoLowerCase value)? noLowerCase,
    TResult Function(_PasswordNoDigit value)? noDigit,
    TResult Function(_PasswordNoSpecialChar value)? noSpecialChar,
    required TResult orElse(),
  }) {
    if (empty != null) {
      return empty(this);
    }
    return orElse();
  }
}

abstract class _PasswordEmpty implements PasswordValidationException {
  const factory _PasswordEmpty() = _$_PasswordEmpty;
}

/// @nodoc
abstract class _$$_PasswordTooShortCopyWith<$Res> {
  factory _$$_PasswordTooShortCopyWith(
          _$_PasswordTooShort value, $Res Function(_$_PasswordTooShort) then) =
      __$$_PasswordTooShortCopyWithImpl<$Res>;
}

/// @nodoc
class __$$_PasswordTooShortCopyWithImpl<$Res>
    extends _$PasswordValidationExceptionCopyWithImpl<$Res,
        _$_PasswordTooShort>
    implements _$$_PasswordTooShortCopyWith<$Res> {
  __$$_PasswordTooShortCopyWithImpl(
      _$_PasswordTooShort _value, $Res Function(_$_PasswordTooShort) _then)
      : super(_value, _then);
}

/// @nodoc

class _$_PasswordTooShort implements _PasswordTooShort {
  const _$_PasswordTooShort();

  @override
  String toString() {
    return 'PasswordValidationException.tooShort()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$_PasswordTooShort);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() empty,
    required TResult Function() tooShort,
    required TResult Function() tooLong,
    required TResult Function() noUpperCase,
    required TResult Function() noLowerCase,
    required TResult Function() noDigit,
    required TResult Function() noSpecialChar,
  }) {
    return tooShort();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? empty,
    TResult? Function()? tooShort,
    TResult? Function()? tooLong,
    TResult? Function()? noUpperCase,
    TResult? Function()? noLowerCase,
    TResult? Function()? noDigit,
    TResult? Function()? noSpecialChar,
  }) {
    return tooShort?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? empty,
    TResult Function()? tooShort,
    TResult Function()? tooLong,
    TResult Function()? noUpperCase,
    TResult Function()? noLowerCase,
    TResult Function()? noDigit,
    TResult Function()? noSpecialChar,
    required TResult orElse(),
  }) {
    if (tooShort != null) {
      return tooShort();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_PasswordEmpty value) empty,
    required TResult Function(_PasswordTooShort value) tooShort,
    required TResult Function(_PasswordTooLong value) tooLong,
    required TResult Function(_PasswordNoUpperCase value) noUpperCase,
    required TResult Function(_PasswordNoLowerCase value) noLowerCase,
    required TResult Function(_PasswordNoDigit value) noDigit,
    required TResult Function(_PasswordNoSpecialChar value) noSpecialChar,
  }) {
    return tooShort(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_PasswordEmpty value)? empty,
    TResult? Function(_PasswordTooShort value)? tooShort,
    TResult? Function(_PasswordTooLong value)? tooLong,
    TResult? Function(_PasswordNoUpperCase value)? noUpperCase,
    TResult? Function(_PasswordNoLowerCase value)? noLowerCase,
    TResult? Function(_PasswordNoDigit value)? noDigit,
    TResult? Function(_PasswordNoSpecialChar value)? noSpecialChar,
  }) {
    return tooShort?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_PasswordEmpty value)? empty,
    TResult Function(_PasswordTooShort value)? tooShort,
    TResult Function(_PasswordTooLong value)? tooLong,
    TResult Function(_PasswordNoUpperCase value)? noUpperCase,
    TResult Function(_PasswordNoLowerCase value)? noLowerCase,
    TResult Function(_PasswordNoDigit value)? noDigit,
    TResult Function(_PasswordNoSpecialChar value)? noSpecialChar,
    required TResult orElse(),
  }) {
    if (tooShort != null) {
      return tooShort(this);
    }
    return orElse();
  }
}

abstract class _PasswordTooShort implements PasswordValidationException {
  const factory _PasswordTooShort() = _$_PasswordTooShort;
}

/// @nodoc
abstract class _$$_PasswordTooLongCopyWith<$Res> {
  factory _$$_PasswordTooLongCopyWith(
          _$_PasswordTooLong value, $Res Function(_$_PasswordTooLong) then) =
      __$$_PasswordTooLongCopyWithImpl<$Res>;
}

/// @nodoc
class __$$_PasswordTooLongCopyWithImpl<$Res>
    extends _$PasswordValidationExceptionCopyWithImpl<$Res, _$_PasswordTooLong>
    implements _$$_PasswordTooLongCopyWith<$Res> {
  __$$_PasswordTooLongCopyWithImpl(
      _$_PasswordTooLong _value, $Res Function(_$_PasswordTooLong) _then)
      : super(_value, _then);
}

/// @nodoc

class _$_PasswordTooLong implements _PasswordTooLong {
  const _$_PasswordTooLong();

  @override
  String toString() {
    return 'PasswordValidationException.tooLong()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$_PasswordTooLong);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() empty,
    required TResult Function() tooShort,
    required TResult Function() tooLong,
    required TResult Function() noUpperCase,
    required TResult Function() noLowerCase,
    required TResult Function() noDigit,
    required TResult Function() noSpecialChar,
  }) {
    return tooLong();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? empty,
    TResult? Function()? tooShort,
    TResult? Function()? tooLong,
    TResult? Function()? noUpperCase,
    TResult? Function()? noLowerCase,
    TResult? Function()? noDigit,
    TResult? Function()? noSpecialChar,
  }) {
    return tooLong?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? empty,
    TResult Function()? tooShort,
    TResult Function()? tooLong,
    TResult Function()? noUpperCase,
    TResult Function()? noLowerCase,
    TResult Function()? noDigit,
    TResult Function()? noSpecialChar,
    required TResult orElse(),
  }) {
    if (tooLong != null) {
      return tooLong();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_PasswordEmpty value) empty,
    required TResult Function(_PasswordTooShort value) tooShort,
    required TResult Function(_PasswordTooLong value) tooLong,
    required TResult Function(_PasswordNoUpperCase value) noUpperCase,
    required TResult Function(_PasswordNoLowerCase value) noLowerCase,
    required TResult Function(_PasswordNoDigit value) noDigit,
    required TResult Function(_PasswordNoSpecialChar value) noSpecialChar,
  }) {
    return tooLong(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_PasswordEmpty value)? empty,
    TResult? Function(_PasswordTooShort value)? tooShort,
    TResult? Function(_PasswordTooLong value)? tooLong,
    TResult? Function(_PasswordNoUpperCase value)? noUpperCase,
    TResult? Function(_PasswordNoLowerCase value)? noLowerCase,
    TResult? Function(_PasswordNoDigit value)? noDigit,
    TResult? Function(_PasswordNoSpecialChar value)? noSpecialChar,
  }) {
    return tooLong?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_PasswordEmpty value)? empty,
    TResult Function(_PasswordTooShort value)? tooShort,
    TResult Function(_PasswordTooLong value)? tooLong,
    TResult Function(_PasswordNoUpperCase value)? noUpperCase,
    TResult Function(_PasswordNoLowerCase value)? noLowerCase,
    TResult Function(_PasswordNoDigit value)? noDigit,
    TResult Function(_PasswordNoSpecialChar value)? noSpecialChar,
    required TResult orElse(),
  }) {
    if (tooLong != null) {
      return tooLong(this);
    }
    return orElse();
  }
}

abstract class _PasswordTooLong implements PasswordValidationException {
  const factory _PasswordTooLong() = _$_PasswordTooLong;
}

/// @nodoc
abstract class _$$_PasswordNoUpperCaseCopyWith<$Res> {
  factory _$$_PasswordNoUpperCaseCopyWith(_$_PasswordNoUpperCase value,
          $Res Function(_$_PasswordNoUpperCase) then) =
      __$$_PasswordNoUpperCaseCopyWithImpl<$Res>;
}

/// @nodoc
class __$$_PasswordNoUpperCaseCopyWithImpl<$Res>
    extends _$PasswordValidationExceptionCopyWithImpl<$Res,
        _$_PasswordNoUpperCase>
    implements _$$_PasswordNoUpperCaseCopyWith<$Res> {
  __$$_PasswordNoUpperCaseCopyWithImpl(_$_PasswordNoUpperCase _value,
      $Res Function(_$_PasswordNoUpperCase) _then)
      : super(_value, _then);
}

/// @nodoc

class _$_PasswordNoUpperCase implements _PasswordNoUpperCase {
  const _$_PasswordNoUpperCase();

  @override
  String toString() {
    return 'PasswordValidationException.noUpperCase()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$_PasswordNoUpperCase);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() empty,
    required TResult Function() tooShort,
    required TResult Function() tooLong,
    required TResult Function() noUpperCase,
    required TResult Function() noLowerCase,
    required TResult Function() noDigit,
    required TResult Function() noSpecialChar,
  }) {
    return noUpperCase();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? empty,
    TResult? Function()? tooShort,
    TResult? Function()? tooLong,
    TResult? Function()? noUpperCase,
    TResult? Function()? noLowerCase,
    TResult? Function()? noDigit,
    TResult? Function()? noSpecialChar,
  }) {
    return noUpperCase?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? empty,
    TResult Function()? tooShort,
    TResult Function()? tooLong,
    TResult Function()? noUpperCase,
    TResult Function()? noLowerCase,
    TResult Function()? noDigit,
    TResult Function()? noSpecialChar,
    required TResult orElse(),
  }) {
    if (noUpperCase != null) {
      return noUpperCase();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_PasswordEmpty value) empty,
    required TResult Function(_PasswordTooShort value) tooShort,
    required TResult Function(_PasswordTooLong value) tooLong,
    required TResult Function(_PasswordNoUpperCase value) noUpperCase,
    required TResult Function(_PasswordNoLowerCase value) noLowerCase,
    required TResult Function(_PasswordNoDigit value) noDigit,
    required TResult Function(_PasswordNoSpecialChar value) noSpecialChar,
  }) {
    return noUpperCase(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_PasswordEmpty value)? empty,
    TResult? Function(_PasswordTooShort value)? tooShort,
    TResult? Function(_PasswordTooLong value)? tooLong,
    TResult? Function(_PasswordNoUpperCase value)? noUpperCase,
    TResult? Function(_PasswordNoLowerCase value)? noLowerCase,
    TResult? Function(_PasswordNoDigit value)? noDigit,
    TResult? Function(_PasswordNoSpecialChar value)? noSpecialChar,
  }) {
    return noUpperCase?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_PasswordEmpty value)? empty,
    TResult Function(_PasswordTooShort value)? tooShort,
    TResult Function(_PasswordTooLong value)? tooLong,
    TResult Function(_PasswordNoUpperCase value)? noUpperCase,
    TResult Function(_PasswordNoLowerCase value)? noLowerCase,
    TResult Function(_PasswordNoDigit value)? noDigit,
    TResult Function(_PasswordNoSpecialChar value)? noSpecialChar,
    required TResult orElse(),
  }) {
    if (noUpperCase != null) {
      return noUpperCase(this);
    }
    return orElse();
  }
}

abstract class _PasswordNoUpperCase implements PasswordValidationException {
  const factory _PasswordNoUpperCase() = _$_PasswordNoUpperCase;
}

/// @nodoc
abstract class _$$_PasswordNoLowerCaseCopyWith<$Res> {
  factory _$$_PasswordNoLowerCaseCopyWith(_$_PasswordNoLowerCase value,
          $Res Function(_$_PasswordNoLowerCase) then) =
      __$$_PasswordNoLowerCaseCopyWithImpl<$Res>;
}

/// @nodoc
class __$$_PasswordNoLowerCaseCopyWithImpl<$Res>
    extends _$PasswordValidationExceptionCopyWithImpl<$Res,
        _$_PasswordNoLowerCase>
    implements _$$_PasswordNoLowerCaseCopyWith<$Res> {
  __$$_PasswordNoLowerCaseCopyWithImpl(_$_PasswordNoLowerCase _value,
      $Res Function(_$_PasswordNoLowerCase) _then)
      : super(_value, _then);
}

/// @nodoc

class _$_PasswordNoLowerCase implements _PasswordNoLowerCase {
  const _$_PasswordNoLowerCase();

  @override
  String toString() {
    return 'PasswordValidationException.noLowerCase()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$_PasswordNoLowerCase);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() empty,
    required TResult Function() tooShort,
    required TResult Function() tooLong,
    required TResult Function() noUpperCase,
    required TResult Function() noLowerCase,
    required TResult Function() noDigit,
    required TResult Function() noSpecialChar,
  }) {
    return noLowerCase();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? empty,
    TResult? Function()? tooShort,
    TResult? Function()? tooLong,
    TResult? Function()? noUpperCase,
    TResult? Function()? noLowerCase,
    TResult? Function()? noDigit,
    TResult? Function()? noSpecialChar,
  }) {
    return noLowerCase?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? empty,
    TResult Function()? tooShort,
    TResult Function()? tooLong,
    TResult Function()? noUpperCase,
    TResult Function()? noLowerCase,
    TResult Function()? noDigit,
    TResult Function()? noSpecialChar,
    required TResult orElse(),
  }) {
    if (noLowerCase != null) {
      return noLowerCase();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_PasswordEmpty value) empty,
    required TResult Function(_PasswordTooShort value) tooShort,
    required TResult Function(_PasswordTooLong value) tooLong,
    required TResult Function(_PasswordNoUpperCase value) noUpperCase,
    required TResult Function(_PasswordNoLowerCase value) noLowerCase,
    required TResult Function(_PasswordNoDigit value) noDigit,
    required TResult Function(_PasswordNoSpecialChar value) noSpecialChar,
  }) {
    return noLowerCase(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_PasswordEmpty value)? empty,
    TResult? Function(_PasswordTooShort value)? tooShort,
    TResult? Function(_PasswordTooLong value)? tooLong,
    TResult? Function(_PasswordNoUpperCase value)? noUpperCase,
    TResult? Function(_PasswordNoLowerCase value)? noLowerCase,
    TResult? Function(_PasswordNoDigit value)? noDigit,
    TResult? Function(_PasswordNoSpecialChar value)? noSpecialChar,
  }) {
    return noLowerCase?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_PasswordEmpty value)? empty,
    TResult Function(_PasswordTooShort value)? tooShort,
    TResult Function(_PasswordTooLong value)? tooLong,
    TResult Function(_PasswordNoUpperCase value)? noUpperCase,
    TResult Function(_PasswordNoLowerCase value)? noLowerCase,
    TResult Function(_PasswordNoDigit value)? noDigit,
    TResult Function(_PasswordNoSpecialChar value)? noSpecialChar,
    required TResult orElse(),
  }) {
    if (noLowerCase != null) {
      return noLowerCase(this);
    }
    return orElse();
  }
}

abstract class _PasswordNoLowerCase implements PasswordValidationException {
  const factory _PasswordNoLowerCase() = _$_PasswordNoLowerCase;
}

/// @nodoc
abstract class _$$_PasswordNoDigitCopyWith<$Res> {
  factory _$$_PasswordNoDigitCopyWith(
          _$_PasswordNoDigit value, $Res Function(_$_PasswordNoDigit) then) =
      __$$_PasswordNoDigitCopyWithImpl<$Res>;
}

/// @nodoc
class __$$_PasswordNoDigitCopyWithImpl<$Res>
    extends _$PasswordValidationExceptionCopyWithImpl<$Res, _$_PasswordNoDigit>
    implements _$$_PasswordNoDigitCopyWith<$Res> {
  __$$_PasswordNoDigitCopyWithImpl(
      _$_PasswordNoDigit _value, $Res Function(_$_PasswordNoDigit) _then)
      : super(_value, _then);
}

/// @nodoc

class _$_PasswordNoDigit implements _PasswordNoDigit {
  const _$_PasswordNoDigit();

  @override
  String toString() {
    return 'PasswordValidationException.noDigit()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$_PasswordNoDigit);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() empty,
    required TResult Function() tooShort,
    required TResult Function() tooLong,
    required TResult Function() noUpperCase,
    required TResult Function() noLowerCase,
    required TResult Function() noDigit,
    required TResult Function() noSpecialChar,
  }) {
    return noDigit();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? empty,
    TResult? Function()? tooShort,
    TResult? Function()? tooLong,
    TResult? Function()? noUpperCase,
    TResult? Function()? noLowerCase,
    TResult? Function()? noDigit,
    TResult? Function()? noSpecialChar,
  }) {
    return noDigit?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? empty,
    TResult Function()? tooShort,
    TResult Function()? tooLong,
    TResult Function()? noUpperCase,
    TResult Function()? noLowerCase,
    TResult Function()? noDigit,
    TResult Function()? noSpecialChar,
    required TResult orElse(),
  }) {
    if (noDigit != null) {
      return noDigit();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_PasswordEmpty value) empty,
    required TResult Function(_PasswordTooShort value) tooShort,
    required TResult Function(_PasswordTooLong value) tooLong,
    required TResult Function(_PasswordNoUpperCase value) noUpperCase,
    required TResult Function(_PasswordNoLowerCase value) noLowerCase,
    required TResult Function(_PasswordNoDigit value) noDigit,
    required TResult Function(_PasswordNoSpecialChar value) noSpecialChar,
  }) {
    return noDigit(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_PasswordEmpty value)? empty,
    TResult? Function(_PasswordTooShort value)? tooShort,
    TResult? Function(_PasswordTooLong value)? tooLong,
    TResult? Function(_PasswordNoUpperCase value)? noUpperCase,
    TResult? Function(_PasswordNoLowerCase value)? noLowerCase,
    TResult? Function(_PasswordNoDigit value)? noDigit,
    TResult? Function(_PasswordNoSpecialChar value)? noSpecialChar,
  }) {
    return noDigit?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_PasswordEmpty value)? empty,
    TResult Function(_PasswordTooShort value)? tooShort,
    TResult Function(_PasswordTooLong value)? tooLong,
    TResult Function(_PasswordNoUpperCase value)? noUpperCase,
    TResult Function(_PasswordNoLowerCase value)? noLowerCase,
    TResult Function(_PasswordNoDigit value)? noDigit,
    TResult Function(_PasswordNoSpecialChar value)? noSpecialChar,
    required TResult orElse(),
  }) {
    if (noDigit != null) {
      return noDigit(this);
    }
    return orElse();
  }
}

abstract class _PasswordNoDigit implements PasswordValidationException {
  const factory _PasswordNoDigit() = _$_PasswordNoDigit;
}

/// @nodoc
abstract class _$$_PasswordNoSpecialCharCopyWith<$Res> {
  factory _$$_PasswordNoSpecialCharCopyWith(_$_PasswordNoSpecialChar value,
          $Res Function(_$_PasswordNoSpecialChar) then) =
      __$$_PasswordNoSpecialCharCopyWithImpl<$Res>;
}

/// @nodoc
class __$$_PasswordNoSpecialCharCopyWithImpl<$Res>
    extends _$PasswordValidationExceptionCopyWithImpl<$Res,
        _$_PasswordNoSpecialChar>
    implements _$$_PasswordNoSpecialCharCopyWith<$Res> {
  __$$_PasswordNoSpecialCharCopyWithImpl(_$_PasswordNoSpecialChar _value,
      $Res Function(_$_PasswordNoSpecialChar) _then)
      : super(_value, _then);
}

/// @nodoc

class _$_PasswordNoSpecialChar implements _PasswordNoSpecialChar {
  const _$_PasswordNoSpecialChar();

  @override
  String toString() {
    return 'PasswordValidationException.noSpecialChar()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$_PasswordNoSpecialChar);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() empty,
    required TResult Function() tooShort,
    required TResult Function() tooLong,
    required TResult Function() noUpperCase,
    required TResult Function() noLowerCase,
    required TResult Function() noDigit,
    required TResult Function() noSpecialChar,
  }) {
    return noSpecialChar();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? empty,
    TResult? Function()? tooShort,
    TResult? Function()? tooLong,
    TResult? Function()? noUpperCase,
    TResult? Function()? noLowerCase,
    TResult? Function()? noDigit,
    TResult? Function()? noSpecialChar,
  }) {
    return noSpecialChar?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? empty,
    TResult Function()? tooShort,
    TResult Function()? tooLong,
    TResult Function()? noUpperCase,
    TResult Function()? noLowerCase,
    TResult Function()? noDigit,
    TResult Function()? noSpecialChar,
    required TResult orElse(),
  }) {
    if (noSpecialChar != null) {
      return noSpecialChar();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_PasswordEmpty value) empty,
    required TResult Function(_PasswordTooShort value) tooShort,
    required TResult Function(_PasswordTooLong value) tooLong,
    required TResult Function(_PasswordNoUpperCase value) noUpperCase,
    required TResult Function(_PasswordNoLowerCase value) noLowerCase,
    required TResult Function(_PasswordNoDigit value) noDigit,
    required TResult Function(_PasswordNoSpecialChar value) noSpecialChar,
  }) {
    return noSpecialChar(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_PasswordEmpty value)? empty,
    TResult? Function(_PasswordTooShort value)? tooShort,
    TResult? Function(_PasswordTooLong value)? tooLong,
    TResult? Function(_PasswordNoUpperCase value)? noUpperCase,
    TResult? Function(_PasswordNoLowerCase value)? noLowerCase,
    TResult? Function(_PasswordNoDigit value)? noDigit,
    TResult? Function(_PasswordNoSpecialChar value)? noSpecialChar,
  }) {
    return noSpecialChar?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_PasswordEmpty value)? empty,
    TResult Function(_PasswordTooShort value)? tooShort,
    TResult Function(_PasswordTooLong value)? tooLong,
    TResult Function(_PasswordNoUpperCase value)? noUpperCase,
    TResult Function(_PasswordNoLowerCase value)? noLowerCase,
    TResult Function(_PasswordNoDigit value)? noDigit,
    TResult Function(_PasswordNoSpecialChar value)? noSpecialChar,
    required TResult orElse(),
  }) {
    if (noSpecialChar != null) {
      return noSpecialChar(this);
    }
    return orElse();
  }
}

abstract class _PasswordNoSpecialChar implements PasswordValidationException {
  const factory _PasswordNoSpecialChar() = _$_PasswordNoSpecialChar;
}