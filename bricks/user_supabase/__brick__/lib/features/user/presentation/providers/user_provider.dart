import 'dart:async';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import '../../domain/entities/user_profile.dart';
import '../../domain/use_cases/get_user_profile_usecase.dart';
import '../../domain/use_cases/create_user_profile_usecase.dart';
import '../../domain/use_cases/update_user_profile_usecase.dart';
import '../../domain/use_cases/delete_user_profile_usecase.dart';
import '../../domain/use_cases/upload_profile_image_usecase.dart';
import '../../domain/use_cases/search_user_profiles_usecase.dart';

@injectable
class UserProvider extends ChangeNotifier {
  final GetUserProfileUseCase _getUserProfileUseCase;
  final CreateUserProfileUseCase _createUserProfileUseCase;
  final UpdateUserProfileUseCase _updateUserProfileUseCase;
  final DeleteUserProfileUseCase _deleteUserProfileUseCase;
  final UploadProfileImageUseCase _uploadProfileImageUseCase;
  final SearchUserProfilesUseCase _searchUserProfilesUseCase;

  UserProvider(
    this._getUserProfileUseCase,
    this._createUserProfileUseCase,
    this._updateUserProfileUseCase,
    this._deleteUserProfileUseCase,
    this._uploadProfileImageUseCase,
    this._searchUserProfilesUseCase,
  );

  UserProfile? _userProfile;
  List<UserProfile> _searchResults = [];
  bool _isLoading = false;
  bool _isUploading = false;
  bool _isSearching = false;
  String? _error;
  StreamSubscription<UserProfile?>? _userProfileSubscription;

  UserProfile? get userProfile => _userProfile;
  List<UserProfile> get searchResults => _searchResults;
  bool get isLoading => _isLoading;
  bool get isUploading => _isUploading;
  bool get isSearching => _isSearching;
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

  Future<void> createUserProfile(UserProfile userProfile) async {
    _setLoading(true);
    _setError(null);

    try {
      _userProfile = await _createUserProfileUseCase.call(userProfile);
      notifyListeners();
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  Future<String?> uploadProfileImage(String userId, String filePath) async {
    _setUploading(true);
    _setError(null);

    try {
      final imageUrl = await _uploadProfileImageUseCase.call(userId, filePath);
      
      if (_userProfile != null) {
        _userProfile = _userProfile!.copyWith(photoUrl: imageUrl);
        notifyListeners();
      }
      
      return imageUrl;
    } catch (e) {
      _setError(e.toString());
      return null;
    } finally {
      _setUploading(false);
    }
  }

  Future<void> searchUserProfiles(String query, {int limit = 20}) async {
    if (query.trim().isEmpty) {
      _searchResults = [];
      notifyListeners();
      return;
    }

    _setSearching(true);
    _setError(null);

    try {
      _searchResults = await _searchUserProfilesUseCase.call(query, limit: limit);
      notifyListeners();
    } catch (e) {
      _setError(e.toString());
      _searchResults = [];
    } finally {
      _setSearching(false);
    }
  }

  void clearSearchResults() {
    _searchResults = [];
    notifyListeners();
  }

  void _setUploading(bool uploading) {
    _isUploading = uploading;
    notifyListeners();
  }

  void _setSearching(bool searching) {
    _isSearching = searching;
    notifyListeners();
  }

  @override
  void dispose() {
    _userProfileSubscription?.cancel();
    super.dispose();
  }
}