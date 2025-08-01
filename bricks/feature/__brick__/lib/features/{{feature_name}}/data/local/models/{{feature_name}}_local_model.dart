import '../../domain/entities/{{feature_name}}.dart';

class {{feature_name.pascalCase()}}LocalModel {
  final int? id;
  final String name;
  final DateTime createdAt;
  final DateTime updatedAt;

  {{feature_name.pascalCase()}}LocalModel({
    this.id,
    required this.name,
    required this.createdAt,
    required this.updatedAt,
  });

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

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  factory {{feature_name.pascalCase()}}LocalModel.fromJson(Map<String, dynamic> json) {
    return {{feature_name.pascalCase()}}LocalModel(
      id: json['id'],
      name: json['name'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }
}