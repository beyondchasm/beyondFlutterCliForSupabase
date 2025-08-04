import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import '../errors/app_error.dart';

/// 글로벌 에러 핸들러 서비스
/// 
/// 앱 전체의 에러를 통합 관리하고 사용자에게 적절한 피드백을 제공합니다.
class ErrorHandlerService {
  static final Logger _logger = Logger();
  static GlobalKey<NavigatorState>? _navigatorKey;
  static GlobalKey<ScaffoldMessengerState>? _scaffoldKey;

  /// Navigator Key 설정
  static void setNavigatorKey(GlobalKey<NavigatorState> key) {
    _navigatorKey = key;
  }

  /// ScaffoldMessenger Key 설정
  static void setScaffoldKey(GlobalKey<ScaffoldMessengerState> key) {
    _scaffoldKey = key;
  }

  /// 에러를 AppError로 변환
  static AppError convertToAppError(dynamic error) {
    if (error is AppError) {
      return error;
    }

    if (error is DioException) {
      return _handleDioError(error);
    }

    if (error is Exception) {
      return AppError.unknown(
        message: error.toString(),
        originalError: error,
      );
    }

    return AppError.unknown(
      message: '알 수 없는 오류가 발생했습니다',
      originalError: error,
    );
  }

  /// DioException을 AppError로 변환
  static AppError _handleDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return const AppError.timeout();

      case DioExceptionType.connectionError:
        return const AppError.noInternet();

      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode ?? 500;
        final message = _extractErrorMessage(error.response?.data);
        
        if (statusCode == 401) {
          return AppError.auth(message: message, code: '401');
        }
        
        return AppError.network(
          message: message,
          statusCode: statusCode,
          code: statusCode.toString(),
        );

      case DioExceptionType.cancel:
        return const AppError.unknown(message: '요청이 취소되었습니다');

      case DioExceptionType.unknown:
      case DioExceptionType.badCertificate:
      default:
        return AppError.network(
          message: error.message ?? '네트워크 오류가 발생했습니다',
          statusCode: error.response?.statusCode ?? 500,
        );
    }
  }

  /// 응답 데이터에서 에러 메시지 추출
  static String _extractErrorMessage(dynamic data) {
    if (data is Map<String, dynamic>) {
      // Supabase 에러 메시지 형식
      if (data['message'] != null) {
        return data['message'].toString();
      }
      if (data['error'] != null) {
        if (data['error'] is Map && data['error']['message'] != null) {
          return data['error']['message'].toString();
        }
        return data['error'].toString();
      }
      if (data['detail'] != null) {
        return data['detail'].toString();
      }
    }
    return '서버 오류가 발생했습니다';
  }

  /// 에러를 로그에 기록
  static void logError(AppError error, {StackTrace? stackTrace}) {
    error.when(
      network: (message, code, statusCode) {
        _logger.e('🌐 Network Error [$statusCode]: $message', error: error, stackTrace: stackTrace);
      },
      auth: (message, code) {
        _logger.w('🔐 Auth Error: $message', error: error);
      },
      validation: (message, field) {
        _logger.w('📝 Validation Error [$field]: $message');
      },
      storage: (message, code) {
        _logger.e('💾 Storage Error: $message', error: error, stackTrace: stackTrace);
      },
      permission: (message, permission) {
        _logger.w('🚫 Permission Error [$permission]: $message');
      },
      unknown: (message, originalError) {
        _logger.e('❓ Unknown Error: $message', error: originalError, stackTrace: stackTrace);
      },
      timeout: (message) {
        _logger.w('⏰ Timeout Error: $message');
      },
      noInternet: (message) {
        _logger.w('📡 No Internet: $message');
      },
    );
  }

  /// 사용자에게 에러 표시 (SnackBar)
  static void showError(AppError error) {
    logError(error);
    
    final scaffoldMessenger = _scaffoldKey?.currentState;
    if (scaffoldMessenger != null) {
      scaffoldMessenger.showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(
                _getErrorIcon(error),
                color: Colors.white,
                size: 20,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  error.userMessage,
                  style: const TextStyle(color: Colors.white),
                ),
              ),
              if (error.isRetryable)
                TextButton(
                  onPressed: () {
                    scaffoldMessenger.hideCurrentSnackBar();
                    // 재시도 로직 (필요 시 콜백으로 처리)
                  },
                  child: const Text(
                    '재시도',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
            ],
          ),
          backgroundColor: _getErrorColor(error),
          duration: Duration(seconds: error.isRetryable ? 5 : 3),
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      );
    }
  }

  /// 에러 다이얼로그 표시
  static void showErrorDialog(AppError error) {
    logError(error);
    
    final context = _navigatorKey?.currentContext;
    if (context != null) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          icon: Icon(
            _getErrorIcon(error),
            color: _getErrorColor(error),
            size: 32,
          ),
          title: Text(_getErrorTitle(error)),
          content: Text(error.userMessage),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('확인'),
            ),
            if (error.isRetryable)
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  // 재시도 로직
                },
                child: const Text('재시도'),
              ),
          ],
        ),
      );
    }
  }

  /// 에러 타입에 따른 아이콘 반환
  static IconData _getErrorIcon(AppError error) {
    return error.when(
      network: (_, __, ___) => Icons.wifi_off,
      auth: (_, __) => Icons.lock,
      validation: (_, __) => Icons.error_outline,
      storage: (_, __) => Icons.storage,
      permission: (_, __) => Icons.security,
      unknown: (_, __) => Icons.error,
      timeout: (_) => Icons.timer_off,
      noInternet: (_) => Icons.signal_wifi_off,
    );
  }

  /// 에러 타입에 따른 색상 반환
  static Color _getErrorColor(AppError error) {
    return error.when(
      network: (_, __, ___) => Colors.orange,
      auth: (_, __) => Colors.red,
      validation: (_, __) => Colors.amber,
      storage: (_, __) => Colors.purple,
      permission: (_, __) => Colors.red,
      unknown: (_, __) => Colors.grey,
      timeout: (_) => Colors.orange,
      noInternet: (_) => Colors.blue,
    );
  }

  /// 에러 타입에 따른 제목 반환
  static String _getErrorTitle(AppError error) {
    return error.when(
      network: (_, __, ___) => '네트워크 오류',
      auth: (_, __) => '인증 오류',
      validation: (_, __) => '입력 오류',
      storage: (_, __) => '저장소 오류',
      permission: (_, __) => '권한 오류',
      unknown: (_, __) => '오류',
      timeout: (_) => '시간 초과',
      noInternet: (_) => '연결 오류',
    );
  }

  /// 글로벌 에러 처리 (최상위에서 catch되지 않은 에러)
  static void handleGlobalError(Object error, StackTrace stackTrace) {
    final appError = convertToAppError(error);
    logError(appError, stackTrace: stackTrace);
    
    // 중요한 에러는 다이얼로그로, 일반적인 에러는 스낵바로
    if (appError is AuthError || appError is UnknownError) {
      showErrorDialog(appError);
    } else {
      showError(appError);
    }
  }
}