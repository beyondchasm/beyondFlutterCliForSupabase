import '../local/data_sources/{{feature_name}}_local_data_source.dart';
import '../remote/data_sources/{{feature_name}}_remote_data_source.dart';
import '../local/models/{{feature_name}}_local_model.dart';
import '../remote/models/{{feature_name}}_remote_model.dart';
import '../../domain/entities/{{feature_name}}.dart';
import '../../domain/repositories/{{feature_name}}_repository.dart';

class {{feature_name.pascalCase()}}RepositoryImpl implements {{feature_name.pascalCase()}}Repository {
  final {{feature_name.pascalCase()}}LocalDataSource localDataSource;
  final {{feature_name.pascalCase()}}RemoteDataSource remoteDataSource;

  {{feature_name.pascalCase()}}RepositoryImpl({
    required this.localDataSource,
    required this.remoteDataSource,
  });

  @override
  Future<List<{{feature_name.pascalCase()}}>> getAll() async {
    try {
      final remoteData = await remoteDataSource.getAll();
      final entities = remoteData.map((model) => model.toEntity()).toList();
      
      // Cache to local storage
      for (final entity in entities) {
        final localModel = {{feature_name.pascalCase()}}LocalModel.fromEntity(entity);
        await localDataSource.create(localModel);
      }
      
      return entities;
    } catch (e) {
      // Fallback to local data
      final localData = await localDataSource.getAll();
      return localData.map((model) => model.toEntity()).toList();
    }
  }

  @override
  Future<{{feature_name.pascalCase()}}?> getById(int id) async {
    try {
      final remoteData = await remoteDataSource.getById(id);
      if (remoteData != null) {
        final entity = remoteData.toEntity();
        
        // Cache to local storage
        final localModel = {{feature_name.pascalCase()}}LocalModel.fromEntity(entity);
        await localDataSource.update(localModel);
        
        return entity;
      }
    } catch (e) {
      // Fallback to local data
      final localData = await localDataSource.getById(id);
      return localData?.toEntity();
    }
    return null;
  }

  @override
  Future<List<{{feature_name.pascalCase()}}>> getByDate(DateTime date) async {
    final localData = await localDataSource.getByDate(date);
    return localData.map((model) => model.toEntity()).toList();
  }

  @override
  Future<{{feature_name.pascalCase()}}> create({{feature_name.pascalCase()}} entity) async {
    try {
      final remoteModel = {{feature_name.pascalCase()}}RemoteModel.fromEntity(entity);
      final createdRemoteModel = await remoteDataSource.create(remoteModel);
      final createdEntity = createdRemoteModel.toEntity();
      
      // Cache to local storage
      final localModel = {{feature_name.pascalCase()}}LocalModel.fromEntity(createdEntity);
      await localDataSource.create(localModel);
      
      return createdEntity;
    } catch (e) {
      // Fallback to local storage only
      final localModel = {{feature_name.pascalCase()}}LocalModel.fromEntity(entity);
      final id = await localDataSource.create(localModel);
      return entity.copyWith(id: id);
    }
  }

  @override
  Future<{{feature_name.pascalCase()}}> update({{feature_name.pascalCase()}} entity) async {
    try {
      final remoteModel = {{feature_name.pascalCase()}}RemoteModel.fromEntity(entity);
      final updatedRemoteModel = await remoteDataSource.update(remoteModel);
      final updatedEntity = updatedRemoteModel.toEntity();
      
      // Update local storage
      final localModel = {{feature_name.pascalCase()}}LocalModel.fromEntity(updatedEntity);
      await localDataSource.update(localModel);
      
      return updatedEntity;
    } catch (e) {
      // Fallback to local storage only
      final localModel = {{feature_name.pascalCase()}}LocalModel.fromEntity(entity);
      await localDataSource.update(localModel);
      return entity;
    }
  }

  @override
  Future<bool> delete(int id) async {
    try {
      final remoteDeleted = await remoteDataSource.delete(id);
      if (remoteDeleted) {
        await localDataSource.delete(id);
        return true;
      }
    } catch (e) {
      // Fallback to local storage only
      return await localDataSource.delete(id);
    }
    return false;
  }
}