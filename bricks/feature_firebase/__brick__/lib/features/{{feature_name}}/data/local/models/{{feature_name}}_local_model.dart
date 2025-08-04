import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../domain/entities/{{feature_name}}.dart';

part '{{feature_name}}_local_model.freezed.dart';
part '{{feature_name}}_local_model.g.dart';

@freezed
class {{feature_name.pascalCase()}}LocalModel with _${{feature_name.pascalCase()}}LocalModel {
  const factory {{feature_name.pascalCase()}}LocalModel({
    String? id, // Firebase document ID는 String
    required String name,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _{{feature_name.pascalCase()}}LocalModel;

  const {{feature_name.pascalCase()}}LocalModel._();

  factory {{feature_name.pascalCase()}}LocalModel.fromJson(Map<String, dynamic> json) =>
      _${{feature_name.pascalCase()}}LocalModelFromJson(json);

  // Entity conversion methods
  {{feature_name.pascalCase()}} toEntity() {
    return {{feature_name.pascalCase()}}(
      id: id,
      name: name,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  factory {{feature_name.pascalCase()}}LocalModel.fromEntity({{feature_name.pascalCase()}} entity) {
    return {{feature_name.pascalCase()}}LocalModel(
      id: entity.id,
      name: entity.name,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }
}