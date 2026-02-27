import 'package:bpg_retail/core/utilities/enum.dart';
import 'package:bpg_retail/features/asset_category/data/models/asset_overview_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'asset_overview_state.freezed.dart';

@freezed
class AssetOverviewState with _$AssetOverviewState {
  const factory AssetOverviewState({
    @Default(CubitStatus.init) CubitStatus status,
    @Default('') String message,
    AssetOverviewModel? data,
  }) = _AssetOverviewState;
}
