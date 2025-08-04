import '../models/order_local_model.dart';

abstract class OrderLocalDataSource {
  Future<List<OrderLocalModel>> getAll();
  Future<OrderLocalModel?> getById(int id);
  Future<List<OrderLocalModel>> getByDate(DateTime date);
  Future<int> create(OrderLocalModel model);
  Future<bool> update(OrderLocalModel model);
  Future<bool> delete(int id);
}