import 'package:bpg_retail/core/configs/dio_config.dart';
import 'package:bpg_retail/core/constants/api_constants.dart';
import 'package:bpg_retail/core/data/models/common_list_response.dart';
import 'package:bpg_retail/features/asset_category/data/models/hospital_asset_model.dart';
import 'package:injectable/injectable.dart';

@LazySingleton()
class AssetRepository {
  final BaseDio _baseDio;

  AssetRepository(this._baseDio);

  Future<CommonListResponse<HospitalAssetModel>> getAssetList({
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

      return CommonListResponse<HospitalAssetModel>.fromJson(
        response.data,
        (json) => HospitalAssetModel.fromJson(json as Map<String, dynamic>),
      );
    } catch (e) {
      return CommonListResponse<HospitalAssetModel>(
        success: false,
        message: e.toString(),
      );
    }
  }
}
