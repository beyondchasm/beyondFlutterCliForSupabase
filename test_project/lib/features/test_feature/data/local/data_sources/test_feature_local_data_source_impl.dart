import 'test_feature_local_data_source.dart';
import '../models/test_feature_local_model.dart';

class TestFeatureLocalDataSourceImpl implements TestFeatureLocalDataSource {
  // TODO: Add ObjectBox or other local storage implementation
  
  @override
  Future<List<TestFeatureLocalModel>> getAll() async {
    // TODO: Implement
    throw UnimplementedError();
  }

  @override
  Future<TestFeatureLocalModel?> getById(int id) async {
    // TODO: Implement
    throw UnimplementedError();
  }

  @override
  Future<List<TestFeatureLocalModel>> getByDate(DateTime date) async {
    // TODO: Implement
    throw UnimplementedError();
  }

  @override
  Future<int> create(TestFeatureLocalModel model) async {
    // TODO: Implement
    throw UnimplementedError();
  }

  @override
  Future<bool> update(TestFeatureLocalModel model) async {
    // TODO: Implement
    throw UnimplementedError();
  }

  @override
  Future<bool> delete(int id) async {
    // TODO: Implement
    throw UnimplementedError();
  }
}