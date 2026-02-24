import 'package:bpg_retail/features/asset_category/data/repositories/asset_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'asset_detail_state.dart';

@injectable
class AssetDetailCubit extends Cubit<AssetDetailState> {
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
      // Re-fetch details after successful toggle to get updated status label/value
      await getAssetDetail(id);
    } else {
      // If failed, we don't necessarily want to change the success state to failure
      // if we already have the asset data, but maybe we should show an error message.
      // For now, let's just re-fetch to ensure sync (or do nothing if we want to stay where we are).
      // If we emit failure, the whole page might show error state.
      // Better approach: emit current success state but with an error message in it?
      // Our state doesn't have an error field for side-effects.
      // For now, let's just log or re-fetch.
      await getAssetDetail(id);
    }
  }
}
