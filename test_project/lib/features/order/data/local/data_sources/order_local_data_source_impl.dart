import 'order_local_data_source.dart';
import '../models/order_local_model.dart';

class OrderLocalDataSourceImpl implements OrderLocalDataSource {
  // TODO: Add ObjectBox or other local storage implementation
  
  @override
  Future<List<OrderLocalModel>> getAll() async {
    // TODO: Implement
    throw UnimplementedError();
  }

  @override
  Future<OrderLocalModel?> getById(int id) async {
    // TODO: Implement
    throw UnimplementedError();
  }

  @override
  Future<List<OrderLocalModel>> getByDate(DateTime date) async {
    // TODO: Implement
    throw UnimplementedError();
  }

  @override
  Future<int> create(OrderLocalModel model) async {
    // TODO: Implement
    throw UnimplementedError();
  }

  @override
  Future<bool> update(OrderLocalModel model) async {
    // TODO: Implement
    throw UnimplementedError();
  }

  @override
  Future<bool> delete(int id) async {
    // TODO: Implement
    throw UnimplementedError();
  }
}