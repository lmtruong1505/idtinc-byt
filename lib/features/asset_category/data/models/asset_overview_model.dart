import 'package:freezed_annotation/freezed_annotation.dart';

part 'asset_overview_model.freezed.dart';
part 'asset_overview_model.g.dart';

@freezed
class AssetOverviewModel with _$AssetOverviewModel {
  const factory AssetOverviewModel({
    @JsonKey(name: 'tong_so_luong') int? tongSoLuong,
    @JsonKey(name: 'tong_nguyen_gia') double? tongNguyenGia,
    @JsonKey(name: 'tong_gia_tri_hao_mon') double? tongGiaTriHaoMon,
    @JsonKey(name: 'tong_gia_tri_hao_mon_con_lai')
    double? tongGiaTriHaoMonConLai,
    @JsonKey(name: 'tong_so_luong_thanh_ly') int? tongSoLuongThanhLy,
    @JsonKey(name: 'tong_gia_tri_thanh_ly') double? tongGiaTriThanhLy,
    @JsonKey(name: 'so_luong_thanh_ly_con_khau_hao')
    int? soLuongThanhLyConKhauHao,
    @JsonKey(name: 'so_luong_thanh_ly_het_khau_hao')
    int? soLuongThanhLyHetKhauHao,
    @JsonKey(name: 'ti_le_so_luong_thanh_ly_con_khau_hao')
    double? tiLeSoLuongThanhLyConKhauHao,
    @JsonKey(name: 'ti_le_so_luong_thanh_ly_het_khau_hao')
    double? tiLeSoLuongThanhLyHetKhauHao,
    @JsonKey(name: 'ti_le_hao_mon') double? tiLeHaoMon,
    @JsonKey(name: 'ti_le_hao_mon_con_lai') double? tiLeHaoMonConLai,
  }) = _AssetOverviewModel;

  factory AssetOverviewModel.fromJson(Map<String, dynamic> json) =>
      _$AssetOverviewModelFromJson(json);
}
