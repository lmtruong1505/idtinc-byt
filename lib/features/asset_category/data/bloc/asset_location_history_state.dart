import 'package:tasa/features/asset_category/data/models/asset_location_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'asset_location_history_state.freezed.dart';

@freezed
class AssetLocationHistoryState with _$AssetLocationHistoryState {
  const factory AssetLocationHistoryState.initial() = _Initial;
  const factory AssetLocationHistoryState.loading() = _Loading;
  const factory AssetLocationHistoryState.success(
    List<AssetLocationModel> data,
  ) = _Success;
  const factory AssetLocationHistoryState.failure(String message) = _Failure;
}
