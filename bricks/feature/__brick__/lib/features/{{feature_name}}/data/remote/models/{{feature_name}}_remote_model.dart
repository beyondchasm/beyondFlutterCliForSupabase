import '../../domain/entities/{{feature_name}}.dart';

class {{feature_name.pascalCase()}}RemoteModel {
  final int? id;
  final String name;
  final String createdAt;
  final String updatedAt;

  {{feature_name.pascalCase()}}RemoteModel({
    this.id,
    required this.name,
    required this.createdAt,
    required this.updatedAt,
  });

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

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }

  factory {{feature_name.pascalCase()}}RemoteModel.fromJson(Map<String, dynamic> json) {
    return {{feature_name.pascalCase()}}RemoteModel(
      id: json['id'],
      name: json['name'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }
}