import '../entities/order.dart';
import '../repositories/order_repository.dart';

class UpdateOrderUseCase {
  final OrderRepository repository;

  UpdateOrderUseCase(this.repository);

  Future<Order> call(Order entity) async {
    return await repository.update(entity);
  }
}