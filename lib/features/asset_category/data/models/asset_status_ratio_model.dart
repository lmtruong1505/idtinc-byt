import 'package:freezed_annotation/freezed_annotation.dart';

part 'asset_status_ratio_model.freezed.dart';
part 'asset_status_ratio_model.g.dart';

@freezed
class AssetStatusRatioModel with _$AssetStatusRatioModel {
  const factory AssetStatusRatioModel({
    String? label,
    double? amount,
    int? value,
    double? percent,
    String? labelColor,
  }) = _AssetStatusRatioModel;

  factory AssetStatusRatioModel.fromJson(Map<String, dynamic> json) =>
      _$AssetStatusRatioModelFromJson(json);
}
