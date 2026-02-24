import 'package:bpg_retail/core/configs/dio_config.dart';
import 'package:bpg_retail/core/constants/api_constants.dart';
import 'package:bpg_retail/core/data/models/common_response.dart';
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
    String? toChuc = '5',
  }) async {
    try {
      final queryParameters = {
        'to_chuc': toChuc,
        'search': search,
        'limit': limit,
        'page': page,
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
}
