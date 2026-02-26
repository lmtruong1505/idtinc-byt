import 'package:bpg_retail/features/asset_category/data/models/hospital_asset_model.dart';
import 'package:bpg_retail/features/authentication/data/models/user_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'asset_location_model.freezed.dart';
part 'asset_location_model.g.dart';

@freezed
class AssetLocationModel with _$AssetLocationModel {
  const factory AssetLocationModel({
    int? id,
    @JsonKey(name: 'display_date') String? displayDate,
    @JsonKey(name: 'created_by') UserModel? createdBy,
    @JsonKey(name: 'updated_by') UserModel? updatedBy,
    @JsonKey(name: 'phieu_dieu_chuyen') TransferTicket? phieuDieuChuyen,
    @JsonKey(name: 'phieu_thanh_ly') DisposeTicket? phieuThanhLy,
    @JsonKey(name: 'loai_vi_tri') LocationType? loaiViTri,
    @JsonKey(name: 'chuc_vu') String? chucVu,
    @JsonKey(name: 'ten_khoa_hien_tai') String? tenKhoaHienTai,
    @JsonKey(name: 'vi_tri') String? viTri,
    @JsonKey(name: 'ten_nguoi_duoc_giao') String? tenNguoiDuocGiao,
    @JsonKey(name: 'ngay_ghi_nhan') String? ngayGhiNhan,
    @JsonKey(name: 'ghi_chu') String? ghiChu,
    @JsonKey(name: 'vi_tri_hien_tai') bool? viTriHienTai,
    @JsonKey(name: 'so_luong_su_co') int? soLuongSuCo,
  }) = _AssetLocationModel;

  factory AssetLocationModel.fromJson(Map<String, dynamic> json) =>
      _$AssetLocationModelFromJson(json);
}

@freezed
class TransferTicket with _$TransferTicket {
  const factory TransferTicket({
    int? id,
    @JsonKey(name: 'trang_thai') String? trangThai,
    @JsonKey(name: 'xac_nhan') bool? xacNhan,
  }) = _TransferTicket;

  factory TransferTicket.fromJson(Map<String, dynamic> json) =>
      _$TransferTicketFromJson(json);
}

@freezed
class DisposeTicket with _$DisposeTicket {
  const factory DisposeTicket({
    int? id,
    @JsonKey(name: 'trang_thai') String? trangThai,
    @JsonKey(name: 'nguyen_nhan_thanh_ly') String? nguyenNhanThanhLy,
    @JsonKey(name: 'xac_nhan') bool? xacNhan,
  }) = _DisposeTicket;

  factory DisposeTicket.fromJson(Map<String, dynamic> json) =>
      _$DisposeTicketFromJson(json);
}

@freezed
class LocationType with _$LocationType {
  const factory LocationType({String? label, String? value}) = _LocationType;

  factory LocationType.fromJson(Map<String, dynamic> json) =>
      _$LocationTypeFromJson(json);
}
