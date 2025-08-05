import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/entities/auth_result.dart';
import '../../domain/use_cases/sign_in_usecase.dart';
import '../../domain/use_cases/sign_up_usecase.dart';
import '../../domain/use_cases/sign_out_usecase.dart';
import '../../domain/use_cases/reset_password_usecase.dart';
import '../../domain/use_cases/get_current_user_usecase.dart';

@injectable
class EnhancedAuthProvider extends ChangeNotifier {
  final SignInUseCase _signInUseCase;
  final SignUpUseCase _signUpUseCase;
  final SignOutUseCase _signOutUseCase;
  final ResetPasswordUseCase _resetPasswordUseCase;
  final GetCurrentUserUseCase _getCurrentUserUseCase;

  EnhancedAuthProvider(
    this._signInUseCase,
    this._signUpUseCase,
    this._signOutUseCase,
    this._resetPasswordUseCase,
    this._getCurrentUserUseCase,
  ) {
    _initializeAuthState();
  }

  // 상태 변수들
  UserEntity? _currentUser;
  AuthResult? _lastResult;
  bool _isLoading = false;
  String? _errorMessage;
  AuthErrorType? _lastErrorType;
  Timer? _sessionTimer;
  
  // Getters
  UserEntity? get currentUser => _currentUser;
  AuthResult? get lastResult => _lastResult;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  AuthErrorType? get lastErrorType => _lastErrorType;
  bool get isAuthenticated => _currentUser != null;
  bool get hasError => _errorMessage != null;
  
  // 특정 에러 타입 체크 편의 메서드들
  bool get isNetworkError => _lastErrorType == AuthErrorType.networkError;
  bool get isInvalidCredentials => _lastErrorType == AuthErrorType.invalidCredentials;
  bool get isEmailNotVerified => _lastErrorType == AuthErrorType.emailNotVerified;
  bool get isWeakPassword => _lastErrorType == AuthErrorType.weakPassword;
  
  void _initializeAuthState() {
    // 인증 상태 변화 감지
    _getCurrentUserUseCase.authStateChanges.listen((user) {
      _currentUser = user;
      
      if (user != null) {
        _startSessionTimer();
      } else {
        _stopSessionTimer();
      }
      
      notifyListeners();
    });
    
    // 초기 사용자 상태 확인
    _checkInitialAuthState();
  }
  
  Future<void> _checkInitialAuthState() async {
    try {
      _currentUser = await _getCurrentUserUseCase();
      if (_currentUser != null) {
        _startSessionTimer();
      }
      notifyListeners();
    } catch (e) {
      // 초기 상태 확인 실패는 무시 (로그인 안 됨으로 처리)
    }
  }
  
  /// 세션 타이머 시작 (1시간마다 세션 확인)
  void _startSessionTimer() {
    _stopSessionTimer();
    _sessionTimer = Timer.periodic(const Duration(hours: 1), (timer) {
      _validateSession();
    });
  }
  
  void _stopSessionTimer() {
    _sessionTimer?.cancel();
    _sessionTimer = null;
  }
  
  Future<void> _validateSession() async {
    // TODO: 세션 검증 로직 구현
    // Repository에 세션 검증 메서드가 추가되면 사용
  }

  /// 로그인
  Future<AuthResult> signIn(String email, String password) async {
    _setLoading(true);
    _clearError();

    try {
      final result = await _signInUseCase(email, password);
      _lastResult = result;
      
      return result.when(
        success: (user) {
          _currentUser = user;
          _setLoading(false);
          return result;
        },
        failure: (message, errorType, code, details) {
          _setError(message, errorType);
          _setLoading(false);
          return result;
        },
        loading: () {
          // 이미 로딩 상태
          return result;
        },
        emailVerificationRequired: (email, message) {
          _setError(message ?? '이메일 인증이 필요합니다.', AuthErrorType.emailNotVerified);
          _setLoading(false);
          return result;
        },
      );
    } catch (e) {
      final errorResult = AuthResult.failure(
        message: e.toString(),
        errorType: AuthErrorType.unknownError,
      );
      _lastResult = errorResult;
      _setError(e.toString(), AuthErrorType.unknownError);
      _setLoading(false);
      return errorResult;
    }
  }

