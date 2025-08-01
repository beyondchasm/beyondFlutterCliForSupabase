import '{{feature_name}}_local_data_source.dart';
import '../models/{{feature_name}}_local_model.dart';

class {{feature_name.pascalCase()}}LocalDataSourceImpl implements {{feature_name.pascalCase()}}LocalDataSource {
  // TODO: Add ObjectBox or other local storage implementation
  
  @override
  Future<List<{{feature_name.pascalCase()}}LocalModel>> getAll() async {
    // TODO: Implement
    throw UnimplementedError();
  }

  @override
  Future<{{feature_name.pascalCase()}}LocalModel?> getById(int id) async {
    // TODO: Implement
    throw UnimplementedError();
  }

  @override
  Future<List<{{feature_name.pascalCase()}}LocalModel>> getByDate(DateTime date) async {
    // TODO: Implement
    throw UnimplementedError();
  }

  @override
  Future<int> create({{feature_name.pascalCase()}}LocalModel model) async {
    // TODO: Implement
    throw UnimplementedError();
  }

  @override
  Future<bool> update({{feature_name.pascalCase()}}LocalModel model) async {
    // TODO: Implement
    throw UnimplementedError();
  }

  @override
  Future<bool> delete(int id) async {
    // TODO: Implement
    throw UnimplementedError();
  }
}