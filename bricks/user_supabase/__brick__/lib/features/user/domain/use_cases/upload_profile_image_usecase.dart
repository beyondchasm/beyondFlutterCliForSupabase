import 'package:injectable/injectable.dart';
import '../repositories/user_repository.dart';

@lazySingleton
class UploadProfileImageUseCase {
  final UserRepository _repository;

  UploadProfileImageUseCase(this._repository);

  Future<String> call(String userId, String filePath) async {
    if (userId.isEmpty) {
      throw Exception('User ID cannot be empty');
    }

    if (filePath.isEmpty) {
      throw Exception('File path cannot be empty');
    }

    final supportedExtensions = ['jpg', 'jpeg', 'png', 'webp'];
    final fileExtension = filePath.split('.').last.toLowerCase();
    
    if (!supportedExtensions.contains(fileExtension)) {
      throw Exception('Unsupported file type. Supported types: ${supportedExtensions.join(', ')}');
    }

    return await _repository.uploadProfileImage(userId, filePath);
  }
}