import 'package:json_annotation/json_annotation.dart';

part 'asset_status_count_model.g.dart';

@JsonSerializable()
class AssetStatusCountModel {
  final String? label;
  final String? value;
  final int? count;

  AssetStatusCountModel({this.label, this.value, this.count});

  factory AssetStatusCountModel.fromJson(Map<String, dynamic> json) =>
      _$AssetStatusCountModelFromJson(json);
  Map<String, dynamic> toJson() => _$AssetStatusCountModelToJson(this);
}
