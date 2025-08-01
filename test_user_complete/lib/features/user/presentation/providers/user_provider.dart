import 'dart:async';
import 'package:flutter/material.dart';
import '../../domain/entities/user_profile.dart';
import '../../domain/use_cases/get_user_profile_usecase.dart';
import '../../domain/use_cases/update_user_profile_usecase.dart';
import '../../domain/use_cases/delete_user_profile_usecase.dart';
import '../../../../core/di/service_locator.dart';

class UserProvider extends ChangeNotifier {
  final GetUserProfileUseCase _getUserProfileUseCase;
  final UpdateUserProfileUseCase _updateUserProfileUseCase;
  final DeleteUserProfileUseCase _deleteUserProfileUseCase;

  UserProvider()
      : _getUserProfileUseCase = ServiceLocator.get<GetUserProfileUseCase>(),
        _updateUserProfileUseCase = ServiceLocator.get<UpdateUserProfileUseCase>(),
        _deleteUserProfileUseCase = ServiceLocator.get<DeleteUserProfileUseCase>();

  UserProfile? _userProfile;
  bool _isLoading = false;
  String? _error;
  StreamSubscription<UserProfile?>? _userProfileSubscription;

  UserProfile? get userProfile => _userProfile;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> getUserProfile(String userId) async {
    _setLoading(true);
    _setError(null);

    try {
      _userProfile = await _getUserProfileUseCase.call(userId);
      notifyListeners();
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  void subscribeToUserProfile(String userId) {
    _userProfileSubscription?.cancel();
    _userProfileSubscription = _getUserProfileUseCase.getStream(userId).listen(
      (userProfile) {
        _userProfile = userProfile;
        _setError(null);
        notifyListeners();
      },
      onError: (error) {
        _setError(error.toString());
      },
    );
  }

  Future<void> updateUserProfile(UserProfile userProfile) async {
    _setLoading(true);
    _setError(null);

    try {
      _userProfile = await _updateUserProfileUseCase.call(userProfile);
      notifyListeners();
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  Future<void> deleteUserProfile(String userId) async {
    _setLoading(true);
    _setError(null);

    try {
      await _deleteUserProfileUseCase.call(userId);
      _userProfile = null;
      notifyListeners();
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String? error) {
    _error = error;
    notifyListeners();
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }

  @override
  void dispose() {
    _userProfileSubscription?.cancel();
    super.dispose();
  }
}