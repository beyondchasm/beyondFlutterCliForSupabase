import '../local/data_sources/product_local_data_source.dart';
import '../remote/data_sources/product_remote_data_source.dart';
import '../local/models/product_local_model.dart';
import '../remote/models/product_remote_model.dart';
import '../../domain/entities/product.dart';
import '../../domain/repositories/product_repository.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ProductLocalDataSource localDataSource;
  final ProductRemoteDataSource remoteDataSource;

  ProductRepositoryImpl({
    required this.localDataSource,
    required this.remoteDataSource,
  });

  @override
  Future<List<Product>> getAll() async {
    try {
      final remoteData = await remoteDataSource.getAll();
      final entities = remoteData.map((model) => model.toEntity()).toList();
      
      // Cache to local storage
      for (final entity in entities) {
        final localModel = ProductLocalModel.fromEntity(entity);
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
  Future<Product?> getById(int id) async {
    try {
      final remoteData = await remoteDataSource.getById(id);
      if (remoteData != null) {
        final entity = remoteData.toEntity();
        
        // Cache to local storage
        final localModel = ProductLocalModel.fromEntity(entity);
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
  Future<List<Product>> getByDate(DateTime date) async {
    final localData = await localDataSource.getByDate(date);
    return localData.map((model) => model.toEntity()).toList();
  }

  @override
  Future<Product> create(Product entity) async {
    try {
      final remoteModel = ProductRemoteModel.fromEntity(entity);
      final createdRemoteModel = await remoteDataSource.create(remoteModel);
      final createdEntity = createdRemoteModel.toEntity();
      
      // Cache to local storage
      final localModel = ProductLocalModel.fromEntity(createdEntity);
      await localDataSource.create(localModel);
      
      return createdEntity;
    } catch (e) {
      // Fallback to local storage only
      final localModel = ProductLocalModel.fromEntity(entity);
      final id = await localDataSource.create(localModel);
      return entity.copyWith(id: id);
    }
  }

  @override
  Future<Product> update(Product entity) async {
    try {
      final remoteModel = ProductRemoteModel.fromEntity(entity);
      final updatedRemoteModel = await remoteDataSource.update(remoteModel);
      final updatedEntity = updatedRemoteModel.toEntity();
      
      // Update local storage
      final localModel = ProductLocalModel.fromEntity(updatedEntity);
      await localDataSource.update(localModel);
      
      return updatedEntity;
    } catch (e) {
      // Fallback to local storage only
      final localModel = ProductLocalModel.fromEntity(entity);
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