import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/supabase_user_model.dart';
import 'supabase_auth_remote_data_source.dart';

@LazySingleton(as: SupabaseAuthRemoteDataSource)
class SupabaseAuthRemoteDataSourceImpl implements SupabaseAuthRemoteDataSource {
  final SupabaseClient _supabaseClient;

  SupabaseAuthRemoteDataSourceImpl(@Named('supabaseClient') this._supabaseClient);

  @override
  Future<SupabaseUserModel> signInWithEmailAndPassword(String email, String password) async {
    try {
      final response = await _supabaseClient.auth.signInWithPassword(
        email: email,
        password: password,
      );
      
      if (response.user == null) {
        throw Exception('Sign in failed');
      }
      
      return SupabaseUserModel.fromSupabaseUser(response.user!);
    } on AuthException catch (e) {
      throw Exception(_getAuthErrorMessage(e.message));
    }
  }

  @override
  Future<SupabaseUserModel> signUpWithEmailAndPassword(String email, String password) async {
    try {
      final response = await _supabaseClient.auth.signUp(
        email: email,
        password: password,
      );
      
      if (response.user == null) {
        throw Exception('Sign up failed');
      }
      
      return SupabaseUserModel.fromSupabaseUser(response.user!);
    } on AuthException catch (e) {
      throw Exception(_getAuthErrorMessage(e.message));
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await _supabaseClient.auth.signOut();
    } on AuthException catch (e) {
      throw Exception(_getAuthErrorMessage(e.message));
    }
  }

  @override
  Future<void> resetPassword(String email) async {
    try {
      await _supabaseClient.auth.resetPasswordForEmail(email);
    } on AuthException catch (e) {
      throw Exception(_getAuthErrorMessage(e.message));
    }
  }

  @override
  Future<SupabaseUserModel?> getCurrentUser() async {
    final user = _supabaseClient.auth.currentUser;
    return user != null ? SupabaseUserModel.fromSupabaseUser(user) : null;
  }

  @override
  Stream<SupabaseUserModel?> get authStateChanges {
    return _supabaseClient.auth.onAuthStateChange.map((data) {
      final user = data.session?.user;
      return user != null ? SupabaseUserModel.fromSupabaseUser(user) : null;
    });
  }

  @override
  Future<SupabaseUserModel> signInWithGoogle() async {
    try {
      final response = await _supabaseClient.auth.signInWithOAuth(
        OAuthProvider.google,
      );
      
      if (response == false) {
        throw Exception('Google sign in was cancelled or failed');
      }

      // Wait for auth state change
      await Future.delayed(const Duration(seconds: 2));
      
      final user = _supabaseClient.auth.currentUser;
      if (user == null) {
        throw Exception('Google sign in failed - no user found');
      }
      
      return SupabaseUserModel.fromSupabaseUser(user);
    } catch (e) {
      throw Exception('Google sign in failed: $e');
    }
  }

  @override
  Future<void> confirmEmail(String token) async {
    try {
      await _supabaseClient.auth.verifyOTP(
        type: OtpType.email,
        token: token,
        email: '', // Email should be provided in real implementation
      );
    } on AuthException catch (e) {
      throw Exception(_getAuthErrorMessage(e.message));
    }
  }

  String _getAuthErrorMessage(String message) {
    if (message.contains('Invalid login credentials')) {
      return 'Invalid email or password.';
    } else if (message.contains('Email not confirmed')) {
      return 'Please confirm your email address.';
    } else if (message.contains('User already registered')) {
      return 'An account with this email already exists.';
    } else if (message.contains('Password should be at least')) {
      return 'Password should be at least 6 characters long.';
    } else if (message.contains('Unable to validate email address')) {
      return 'Please enter a valid email address.';
    } else if (message.contains('Signup is disabled')) {
      return 'New user registration is currently disabled.';
    }
    return message.isNotEmpty ? message : 'An unexpected error occurred. Please try again.';
  }
}