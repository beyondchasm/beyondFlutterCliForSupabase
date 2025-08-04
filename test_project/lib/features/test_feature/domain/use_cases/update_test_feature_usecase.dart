import '../entities/test_feature.dart';
import '../repositories/test_feature_repository.dart';

class UpdateTestFeatureUseCase {
  final TestFeatureRepository repository;

  UpdateTestFeatureUseCase(this.repository);

  Future<TestFeature> call(TestFeature entity) async {
    return await repository.update(entity);
  }
}