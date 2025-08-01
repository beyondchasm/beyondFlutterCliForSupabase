import '../entities/auth_result.dart';
import '../entities/user_entity.dart';

abstract class AuthRepository {
  Future<AuthResult> signInWithEmailAndPassword(String email, String password);
  Future<AuthResult> signUpWithEmailAndPassword(String email, String password);
  Future<void> signOut();
  Future<AuthResult> resetPassword(String email);
  Future<UserEntity?> getCurrentUser();
  Stream<UserEntity?> get authStateChanges;
  Future<AuthResult> signInWithGoogle();
  Future<void> confirmEmail(String token);
}