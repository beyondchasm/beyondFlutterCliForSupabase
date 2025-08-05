import 'package:freezed_annotation/freezed_annotation.dart';

part 'email.freezed.dart';

@freezed
class Email with _$Email {
  const factory Email._(String value) = _Email;
  
  factory Email(String input) {
    if (input.isEmpty) {
      throw const EmailValidationException.empty();
    }
    
    if (!_isValidEmail(input)) {
      throw const EmailValidationException.invalid();
    }
    
    return Email._(input.toLowerCase().trim());
  }
  
  static bool _isValidEmail(String email) {
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    return emailRegex.hasMatch(email);
  }
}

@freezed
class EmailValidationException with _$EmailValidationException implements Exception {
  const factory EmailValidationException.empty() = _EmailEmpty;
  const factory EmailValidationException.invalid() = _EmailInvalid;
}