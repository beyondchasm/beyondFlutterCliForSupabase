import 'package:cloud_firestore/cloud_firestore.dart';
import '{{feature_name}}_remote_data_source.dart';
import '../models/{{feature_name}}_remote_model.dart';

class {{feature_name.pascalCase()}}RemoteDataSourceImpl implements {{feature_name.pascalCase()}}RemoteDataSource {
  final FirebaseFirestore _firestore;
  final String _collectionName = '{{feature_name}}s';

  {{feature_name.pascalCase()}}RemoteDataSourceImpl({
    FirebaseFirestore? firestore,
  }) : _firestore = firestore ?? FirebaseFirestore.instance;

  @override
  Future<List<{{feature_name.pascalCase()}}RemoteModel>> getAll() async {
    try {
      final querySnapshot = await _firestore
          .collection(_collectionName)
          .orderBy('createdAt', descending: true)
          .get();

      return querySnapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id; // Firestore document ID를 모델 ID로 사용
        return {{feature_name.pascalCase()}}RemoteModel.fromJson(data);
      }).toList();
    } catch (e) {
      throw Exception('Failed to fetch {{feature_name}}s: $e');
    }
  }

  @override
  Future<{{feature_name.pascalCase()}}RemoteModel?> getById(String id) async {
    try {
      final docSnapshot = await _firestore
          .collection(_collectionName)
          .doc(id)
          .get();

      if (!docSnapshot.exists) {
        return null;
      }

      final data = docSnapshot.data()!;
      data['id'] = docSnapshot.id;
      return {{feature_name.pascalCase()}}RemoteModel.fromJson(data);
    } catch (e) {
      throw Exception('Failed to fetch {{feature_name}} with id $id: $e');
    }
  }

  @override
  Future<{{feature_name.pascalCase()}}RemoteModel> create({{feature_name.pascalCase()}}RemoteModel model) async {
    try {
      final now = DateTime.now().toIso8601String();
      final data = model.toJson()..remove('id'); // ID는 Firestore가 자동 생성
      data['createdAt'] = now;
      data['updatedAt'] = now;

      final docRef = await _firestore
          .collection(_collectionName)
          .add(data);

      final createdData = data;
      createdData['id'] = docRef.id;
      return {{feature_name.pascalCase()}}RemoteModel.fromJson(createdData);
    } catch (e) {
      throw Exception('Failed to create {{feature_name}}: $e');
    }
  }

  @override
  Future<{{feature_name.pascalCase()}}RemoteModel> update({{feature_name.pascalCase()}}RemoteModel model) async {
    try {
      if (model.id == null) {
        throw Exception('Cannot update {{feature_name}} without ID');
      }

      final data = model.toJson()..remove('id');
      data['updatedAt'] = DateTime.now().toIso8601String();

      await _firestore
          .collection(_collectionName)
          .doc(model.id)
          .update(data);

      return model.copyWith(updatedAt: DateTime.now().toIso8601String());
    } catch (e) {
      throw Exception('Failed to update {{feature_name}}: $e');
    }
  }

  @override
  Future<bool> delete(String id) async {
    try {
      await _firestore
          .collection(_collectionName)
          .doc(id)
          .delete();
      return true;
    } catch (e) {
      throw Exception('Failed to delete {{feature_name}} with id $id: $e');
    }
  }

  /// 실시간 스트림으로 모든 {{feature_name}}s 가져오기
  Stream<List<{{feature_name.pascalCase()}}RemoteModel>> getAllStream() {
    return _firestore
        .collection(_collectionName)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id;
        return {{feature_name.pascalCase()}}RemoteModel.fromJson(data);
      }).toList();
    });
  }

  /// 특정 {{feature_name}} 실시간 스트림
  Stream<{{feature_name.pascalCase()}}RemoteModel?> getByIdStream(String id) {
    return _firestore
        .collection(_collectionName)
        .doc(id)
        .snapshots()
        .map((snapshot) {
      if (!snapshot.exists) return null;

      final data = snapshot.data()!;
      data['id'] = snapshot.id;
      return {{feature_name.pascalCase()}}RemoteModel.fromJson(data);
    });
  }
}