class {{feature_name.pascalCase()}} {
  final int? id;
  final String name;
  final DateTime createdAt;
  final DateTime updatedAt;

  {{feature_name.pascalCase()}}({
    this.id,
    required this.name,
    required this.createdAt,
    required this.updatedAt,
  });

  {{feature_name.pascalCase()}} copyWith({
    int? id,
    String? name,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return {{feature_name.pascalCase()}}(
      id: id ?? this.id,
      name: name ?? this.name,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is {{feature_name.pascalCase()}} &&
        other.id == id &&
        other.name == name &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^ name.hashCode ^ createdAt.hashCode ^ updatedAt.hashCode;
  }

  @override
  String toString() {
    return '{{feature_name.pascalCase()}}(id: $id, name: $name, createdAt: $createdAt, updatedAt: $updatedAt)';
  }
}