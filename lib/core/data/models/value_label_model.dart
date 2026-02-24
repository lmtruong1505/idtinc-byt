import 'package:json_annotation/json_annotation.dart';

part 'value_label_model.g.dart';

@JsonSerializable()
class ValueLabelModel {
  final String? label;
  final dynamic value;

  ValueLabelModel({this.label, this.value});

  factory ValueLabelModel.fromJson(Map<String, dynamic> json) =>
      _$ValueLabelModelFromJson(json);
  Map<String, dynamic> toJson() => _$ValueLabelModelToJson(this);
}
