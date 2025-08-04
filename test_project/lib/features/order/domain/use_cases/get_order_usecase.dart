import '../entities/order.dart';
import '../repositories/order_repository.dart';

class GetOrderUseCase {
  final OrderRepository repository;

  GetOrderUseCase(this.repository);

  Future<List<Order>> call() async {
    return await repository.getAll();
  }

  Future<Order?> getById(int id) async {
    return await repository.getById(id);
  }

  Future<List<Order>> getByDate(DateTime date) async {
    return await repository.getByDate(date);
  }
}