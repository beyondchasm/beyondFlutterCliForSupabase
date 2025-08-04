import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../domain/entities/order.dart';

part 'order_remote_model.freezed.dart';
part 'order_remote_model.g.dart';

@freezed
class OrderRemoteModel with _$OrderRemoteModel {
  const factory OrderRemoteModel({
    int? id,
    required String name,
    @JsonKey(name: 'created_at') required String createdAt,
    @JsonKey(name: 'updated_at') required String updatedAt,
  }) = _OrderRemoteModel;

  const OrderRemoteModel._();

  factory OrderRemoteModel.fromJson(Map<String, dynamic> json) =>
      _$OrderRemoteModelFromJson(json);

  // Entity conversion methods
  Order toEntity() {
    return Order(
      id: id,
      name: name,
      createdAt: DateTime.parse(createdAt),
      updatedAt: DateTime.parse(updatedAt),
    );
  }

  factory OrderRemoteModel.fromEntity(Order entity) {
    return OrderRemoteModel(
      id: entity.id,
      name: entity.name,
      createdAt: entity.createdAt.toIso8601String(),
      updatedAt: entity.updatedAt.toIso8601String(),
    );
  }
}