import '../entities/product.dart';
import '../repositories/product_repository.dart';

class GetProductUseCase {
  final ProductRepository repository;

  GetProductUseCase(this.repository);

  Future<List<Product>> call() async {
    return await repository.getAll();
  }

  Future<Product?> getById(int id) async {
    return await repository.getById(id);
  }

  Future<List<Product>> getByDate(DateTime date) async {
    return await repository.getByDate(date);
  }
}