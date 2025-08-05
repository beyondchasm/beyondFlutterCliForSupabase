import 'package:injectable/injectable.dart';
import '../entities/user_profile.dart';
import '../repositories/user_repository.dart';

@lazySingleton
class SearchUserProfilesUseCase {
  final UserRepository _repository;

  SearchUserProfilesUseCase(this._repository);

  Future<List<UserProfile>> call(String query, {int limit = 20}) async {
    if (query.trim().isEmpty) {
      return [];
    }

    if (query.trim().length < 2) {
      throw Exception('Search query must be at least 2 characters long');
    }

    if (limit <= 0 || limit > 100) {
      throw Exception('Limit must be between 1 and 100');
    }

    return await _repository.searchUserProfiles(query.trim(), limit: limit);
  }
}