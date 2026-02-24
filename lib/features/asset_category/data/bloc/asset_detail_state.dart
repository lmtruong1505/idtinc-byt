import 'package:bpg_retail/features/asset_category/data/models/hospital_asset_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'asset_detail_state.freezed.dart';

@freezed
class AssetDetailState with _$AssetDetailState {
  const factory AssetDetailState.initial() = _Initial;
  const factory AssetDetailState.loading() = _Loading;
  const factory AssetDetailState.success(HospitalAssetModel asset) = _Success;
  const factory AssetDetailState.failure(String message) = _Failure;
}
