import 'package:tasa/core/utilities/enum.dart';
import 'package:tasa/features/asset_category/data/models/asset_quantity_report_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'asset_quantity_state.freezed.dart';

@freezed
class AssetQuantityState with _$AssetQuantityState {
  const factory AssetQuantityState({
    @Default(CubitStatus.init) CubitStatus status,
    AssetQuantityReportModel? data,
    @Default('') String message,
  }) = _AssetQuantityState;
}
