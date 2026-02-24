import 'package:bpg_retail/core/data/models/value_label_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'asset_status_model.g.dart';

@JsonSerializable()
class AssetStatusModel {
  final String? label;
  final String? value;

  AssetStatusModel({this.label, this.value});

  factory AssetStatusModel.fromJson(Map<String, dynamic> json) =>
      _$AssetStatusModelFromJson(json);
  Map<String, dynamic> toJson() => _$AssetStatusModelToJson(this);

  ValueLabelModel toValueLabel() => ValueLabelModel(label: label, value: value);
}
