import 'package:freezed_annotation/freezed_annotation.dart';

part 'test_feature.freezed.dart';
part 'test_feature.g.dart';

@freezed
class TestFeature with _$TestFeature {
  const factory TestFeature({
    int? id,
    required String name,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _TestFeature;

  factory TestFeature.fromJson(Map<String, dynamic> json) =>
      _$TestFeatureFromJson(json);
}