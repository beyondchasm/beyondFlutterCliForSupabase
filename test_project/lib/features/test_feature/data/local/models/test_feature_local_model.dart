import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../domain/entities/test_feature.dart';

part 'test_feature_local_model.freezed.dart';
part 'test_feature_local_model.g.dart';

@freezed
class TestFeatureLocalModel with _$TestFeatureLocalModel {
  const factory TestFeatureLocalModel({
    int? id,
    required String name,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _TestFeatureLocalModel;

  const TestFeatureLocalModel._();

  factory TestFeatureLocalModel.fromJson(Map<String, dynamic> json) =>
      _$TestFeatureLocalModelFromJson(json);

  // Entity conversion methods
  TestFeature toEntity() {
    return TestFeature(
      id: id,
      name: name,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  factory TestFeatureLocalModel.fromEntity(TestFeature entity) {
    return TestFeatureLocalModel(
      id: entity.id,
      name: entity.name,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }
}