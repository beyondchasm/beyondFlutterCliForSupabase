import '../models/{{feature_name}}_local_model.dart';

abstract class {{feature_name.pascalCase()}}LocalDataSource {
  Future<List<{{feature_name.pascalCase()}}LocalModel>> getAll();
  Future<{{feature_name.pascalCase()}}LocalModel?> getById(int id);
  Future<List<{{feature_name.pascalCase()}}LocalModel>> getByDate(DateTime date);
  Future<int> create({{feature_name.pascalCase()}}LocalModel model);
  Future<bool> update({{feature_name.pascalCase()}}LocalModel model);
  Future<bool> delete(int id);
}