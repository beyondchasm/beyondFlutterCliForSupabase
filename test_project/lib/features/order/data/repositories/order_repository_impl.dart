import '../local/data_sources/order_local_data_source.dart';
import '../remote/data_sources/order_remote_data_source.dart';
import '../local/models/order_local_model.dart';
import '../remote/models/order_remote_model.dart';
import '../../domain/entities/order.dart';
import '../../domain/repositories/order_repository.dart';

class OrderRepositoryImpl implements OrderRepository {
  final OrderLocalDataSource localDataSource;
  final OrderRemoteDataSource remoteDataSource;

  OrderRepositoryImpl({
    required this.localDataSource,
    required this.remoteDataSource,
  });

  @override
  Future<List<Order>> getAll() async {
    try {
      final remoteData = await remoteDataSource.getAll();
      final entities = remoteData.map((model) => model.toEntity()).toList();
      
      // Cache to local storage
      for (final entity in entities) {
        final localModel = OrderLocalModel.fromEntity(entity);
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
  Future<Order?> getById(int id) async {
    try {
      final remoteData = await remoteDataSource.getById(id);
      if (remoteData != null) {
        final entity = remoteData.toEntity();
        
        // Cache to local storage
        final localModel = OrderLocalModel.fromEntity(entity);
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
  Future<List<Order>> getByDate(DateTime date) async {
    final localData = await localDataSource.getByDate(date);
    return localData.map((model) => model.toEntity()).toList();
  }

  @override
  Future<Order> create(Order entity) async {
    try {
      final remoteModel = OrderRemoteModel.fromEntity(entity);
      final createdRemoteModel = await remoteDataSource.create(remoteModel);
      final createdEntity = createdRemoteModel.toEntity();
      
      // Cache to local storage
      final localModel = OrderLocalModel.fromEntity(createdEntity);
      await localDataSource.create(localModel);
      
      return createdEntity;
    } catch (e) {
      // Fallback to local storage only
      final localModel = OrderLocalModel.fromEntity(entity);
      final id = await localDataSource.create(localModel);
      return entity.copyWith(id: id);
    }
  }

  @override
  Future<Order> update(Order entity) async {
    try {
      final remoteModel = OrderRemoteModel.fromEntity(entity);
      final updatedRemoteModel = await remoteDataSource.update(remoteModel);
      final updatedEntity = updatedRemoteModel.toEntity();
      
      // Update local storage
      final localModel = OrderLocalModel.fromEntity(updatedEntity);
      await localDataSource.update(localModel);
      
      return updatedEntity;
    } catch (e) {
      // Fallback to local storage only
      final localModel = OrderLocalModel.fromEntity(entity);
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