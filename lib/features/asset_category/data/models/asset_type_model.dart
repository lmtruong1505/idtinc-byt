import 'package:json_annotation/json_annotation.dart';

part 'asset_type_model.g.dart';

@JsonSerializable()
class AssetTypeModel {
  final String? id;
  @JsonKey(name: 'ten_danh_muc')
  final String? tenDanhMuc;
  @JsonKey(name: 'ma_danh_muc')
  final String? maDanhMuc;
  @JsonKey(name: 'meta_data')
  final AssetTypeMetadata? metaData;

  AssetTypeModel({this.id, this.tenDanhMuc, this.maDanhMuc, this.metaData});

  factory AssetTypeModel.fromJson(Map<String, dynamic> json) =>
      _$AssetTypeModelFromJson(json);
  Map<String, dynamic> toJson() => _$AssetTypeModelToJson(this);
}

@JsonSerializable()
class AssetTypeMetadata {
  @JsonKey(name: 'thoi_gian_tinh_khau_hao')
  final int? thoiGianTinhKhauHao;

  AssetTypeMetadata({this.thoiGianTinhKhauHao});

  factory AssetTypeMetadata.fromJson(Map<String, dynamic> json) =>
      _$AssetTypeMetadataFromJson(json);
  Map<String, dynamic> toJson() => _$AssetTypeMetadataToJson(this);
}
