import 'package:tasa/core/utilities/enum.dart';
import 'package:tasa/features/asset_category/data/models/asset_status_ratio_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'asset_status_ratio_state.freezed.dart';

@freezed
class AssetStatusRatioState with _$AssetStatusRatioState {
  const factory AssetStatusRatioState({
    @Default(CubitStatus.init) CubitStatus status,
    @Default([]) List<AssetStatusRatioModel> data,
    @Default('') String message,
  }) = _AssetStatusRatioState;
}
