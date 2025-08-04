import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../domain/entities/order.dart';

part 'order_local_model.freezed.dart';
part 'order_local_model.g.dart';

@freezed
class OrderLocalModel with _$OrderLocalModel {
  const factory OrderLocalModel({
    int? id,
    required String name,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _OrderLocalModel;

  const OrderLocalModel._();

  factory OrderLocalModel.fromJson(Map<String, dynamic> json) =>
      _$OrderLocalModelFromJson(json);

  // Entity conversion methods
  Order toEntity() {
    return Order(
      id: id,
      name: name,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  factory OrderLocalModel.fromEntity(Order entity) {
    return OrderLocalModel(
      id: entity.id,
      name: entity.name,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }
}