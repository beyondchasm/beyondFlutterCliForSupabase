import '../entities/{{feature_name}}.dart';
import '../repositories/{{feature_name}}_repository.dart';

class Create{{feature_name.pascalCase()}}UseCase {
  final {{feature_name.pascalCase()}}Repository repository;

  Create{{feature_name.pascalCase()}}UseCase(this.repository);

  Future<{{feature_name.pascalCase()}}> call({{feature_name.pascalCase()}} entity) async {
    return await repository.create(entity);
  }
}