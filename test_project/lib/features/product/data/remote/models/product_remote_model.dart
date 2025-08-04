import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../domain/entities/product.dart';

part 'product_remote_model.freezed.dart';
part 'product_remote_model.g.dart';

@freezed
class ProductRemoteModel with _$ProductRemoteModel {
  const factory ProductRemoteModel({
    int? id,
    required String name,
    @JsonKey(name: 'created_at') required String createdAt,
    @JsonKey(name: 'updated_at') required String updatedAt,
  }) = _ProductRemoteModel;

  const ProductRemoteModel._();

  factory ProductRemoteModel.fromJson(Map<String, dynamic> json) =>
      _$ProductRemoteModelFromJson(json);

  // Entity conversion methods
  Product toEntity() {
    return Product(
      id: id,
      name: name,
      createdAt: DateTime.parse(createdAt),
      updatedAt: DateTime.parse(updatedAt),
    );
  }

  factory ProductRemoteModel.fromEntity(Product entity) {
    return ProductRemoteModel(
      id: entity.id,
      name: entity.name,
      createdAt: entity.createdAt.toIso8601String(),
      updatedAt: entity.updatedAt.toIso8601String(),
    );
  }
}