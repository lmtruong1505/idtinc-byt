import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:bpg_retail/features/asset_category/data/models/hospital_asset_model.dart';
import 'package:bpg_retail/features/asset_category/data/repositories/asset_repository.dart';
import 'asset_category_state.dart';

@injectable
class AssetCategoryCubit extends Cubit<AssetCategoryState> {
  final AssetRepository _assetRepository;

  AssetCategoryCubit(this._assetRepository) : super(const AssetCategoryState());

  Future<void> getAssets({bool refresh = false}) async {
    if (refresh) {
      emit(
        state.copyWith(
          status: AssetLoadStatus.loading,
          currentPage: 1,
          assets: [],
        ),
      );
    } else {
      if (state.status == AssetLoadStatus.loading ||
          state.status == AssetLoadStatus.loadingMore)
        return;

      if (state.status == AssetLoadStatus.success && state.pagination != null) {
        if (state.currentPage >= (state.pagination?.numPages ?? 0)) return;
        emit(state.copyWith(status: AssetLoadStatus.loadingMore));
      } else {
        emit(state.copyWith(status: AssetLoadStatus.loading));
      }
    }

    final response = await _assetRepository.getAssetList(
      page:
          refresh
              ? 1
              : (state.status == AssetLoadStatus.loadingMore
                  ? state.currentPage + 1
                  : 1),
    );

    if (response.success == true) {
      final newAssets = response.data ?? [];
      final List<HospitalAssetModel> updatedAssets =
          refresh ? newAssets : [...state.assets, ...newAssets];

      emit(
        state.copyWith(
          status: AssetLoadStatus.success,
          assets: updatedAssets,
          pagination: response.metadata?.pagination,
          currentPage:
              refresh
                  ? 1
                  : (state.status == AssetLoadStatus.loadingMore
                      ? state.currentPage + 1
                      : 1),
        ),
      );
    } else {
      emit(
        state.copyWith(
          status: AssetLoadStatus.failure,
          errorMessage: response.message,
        ),
      );
    }
  }

  Future<void> loadMore() async {
    await getAssets();
  }
}
