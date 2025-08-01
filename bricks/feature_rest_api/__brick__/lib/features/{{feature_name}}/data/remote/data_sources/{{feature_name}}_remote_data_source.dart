import '../models/{{feature_name}}_remote_model.dart';

abstract class {{feature_name.pascalCase()}}RemoteDataSource {
  Future<List<{{feature_name.pascalCase()}}RemoteModel>> getAll();
  Future<{{feature_name.pascalCase()}}RemoteModel?> getById(int id);
  Future<{{feature_name.pascalCase()}}RemoteModel> create({{feature_name.pascalCase()}}RemoteModel model);
  Future<{{feature_name.pascalCase()}}RemoteModel> update({{feature_name.pascalCase()}}RemoteModel model);
  Future<bool> delete(int id);
}