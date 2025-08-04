import '../models/test_feature_local_model.dart';

abstract class TestFeatureLocalDataSource {
  Future<List<TestFeatureLocalModel>> getAll();
  Future<TestFeatureLocalModel?> getById(int id);
  Future<List<TestFeatureLocalModel>> getByDate(DateTime date);
  Future<int> create(TestFeatureLocalModel model);
  Future<bool> update(TestFeatureLocalModel model);
  Future<bool> delete(int id);
}