import 'package:bpg_retail/core/utilities/enum.dart';
import 'package:bpg_retail/features/asset_category/data/models/asset_depreciation_rate_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'depreciation_rate_state.freezed.dart';

@freezed
class DepreciationRateState with _$DepreciationRateState {
  const factory DepreciationRateState({
    @Default(CubitStatus.init) CubitStatus status,
    @Default('') String message,
    @Default([]) List<AssetDepreciationRateModel> data,
  }) = _DepreciationRateState;
}
