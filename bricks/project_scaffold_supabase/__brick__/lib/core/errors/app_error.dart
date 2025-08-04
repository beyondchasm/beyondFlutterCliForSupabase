import 'package:freezed_annotation/freezed_annotation.dart';

part 'app_error.freezed.dart';

/// 앱 전체에서 사용하는 통합 에러 클래스
@freezed
class AppError with _$AppError {
  const factory AppError.network({
    required String message,
    String? code,
    @Default(500) int statusCode,
  }) = NetworkError;

  const factory AppError.auth({required String message, String? code}) =
      AuthError;

  const factory AppError.validation({
    required String message,
    required String field,
  }) = ValidationError;

  const factory AppError.storage({required String message, String? code}) =
      StorageError;

  const factory AppError.permission({
    required String message,
    required String permission,
  }) = PermissionError;

  const factory AppError.unknown({
    required String message,
    Object? originalError,
  }) = UnknownError;

  const factory AppError.timeout({@Default('요청 시간이 초과되었습니다') String message}) =
      TimeoutError;

  const factory AppError.noInternet({
    @Default('인터넷 연결을 확인해주세요') String message,
  }) = NoInternetError;
}

/// 에러를 사용자 친화적 메시지로 변환
extension AppErrorExtension on AppError {
  String get userMessage {
    return when(
      network: (message, code, statusCode) {
        switch (statusCode) {
          case 400:
            return '잘못된 요청입니다';
          case 401:
            return '로그인이 필요합니다';
          case 403:
            return '접근 권한이 없습니다';
          case 404:
            return '요청한 정보를 찾을 수 없습니다';
          case 500:
            return '서버 오류가 발생했습니다';
          default:
            return message.isNotEmpty ? message : '네트워크 오류가 발생했습니다';
        }
      },
      auth: (message, code) => message.isNotEmpty ? message : '인증 오류가 발생했습니다',
      validation: (message, field) => message,
      storage: (message, code) => '데이터 저장 중 오류가 발생했습니다',
      permission: (message, permission) => '권한이 필요합니다: $permission',
      unknown: (message, originalError) =>
          message.isNotEmpty ? message : '알 수 없는 오류가 발생했습니다',
      timeout: (message) => message,
      noInternet: (message) => message,
    );
  }

bool get isRetryable {
    return when(
      network: (_, __, statusCode) => statusCode >= 500,
      auth: (_, __) => false,
      validation: (_, __) => false,
      storage: (_, __) => true,
      permission: (_, __) => false,
      unknown: (_, __) => true,
      timeout: (_) => true,
      noInternet: (_) => true,
    );
  }
}
