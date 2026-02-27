import 'package:freezed_annotation/freezed_annotation.dart';

part 'asset_quantity_report_model.freezed.dart';
part 'asset_quantity_report_model.g.dart';

@freezed
class AssetQuantityItemModel with _$AssetQuantityItemModel {
  const factory AssetQuantityItemModel({
    required dynamic id,
    required String name,
    required int quantity,
    @JsonKey(name: 'total_original_price') required double totalOriginalPrice,
  }) = _AssetQuantityItemModel;

  factory AssetQuantityItemModel.fromJson(Map<String, dynamic> json) =>
      _$AssetQuantityItemModelFromJson(json);
}

@freezed
class AssetQuantityReportModel with _$AssetQuantityReportModel {
  const factory AssetQuantityReportModel({
    @Default([]) List<AssetQuantityItemModel> khoa,
    @JsonKey(name: 'loai_tai_san')
    @Default([])
    List<AssetQuantityItemModel> loaiTaiSan,
  }) = _AssetQuantityReportModel;

  factory AssetQuantityReportModel.fromJson(Map<String, dynamic> json) =>
      _$AssetQuantityReportModelFromJson(json);
}