  /// 회원가입
  Future<AuthResult> signUp(String email, String password) async {
    _setLoading(true);
    _clearError();

    try {
      final result = await _signUpUseCase(email, password);
      _lastResult = result;
      
      return result.when(
        success: (user) {
          _currentUser = user;
          _setLoading(false);
          return result;
        },
        failure: (message, errorType, code, details) {
          _setError(message, errorType);
          _setLoading(false);
          return result;
        },
        loading: () {
          return result;
        },
        emailVerificationRequired: (email, message) {
          _setError(message ?? '이메일 인증을 완료해주세요.', AuthErrorType.emailNotVerified);
          _setLoading(false);
          return result;
        },
      );
    } catch (e) {
      final errorResult = AuthResult.failure(
        message: e.toString(),
        errorType: AuthErrorType.unknownError,
      );
      _lastResult = errorResult;
      _setError(e.toString(), AuthErrorType.unknownError);
      _setLoading(false);
      return errorResult;
    }
  }

  /// 로그아웃
  Future<void> signOut() async {
    _setLoading(true);
    _clearError();

    try {
      await _signOutUseCase();
      _currentUser = null;
      _lastResult = null;
      _stopSessionTimer();
    } catch (e) {
      _setError(e.toString(), AuthErrorType.unknownError);
    } finally {
      _setLoading(false);
    }
  }

  /// 비밀번호 재설정
  Future<AuthResult> resetPassword(String email) async {
    _setLoading(true);
    _clearError();

    try {
      final result = await _resetPasswordUseCase(email);
      _lastResult = result;
      _setLoading(false);
      return result;
    } catch (e) {
      final errorResult = AuthResult.failure(
        message: e.toString(),
        errorType: AuthErrorType.unknownError,
      );
      _lastResult = errorResult;
      _setError(e.toString(), AuthErrorType.unknownError);
      _setLoading(false);
      return errorResult;
    }
  }

  /// 에러 재시도
  Future<AuthResult?> retry() async {
    if (_lastResult == null) return null;
    
    // 마지막 작업 유형에 따라 재시도
    // 실제 구현에서는 마지막 작업을 추적하여 재시도
    _clearError();
    return null;
  }

  /// 특정 에러 타입에 대한 처리 제안
  String getErrorActionSuggestion(AuthErrorType errorType) {
    switch (errorType) {
      case AuthErrorType.networkError:
        return '인터넷 연결을 확인하고 다시 시도해주세요.';
      case AuthErrorType.invalidCredentials:
        return '이메일과 비밀번호를 다시 확인해주세요.';
      case AuthErrorType.emailNotVerified:
        return '이메일을 확인하여 인증을 완료해주세요.';
      case AuthErrorType.weakPassword:
        return '더 강력한 비밀번호를 사용해주세요. (8자 이상, 대소문자, 숫자, 특수문자 포함)';
      case AuthErrorType.emailAlreadyInUse:
        return '이미 사용중인 이메일입니다. 로그인을 시도해보세요.';
      case AuthErrorType.tooManyRequests:
        return '너무 많은 요청이 발생했습니다. 잠시 후 다시 시도해주세요.';
      case AuthErrorType.userNotFound:
        return '등록되지 않은 계정입니다. 회원가입을 진행해주세요.';
      default:
        return '문제가 지속되면 고객지원에 문의해주세요.';
    }
  }

  // 상태 변경 헬퍼 메서드들
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String message, AuthErrorType errorType) {
    _errorMessage = message;
    _lastErrorType = errorType;
    notifyListeners();
  }

  void _clearError() {
    _errorMessage = null;
    _lastErrorType = null;
    notifyListeners();
  }

  /// 에러 수동 클리어
  void clearError() {
    _clearError();
  }

  @override
  void dispose() {
    _stopSessionTimer();
    super.dispose();
  }
}