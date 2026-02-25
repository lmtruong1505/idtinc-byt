import 'package:json_annotation/json_annotation.dart';
import 'asset_status_model.dart';
import 'asset_type_model.dart';
import 'asset_location_model.dart';
import 'asset_user_model.dart';

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
  @JsonKey(name: 'is_parent')
  final bool? isParent;

  // Additional fields from detailed JSON
  @JsonKey(name: 'ma_seri')
  final String? maSeri;
  @JsonKey(name: 'ma_model')
  final String? maModel;
  @JsonKey(name: 'hang_san_xuat')
  final String? hangSanXuat;
  @JsonKey(name: 'nuoc_san_xuat')
  final String? nuocSanXuat;
  @JsonKey(name: 'thoi_gian_san_xuat')
  final String? thoiGianSanXuat;
  @JsonKey(name: 'don_vi_tinh')
  final String? donViTinh;
  @JsonKey(name: 'gia_tri_khau_hao')
  final String? giaTriKhauHao;
  @JsonKey(name: 'khau_hao_con_lai')
  final String? khauHaoConLai;
  @JsonKey(name: 'to_chuc')
  final int? toChuc;
  @JsonKey(name: 'created_by')
  final AssetUserModel? createdBy;
  @JsonKey(name: 'updated_by')
  final AssetUserModel? updatedBy;
  @JsonKey(name: 'bo_tai_san')
  final List<HospitalAssetModel>? boTaiSan;
  @JsonKey(name: 'created_at')
  final String? createdAt;
  @JsonKey(name: 'updated_at')
  final String? updatedAt;

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
    this.maSeri,
    this.maModel,
    this.hangSanXuat,
    this.nuocSanXuat,
    this.thoiGianSanXuat,
    this.donViTinh,
    this.giaTriKhauHao,
    this.khauHaoConLai,
    this.toChuc,
    this.createdBy,
    this.updatedBy,
    this.boTaiSan,
    this.createdAt,
    this.updatedAt,
    this.isParent,
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

  double get remainingValue => originalPriceValue - accumulatedDepreciation;

  double get depreciationRatio =>
      originalPriceValue > 0
          ? (annualDepreciation / originalPriceValue) * 100
          : 0;

  double get usageYears {
    if (ngayBatDauSuDung == null) return 0;
    try {
      final startDate = DateTime.parse(ngayBatDauSuDung!);
      final now = DateTime.now();

      // Calculate years as currentYear - startYear
      double years = (now.year - startDate.year).toDouble();
      if (years < 0) years = 0;

      // Cap by total depreciation period
      if (depreciationYearsValue > 0 && years > depreciationYearsValue) {
        years = depreciationYearsValue;
      }
      return years;
    } catch (e) {
      return 0;
    }
  }

  double get accumulatedDepreciation => annualDepreciation * usageYears;

  double get accumulatedDepreciationRatio =>
      originalPriceValue > 0
          ? (accumulatedDepreciation / originalPriceValue) * 100
          : 0;
}
