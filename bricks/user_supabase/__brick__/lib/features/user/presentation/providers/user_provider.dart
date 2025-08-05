import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:injectable/injectable.dart';
import '../../domain/entities/user_profile.dart';
import '../../domain/use_cases/get_user_profile_usecase.dart';
import '../../domain/use_cases/create_user_profile_usecase.dart';
import '../../domain/use_cases/update_user_profile_usecase.dart';
import '../../domain/use_cases/delete_user_profile_usecase.dart';
import '../../domain/use_cases/upload_profile_image_usecase.dart';
import '../../domain/use_cases/search_user_profiles_usecase.dart';
import '../../../../core/di/injection.dart';

class UserState {
  final UserProfile? userProfile;
  final List<UserProfile> searchResults;
  final bool isLoading;
  final bool isUploading;
  final bool isSearching;
  final String? error;

  const UserState({
    this.userProfile,
    this.searchResults = const [],
    this.isLoading = false,
    this.isUploading = false,
    this.isSearching = false,
    this.error,
  });

  UserState copyWith({
    UserProfile? userProfile,
    List<UserProfile>? searchResults,
    bool? isLoading,
    bool? isUploading,
    bool? isSearching,
    String? error,
  }) {
    return UserState(
      userProfile: userProfile ?? this.userProfile,
      searchResults: searchResults ?? this.searchResults,
      isLoading: isLoading ?? this.isLoading,
      isUploading: isUploading ?? this.isUploading,
      isSearching: isSearching ?? this.isSearching,
      error: error ?? this.error,
    );
  }
}

@injectable
class UserNotifier extends AsyncNotifier<UserState> {
  final GetUserProfileUseCase _getUserProfileUseCase;
  final CreateUserProfileUseCase _createUserProfileUseCase;
  final UpdateUserProfileUseCase _updateUserProfileUseCase;
  final DeleteUserProfileUseCase _deleteUserProfileUseCase;
  final UploadProfileImageUseCase _uploadProfileImageUseCase;
  final SearchUserProfilesUseCase _searchUserProfilesUseCase;

  UserNotifier(
    this._getUserProfileUseCase,
    this._createUserProfileUseCase,
    this._updateUserProfileUseCase,
    this._deleteUserProfileUseCase,
    this._uploadProfileImageUseCase,
    this._searchUserProfilesUseCase,
  );

  StreamSubscription<UserProfile?>? _userProfileSubscription;

  @override
  FutureOr<UserState> build() async {
    return const UserState();
  }

  Future<void> getUserProfile(String userId) async {
    state = AsyncValue.data(
      state.value!.copyWith(isLoading: true, error: null),
    );

    try {
      final userProfile = await _getUserProfileUseCase.call(userId);
      state = AsyncValue.data(
        state.value!.copyWith(userProfile: userProfile, isLoading: false),
      );
    } catch (e) {
      state = AsyncValue.data(
        state.value!.copyWith(isLoading: false, error: e.toString()),
      );
    }
  }

  void subscribeToUserProfile(String userId) {
    _userProfileSubscription?.cancel();
    _userProfileSubscription = _getUserProfileUseCase
        .getStream(userId)
        .listen(
          (userProfile) {
            state = AsyncValue.data(
              state.value!.copyWith(userProfile: userProfile, error: null),
            );
          },
          onError: (error) {
            state = AsyncValue.data(
              state.value!.copyWith(error: error.toString()),
            );
          },
        );
  }

  Future<void> updateUserProfile(UserProfile userProfile) async {
    state = AsyncValue.data(
      state.value!.copyWith(isLoading: true, error: null),
    );

    try {
      final updatedProfile = await _updateUserProfileUseCase.call(userProfile);
      state = AsyncValue.data(
        state.value!.copyWith(userProfile: updatedProfile, isLoading: false),
      );
    } catch (e) {
      state = AsyncValue.data(
        state.value!.copyWith(isLoading: false, error: e.toString()),
      );
    }
  }

  Future<void> deleteUserProfile(String userId) async {
    state = AsyncValue.data(
      state.value!.copyWith(isLoading: true, error: null),
    );

    try {
      await _deleteUserProfileUseCase.call(userId);
      state = AsyncValue.data(
        state.value!.copyWith(userProfile: null, isLoading: false),
      );
    } catch (e) {
      state = AsyncValue.data(
        state.value!.copyWith(isLoading: false, error: e.toString()),
      );
    }
  }

  void clearError() {
    state = AsyncValue.data(state.value!.copyWith(error: null));
  }

  Future<void> createUserProfile(UserProfile userProfile) async {
    state = AsyncValue.data(
      state.value!.copyWith(isLoading: true, error: null),
    );

    try {
      final createdProfile = await _createUserProfileUseCase.call(userProfile);
      state = AsyncValue.data(
        state.value!.copyWith(userProfile: createdProfile, isLoading: false),
      );
    } catch (e) {
      state = AsyncValue.data(
        state.value!.copyWith(isLoading: false, error: e.toString()),
      );
    }
  }

  Future<String?> uploadProfileImage(String userId, String filePath) async {
    state = AsyncValue.data(
      state.value!.copyWith(isUploading: true, error: null),
    );

    try {
      final imageUrl = await _uploadProfileImageUseCase.call(userId, filePath);

      if (state.value!.userProfile != null) {
        final updatedProfile = state.value!.userProfile!.copyWith(
          photoUrl: imageUrl,
        );
        state = AsyncValue.data(
          state.value!.copyWith(
            userProfile: updatedProfile,
            isUploading: false,
          ),
        );
      } else {
        state = AsyncValue.data(state.value!.copyWith(isUploading: false));
      }

      return imageUrl;
    } catch (e) {
      state = AsyncValue.data(
        state.value!.copyWith(isUploading: false, error: e.toString()),
      );
      return null;
    }
  }

  Future<void> searchUserProfiles(String query, {int limit = 20}) async {
    if (query.trim().isEmpty) {
      state = AsyncValue.data(state.value!.copyWith(searchResults: []));
      return;
    }

    state = AsyncValue.data(
      state.value!.copyWith(isSearching: true, error: null),
    );

    try {
      final searchResults = await _searchUserProfilesUseCase.call(
        query,
        limit: limit,
      );
      state = AsyncValue.data(
        state.value!.copyWith(searchResults: searchResults, isSearching: false),
      );
    } catch (e) {
      state = AsyncValue.data(
        state.value!.copyWith(
          isSearching: false,
          error: e.toString(),
          searchResults: [],
        ),
      );
    }
  }

  void clearSearchResults() {
    state = AsyncValue.data(state.value!.copyWith(searchResults: []));
  }
}

final userProvider = AsyncNotifierProvider<UserNotifier, UserState>(() {
  return getIt<UserNotifier>();
});
