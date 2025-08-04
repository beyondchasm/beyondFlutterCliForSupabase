import '../entities/test_feature.dart';

abstract class TestFeatureRepository {
  Future<List<TestFeature>> getAll();
  Future<TestFeature?> getById(int id);
  Future<List<TestFeature>> getByDate(DateTime date);
  Future<TestFeature> create(TestFeature entity);
  Future<TestFeature> update(TestFeature entity);
  Future<bool> delete(int id);
}