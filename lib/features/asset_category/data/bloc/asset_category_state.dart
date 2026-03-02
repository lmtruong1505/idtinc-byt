import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:tasa/features/asset_category/data/models/hospital_asset_model.dart';
import 'package:tasa/core/data/models/pagination_model.dart';

part 'asset_category_state.freezed.dart';

enum AssetLoadStatus { initial, loading, success, failure, loadingMore }

@freezed
class AssetCategoryState with _$AssetCategoryState {
  const factory AssetCategoryState({
    @Default(AssetLoadStatus.initial) AssetLoadStatus status,
    @Default([]) List<HospitalAssetModel> assets,
    PaginationModel? pagination,
    String? errorMessage,
    @Default(1) int currentPage,
    @Default('') String search,
    String? khoa,
    String? trangThai,
    String? loaiTaiSan,
  }) = _AssetCategoryState;
}
