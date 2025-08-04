import '../entities/test_feature.dart';
import '../repositories/test_feature_repository.dart';

class CreateTestFeatureUseCase {
  final TestFeatureRepository repository;

  CreateTestFeatureUseCase(this.repository);

  Future<TestFeature> call(TestFeature entity) async {
    return await repository.create(entity);
  }
}