import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../domain/entities/product.dart';

part 'product_local_model.freezed.dart';
part 'product_local_model.g.dart';

@freezed
class ProductLocalModel with _$ProductLocalModel {
  const factory ProductLocalModel({
    int? id,
    required String name,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _ProductLocalModel;

  const ProductLocalModel._();

  factory ProductLocalModel.fromJson(Map<String, dynamic> json) =>
      _$ProductLocalModelFromJson(json);

  // Entity conversion methods
  Product toEntity() {
    return Product(
      id: id,
      name: name,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  factory ProductLocalModel.fromEntity(Product entity) {
    return ProductLocalModel(
      id: entity.id,
      name: entity.name,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }
}