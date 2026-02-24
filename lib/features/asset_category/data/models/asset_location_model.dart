import 'package:json_annotation/json_annotation.dart';

part 'asset_location_model.g.dart';

@JsonSerializable()
class AssetLocationModel {
  @JsonKey(name: 'ten_khoa_hien_tai')
  final String? tenKhoaHienTai;
  @JsonKey(name: 'ten_nguoi_duoc_giao')
  final String? tenNguoiDuocGiao;
  @JsonKey(name: 'vi_tri')
  final String? viTri;
  @JsonKey(name: 'chuc_vu')
  final String? chucVu;

  AssetLocationModel({
    this.tenKhoaHienTai,
    this.tenNguoiDuocGiao,
    this.viTri,
    this.chucVu,
  });

  factory AssetLocationModel.fromJson(Map<String, dynamic> json) =>
      _$AssetLocationModelFromJson(json);
  Map<String, dynamic> toJson() => _$AssetLocationModelToJson(this);
}
