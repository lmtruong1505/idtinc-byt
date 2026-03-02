import 'package:tasa/core/base/base_cubit.dart';
import 'package:tasa/features/asset_category/data/repositories/asset_repository.dart';
import 'package:injectable/injectable.dart';

import 'asset_location_history_state.dart';

@injectable
class AssetLocationHistoryCubit extends BaseCubit<AssetLocationHistoryState> {
  final AssetRepository _assetRepository;

  AssetLocationHistoryCubit(this._assetRepository)
    : super(const AssetLocationHistoryState.initial());

  Future<void> getLocationHistory(int assetId) async {
    emit(const AssetLocationHistoryState.loading());
    try {
      final response = await _assetRepository.getAssetLocationHistory(assetId);
      if (response.success == true && response.data != null) {
        emit(AssetLocationHistoryState.success(response.data!));
      } else {
        emit(
          AssetLocationHistoryState.failure(
            response.message ?? 'Không thể tải lịch sử điều chuyển',
          ),
        );
      }
    } catch (e) {
      emit(AssetLocationHistoryState.failure(e.toString()));
    }
  }
}
