import '../entities/order.dart';

abstract class OrderRepository {
  Future<List<Order>> getAll();
  Future<Order?> getById(int id);
  Future<List<Order>> getByDate(DateTime date);
  Future<Order> create(Order entity);
  Future<Order> update(Order entity);
  Future<bool> delete(int id);
}