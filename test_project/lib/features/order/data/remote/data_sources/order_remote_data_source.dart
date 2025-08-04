import '../models/order_remote_model.dart';

abstract class OrderRemoteDataSource {
  Future<List<OrderRemoteModel>> getAll();
  Future<OrderRemoteModel?> getById(int id);
  Future<OrderRemoteModel> create(OrderRemoteModel model);
  Future<OrderRemoteModel> update(OrderRemoteModel model);
  Future<bool> delete(int id);
}