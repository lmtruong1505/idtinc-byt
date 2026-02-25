import 'package:json_annotation/json_annotation.dart';

part 'department_model.g.dart';

@JsonSerializable()
class DepartmentModel {
  final int? id;
  @JsonKey(name: 'ma_khoa')
  final String? maKhoa;
  @JsonKey(name: 'ten_khoa')
  final String? tenKhoa;
  @JsonKey(name: 'so_luong_kho')
  final int? soLuongKho;
  @JsonKey(name: 'kho_truc_thuoc')
  final List<dynamic>? khoTrucThuoc;

  DepartmentModel({
    this.id,
    this.maKhoa,
    this.tenKhoa,
    this.soLuongKho,
    this.khoTrucThuoc,
  });

  factory DepartmentModel.fromJson(Map<String, dynamic> json) =>
      _$DepartmentModelFromJson(json);
  Map<String, dynamic> toJson() => _$DepartmentModelToJson(this);
}
