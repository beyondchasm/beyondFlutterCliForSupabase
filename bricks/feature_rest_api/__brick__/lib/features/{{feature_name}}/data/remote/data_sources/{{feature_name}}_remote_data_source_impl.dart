import '{{feature_name}}_remote_data_source.dart';
import '../models/{{feature_name}}_remote_model.dart';

class {{feature_name.pascalCase()}}RemoteDataSourceImpl implements {{feature_name.pascalCase()}}RemoteDataSource {
  // TODO: Add HTTP client or other remote API implementation
  
  @override
  Future<List<{{feature_name.pascalCase()}}RemoteModel>> getAll() async {
    // TODO: Implement API call
    throw UnimplementedError();
  }

  @override
  Future<{{feature_name.pascalCase()}}RemoteModel?> getById(int id) async {
    // TODO: Implement API call
    throw UnimplementedError();
  }

  @override
  Future<{{feature_name.pascalCase()}}RemoteModel> create({{feature_name.pascalCase()}}RemoteModel model) async {
    // TODO: Implement API call
    throw UnimplementedError();
  }

  @override
  Future<{{feature_name.pascalCase()}}RemoteModel> update({{feature_name.pascalCase()}}RemoteModel model) async {
    // TODO: Implement API call
    throw UnimplementedError();
  }

  @override
  Future<bool> delete(int id) async {
    // TODO: Implement API call
    throw UnimplementedError();
  }
}