import '../models/rest_user_model.dart';

abstract class RestAuthRemoteDataSource {
  Future<RestUserModel> signInWithEmailAndPassword(String email, String password);
  Future<RestUserModel> signUpWithEmailAndPassword(String email, String password);
  Future<void> signOut();
  Future<void> resetPassword(String email);
  Future<RestUserModel?> getCurrentUser();
  Future<String> refreshToken();
}