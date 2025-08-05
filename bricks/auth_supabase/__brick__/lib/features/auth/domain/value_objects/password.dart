import 'package:freezed_annotation/freezed_annotation.dart';

part 'password.freezed.dart';

@freezed
class Password with _$Password {
  const factory Password._(String value) = _Password;
  
  factory Password(String input) {
    if (input.isEmpty) {
      throw const PasswordValidationException.empty();
    }
    
    if (input.length < 8) {
      throw const PasswordValidationException.tooShort();
    }
    
    if (input.length > 128) {
      throw const PasswordValidationException.tooLong();
    }
    
    if (!_hasUpperCase(input)) {
      throw const PasswordValidationException.noUpperCase();
    }
    
    if (!_hasLowerCase(input)) {
      throw const PasswordValidationException.noLowerCase();
    }
    
    if (!_hasDigit(input)) {
      throw const PasswordValidationException.noDigit();
    }
    
    if (!_hasSpecialChar(input)) {
      throw const PasswordValidationException.noSpecialChar();
    }
    
    return Password._(input);
  }
  
  static bool _hasUpperCase(String password) => password.contains(RegExp(r'[A-Z]'));
  static bool _hasLowerCase(String password) => password.contains(RegExp(r'[a-z]'));
  static bool _hasDigit(String password) => password.contains(RegExp(r'\d'));
  static bool _hasSpecialChar(String password) => password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));
  
  /// 비밀번호 강도 계산 (1-5)
  int get strength {
    int score = 0;
    final value = this.value;
    
    if (value.length >= 8) score++;
    if (value.length >= 12) score++;
    if (_hasUpperCase(value) && _hasLowerCase(value)) score++;
    if (_hasDigit(value)) score++;
    if (_hasSpecialChar(value)) score++;
    
    return score;
  }
  
  /// 비밀번호 강도 텍스트
  String get strengthText {
    switch (strength) {
      case 1:
      case 2:
        return '약함';
      case 3:
        return '보통';
      case 4:
        return '강함';
      case 5:
        return '매우 강함';
      default:
        return '매우 약함';
    }
  }
}

@freezed
class PasswordValidationException with _$PasswordValidationException implements Exception {
  const factory PasswordValidationException.empty() = _PasswordEmpty;
  const factory PasswordValidationException.tooShort() = _PasswordTooShort;
  const factory PasswordValidationException.tooLong() = _PasswordTooLong;
  const factory PasswordValidationException.noUpperCase() = _PasswordNoUpperCase;
  const factory PasswordValidationException.noLowerCase() = _PasswordNoLowerCase;
  const factory PasswordValidationException.noDigit() = _PasswordNoDigit;
  const factory PasswordValidationException.noSpecialChar() = _PasswordNoSpecialChar;
}