import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../domain/entities/user_profile.dart';

part 'firebase_user_profile_model.freezed.dart';
part 'firebase_user_profile_model.g.dart';

@freezed
class FirebaseUserProfileModel with _$FirebaseUserProfileModel {
  const factory FirebaseUserProfileModel({
    required String id,
    required String email,
    String? displayName,
    String? photoUrl,
    String? phoneNumber,
    Map<String, dynamic>? customClaims,
    @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
    required DateTime createdAt,
    @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
    DateTime? lastSignInAt,
    @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
    DateTime? updatedAt,
  }) = _FirebaseUserProfileModel;

  const FirebaseUserProfileModel._();

  factory FirebaseUserProfileModel.fromJson(Map<String, dynamic> json) =>
      _$FirebaseUserProfileModelFromJson(json);

  UserProfile toEntity() {
    return UserProfile(
      id: id,
      email: email,
      displayName: displayName,
      photoUrl: photoUrl,
      phoneNumber: phoneNumber,
      customClaims: customClaims,
      createdAt: createdAt,
      lastSignInAt: lastSignInAt,
      updatedAt: updatedAt,
    );
  }

  factory FirebaseUserProfileModel.fromEntity(UserProfile entity) {
    return FirebaseUserProfileModel(
      id: entity.id,
      email: entity.email,
      displayName: entity.displayName,
      photoUrl: entity.photoUrl,
      phoneNumber: entity.phoneNumber,
      customClaims: entity.customClaims,
      createdAt: entity.createdAt,
      lastSignInAt: entity.lastSignInAt,
      updatedAt: entity.updatedAt,
    );
  }

  factory FirebaseUserProfileModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>?;
    if (data == null) {
      throw Exception('Document data is null');
    }
    
    return FirebaseUserProfileModel(
      id: doc.id,
      email: data['email'] ?? '',
      displayName: data['displayName'],
      photoUrl: data['photoUrl'],
      phoneNumber: data['phoneNumber'],
      customClaims: data['customClaims'] != null 
          ? Map<String, dynamic>.from(data['customClaims'])
          : null,
      createdAt: data['createdAt'] is Timestamp
          ? (data['createdAt'] as Timestamp).toDate()
          : DateTime.parse(data['createdAt']),
      lastSignInAt: data['lastSignInAt'] != null
          ? (data['lastSignInAt'] is Timestamp
              ? (data['lastSignInAt'] as Timestamp).toDate()
              : DateTime.parse(data['lastSignInAt']))
          : null,
      updatedAt: data['updatedAt'] != null
          ? (data['updatedAt'] is Timestamp
              ? (data['updatedAt'] as Timestamp).toDate()
              : DateTime.parse(data['updatedAt']))
          : null,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'email': email,
      'displayName': displayName,
      'photoUrl': photoUrl,
      'phoneNumber': phoneNumber,
      'customClaims': customClaims,
      'createdAt': Timestamp.fromDate(createdAt),
      'lastSignInAt': lastSignInAt != null ? Timestamp.fromDate(lastSignInAt!) : null,
      'updatedAt': updatedAt != null ? Timestamp.fromDate(updatedAt!) : null,
    };
  }
}

DateTime _timestampFromJson(dynamic timestamp) {
  if (timestamp is Timestamp) {
    return timestamp.toDate();
  } else if (timestamp is String) {
    return DateTime.parse(timestamp);
  } else {
    return DateTime.now();
  }
}

dynamic _timestampToJson(DateTime dateTime) {
  return Timestamp.fromDate(dateTime);
}