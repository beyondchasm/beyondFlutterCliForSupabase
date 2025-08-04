import '../models/test_feature_remote_model.dart';

abstract class TestFeatureRemoteDataSource {
  Future<List<TestFeatureRemoteModel>> getAll();
  Future<TestFeatureRemoteModel?> getById(int id);
  Future<TestFeatureRemoteModel> create(TestFeatureRemoteModel model);
  Future<TestFeatureRemoteModel> update(TestFeatureRemoteModel model);
  Future<bool> delete(int id);
}