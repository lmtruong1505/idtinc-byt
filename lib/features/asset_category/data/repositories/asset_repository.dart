import 'package:bpg_retail/core/configs/dio_config.dart';
import 'package:dio/dio.dart';
import 'dart:io';
import 'package:bpg_retail/core/constants/api_constants.dart';
import 'package:bpg_retail/core/data/models/common_response.dart';
import 'package:bpg_retail/features/asset_category/data/models/asset_status_count_model.dart';
import 'package:bpg_retail/features/asset_category/data/models/asset_type_model.dart';
import 'package:bpg_retail/features/asset_category/data/models/department_model.dart';
import 'package:bpg_retail/features/asset_category/data/models/hospital_asset_model.dart';
import 'package:injectable/injectable.dart';

@LazySingleton()
class AssetRepository {
  final BaseDio _baseDio;

  AssetRepository(this._baseDio);

  Future<CommonResponse<List<HospitalAssetModel>>> getAssetList({
    int page = 1,
    int limit = 25,
    String search = '',
    String? khoa,
    String? trangThai,
    String? toChuc = '5',
    int? timTaiSanChinhId,
  }) async {
    try {
      final queryParameters = {
        'to_chuc': toChuc,
        'search': search,
        'limit': limit,
        'page': page,
        if (khoa != null && khoa != 'all') 'khoa': khoa,
        if (trangThai != null && trangThai != 'Tất cả') 'trang_thai': trangThai,
        if (timTaiSanChinhId != null) 'tim_tai_san_chinh_id': timTaiSanChinhId,
      };

      final response = await _baseDio.get(
        Api.getAssetList,
        data: queryParameters,
      );

      return CommonResponse<List<HospitalAssetModel>>.fromJson(
        response.data,
        (json) =>
            (json as List)
                .map(
                  (e) => HospitalAssetModel.fromJson(e as Map<String, dynamic>),
                )
                .toList(),
      );
    } catch (e) {
      return CommonResponse<List<HospitalAssetModel>>(
        success: false,
        message: e.toString(),
      );
    }
  }

  Future<CommonResponse<HospitalAssetModel>> getAssetDetail(int id) async {
    try {
      final response = await _baseDio.get(Api.getAssetDetail(id));

      return CommonResponse<HospitalAssetModel>.fromJson(
        response.data,
        (json) => HospitalAssetModel.fromJson(json as Map<String, dynamic>),
      );
    } catch (e) {
      return CommonResponse<HospitalAssetModel>(
        success: false,
        message: e.toString(),
      );
    }
  }

  Future<CommonResponse<dynamic>> toggleAssetStatus(int id) async {
    try {
      final response = await _baseDio.get(Api.toggleStatusActive(id));

      return CommonResponse<dynamic>.fromJson(response.data, (json) => json);
    } catch (e) {
      return CommonResponse<dynamic>(success: false, message: e.toString());
    }
  }

  Future<CommonResponse<List<AssetStatusCountModel>>> getAssetStatusStatistics({
    String? toChuc = '5',
    String search = '',
    String? khoa,
  }) async {
    try {
      final queryParameters = {
        'to_chuc': toChuc,
        'search': search,
        if (khoa != null && khoa != 'all') 'khoa': khoa,
      };

      final response = await _baseDio.get(
        Api.getAssetStatistics,
        data: queryParameters,
      );

      return CommonResponse<List<AssetStatusCountModel>>.fromJson(
        response.data,
        (json) =>
            (json as List)
                .map(
                  (e) =>
                      AssetStatusCountModel.fromJson(e as Map<String, dynamic>),
                )
                .toList(),
      );
    } catch (e) {
      return CommonResponse<List<AssetStatusCountModel>>(
        success: false,
        message: e.toString(),
      );
    }
  }

  Future<CommonResponse<List<DepartmentModel>>> getDepartments({
    String toChucId = '5',
  }) async {
    try {
      final queryParameters = {'to_chuc_id': toChucId};

      final response = await _baseDio.get(
        Api.getDepartments,
        data: queryParameters,
      );

      return CommonResponse<List<DepartmentModel>>.fromJson(
        response.data,
        (json) =>
            (json as List)
                .map((e) => DepartmentModel.fromJson(e as Map<String, dynamic>))
                .toList(),
      );
    } catch (e) {
      return CommonResponse<List<DepartmentModel>>(
        success: false,
        message: e.toString(),
      );
    }
  }

  Future<CommonResponse<dynamic>> updateAsset(
    int id,
    Map<String, dynamic> data,
  ) async {
    try {
      final response = await _baseDio.put(
        Api.updateAsset(id),
        data: FormData.fromMap(data),
      );

      return CommonResponse<dynamic>.fromJson(response.data, (json) => json);
    } catch (e) {
      return CommonResponse<dynamic>(success: false, message: e.toString());
    }
  }

  Future<CommonResponse<dynamic>> createAsset(Map<String, dynamic> data) async {
    try {
      final formData = FormData.fromMap(data);

      // Handle all image file uploads (hinh_anh and hinh_anh_0, hinh_anh_1...)
      for (final entry in data.entries) {
        if (entry.key.startsWith('hinh_anh') &&
            entry.value is String &&
            (entry.value as String).isNotEmpty) {
          final path = entry.value as String;
          final file = File(path);
          if (await file.exists()) {
            formData.files.add(
              MapEntry(
                entry.key,
                await MultipartFile.fromFile(
                  path,
                  filename: path.split('/').last,
                ),
              ),
            );
          }
        }
      }

      final response = await _baseDio.post(Api.createAsset, data: formData);

      return CommonResponse<dynamic>.fromJson(response.data, (json) => json);
    } catch (e) {
      return CommonResponse<dynamic>(
        success: false,
        message: 'Lỗi khi tạo tài sản: ${e.toString()}',
      );
    }
  }

  Future<CommonResponse<List<AssetTypeModel>>> getAssetTypes({
    String toChuc = '5',
    int page = 1,
    int limit = 25,
    String? nhomDanhMuc = 'KHAC',
    String? phanLoaiDanhMuc = 'LOAI_THIET_BI',
  }) async {
    try {
      final queryParameters = {
        'to_chuc': toChuc,
        'page': page,
        'limit': limit,
        'nhom_danh_muc': nhomDanhMuc,
        'phan_loai_danh_muc': phanLoaiDanhMuc,
      };

      final response = await _baseDio.get(
        Api.getAssetTypes,
        data: queryParameters,
      );

      return CommonResponse<List<AssetTypeModel>>.fromJson(
        response.data,
        (json) =>
            (json as List)
                .map((e) => AssetTypeModel.fromJson(e as Map<String, dynamic>))
                .toList(),
      );
    } catch (e) {
      return CommonResponse<List<AssetTypeModel>>(
        success: false,
        message: e.toString(),
      );
    }
  }
}
