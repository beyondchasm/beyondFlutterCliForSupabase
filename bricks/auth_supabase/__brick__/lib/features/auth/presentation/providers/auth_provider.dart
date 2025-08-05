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
class AuthProvider extends ChangeNotifier {
  final SignInUseCase _signInUseCase;
  final SignUpUseCase _signUpUseCase;
  final SignOutUseCase _signOutUseCase;
  final ResetPasswordUseCase _resetPasswordUseCase;
  final GetCurrentUserUseCase _getCurrentUserUseCase;

  AuthProvider(
    this._signInUseCase,
    this._signUpUseCase,
    this._signOutUseCase,
    this._resetPasswordUseCase,
    this._getCurrentUserUseCase,
  ) {
    _initializeAuthState();
  }

  UserEntity? _currentUser;
  bool _isLoading = false;
  String? _errorMessage;

  UserEntity? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => _currentUser != null;

  void _initializeAuthState() {
    _getCurrentUserUseCase.authStateChanges.listen((user) {
      _currentUser = user;
      notifyListeners();
    });
  }

  Future<bool> signIn(String email, String password) async {
    _setLoading(true);
    _clearError();

    final result = await _signInUseCase(email, password);
    
    return result.when(
      success: (user) {
        _currentUser = user;
        _setLoading(false);
        return true;
      },
      failure: (message) {
        _setError(message);
        _setLoading(false);
        return false;
      },
    );
  }

  Future<bool> signUp(String email, String password) async {
    _setLoading(true);
    _clearError();

    final result = await _signUpUseCase(email, password);
    
    return result.when(
      success: (user) {
        _currentUser = user;
        _setLoading(false);
        return true;
      },
      failure: (message) {
        _setError(message);
        _setLoading(false);
        return false;
      },
    );
  }

  Future<void> signOut() async {
    _setLoading(true);
    _clearError();

    try {
      await _signOutUseCase();
      _currentUser = null;
    } catch (e) {
      _setError(e.toString());
    }
    
    _setLoading(false);
  }

  Future<bool> resetPassword(String email) async {
    _setLoading(true);
    _clearError();

    final result = await _resetPasswordUseCase(email);
    
    return result.when(
      success: (_) {
        _setLoading(false);
        return true;
      },
      failure: (message) {
        _setError(message);
        _setLoading(false);
        return false;
      },
    );
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String message) {
    _errorMessage = message;
    notifyListeners();
  }

  void _clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  void clearError() {
    _clearError();
  }
}