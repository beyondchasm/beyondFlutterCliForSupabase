import '../entities/product.dart';

abstract class ProductRepository {
  Future<List<Product>> getAll();
  Future<Product?> getById(int id);
  Future<List<Product>> getByDate(DateTime date);
  Future<Product> create(Product entity);
  Future<Product> update(Product entity);
  Future<bool> delete(int id);
}