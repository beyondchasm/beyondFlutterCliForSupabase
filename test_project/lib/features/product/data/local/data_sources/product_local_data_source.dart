import '../models/product_local_model.dart';

abstract class ProductLocalDataSource {
  Future<List<ProductLocalModel>> getAll();
  Future<ProductLocalModel?> getById(int id);
  Future<List<ProductLocalModel>> getByDate(DateTime date);
  Future<int> create(ProductLocalModel model);
  Future<bool> update(ProductLocalModel model);
  Future<bool> delete(int id);
}