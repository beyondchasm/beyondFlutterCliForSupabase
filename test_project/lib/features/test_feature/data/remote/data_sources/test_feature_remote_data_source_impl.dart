import 'package:supabase_flutter/supabase_flutter.dart';
import 'test_feature_remote_data_source.dart';
import '../models/test_feature_remote_model.dart';

class TestFeatureRemoteDataSourceImpl implements TestFeatureRemoteDataSource {
  final SupabaseClient _supabase;
  final String _tableName = 'test_features';

  TestFeatureRemoteDataSourceImpl({
    SupabaseClient? supabase,
  }) : _supabase = supabase ?? Supabase.instance.client;

  @override
  Future<List<TestFeatureRemoteModel>> getAll() async {
    try {
      final response = await _supabase
          .from(_tableName)
          .select()
          .order('created_at', ascending: false);

      return (response as List)
          .map((json) => TestFeatureRemoteModel.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch test_features: $e');
    }
  }

  @override
  Future<TestFeatureRemoteModel?> getById(int id) async {
    try {
      final response = await _supabase
          .from(_tableName)
          .select()
          .eq('id', id)
          .maybeSingle();

      if (response == null) return null;

      return TestFeatureRemoteModel.fromJson(response);
    } catch (e) {
      throw Exception('Failed to fetch test_feature with id $id: $e');
    }
  }

  @override
  Future<TestFeatureRemoteModel> create(TestFeatureRemoteModel model) async {
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

      return TestFeatureRemoteModel.fromJson(response);
    } catch (e) {
      throw Exception('Failed to create test_feature: $e');
    }
  }

  @override
  Future<TestFeatureRemoteModel> update(TestFeatureRemoteModel model) async {
    try {
      if (model.id == null) {
        throw Exception('Cannot update test_feature without ID');
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

      return TestFeatureRemoteModel.fromJson(response);
    } catch (e) {
      throw Exception('Failed to update test_feature: $e');
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
      throw Exception('Failed to delete test_feature with id $id: $e');
    }
  }

  /// 실시간 스트림으로 모든 test_features 가져오기
  Stream<List<TestFeatureRemoteModel>> getAllStream() {
    return _supabase
        .from(_tableName)
        .stream(primaryKey: ['id'])
        .order('created_at', ascending: false)
        .map((data) => data
            .map((json) => TestFeatureRemoteModel.fromJson(json))
            .toList());
  }

  /// 특정 test_feature 실시간 스트림
  Stream<TestFeatureRemoteModel?> getByIdStream(int id) {
    return _supabase
        .from(_tableName)
        .stream(primaryKey: ['id'])
        .eq('id', id)
        .map((data) {
          if (data.isEmpty) return null;
          return TestFeatureRemoteModel.fromJson(data.first);
        });
  }

  /// 필터를 이용한 검색
  Future<List<TestFeatureRemoteModel>> search(String query) async {
    try {
      final response = await _supabase
          .from(_tableName)
          .select()
          .ilike('name', '%$query%')
          .order('created_at', ascending: false);

      return (response as List)
          .map((json) => TestFeatureRemoteModel.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Failed to search test_features: $e');
    }
  }

  /// 페이지네이션
  Future<List<TestFeatureRemoteModel>> getPaginated({
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
          .map((json) => TestFeatureRemoteModel.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch paginated test_features: $e');
    }
  }
}