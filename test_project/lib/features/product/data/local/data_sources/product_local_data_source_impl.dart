import 'product_local_data_source.dart';
import '../models/product_local_model.dart';

class ProductLocalDataSourceImpl implements ProductLocalDataSource {
  // TODO: Add ObjectBox or other local storage implementation
  
  @override
  Future<List<ProductLocalModel>> getAll() async {
    // TODO: Implement
    throw UnimplementedError();
  }

  @override
  Future<ProductLocalModel?> getById(int id) async {
    // TODO: Implement
    throw UnimplementedError();
  }

  @override
  Future<List<ProductLocalModel>> getByDate(DateTime date) async {
    // TODO: Implement
    throw UnimplementedError();
  }

  @override
  Future<int> create(ProductLocalModel model) async {
    // TODO: Implement
    throw UnimplementedError();
  }

  @override
  Future<bool> update(ProductLocalModel model) async {
    // TODO: Implement
    throw UnimplementedError();
  }

  @override
  Future<bool> delete(int id) async {
    // TODO: Implement
    throw UnimplementedError();
  }
}