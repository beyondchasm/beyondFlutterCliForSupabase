import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:logger/logger.dart';

/// 암호화된 보안 저장소 서비스
///
/// 민감한 데이터(토큰, 비밀번호 등)를 안전하게 저장하고 관리합니다.
/// iOS에서는 Keychain, Android에서는 EncryptedSharedPreferences를 사용합니다.
class SecureStorageService {
  static const FlutterSecureStorage _storage = FlutterSecureStorage(
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true,
      // Android에서 생체 인증 필요 시 활성화
      // requireAuthentication: true,
    ),
    iOptions: IOSOptions(
      // iOS에서 생체 인증 필요 시 활성화
      // accessibility: IOSAccessibility.biometryAny,
    ),
  );

  static final Logger _logger = Logger();

  // 키 상수들
  static const String _accessTokenKey = 'access_token';
  static const String _refreshTokenKey = 'refresh_token';
  static const String _userIdKey = 'user_id';
  static const String _biometricEnabledKey = 'biometric_enabled';
  static const String _deviceIdKey = 'device_id';

  /// 데이터 저장
  static Future<void> write(String key, String value) async {
    try {
      await _storage.write(key: key, value: value);
      _logger.d('✅ Secure storage write success: $key');
    } catch (e) {
      _logger.e('❌ Secure storage write error: $key', error: e);
      rethrow;
    }
  }

  /// 데이터 읽기
  static Future<String?> read(String key) async {
    try {
      final value = await _storage.read(key: key);
      _logger.d('✅ Secure storage read success: $key');
      return value;
    } catch (e) {
      _logger.e('❌ Secure storage read error: $key', error: e);
      return null;
    }
  }

  /// 데이터 삭제
  static Future<void> delete(String key) async {
    try {
      await _storage.delete(key: key);
      _logger.d('✅ Secure storage delete success: $key');
    } catch (e) {
      _logger.e('❌ Secure storage delete error: $key', error: e);
    }
  }

  /// 모든 데이터 삭제
  static Future<void> deleteAll() async {
    try {
      await _storage.deleteAll();
      _logger.d('✅ Secure storage delete all success');
    } catch (e) {
      _logger.e('❌ Secure storage delete all error', error: e);
    }
  }

  /// 모든 키 목록 조회
  static Future<Map<String, String>> readAll() async {
    try {
      final allData = await _storage.readAll();
      _logger.d('✅ Secure storage read all success: ${allData.length} items');
      return allData;
    } catch (e) {
      _logger.e('❌ Secure storage read all error', error: e);
      return {};
    }
  }

  /// 특정 키 존재 여부 확인
  static Future<bool> containsKey(String key) async {
    try {
      final value = await _storage.read(key: key);
      return value != null;
    } catch (e) {
      _logger.e('❌ Secure storage containsKey error: $key', error: e);
      return false;
    }
  }

  // === 토큰 관리 메서드들 ===

  /// 액세스 토큰 저장
  static Future<void> saveAccessToken(String token) async {
    await write(_accessTokenKey, token);
  }

  /// 액세스 토큰 조회
  static Future<String?> getAccessToken() async {
    return await read(_accessTokenKey);
  }

  /// 리프레시 토큰 저장
  static Future<void> saveRefreshToken(String token) async {
    await write(_refreshTokenKey, token);
  }

  /// 리프레시 토큰 조회
  static Future<String?> getRefreshToken() async {
    return await read(_refreshTokenKey);
  }

  /// 사용자 ID 저장
  static Future<void> saveUserId(String userId) async {
    await write(_userIdKey, userId);
  }

  /// 사용자 ID 조회
  static Future<String?> getUserId() async {
    return await read(_userIdKey);
  }

  /// 생체 인증 활성화 상태 저장
  static Future<void> setBiometricEnabled(bool enabled) async {
    await write(_biometricEnabledKey, enabled.toString());
  }

  /// 생체 인증 활성화 상태 조회
  static Future<bool> isBiometricEnabled() async {
    final value = await read(_biometricEnabledKey);
    return value == 'true';
  }

  /// 디바이스 ID 저장
  static Future<void> saveDeviceId(String deviceId) async {
    await write(_deviceIdKey, deviceId);
  }

  /// 디바이스 ID 조회
  static Future<String?> getDeviceId() async {
    return await read(_deviceIdKey);
  }

  /// 인증 관련 모든 데이터 삭제 (로그아웃 시)
  static Future<void> clearAuthData() async {
    await Future.wait([
      delete(_accessTokenKey),
      delete(_refreshTokenKey),
      delete(_userIdKey),
    ]);
    _logger.i('🔐 Auth data cleared from secure storage');
  }

  /// 보안 저장소 상태 확인 (디버그용)
  static Future<Map<String, dynamic>> getStorageInfo() async {
    try {
      final allData = await readAll();
      return {
        'totalItems': allData.length,
        'hasAccessToken': await containsKey(_accessTokenKey),
        'hasRefreshToken': await containsKey(_refreshTokenKey),
        'hasUserId': await containsKey(_userIdKey),
        'biometricEnabled': await isBiometricEnabled(),
        'hasDeviceId': await containsKey(_deviceIdKey),
      };
    } catch (e) {
      _logger.e('❌ Failed to get storage info', error: e);
      return {'error': e.toString()};
    }
  }
}
