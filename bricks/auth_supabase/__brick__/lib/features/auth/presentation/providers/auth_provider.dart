import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:injectable/injectable.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/use_cases/sign_in_usecase.dart';
import '../../domain/use_cases/sign_up_usecase.dart';
import '../../domain/use_cases/sign_out_usecase.dart';
import '../../domain/use_cases/reset_password_usecase.dart';
import '../../domain/use_cases/get_current_user_usecase.dart';
import '../../../../core/di/injection.dart';

class AuthState {
  final UserEntity? currentUser;
  final bool isLoading;
  final String? errorMessage;

  const AuthState({
    this.currentUser,
    this.isLoading = false,
    this.errorMessage,
  });

  bool get isAuthenticated => currentUser != null;

  AuthState copyWith({
    UserEntity? currentUser,
    bool? isLoading,
    String? errorMessage,
  }) {
    return AuthState(
      currentUser: currentUser ?? this.currentUser,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

@injectable
class AuthNotifier extends AsyncNotifier<AuthState> {
  final SignInUseCase _signInUseCase;
  final SignUpUseCase _signUpUseCase;
  final SignOutUseCase _signOutUseCase;
  final ResetPasswordUseCase _resetPasswordUseCase;
  final GetCurrentUserUseCase _getCurrentUserUseCase;

  AuthNotifier(
    this._signInUseCase,
    this._signUpUseCase,
    this._signOutUseCase,
    this._resetPasswordUseCase,
    this._getCurrentUserUseCase,
  );

  @override
  FutureOr<AuthState> build() async {
    final currentUser = await _getCurrentUserUseCase();

    _getCurrentUserUseCase.authStateChanges.listen((user) {
      state = AsyncValue.data(AuthState(currentUser: user));
    });

    return AuthState(currentUser: currentUser);
  }

  Future<bool> signIn(String email, String password) async {
    state = AsyncValue.data(
      state.value!.copyWith(isLoading: true, errorMessage: null),
    );

    final result = await _signInUseCase(email, password);

    return result.when(
      success: (user) {
        state = AsyncValue.data(AuthState(currentUser: user, isLoading: false));
        return true;
      },
      failure: (message, errorType, code, details) {
        state = AsyncValue.data(
          state.value!.copyWith(isLoading: false, errorMessage: message),
        );
        return false;
      },
      loading: () {
        state = AsyncValue.data(state.value!.copyWith(isLoading: true));
        return false;
      },
      emailVerificationRequired: (email, message) {
        state = AsyncValue.data(
          state.value!.copyWith(
            isLoading: false,
            errorMessage: message ?? 'Email verification required',
          ),
        );
        return false;
      },
    );
  }

  Future<bool> signUp(String email, String password) async {
    state = AsyncValue.data(
      state.value!.copyWith(isLoading: true, errorMessage: null),
    );

    final result = await _signUpUseCase(email, password);

    return result.when(
      success: (user) {
        state = AsyncValue.data(AuthState(currentUser: user, isLoading: false));
        return true;
      },
      failure: (message, errorType, code, details) {
        state = AsyncValue.data(
          state.value!.copyWith(isLoading: false, errorMessage: message),
        );
        return false;
      },
      loading: () {
        state = AsyncValue.data(state.value!.copyWith(isLoading: true));
        return false;
      },
      emailVerificationRequired: (email, message) {
        state = AsyncValue.data(
          state.value!.copyWith(
            isLoading: false,
            errorMessage: message ?? 'Email verification required',
          ),
        );
        return false;
      },
    );
  }

  Future<void> signOut() async {
    state = AsyncValue.data(
      state.value!.copyWith(isLoading: true, errorMessage: null),
    );

    try {
      await _signOutUseCase();
      state = AsyncValue.data(AuthState(currentUser: null, isLoading: false));
    } catch (e) {
      state = AsyncValue.data(
        state.value!.copyWith(isLoading: false, errorMessage: e.toString()),
      );
    }
  }

  Future<bool> resetPassword(String email) async {
    state = AsyncValue.data(
      state.value!.copyWith(isLoading: true, errorMessage: null),
    );

    final result = await _resetPasswordUseCase(email);

    return result.when(
      success: (_) {
        state = AsyncValue.data(state.value!.copyWith(isLoading: false));
        return true;
      },
      failure: (message, errorType, code, details) {
        state = AsyncValue.data(
          state.value!.copyWith(isLoading: false, errorMessage: message),
        );
        return false;
      },
      loading: () {
        state = AsyncValue.data(state.value!.copyWith(isLoading: true));
        return false;
      },
      emailVerificationRequired: (email, message) {
        state = AsyncValue.data(
          state.value!.copyWith(
            isLoading: false,
            errorMessage: message ?? 'Email verification required',
          ),
        );
        return false;
      },
    );
  }

  void clearError() {
    state = AsyncValue.data(state.value!.copyWith(errorMessage: null));
  }
}

final authProvider = AsyncNotifierProvider<AuthNotifier, AuthState>(() {
  return AuthNotifier(
    getIt<SignInUseCase>(),
    getIt<SignUpUseCase>(),
    getIt<SignOutUseCase>(),
    getIt<ResetPasswordUseCase>(),
    getIt<GetCurrentUserUseCase>(),
  );
});
