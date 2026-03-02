import 'package:tasa/core/base/base_cubit.dart';
import 'package:tasa/features/asset_category/data/repositories/asset_repository.dart';
import 'package:injectable/injectable.dart';
import 'asset_detail_state.dart';

@injectable
class AssetDetailCubit extends BaseCubit<AssetDetailState> {
  final AssetRepository _assetRepository;

  AssetDetailCubit(this._assetRepository)
    : super(const AssetDetailState.initial());

  Future<void> getAssetDetail(int id) async {
    emit(const AssetDetailState.loading());

    final response = await _assetRepository.getAssetDetail(id);

    if (response.success == true && response.data != null) {
      emit(AssetDetailState.success(response.data!));
    } else {
      emit(AssetDetailState.failure(response.message ?? "Có lỗi xảy ra"));
    }
  }

  Future<void> toggleStatus(int id) async {
    final response = await _assetRepository.toggleAssetStatus(id);

    if (response.success == true) {
      navigator.showToast(response.message ?? "Cập nhật trạng thái thành công");
      // Re-fetch details after successful toggle to get updated status label/value
      await getAssetDetail(id);
    } else {
      navigator.showToast(response.message ?? "Cập nhật trạng thái thất bại");
      await getAssetDetail(id);
    }
  }

  Future<void> separateFromSet(int id) async {
    final response = await _assetRepository.updateAsset(id, {
      'xoa_bo_thiet_bi': 'false',
      'parent': '',
      'to_chuc': '5',
    });

    if (response.success == true) {
      navigator.showToast(
        response.message ?? "Tách khỏi bộ tài sản thành công",
      );
      // Reload asset detail to update UI
      await getAssetDetail(id);
    } else {
      navigator.showToast(response.message ?? "Tách khỏi bộ tài sản thất bại");
      await getAssetDetail(id);
    }
  }
}
