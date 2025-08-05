import '../models/supabase_user_model.dart';

abstract class SupabaseAuthRemoteDataSource {
  Future<SupabaseUserModel> signInWithEmailAndPassword(String email, String password);
  Future<SupabaseUserModel> signUpWithEmailAndPassword(String email, String password);
  Future<void> signOut();
  Future<void> resetPassword(String email);
  Future<SupabaseUserModel?> getCurrentUser();
  Stream<SupabaseUserModel?> get authStateChanges;
  Future<SupabaseUserModel> signInWithGoogle();
  Future<SupabaseUserModel> signInWithApple();
  Future<void> confirmEmail(String token);
  Future<void> resendEmailConfirmation(String email);
  Future<void> updatePassword(String newPassword);
  Future<void> updateEmail(String newEmail);
  Future<bool> verifySession();
  Future<void> refreshSession();
  Future<Map<String, dynamic>> getSessionInfo();
}