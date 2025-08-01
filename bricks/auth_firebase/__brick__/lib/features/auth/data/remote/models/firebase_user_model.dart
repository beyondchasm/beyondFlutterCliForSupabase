import 'package:firebase_auth/firebase_auth.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../domain/entities/user_entity.dart';

part 'freezed/firebase_user_model.freezed.dart';
part 'freezed/firebase_user_model.g.dart';

@freezed
class FirebaseUserModel with _$FirebaseUserModel {
  const factory FirebaseUserModel({
    required String uid,
    required String email,
    String? displayName,
    String? photoURL,
    required bool emailVerified,
    required DateTime createdAt,
    DateTime? lastSignInAt,
  }) = _FirebaseUserModel;

  const FirebaseUserModel._();

  factory FirebaseUserModel.fromJson(Map<String, dynamic> json) =>
      _$FirebaseUserModelFromJson(json);

  factory FirebaseUserModel.fromFirebaseUser(User user) {
    return FirebaseUserModel(
      uid: user.uid,
      email: user.email ?? '',
      displayName: user.displayName,
      photoURL: user.photoURL,
      emailVerified: user.emailVerified,
      createdAt: user.metadata.creationTime ?? DateTime.now(),
      lastSignInAt: user.metadata.lastSignInTime,
    );
  }

  UserEntity toEntity() {
    return UserEntity(
      uid: uid,
      email: email,
      displayName: displayName,
      photoURL: photoURL,
      emailVerified: emailVerified,
      createdAt: createdAt,
      lastSignInAt: lastSignInAt,
    );
  }
}