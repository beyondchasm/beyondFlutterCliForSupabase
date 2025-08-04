import 'package:supabase_flutter/supabase_flutter.dart';
import 'product_remote_data_source.dart';
import '../models/product_remote_model.dart';

class ProductRemoteDataSourceImpl implements ProductRemoteDataSource {
  final SupabaseClient _supabase;
  final String _tableName = 'products';

  ProductRemoteDataSourceImpl({
    SupabaseClient? supabase,
  }) : _supabase = supabase ?? Supabase.instance.client;

  @override
  Future<List<ProductRemoteModel>> getAll() async {
    try {
      final response = await _supabase
          .from(_tableName)
          .select()
          .order('created_at', ascending: false);

      return (response as List)
          .map((json) => ProductRemoteModel.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch products: $e');
    }
  }

  @override
  Future<ProductRemoteModel?> getById(int id) async {
    try {
      final response = await _supabase
          .from(_tableName)
          .select()
          .eq('id', id)
          .maybeSingle();

      if (response == null) return null;

      return ProductRemoteModel.fromJson(response);
    } catch (e) {
      throw Exception('Failed to fetch product with id $id: $e');
    }
  }

  @override
  Future<ProductRemoteModel> create(ProductRemoteModel model) async {
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

      return ProductRemoteModel.fromJson(response);
    } catch (e) {
      throw Exception('Failed to create product: $e');
    }
  }

  @override
  Future<ProductRemoteModel> update(ProductRemoteModel model) async {
    try {
      if (model.id == null) {
        throw Exception('Cannot update product without ID');
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

      return ProductRemoteModel.fromJson(response);
    } catch (e) {
      throw Exception('Failed to update product: $e');
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
      throw Exception('Failed to delete product with id $id: $e');
    }
  }

  /// 실시간 스트림으로 모든 products 가져오기
  Stream<List<ProductRemoteModel>> getAllStream() {
    return _supabase
        .from(_tableName)
        .stream(primaryKey: ['id'])
        .order('created_at', ascending: false)
        .map((data) => data
            .map((json) => ProductRemoteModel.fromJson(json))
            .toList());
  }

  /// 특정 product 실시간 스트림
  Stream<ProductRemoteModel?> getByIdStream(int id) {
    return _supabase
        .from(_tableName)
        .stream(primaryKey: ['id'])
        .eq('id', id)
        .map((data) {
          if (data.isEmpty) return null;
          return ProductRemoteModel.fromJson(data.first);
        });
  }

  /// 필터를 이용한 검색
  Future<List<ProductRemoteModel>> search(String query) async {
    try {
      final response = await _supabase
          .from(_tableName)
          .select()
          .ilike('name', '%$query%')
          .order('created_at', ascending: false);

      return (response as List)
          .map((json) => ProductRemoteModel.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Failed to search products: $e');
    }
  }

  /// 페이지네이션
  Future<List<ProductRemoteModel>> getPaginated({
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
          .map((json) => ProductRemoteModel.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch paginated products: $e');
    }
  }
}