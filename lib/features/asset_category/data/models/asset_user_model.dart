import 'package:json_annotation/json_annotation.dart';

part 'asset_user_model.g.dart';

@JsonSerializable()
class AssetUserModel {
  final int? id;
  @JsonKey(name: 'hinh_anh')
  final String? hinhAnh;
  @JsonKey(name: 'ho_va_ten')
  final String? hoVaTen;
  @JsonKey(name: 'ma_tai_khoan')
  final String? maTaiKhoan;
  @JsonKey(name: 'dien_thoai')
  final String? dienThoai;

  AssetUserModel({
    this.id,
    this.hinhAnh,
    this.hoVaTen,
    this.maTaiKhoan,
    this.dienThoai,
  });

  factory AssetUserModel.fromJson(Map<String, dynamic> json) =>
      _$AssetUserModelFromJson(json);
  Map<String, dynamic> toJson() => _$AssetUserModelToJson(this);
}
