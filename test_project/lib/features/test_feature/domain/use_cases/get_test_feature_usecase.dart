import '../entities/test_feature.dart';
import '../repositories/test_feature_repository.dart';

class GetTestFeatureUseCase {
  final TestFeatureRepository repository;

  GetTestFeatureUseCase(this.repository);

  Future<List<TestFeature>> call() async {
    return await repository.getAll();
  }

  Future<TestFeature?> getById(int id) async {
    return await repository.getById(id);
  }

  Future<List<TestFeature>> getByDate(DateTime date) async {
    return await repository.getByDate(date);
  }
}