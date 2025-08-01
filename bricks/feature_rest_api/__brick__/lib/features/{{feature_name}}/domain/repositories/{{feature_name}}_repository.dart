import '../entities/{{feature_name}}.dart';

abstract class {{feature_name.pascalCase()}}Repository {
  Future<List<{{feature_name.pascalCase()}}>> getAll();
  Future<{{feature_name.pascalCase()}}?> getById(int id);
  Future<List<{{feature_name.pascalCase()}}>> getByDate(DateTime date);
  Future<{{feature_name.pascalCase()}}> create({{feature_name.pascalCase()}} entity);
  Future<{{feature_name.pascalCase()}}> update({{feature_name.pascalCase()}} entity);
  Future<bool> delete(int id);
}