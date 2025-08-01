import '../repositories/{{feature_name}}_repository.dart';

class Delete{{feature_name.pascalCase()}}UseCase {
  final {{feature_name.pascalCase()}}Repository repository;

  Delete{{feature_name.pascalCase()}}UseCase(this.repository);

  Future<bool> call(int id) async {
    return await repository.delete(id);
  }
}