import '../models/product_remote_model.dart';

abstract class ProductRemoteDataSource {
  Future<List<ProductRemoteModel>> getAll();
  Future<ProductRemoteModel?> getById(int id);
  Future<ProductRemoteModel> create(ProductRemoteModel model);
  Future<ProductRemoteModel> update(ProductRemoteModel model);
  Future<bool> delete(int id);
}