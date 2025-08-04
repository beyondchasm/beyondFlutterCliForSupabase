import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../domain/entities/test_feature.dart';

part 'test_feature_remote_model.freezed.dart';
part 'test_feature_remote_model.g.dart';

@freezed
class TestFeatureRemoteModel with _$TestFeatureRemoteModel {
  const factory TestFeatureRemoteModel({
    int? id,
    required String name,
    @JsonKey(name: 'created_at') required String createdAt,
    @JsonKey(name: 'updated_at') required String updatedAt,
  }) = _TestFeatureRemoteModel;

  const TestFeatureRemoteModel._();

  factory TestFeatureRemoteModel.fromJson(Map<String, dynamic> json) =>
      _$TestFeatureRemoteModelFromJson(json);

  // Entity conversion methods
  TestFeature toEntity() {
    return TestFeature(
      id: id,
      name: name,
      createdAt: DateTime.parse(createdAt),
      updatedAt: DateTime.parse(updatedAt),
    );
  }

  factory TestFeatureRemoteModel.fromEntity(TestFeature entity) {
    return TestFeatureRemoteModel(
      id: entity.id,
      name: entity.name,
      createdAt: entity.createdAt.toIso8601String(),
      updatedAt: entity.updatedAt.toIso8601String(),
    );
  }
}