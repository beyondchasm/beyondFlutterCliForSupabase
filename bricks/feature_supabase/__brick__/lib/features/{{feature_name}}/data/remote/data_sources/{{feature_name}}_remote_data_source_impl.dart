import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '{{feature_name}}_remote_data_source.dart';
import '../models/{{feature_name}}_remote_model.dart';

@LazySingleton(as: {{feature_name.pascalCase()}}RemoteDataSource)
class {{feature_name.pascalCase()}}RemoteDataSourceImpl implements {{feature_name.pascalCase()}}RemoteDataSource {
  final SupabaseClient _supabase;
  final String _tableName = '{{feature_name}}s';

  {{feature_name.pascalCase()}}RemoteDataSourceImpl(@Named('supabaseClient') this._supabase);

  @override
  Future<List<{{feature_name.pascalCase()}}RemoteModel>> getAll() async {
    try {
      final response = await _supabase
          .from(_tableName)
          .select()
          .order('created_at', ascending: false);

      return (response as List)
          .map((json) => {{feature_name.pascalCase()}}RemoteModel.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch {{feature_name}}s: $e');
    }
  }

  @override
  Future<{{feature_name.pascalCase()}}RemoteModel?> getById(int id) async {
    try {
      final response = await _supabase
          .from(_tableName)
          .select()
          .eq('id', id)
          .maybeSingle();

      if (response == null) return null;

      return {{feature_name.pascalCase()}}RemoteModel.fromJson(response);
    } catch (e) {
      throw Exception('Failed to fetch {{feature_name}} with id $id: $e');
    }
  }

  @override
  Future<{{feature_name.pascalCase()}}RemoteModel> create({{feature_name.pascalCase()}}RemoteModel model) async {
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

      return {{feature_name.pascalCase()}}RemoteModel.fromJson(response);
    } catch (e) {
      throw Exception('Failed to create {{feature_name}}: $e');
    }
  }

  @override
  Future<{{feature_name.pascalCase()}}RemoteModel> update({{feature_name.pascalCase()}}RemoteModel model) async {
    try {
      if (model.id == null) {
        throw Exception('Cannot update {{feature_name}} without ID');
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

      return {{feature_name.pascalCase()}}RemoteModel.fromJson(response);
    } catch (e) {
      throw Exception('Failed to update {{feature_name}}: $e');
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
      throw Exception('Failed to delete {{feature_name}} with id $id: $e');
    }
  }

  /// 실시간 스트림으로 모든 {{feature_name}}s 가져오기
  Stream<List<{{feature_name.pascalCase()}}RemoteModel>> getAllStream() {
    return _supabase
        .from(_tableName)
        .stream(primaryKey: ['id'])
        .order('created_at', ascending: false)
        .map((data) => data
            .map((json) => {{feature_name.pascalCase()}}RemoteModel.fromJson(json))
            .toList());
  }

  /// 특정 {{feature_name}} 실시간 스트림
  Stream<{{feature_name.pascalCase()}}RemoteModel?> getByIdStream(int id) {
    return _supabase
        .from(_tableName)
        .stream(primaryKey: ['id'])
        .eq('id', id)
        .map((data) {
          if (data.isEmpty) return null;
          return {{feature_name.pascalCase()}}RemoteModel.fromJson(data.first);
        });
  }

  /// 필터를 이용한 검색
  Future<List<{{feature_name.pascalCase()}}RemoteModel>> search(String query) async {
    try {
      final response = await _supabase
          .from(_tableName)
          .select()
          .ilike('name', '%$query%')
          .order('created_at', ascending: false);

      return (response as List)
          .map((json) => {{feature_name.pascalCase()}}RemoteModel.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Failed to search {{feature_name}}s: $e');
    }
  }

  /// 페이지네이션
  Future<List<{{feature_name.pascalCase()}}RemoteModel>> getPaginated({
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
          .map((json) => {{feature_name.pascalCase()}}RemoteModel.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch paginated {{feature_name}}s: $e');
    }
  }
}