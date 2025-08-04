import '../repositories/order_repository.dart';

class DeleteOrderUseCase {
  final OrderRepository repository;

  DeleteOrderUseCase(this.repository);

  Future<bool> call(int id) async {
    return await repository.delete(id);
  }
}