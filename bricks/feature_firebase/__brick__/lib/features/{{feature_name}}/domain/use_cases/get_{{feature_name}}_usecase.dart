import '../entities/{{feature_name}}.dart';
import '../repositories/{{feature_name}}_repository.dart';

class Get{{feature_name.pascalCase()}}UseCase {
  final {{feature_name.pascalCase()}}Repository repository;

  Get{{feature_name.pascalCase()}}UseCase(this.repository);

  Future<List<{{feature_name.pascalCase()}}>> call() async {
    return await repository.getAll();
  }

  Future<{{feature_name.pascalCase()}}?> getById(int id) async {
    return await repository.getById(id);
  }

  Future<List<{{feature_name.pascalCase()}}>> getByDate(DateTime date) async {
    return await repository.getByDate(date);
  }
}