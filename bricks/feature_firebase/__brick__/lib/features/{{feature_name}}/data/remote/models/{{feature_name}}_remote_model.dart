import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../domain/entities/{{feature_name}}.dart';

part '{{feature_name}}_remote_model.freezed.dart';
part '{{feature_name}}_remote_model.g.dart';

@freezed
class {{feature_name.pascalCase()}}RemoteModel with _${{feature_name.pascalCase()}}RemoteModel {
  const factory {{feature_name.pascalCase()}}RemoteModel({
    String? id, // Firebase document ID는 String
    required String name,
    @JsonKey(name: 'createdAt') required String createdAt, // Firestore 필드명과 일치
    @JsonKey(name: 'updatedAt') required String updatedAt, // Firestore 필드명과 일치
  }) = _{{feature_name.pascalCase()}}RemoteModel;

  const {{feature_name.pascalCase()}}RemoteModel._();

  factory {{feature_name.pascalCase()}}RemoteModel.fromJson(Map<String, dynamic> json) =>
      _${{feature_name.pascalCase()}}RemoteModelFromJson(json);

  // Entity conversion methods
  {{feature_name.pascalCase()}} toEntity() {
    return {{feature_name.pascalCase()}}(
      id: id,
      name: name,
      createdAt: DateTime.parse(createdAt),
      updatedAt: DateTime.parse(updatedAt),
    );
  }

  factory {{feature_name.pascalCase()}}RemoteModel.fromEntity({{feature_name.pascalCase()}} entity) {
    return {{feature_name.pascalCase()}}RemoteModel(
      id: entity.id,
      name: entity.name,
      createdAt: entity.createdAt.toIso8601String(),
      updatedAt: entity.updatedAt.toIso8601String(),
    );
  }
}