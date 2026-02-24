import 'package:json_annotation/json_annotation.dart';

part 'asset_type_model.g.dart';

@JsonSerializable()
class AssetTypeModel {
  final String? id;
  @JsonKey(name: 'ten_danh_muc')
  final String? tenDanhMuc;
  @JsonKey(name: 'ma_danh_muc')
  final String? maDanhMuc;

  AssetTypeModel({this.id, this.tenDanhMuc, this.maDanhMuc});

  factory AssetTypeModel.fromJson(Map<String, dynamic> json) =>
      _$AssetTypeModelFromJson(json);
  Map<String, dynamic> toJson() => _$AssetTypeModelToJson(this);
}
