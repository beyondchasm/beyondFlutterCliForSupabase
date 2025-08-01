import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/firebase_user_profile_model.dart';
import 'firebase_user_remote_data_source.dart';

class FirebaseUserRemoteDataSourceImpl implements FirebaseUserRemoteDataSource {
  final FirebaseFirestore _firestore;
  final String _collection = 'users';

  FirebaseUserRemoteDataSourceImpl({
    FirebaseFirestore? firestore,
  }) : _firestore = firestore ?? FirebaseFirestore.instance;

  @override
  Future<FirebaseUserProfileModel> getUserProfile(String userId) async {
    try {
      final doc = await _firestore.collection(_collection).doc(userId).get();
      
      if (!doc.exists) {
        throw Exception('User profile not found');
      }
      
      return FirebaseUserProfileModel.fromFirestore(doc);
    } catch (e) {
      throw Exception('Failed to get user profile: $e');
    }
  }

  @override
  Future<FirebaseUserProfileModel> updateUserProfile(FirebaseUserProfileModel userProfile) async {
    try {
      final updatedProfile = userProfile.copyWith(updatedAt: DateTime.now());
      await _firestore
          .collection(_collection)
          .doc(userProfile.id)
          .set(updatedProfile.toFirestore(), SetOptions(merge: true));
      
      return updatedProfile;
    } catch (e) {
      throw Exception('Failed to update user profile: $e');
    }
  }

  @override
  Future<void> deleteUserProfile(String userId) async {
    try {
      await _firestore.collection(_collection).doc(userId).delete();
    } catch (e) {
      throw Exception('Failed to delete user profile: $e');
    }
  }

  @override
  Stream<FirebaseUserProfileModel?> getUserProfileStream(String userId) {
    return _firestore
        .collection(_collection)
        .doc(userId)
        .snapshots()
        .map((snapshot) {
      if (!snapshot.exists) {
        return null;
      }
      return FirebaseUserProfileModel.fromFirestore(snapshot);
    });
  }
}