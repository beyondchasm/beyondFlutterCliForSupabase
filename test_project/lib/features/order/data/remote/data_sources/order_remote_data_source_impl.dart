import 'package:supabase_flutter/supabase_flutter.dart';
import 'order_remote_data_source.dart';
import '../models/order_remote_model.dart';

class OrderRemoteDataSourceImpl implements OrderRemoteDataSource {
  final SupabaseClient _supabase;
  final String _tableName = 'orders';

  OrderRemoteDataSourceImpl({
    SupabaseClient? supabase,
  }) : _supabase = supabase ?? Supabase.instance.client;

  @override
  Future<List<OrderRemoteModel>> getAll() async {
    try {
      final response = await _supabase
          .from(_tableName)
          .select()
          .order('created_at', ascending: false);

      return (response as List)
          .map((json) => OrderRemoteModel.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch orders: $e');
    }
  }

  @override
  Future<OrderRemoteModel?> getById(int id) async {
    try {
      final response = await _supabase
          .from(_tableName)
          .select()
          .eq('id', id)
          .maybeSingle();

      if (response == null) return null;

      return OrderRemoteModel.fromJson(response);
    } catch (e) {
      throw Exception('Failed to fetch order with id $id: $e');
    }
  }

  @override
  Future<OrderRemoteModel> create(OrderRemoteModel model) async {
    try {
      final data = model.toJson()
        ..remove('id') // ID는 Supabase가 자동 생성
        ..['created_at'] = DateTime.now().toIso8601String()
        ..['updated_at'] = DateTime.now().toIso8601String();

      final response = await _supabase
          .from(_tableName)
          .insert(data)
          .select()
          .single();

      return OrderRemoteModel.fromJson(response);
    } catch (e) {
      throw Exception('Failed to create order: $e');
    }
  }

  @override
  Future<OrderRemoteModel> update(OrderRemoteModel model) async {
    try {
      if (model.id == null) {
        throw Exception('Cannot update order without ID');
      }

      final data = model.toJson()
        ..remove('id')
        ..remove('created_at') // 생성 시간은 수정하지 않음
        ..['updated_at'] = DateTime.now().toIso8601String();

      final response = await _supabase
          .from(_tableName)
          .update(data)
          .eq('id', model.id!)
          .select()
          .single();

      return OrderRemoteModel.fromJson(response);
    } catch (e) {
      throw Exception('Failed to update order: $e');
    }
  }

  @override
  Future<bool> delete(int id) async {
    try {
      await _supabase
          .from(_tableName)
          .delete()
          .eq('id', id);
      return true;
    } catch (e) {
      throw Exception('Failed to delete order with id $id: $e');
    }
  }

  /// 실시간 스트림으로 모든 orders 가져오기
  Stream<List<OrderRemoteModel>> getAllStream() {
    return _supabase
        .from(_tableName)
        .stream(primaryKey: ['id'])
        .order('created_at', ascending: false)
        .map((data) => data
            .map((json) => OrderRemoteModel.fromJson(json))
            .toList());
  }

  /// 특정 order 실시간 스트림
  Stream<OrderRemoteModel?> getByIdStream(int id) {
    return _supabase
        .from(_tableName)
        .stream(primaryKey: ['id'])
        .eq('id', id)
        .map((data) {
          if (data.isEmpty) return null;
          return OrderRemoteModel.fromJson(data.first);
        });
  }

  /// 필터를 이용한 검색
  Future<List<OrderRemoteModel>> search(String query) async {
    try {
      final response = await _supabase
          .from(_tableName)
          .select()
          .ilike('name', '%$query%')
          .order('created_at', ascending: false);

      return (response as List)
          .map((json) => OrderRemoteModel.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Failed to search orders: $e');
    }
  }

  /// 페이지네이션
  Future<List<OrderRemoteModel>> getPaginated({
    int page = 0,
    int limit = 20,
  }) async {
    try {
      final response = await _supabase
          .from(_tableName)
          .select()
          .order('created_at', ascending: false)
          .range(page * limit, (page + 1) * limit - 1);

      return (response as List)
          .map((json) => OrderRemoteModel.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch paginated orders: $e');
    }
  }
}