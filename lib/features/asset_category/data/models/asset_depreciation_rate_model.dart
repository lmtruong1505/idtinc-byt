import 'package:freezed_annotation/freezed_annotation.dart';

part 'asset_depreciation_rate_model.freezed.dart';
part 'asset_depreciation_rate_model.g.dart';

@freezed
class AssetDepreciationRateModel with _$AssetDepreciationRateModel {
  const factory AssetDepreciationRateModel({
    String? label,
    num? value,
    num? percent,
    String? color,
  }) = _AssetDepreciationRateModel;

  factory AssetDepreciationRateModel.fromJson(Map<String, dynamic> json) =>
      _$AssetDepreciationRateModelFromJson(json);
}
