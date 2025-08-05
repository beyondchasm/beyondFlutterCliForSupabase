import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_profile.freezed.dart';
part 'user_profile.g.dart';

@freezed
class UserProfile with _$UserProfile {
  const factory UserProfile({
    required String id,
    required String email,
    String? displayName,
    String? firstName,
    String? lastName,
    String? photoUrl,
    String? phoneNumber,
    String? bio,
    String? website,
    String? location,
    DateTime? dateOfBirth,
    @Default(UserGender.notSpecified) UserGender gender,
    @Default(false) bool isEmailVerified,
    @Default(false) bool isPhoneVerified,
    @Default(UserPrivacyLevel.public) UserPrivacyLevel privacyLevel,
    @Default([]) List<String> interests,
    @Default({}) Map<String, dynamic> preferences,
    @Default({}) Map<String, dynamic> socialLinks,
    Map<String, dynamic>? customClaims,
    required DateTime createdAt,
    DateTime? lastSignInAt,
    DateTime? updatedAt,
    @Default(UserStatus.active) UserStatus status,
  }) = _UserProfile;

  const UserProfile._();

  factory UserProfile.fromJson(Map<String, dynamic> json) =>
      _$UserProfileFromJson(json);

  /// 전체 이름 반환
  String get fullName {
    if (firstName != null && lastName != null) {
      return '$firstName $lastName';
    }
    return displayName ?? email.split('@').first;
  }

  /// 프로필 완성도 계산 (0-100)
  int get completionPercentage {
    int completed = 0;
    const int totalFields = 10;

    if (displayName?.isNotEmpty == true) completed++;
    if (firstName?.isNotEmpty == true) completed++;
    if (lastName?.isNotEmpty == true) completed++;
    if (photoUrl?.isNotEmpty == true) completed++;
    if (phoneNumber?.isNotEmpty == true) completed++;
    if (bio?.isNotEmpty == true) completed++;
    if (location?.isNotEmpty == true) completed++;
    if (dateOfBirth != null) completed++;
    if (gender != UserGender.notSpecified) completed++;
    if (interests.isNotEmpty) completed++;

    return (completed / totalFields * 100).round();
  }

  /// 이메일 도메인 반환
  String get emailDomain {
    return email.split('@').last;
  }

  /// 프로필 이미지 URL (기본 이미지 포함)
  String get profileImageUrl {
    if (photoUrl?.isNotEmpty == true) {
      return photoUrl!;
    }
    // 기본 프로필 이미지 또는 Gravatar 사용
    return 'https://ui-avatars.com/api/?name=${Uri.encodeComponent(fullName)}&size=200&background=random';
  }

  /// 나이 계산
  int? get age {
    if (dateOfBirth == null) return null;
    final now = DateTime.now();
    int age = now.year - dateOfBirth!.year;
    if (now.month < dateOfBirth!.month || 
        (now.month == dateOfBirth!.month && now.day < dateOfBirth!.day)) {
      age--;
    }
    return age;
  }

  /// 가입 후 경과 일수
  int get daysSinceJoined {
    return DateTime.now().difference(createdAt).inDays;
  }

  /// 마지막 로그인으로부터 경과 일수
  int? get daysSinceLastSignIn {
    if (lastSignInAt == null) return null;
    return DateTime.now().difference(lastSignInAt!).inDays;
  }

  /// 유효성 검증
  List<String> validate() {
    final errors = <String>[];

    if (email.isEmpty) {
      errors.add('Email is required');
    } else if (!_isValidEmail(email)) {
      errors.add('Invalid email format');
    }

    if (displayName?.isEmpty == true) {
      errors.add('Display name cannot be empty');
    }

    if (phoneNumber?.isNotEmpty == true && !_isValidPhoneNumber(phoneNumber!)) {
      errors.add('Invalid phone number format');
    }

    if (website?.isNotEmpty == true && !_isValidUrl(website!)) {
      errors.add('Invalid website URL');
    }

    if (bio?.isNotEmpty == true && bio!.length > 500) {
      errors.add('Bio must be less than 500 characters');
    }

    return errors;
  }

  bool _isValidEmail(String email) {
    return RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$')
        .hasMatch(email);
  }

  bool _isValidPhoneNumber(String phone) {
    return RegExp(r'^\+?[\d\s\-\(\)]+$').hasMatch(phone);
  }

  bool _isValidUrl(String url) {
    try {
      final uri = Uri.parse(url);
      return uri.hasScheme && (uri.scheme == 'http' || uri.scheme == 'https');
    } catch (e) {
      return false;
    }
  }
}

enum UserGender {
  male,
  female,
  nonBinary,
  notSpecified,
}

enum UserPrivacyLevel {
  public,
  friendsOnly,
  private,
}

enum UserStatus {
  active,
  inactive,
  suspended,
  deleted,
}