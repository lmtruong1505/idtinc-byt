import 'package:bpg_retail/features/asset_category/data/models/asset_status_count_model.dart';
import 'package:bpg_retail/features/asset_category/data/models/asset_type_model.dart';
import 'package:bpg_retail/features/asset_category/data/models/department_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'asset_filter_state.freezed.dart';

@freezed
abstract class AssetFilterState with _$AssetFilterState {
  const factory AssetFilterState({
    @Default(null) String? selectedDepartment,
    @Default('Tất cả') String selectedStatus,
    @Default(null) String? selectedAssetTypeId,
    @Default('') String searchKeyword,
    @Default([]) List<AssetStatusCountModel> statistics,
    @Default(false) bool isLoadingStatistics,
    @Default([]) List<DepartmentModel> departments,
    @Default(false) bool isLoadingDepartments,
    @Default([]) List<AssetTypeModel> assetTypes,
    @Default(false) bool isLoadingAssetTypes,
  }) = _AssetFilterState;
}
