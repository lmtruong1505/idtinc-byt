import 'package:json_annotation/json_annotation.dart';
import 'asset_status_model.dart';
import 'asset_type_model.dart';
import 'asset_location_model.dart';

part 'hospital_asset_model.g.dart';

@JsonSerializable()
class HospitalAssetModel {
  final int? id;
  @JsonKey(name: 'ten_tai_san')
  final String? tenTaiSan;
  @JsonKey(name: 'ma_tai_san')
  final String? maTaiSan;
  @JsonKey(name: 'trang_thai')
  final AssetStatusModel? trangThai;
  @JsonKey(name: 'hinh_anh')
  final String? hinhAnh;
  @JsonKey(name: 'loai_tai_san')
  final AssetTypeModel? loaiTaiSan;
  @JsonKey(name: 'nguyen_gia')
  final String? nguyenGia;
  @JsonKey(name: 'vi_tri_hien_tai')
  final AssetLocationModel? viTriHienTai;
  @JsonKey(name: 'thoi_gian_tinh_khau_hao')
  final String? thoiGianTinhKhauHao;
  @JsonKey(name: 'ngay_bat_dau_su_dung')
  final String? ngayBatDauSuDung;
  @JsonKey(name: 'has_bo_tai_san')
  final bool? hasBoTaiSan;
  final dynamic parent;
  @JsonKey(name: 'order_parent')
  final int? orderParent;

  HospitalAssetModel({
    this.id,
    this.tenTaiSan,
    this.maTaiSan,
    this.trangThai,
    this.hinhAnh,
    this.loaiTaiSan,
    this.nguyenGia,
    this.viTriHienTai,
    this.thoiGianTinhKhauHao,
    this.ngayBatDauSuDung,
    this.hasBoTaiSan,
    this.parent,
    this.orderParent,
  });

  factory HospitalAssetModel.fromJson(Map<String, dynamic> json) =>
      _$HospitalAssetModelFromJson(json);
  Map<String, dynamic> toJson() => _$HospitalAssetModelToJson(this);

  // Business Logic Getters
  double get originalPriceValue => double.tryParse(nguyenGia ?? '0') ?? 0;
  double get depreciationYearsValue =>
      double.tryParse(thoiGianTinhKhauHao ?? '0') ?? 0;

  double get annualDepreciation =>
      depreciationYearsValue > 0
          ? originalPriceValue / depreciationYearsValue
          : 0;

  double get remainingValue => originalPriceValue - annualDepreciation;

  double get depreciationRatio =>
      originalPriceValue > 0 ? (annualDepreciation / originalPriceValue) : 0;
}
