import 'package:bpg_retail/features/asset_category/data/models/asset_status_count_model.dart';
import 'package:bpg_retail/features/asset_category/data/repositories/asset_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import 'asset_filter_state.dart';

@injectable
class AssetFilterCubit extends Cubit<AssetFilterState> {
  final AssetRepository _repository;
  AssetFilterCubit(this._repository) : super(const AssetFilterState());

  Future<void> getStatistics() async {
    emit(state.copyWith(isLoadingStatistics: true));
    final response = await _repository.getAssetStatusStatistics(
      search: state.searchKeyword,
      khoa: state.selectedDepartment,
    );
    if (response.success == true && response.data != null) {
      final List<AssetStatusCountModel> originalStats = response.data!;
      // Filter out any existing "Tất cả" from the API to avoid duplicates
      final stats =
          originalStats
              .where((s) => s.value != "Tất cả" && s.label != "Tất cả")
              .toList();

      final totalCount = stats.fold<int>(
        0,
        (sum, item) => sum + (item.count ?? 0),
      );
      final allStat = AssetStatusCountModel(
        label: "Tất cả",
        value: "Tất cả",
        count: totalCount,
      );

      emit(
        state.copyWith(
          statistics: [allStat, ...stats],
          isLoadingStatistics: false,
        ),
      );
    } else {
      emit(state.copyWith(isLoadingStatistics: false));
    }
  }

  Future<void> getDepartments() async {
    emit(state.copyWith(isLoadingDepartments: true));
    final response = await _repository.getDepartments();
    if (response.success == true && response.data != null) {
      emit(
        state.copyWith(
          departments: response.data!,
          isLoadingDepartments: false,
        ),
      );
    } else {
      emit(state.copyWith(isLoadingDepartments: false));
    }
  }

  void selectDepartment(String? value) {
    emit(state.copyWith(selectedDepartment: value));
    getStatistics();
  }

  void selectStatus(String status) {
    emit(state.copyWith(selectedStatus: status));
  }

  void selectAssetType(String? value) {
    emit(state.copyWith(selectedAssetTypeId: value));
  }

  Future<void> getAssetTypes() async {
    emit(state.copyWith(isLoadingAssetTypes: true));
    final response = await _repository.getAssetTypes();
    if (response.success == true && response.data != null) {
      emit(
        state.copyWith(assetTypes: response.data!, isLoadingAssetTypes: false),
      );
    } else {
      emit(state.copyWith(isLoadingAssetTypes: false));
    }
  }

  void updateSearchKeyword(String keyword) {
    emit(state.copyWith(searchKeyword: keyword));
  }

  void clearFilter() {
    emit(
      state.copyWith(
        selectedDepartment: null,
        selectedStatus: 'Tất cả',
        selectedAssetTypeId: null,
      ),
    );
  }
}
