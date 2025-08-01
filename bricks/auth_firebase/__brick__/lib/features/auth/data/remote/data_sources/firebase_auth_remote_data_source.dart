import '../models/firebase_user_model.dart';

abstract class FirebaseAuthRemoteDataSource {
  Future<FirebaseUserModel> signInWithEmailAndPassword(String email, String password);
  Future<FirebaseUserModel> createUserWithEmailAndPassword(String email, String password);
  Future<void> signOut();
  Future<void> resetPassword(String email);
  Future<FirebaseUserModel?> getCurrentUser();
  Stream<FirebaseUserModel?> get authStateChanges;
  Future<FirebaseUserModel> signInWithGoogle();
  Future<void> sendEmailVerification();
}