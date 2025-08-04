import '../repositories/test_feature_repository.dart';

class DeleteTestFeatureUseCase {
  final TestFeatureRepository repository;

  DeleteTestFeatureUseCase(this.repository);

  Future<bool> call(int id) async {
    return await repository.delete(id);
  }
}